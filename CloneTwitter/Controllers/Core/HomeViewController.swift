//
//  ViewController.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 16/02/2024.
//

import UIKit
import FirebaseAuth
import SnapKit
import MBProgressHUD

class HomeViewController: UIViewController{
    
    var user: TwitterUser? = nil
    let dispatchGroup = DispatchGroup()
    var tweets: [Tweet] = []
    private lazy var composeTweetButton:UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
            self?.navigateToTweetComposer()
            
        })
        button.backgroundColor = .twitterBlueColor
        button.tintColor = .white
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18,weight: .bold))
        button.setImage(plusSign, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        return button
    }()
    private func configureNavigationBar(){
        let size:CGFloat = 16
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "logo-black")
        
        
        let middView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middView.addSubview(logoImageView)
        navigationItem.titleView = middView
        
    }
    
    private let timelineTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(TweetTableViewCell.self,
                           forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    private var post = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        view.addSubview(composeTweetButton)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        configureNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapSignOut))
        let profileView = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileView, style: .plain, target: self, action: #selector(didTapProfile))
        configureConstraints()
       
        //didTapSignOut()
    }
    
    
    private func tweetUser(){
        
        // Gọi API từ luồng nền
    
            DatabaseManager.shared.collectionAllTweets { result in
               
                    switch result {
                    case .failure(let err):
                        print("Khong thể lấy Tweet \(err)")
                        
                        
                    case .success(let data):
                        self.tweets = data
                        DispatchQueue.main.async {
                            self.timelineTableView.reloadData()
                            
                }
            }
        }
    }
    
    
    
    func navigateToTweetComposer(){
       let vc = UINavigationController(rootViewController: TweetComposeViewController())
       vc.modalPresentationStyle = .fullScreen
       present(vc, animated: true)
   }
    
    private func configureConstraints() {
        composeTweetButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-120)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
    }
    @objc func didTapProfile(){
        let pro = ProfileViewController()
        navigationController?.pushViewController(pro, animated: true)
    }
    
    
    func isShow(show: Bool){
        if show{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }else{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    @objc private func didTapSignOut(){
        do{
            try Auth.auth().signOut()
            handleAuthentication()
        }catch let error as NSError{
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
    private func handleAuthentication(){
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        guard let id = Auth.auth().currentUser?.uid else{
            return
        }
        
         
        DatabaseManager.shared.collectionUsers(id: id) { result in
            switch result {
            case .success(let users):
                print("Lấy thông tin ngừoi dùng thành công để upload")
                guard let user = users as? TwitterUser else{return}
                print("user \(user)")
                
                    if user.isUserOnboarded == false{
                        let vc = ProfileDataFormViewController()
                        let naviController = UINavigationController(rootViewController: vc)
                        naviController.modalPresentationStyle = .fullScreen
                        self.present(naviController, animated: true)
                    
                }
            case .failure(let err):
                print("Lấy thông tin người dùng thất bại: \(err.localizedDescription)")
            }
        }
            self.tweetUser()
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else{
            return UITableViewCell()
        }
        cell.binDataTweet(tweet: tweets[indexPath.row])
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentController = ContentViewController()
        contentController.contentTextView.text = tweets[indexPath.row].tweetContent ?? ""
        navigationController?.pushViewController(contentController, animated: true)
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Sửa") { action, view, completionHandler in
            // Xử lý sự kiện sửa ở đây
                    // Ví dụ: Mở màn hình chỉnh sửa thông tin cho cell tại indexPath
                    print("Sửa nội dung")
                    completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let removeAction = UIContextualAction(style: .normal, title: "Xoá") { action, view, completionHandel in
            print("Xoá nội dung")
            completionHandel(true)
        }
        removeAction.backgroundColor = .red
        
        // Trả về cấu hình cho các hành động swipe
        let configuration = UISwipeActionsConfiguration(actions: [removeAction,editAction])
        configuration.performsFirstActionWithFullSwipe = false // Tùy chỉnh xem liệu hành động đầu tiên sẽ được thực hiện tự động hay không
        return configuration
    }
    
    
    
}
extension HomeViewController: TweetTableViewCellDelegate{
    func tweetTableViewCellDidTapReply() {
        print("Reply")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("Retweet")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("Like")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("Share")
    }
}

