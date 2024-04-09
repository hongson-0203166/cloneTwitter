//
//  ContentViewController.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 22/03/2024.
//

import UIKit
import SnapKit
class ContentViewController: UIViewController {
    let contentTextView : UITextView = {
       let textView = UITextView()
        
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .gray
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentTextView)
        configureConstrain()
    }
    func configureConstrain(){
        contentTextView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
