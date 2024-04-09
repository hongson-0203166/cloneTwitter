//
//  TweetTableViewCell.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 16/02/2024.
//

import UIKit
import SnapKit
import Kingfisher

protocol TweetTableViewCellDelegate:AnyObject{
    func tweetTableViewCellDidTapReply()
    func tweetTableViewCellDidTapRetweet()
    func tweetTableViewCellDidTapLike()
    func tweetTableViewCellDidTapShare()
}
class TweetTableViewCell: UITableViewCell {
    static let identifier = "TweetTableViewCell"
    weak var delegate:TweetTableViewCellDelegate?
    private let avatarImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius  = 25
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
       // imageView.image = UIImage(systemName: "person")
        //imageView.backgroundColor = .red
        return imageView
    }()
    
    private let displayNameLable : UILabel = {
        let lable = UILabel()
       // lable.text = "Amr Hossam"
        lable.font = .systemFont(ofSize: 18, weight: .bold)
        return lable
    }()
    
    private let userNameLable : UILabel = {
        let lable = UILabel()
       // lable.text = "@Amr"
        lable.font = .systemFont(ofSize: 16, weight: .regular)
        return lable
    }()
    private let tweetContentLable : UILabel = {
        let lable = UILabel()
        //lable.text = "@Amr Amr Amr Amr Amr Amr AmrAmrAmrAmrAmrAmrAmrAmrAmr Amr Amr"
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 16, weight: .regular)
        return lable
    }()
    
    
    //MARK: Action
    private let replyButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "reply"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    private let retweetButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "reload"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    private let likeButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    private let shareButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(displayNameLable)
        contentView.addSubview(userNameLable)
        contentView.addSubview(tweetContentLable)
        contentView.addSubview(replyButton)
        contentView.addSubview(retweetButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(shareButton)
        configureConstrains()
        configureButtons()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func binDataTweet(tweet: Tweet){
        displayNameLable.text = tweet.author.displayName ?? ""
        userNameLable.text = "@ " + (tweet.author.username ?? "") ?? ""
        tweetContentLable.text = tweet.tweetContent ?? ""
        avatarImageView.kf.setImage(with: URL(string: tweet.author.avatarPath ?? ""))
    }
    private func configureConstrains(){
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(14)
        }
        
        displayNameLable.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(14)
        }
        
        userNameLable.snp.makeConstraints { make in
            make.leading.equalTo(displayNameLable.snp.trailing).offset(10)
            make.centerY.equalTo(displayNameLable.snp.centerY)
        }
        
        
        tweetContentLable.snp.makeConstraints { make in
            make.leading.equalTo(displayNameLable.snp.leading)
            make.top.equalTo(displayNameLable.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-15)
            //make.bottom.equalToSuperview().offset(-15)
        }
        
        replyButton.snp.makeConstraints { make in
            make.leading.equalTo(tweetContentLable.snp.leading)
            make.top.equalTo(tweetContentLable.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        retweetButton.snp.makeConstraints { make in
            make.leading.equalTo(replyButton.snp.trailing).offset(60)
            make.centerY.equalTo(replyButton.snp.centerY)
        }
        
        likeButton.snp.makeConstraints { make in
            make.leading.equalTo(retweetButton.snp.trailing).offset(60)
            make.centerY.equalTo(replyButton.snp.centerY)
        }
        
        shareButton.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(60)
            make.centerY.equalTo(replyButton.snp.centerY)
        }
        
    }
    public func configureButtons(){
        replyButton.addTarget(self, action: #selector(didTapReply), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(didTapRetweet), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    @objc func didTapReply(){
        delegate?.tweetTableViewCellDidTapReply()
    }
    @objc func didTapRetweet(){
        delegate?.tweetTableViewCellDidTapRetweet()
    }
    @objc func didTapLike(){
        delegate?.tweetTableViewCellDidTapLike()
    }
    @objc func didTapShare(){
        delegate?.tweetTableViewCellDidTapShare()
    }
}
