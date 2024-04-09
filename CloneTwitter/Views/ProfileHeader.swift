//
//  ProfileHeader.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 16/02/2024.
//

import UIKit
import SnapKit

class ProfileHeader: UIView {
    private let followButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlueColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        
        return button
    }()
    private enum SectionTab:String {
        case tweets = "Tweets"
        case tweetsAndReplies = "Tweets & Replies"
        case media = "Media"
        case likes = "Likes"
        var index : Int{
            switch self{
            case .tweets:
                return 0
            case .tweetsAndReplies:
                return 1
            case .media:
                return 2
            case .likes:
                return 3
            }
        }
    }
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    private let indicator:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .twitterBlueColor
        return view
    }()
    private var selectedTab:Int = 0{
        didSet{
            for i in 0..<tabs.count{
                
                UIView.animate(withDuration: 0.3,delay: 0,options: .curveEaseInOut) {[weak self] in
                    self?.sectionStack.arrangedSubviews[i].tintColor = i == self?.selectedTab ? .label : .secondaryLabel
                    self?.leadingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.trailingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.layoutIfNeeded()
                } completion: { _ in
                }
            }
        }
    }
    private var tabs:[UIButton] = ["Tweets", "Tweets & Replies", "Media", "Likes"].map { buttonTitle in
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .label
        return button
    }
    
    private lazy var sectionStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: tabs)
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    public var followersTextLable:UILabel = {
        let lable = UILabel()
        lable.text = "Followers"
        lable.textColor = .secondaryLabel
        lable.font = .systemFont(ofSize: 14,weight: .regular)
        return lable
    }()
    public var followersCountLable:UILabel = {
        let lable = UILabel()
        lable.text = ""
        lable.textColor = .label
        lable.font = .systemFont(ofSize: 14,weight: .bold)
        return lable
    }()
    public var followingTextLable:UILabel = {
        let lable = UILabel()
        lable.text = "Following"
        lable.textColor = .secondaryLabel
        lable.font = .systemFont(ofSize: 14,weight: .regular)
        return lable
    }()
    public var followingCountLable:UILabel = {
        let lable = UILabel()
        lable.text = ""
        lable.textColor = .label
        lable.font = .systemFont(ofSize: 14,weight: .bold)
        return lable
    }()
    public var joinDateLable : UILabel = {
        let lable = UILabel()
//        lable.text = "Joined Feb 2024"
        lable.font = .systemFont(ofSize: 14, weight: .regular)
        lable.textColor = .secondaryLabel
        return lable
    }()
    public var joinDateImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        image.tintColor = .secondaryLabel
        return image
    }()
    public var userBioLable : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 3
        lable.text = ""
        lable.textColor = .label
        return lable
    }()
    public var usernameLable : UILabel = {
        let lable = UILabel()
        lable.text = ""
        lable.numberOfLines = 0
        lable.textColor = .secondaryLabel
        lable.font = .systemFont(ofSize: 18, weight: .regular)
        return lable
    }()
    public var displayNameLable : UILabel = {
        let lable = UILabel()
        lable.text = ""
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 22, weight: .bold)
        lable.textColor = .label
        return lable
    }()
    public var profileAvatarImageView : UIImageView = {
        let profileImage = UIImageView()
        profileImage.contentMode = .scaleAspectFill
        profileImage.image = UIImage(systemName: "person")
        profileImage.layer.masksToBounds = true
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 40
        profileImage.backgroundColor = .yellow
        return profileImage
    }()
    
    public var profileHeaderImageView : UIImageView = {
        let profileImage = UIImageView()
        profileImage.contentMode = .scaleAspectFill
        profileImage.image = UIImage(named: "header")
        profileImage.clipsToBounds = true
        return profileImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // backgroundColor = .red
        addSubview(profileHeaderImageView)
        addSubview(profileAvatarImageView)
        addSubview(displayNameLable)
        addSubview(usernameLable)
        addSubview(userBioLable)
        addSubview(joinDateImageView)
        addSubview(joinDateLable)
        addSubview(followersTextLable)
        addSubview(followingTextLable)
        addSubview(followersCountLable)
        addSubview(followingCountLable)
        addSubview(sectionStack)
        addSubview(indicator)
        addSubview(followButton)
        configureConstrains()
        configureStackButton()
        configureFollowedButton()
    }
    
    private func configureFollowedButton(){
        followButton.setTitle("Unfollow", for: .normal)
        followButton.backgroundColor = .lightGray
        
        followButton.setTitleColor(.label, for: .normal)
        followButton.layer.borderWidth = 2
        followButton.layer.borderColor = UIColor.label.cgColor
    }
    private func configureUnfollowedButton(){
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .twitterBlueColor
        followButton.setTitleColor(.white, for: .normal)
        followButton.layer.borderColor = UIColor.clear.cgColor
    }
    private func configureStackButton(){
        for(i,button) in sectionStack.arrangedSubviews.enumerated(){
            guard let button = button as? UIButton else{
                return
            }
            if i == selectedTab {
                button.tintColor = .label
            }else{
                button.tintColor = .secondaryLabel
            }
            button.addTarget(self, action: #selector(didTapTab(_:)), for: .touchUpInside)
        }
    }
    @objc private func didTapTab(_ sender: UIButton){
        guard let label = sender.titleLabel?.text else{
            return
        }
        switch label {
        case SectionTab.tweets.rawValue:
            selectedTab = 0
        case SectionTab.tweetsAndReplies.rawValue:
            selectedTab = 1
        case SectionTab.media.rawValue:
            selectedTab = 2
        case SectionTab.likes.rawValue:
            selectedTab = 3
        default:
            selectedTab = 0
        }
    }
    private func configureConstrains(){
        
        for i in 0..<tabs.count{
            let leadingAnchor = indicator.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].leadingAnchor)
            leadingAnchors.append(leadingAnchor)
            let trailingAnchor = indicator.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailingAnchor)
        }
        
        profileHeaderImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(150)
            make.trailing.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(0)
        }
        
        profileAvatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(profileHeaderImageView.snp.bottom).offset(10)
            make.height.width.equalTo(80)
        }
        
        displayNameLable.snp.makeConstraints { make in
            make.leading.equalTo(profileAvatarImageView)
            make.top.equalTo(profileAvatarImageView.snp.bottom).offset(20)
        }
        usernameLable.snp.makeConstraints { make in
            make.leading.equalTo(profileAvatarImageView)
            make.top.equalTo(displayNameLable.snp.bottom).offset(5)
        }
        userBioLable.snp.makeConstraints { make in
            make.leading.equalTo(profileAvatarImageView)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(usernameLable.snp.bottom).offset(5)
        }
        joinDateImageView.snp.makeConstraints { make in
            make.leading.equalTo(profileAvatarImageView)
            make.top.equalTo(userBioLable.snp.bottom).offset(5)
        }
        joinDateLable.snp.makeConstraints { make in
            make.leading.equalTo(joinDateImageView.snp.trailing).offset(2)
            make.bottom.equalTo(joinDateImageView.snp.bottom)
        }
        
        
        followingCountLable.snp.makeConstraints { make in
            make.leading.equalTo(profileAvatarImageView)
            make.top.equalTo(joinDateLable.snp.bottom).offset(10)
        }
        followingTextLable.snp.makeConstraints { make in
            make.leading.equalTo(followingCountLable.snp.trailing).offset(4)
            make.bottom.equalTo(followingCountLable.snp.bottom)
        }
        followersCountLable.snp.makeConstraints { make in
            make.leading.equalTo(followingTextLable.snp.trailing).offset(8)
            make.bottom.equalTo(followingCountLable.snp.bottom)
        }
        followersTextLable.snp.makeConstraints { make in
            make.leading.equalTo(followersCountLable.snp.trailing).offset(4)
            make.bottom.equalTo(followingCountLable.snp.bottom)
        }
        sectionStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(followingCountLable.snp.bottom).offset(5)
            make.height.equalTo(35)
        }
        let indicatorConstraints = [
            leadingAnchors[0],
            trailingAnchors[0],
            indicator.topAnchor.constraint(equalTo: sectionStack.bottomAnchor,constant: -4),
            indicator.heightAnchor.constraint(equalToConstant: 4)
        ]
        NSLayoutConstraint.activate(indicatorConstraints)
        
        followButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(90)
            make.height.equalTo(40)
            make.centerY.equalTo(usernameLable.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
