//
//  ProfileDataFormViewController.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 22/02/2024.
//

import UIKit
import SnapKit
import PhotosUI
import FirebaseStorage
import FirebaseAuth

class ProfileDataFormViewController: UIViewController {
    private let scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.keyboardDismissMode = .onDrag
        return scroll
    }()
    private let hintLable:UILabel = {
        let lable = UILabel()
        lable.text = "Fill in your data"
        lable.font = .systemFont(ofSize: 32,weight: .bold)
        lable.textColor = .label
        return lable
    }()
    
    private let avatarPlaceholderImageView:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 60
        image.backgroundColor = .lightGray
        image.image = UIImage(systemName: "camera.fill")
        image.tintColor = .gray
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    private let displayNameTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .default
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.backgroundColor = .secondarySystemFill
        textField.returnKeyType = .done
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "Display Name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
        return textField
    }()
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.returnKeyType = .done
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "Username",attributes: [NSAttributedString.Key.foregroundColor:UIColor.gray])
        return textField
    }()
    private let bioTextView:UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .secondarySystemFill
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "Tell the world about yourself"
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    private let submitButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16,weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        
        return button
    }()
    var isFormValid:Bool = false
    public var avatarPath :((String)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(hintLable)
        scrollView.addSubview(avatarPlaceholderImageView)
        scrollView.addSubview(displayNameTextField)
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(bioTextView)
        
        usernameTextField.delegate = self
        displayNameTextField.delegate = self
        bioTextView.delegate = self
        scrollView.addSubview(submitButton)
        
        configureConstrains()
        avatarPlaceholderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapUpload)))
        submitButton.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        setScrollView()
        displayNameTextField.becomeFirstResponder()
    }
    func setScrollView(){
        // Đăng ký sự kiện bàn phím xuất hiện và biến mất
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Thêm UITapGestureRecognizer để ẩn bàn phím khi người dùng chạm vào bất kỳ nơi nào trên màn hình
               let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
               scrollView.addGestureRecognizer(tapGesture)
    }  
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        scrollView.contentInset.bottom = keyboardFrame.height
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc private func tapSubmit(){
        uploadImageAvtAndProfile()
        self.navigationController?.dismiss(animated: true)
    }
    private func uploadImageAvtAndProfile(){
        let randomID = UUID().uuidString
        print("Random:\(randomID)")
        guard let image = avatarPlaceholderImageView.image?.jpegData(compressionQuality: 0.5) else {
                print("Lỗi")
                return
            }

        
        print("Image : \(image)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        StorageManager.shared.uploadProfilePhoto(with: randomID, image: image, metaData: metadata) { metadata, error in
            if let error = error {
                print("Lỗi: \(error.localizedDescription)")
                       return
                   }
            
            let path = metadata?.path
            print("path:\(path)")
            StorageManager.shared.getDownload(path: path) { url, error in
                if error != nil{
                    print("Lỗi: \(error?.localizedDescription)")
                    return
                }
                let avtPath = url?.absoluteString
                print("avtPath \(avtPath)")
                guard let displayname = self.displayNameTextField.text,
                                  let username = self.usernameTextField.text,
                                  let bio = self.bioTextView.text,
                                  let id = Auth.auth().currentUser?.uid else{
                                print("Update profile thất bại")
                                return
                            }
                
                
                let updateField: [String:Any] = ["displayName":displayname,
                                                             "username":username,
                                                             "bio":bio,
                                                             "avatarPath":avtPath,
                                                             "isUserOnboarded":true
                            ]
                
                DatabaseManager.shared.collectionUsers(updateFields: updateField, id: id) {[weak self] results in
                                guard results == nil else{
                                    print("Lỗi không thể update:\(results)")
                                    return
                                }
                    
                            }
            }
                                
        }
        
    }
    

    private func alertDownloadFail(err:String){
        let alert = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    private func alertUploadFail(err:String){
        let alert = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    @objc private func didTapUpload(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
      
    }
    
    private func configureConstrains(){
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        hintLable.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.top.equalTo(scrollView.snp.top).offset(30)
        }
        avatarPlaceholderImageView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.height.equalTo(120)
            make.width.equalTo(120)
            make.top.equalTo(hintLable.snp.bottom).offset(30)
        }
        displayNameTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(avatarPlaceholderImageView.snp.bottom).offset(40)
        }
        usernameTextField.snp.makeConstraints { make in
            make.leading.equalTo(displayNameTextField)
            make.trailing.equalTo(displayNameTextField)
            make.height.equalTo(50)
            make.top.equalTo(displayNameTextField.snp.bottom).offset(20)
        }
        bioTextView.snp.makeConstraints { make in
            make.leading.equalTo(displayNameTextField)
            make.trailing.equalTo(displayNameTextField)
            make.height.equalTo(150)
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
        }
        submitButton.snp.makeConstraints { make in
            make.leading.equalTo(displayNameTextField)
            make.trailing.equalTo(displayNameTextField)
            make.height.equalTo(50)
            make.top.equalTo(bioTextView.snp.bottom).offset(100)
        }
    }

}
extension ProfileDataFormViewController : UITextViewDelegate, UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == displayNameTextField{
            usernameTextField.becomeFirstResponder()
        }else if textField == usernameTextField{
            bioTextView.becomeFirstResponder()
        }
        return true
    }
}
extension ProfileDataFormViewController : PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage{
                    DispatchQueue.main.sync {
                        self?.avatarPlaceholderImageView.image = image
                    }
                }
            }
        }
    }
}
