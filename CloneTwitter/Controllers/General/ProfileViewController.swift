//
//  ProfileViewController.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 16/02/2024.
//

import UIKit
import SnapKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    var user = TwitterUser()
    private var isStatusBarHidden:Bool = true
    private var tweets = [Tweet]()
    private let statusBar:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.opacity = 0
        return view
    }()
    private let profileTableView:UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    private lazy var headerView = ProfileHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
    
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableHeaderView = headerView
        navigationController?.navigationBar.isHidden = true
        profileTableView.contentInsetAdjustmentBehavior = .never
        configureConstrains()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        bindViews()
    }
    private func bindViews(){
        var id = Auth.auth().currentUser?.uid ?? ""
        DatabaseManager.shared.collectionUsers(id: id) { results in
            switch results{
            case .failure(let err):
                print("Lỗi lấy dữ liệu về profile: \(err)")
            case .success(let data):
                self.user = data
                self.headerView.displayNameLable.text = self.user.displayName ?? ""
                self.headerView.usernameLable.text = self.user.username ?? ""
                self.headerView.followersCountLable.text = String(self.user.followerCount ?? 0) ?? ""
                self.headerView.followingCountLable.text = String(self.user.followingCount ?? 0) ?? ""
                self.headerView.userBioLable.text = self.user.bio ?? ""
                guard let url = URL(string: self.user.avatarPath ?? "") else{
                    print("Khong tim thay avt")
                    return
                }
                print(url)
                self.headerView.profileAvatarImageView.kf.setImage(with: url)
                self.headerView.joinDateLable.text = "Joined \(self.getformatedDate(date: self.user.createdOn) ?? "")"
                self.getTweet()
                
            }
        }
        
    }
    
    func getTweet(){
        guard let userID = self.user.id else{
            return
        }
        DatabaseManager.shared.collectionTweets(get: userID) { result in
            switch result {
            case .failure(let err):
                print("Khong thể lấy Tweet \(err)")
            case .success(let data):
                self.tweets = data
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            }
        }
    }
    
    func getformatedDate(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        return dateFormatter.string(from: date)
    }
    private func configureConstrains(){
        profileTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        statusBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.leading.equalToSuperview()
            make.height.equalTo(view.bounds.height).offset(view.bounds.height > 800 ? 40 : 20)
        }
    }
    
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else{
            return UITableViewCell()
        }
        cell.binDataTweet(tweet: tweets[indexPath.row])
        
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        if yPosition > 150 && isStatusBarHidden{
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0,options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            } completion: { _ in }

        }else if yPosition < 0 && !isStatusBarHidden{
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0,options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            } completion: { _ in }

        }
    }
}
