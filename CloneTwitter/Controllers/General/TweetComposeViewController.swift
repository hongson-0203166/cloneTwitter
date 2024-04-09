//
//  TweetComposeViewController.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 18/03/2024.
//

import UIKit
import SnapKit
import FirebaseAuth

class TweetComposeViewController: UIViewController {

    
    private var user:TwitterUser?
    
    private var tweetButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlueColor
        button.tintColor = .white
        button.setTitle("Tweet", for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
    }()
    
    private let tweetContentTextView:UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .secondarySystemFill
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "What's happening?"
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Tweet"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain, target: self,
                                                           action: #selector(didtapCancel))
        tweetContentTextView.delegate = self
        view.addSubview(tweetButton)
        view.addSubview(tweetContentTextView)
        configureConstrain()
        tweetButton.addTarget(self, action: #selector(tweet), for: .touchUpInside)
    }
    
    
    func configureConstrain(){
        tweetButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(120)
            make.height.equalTo(60)
        }
        
        tweetContentTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalTo(tweetButton.snp.top).offset(-10)
        }
        
    }
    
    @objc private func tweet(){
        print("Click Tweet")
        guard let userID = Auth.auth().currentUser?.uid else{
            return
        }
        DatabaseManager.shared.collectionUsers(id: userID) {[weak self] results in
            switch results{
            case .failure(let err):
                print("Không thể lấy dữ liệu ngừoi dùng hiện tại \(err)")
                break
            case .success(let data):
                self?.user = data
                self?.disPatchTweet()
                break
            }
        }
    }
    
    
    func disPatchTweet(){
        guard let user = user else{
            return
        }
        let tweet = Tweet(author: user, authorID: user.id ?? "", tweetContent: tweetContentTextView.text, likesCount: 0, likes: [], isReply: false, parentReference: nil)
        DatabaseManager.shared.collectionTweets(tweet: tweet) { [weak self] result in
            switch result {
            case .success():
                break
            case .failure(let err):
                print("Thêm tweet khong thành công\(err)")
                break
            
                
            }
        }
        self.dismiss(animated: true)
    }
    @objc func didtapCancel(){
        dismiss(animated: true)
    }
    
}
extension TweetComposeViewController :  UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray{
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happending?"
            textView.textColor = .gray
        }
    }
}
