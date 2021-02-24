//
//  ThisMatchViewController.swift
//  tinder
//
//  Created by José Alves da Cunha on 21/02/21.
//

import UIKit

class ThisMatchViewController: UIViewController {
    
    var user: User? {
        didSet {
            if let user = user {
                dogImageView.image = UIImage(named: user.photo)
                messageLabel.text = "\(user.name) curtiu voce tambem!"
            }
        }
    }
    
    let dogImageView: UIImageView = .photoImageView(named: "dog1")
    let likeImageView: UIImageView = .photoImageView(named: "like")
    let messageLabel: UILabel = .textBoldLabel(18, textColor: .white, numberOfLines: 1)
    
    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.placeholder = "Diga oi ou au au"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.textColor = .darkGray
        textField.returnKeyType = .go
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 0))
        textField.rightViewMode = .always
        
        return textField
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Enviar", for: .normal)
        button.setTitleColor(UIColor(named: "redColor"), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Voltar ao tinderDog", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(dogImageView)
        dogImageView.fillSuperview()
        
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.purple.cgColor]
        dogImageView.layer.addSublayer(gradient)
        
        messageLabel.textAlignment = .center
        
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeImageView.contentMode = .scaleAspectFit
        
        messageTextField.addSubview(sendMessageButton)
        sendMessageButton.fill(top: messageTextField.topAnchor,
                               leading: nil,
                               trailing: messageTextField.trailingAnchor,
                               bottom: messageTextField.bottomAnchor,
                               padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        sendMessageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [likeImageView, messageLabel, messageTextField, backButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        stackView.fill(top: nil,
                       leading: view.leadingAnchor,
                       trailing: view.trailingAnchor,
                       bottom: view.bottomAnchor,
                       padding: .init(top: 0, left: 32, bottom: 46, right: 32))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func backClick() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func sendMessage() {
        if let message = self.messageTextField.text {
            print(message)
        }
    }
    
    @objc func keyboardShow (notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                
                UIView.animate(withDuration: duration) {
                    self.view.frame = CGRect(x: UIScreen.main.bounds.origin.x,
                                             y: UIScreen.main.bounds.origin.y,
                                             width: UIScreen.main.bounds.width,
                                             height: UIScreen.main.bounds.height - keyboardSize.height)
                    self.view.layoutIfNeeded()
                }
            }
            
        }
    }
    @objc func keyboardHide(notification: NSNotification) {
        
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.view.frame = UIScreen.main.bounds
                self.view.layoutIfNeeded()
            }
        }
    }
}
extension ThisMatchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMessage()
        return true
    }
}
