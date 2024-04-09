//
//  OnboardingViewController.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 19/02/2024.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    private let welcomeLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.text = "See what's happening in the world right now."
        lable.font = .systemFont(ofSize: 32,weight: .heavy)
        lable.textAlignment = .center
        lable.textColor = .label
        return lable
    }()
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    private let promptLable: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 14,weight: .regular)
        lable.text = "Have an account already?"
        lable.textColor = .gray
        return lable
    }()
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(welcomeLable)
        view.addSubview(createAccountButton)
        view.addSubview(promptLable)
        view.addSubview(loginButton)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        configureConstrains()
    }
    @objc private func didTapLogin(){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func didTapCreateAccount(){
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    private func configureConstrains(){
        welcomeLable.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(view.snp.centerY)
        }
        createAccountButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(welcomeLable.snp.bottom).offset(20)
            make.width.equalTo(welcomeLable.snp.width).offset(-20)
            make.height.equalTo(60)
        }
        promptLable.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-60)
        }
        loginButton.snp.makeConstraints { make in
            make.centerY.equalTo(promptLable.snp.centerY)
            make.leading.equalTo(promptLable.snp.trailing).offset(10)
        }
    }
}
