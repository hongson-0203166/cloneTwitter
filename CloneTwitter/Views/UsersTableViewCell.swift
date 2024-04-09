//
//  UsersTableViewCell.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 21/03/2024.
//

import UIKit
import SnapKit
import Kingfisher
class UsersTableViewCell: UITableViewCell {
    static let identifier = "UsersTableViewCell"
    private let avatarImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius  = 25
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
       // imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .red
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(displayNameLable)
        contentView.addSubview(userNameLable)
        configureConstrain()
    }
    func configureConstrain(){
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        displayNameLable.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
            make.centerY.equalTo(avatarImageView.snp.centerY)
        }
        
        userNameLable.snp.makeConstraints { make in
            make.leading.equalTo(displayNameLable.snp.trailing).offset(10)
            make.centerY.equalTo(avatarImageView.snp.centerY)
        }
    }
    
    public func configureBindata(user:TwitterUser){
        avatarImageView.kf.setImage(with: URL(string: user.avatarPath ?? ""))
        displayNameLable.text = user.displayName ?? ""
        userNameLable.text = "@ " + ((user.username) ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
