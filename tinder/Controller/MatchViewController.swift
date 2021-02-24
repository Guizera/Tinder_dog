//
//  MatchViewController.swift
//  tinder
//
//  Created by José Alves da Cunha on 19/02/21.
//

import UIKit

enum Action {
    case deslike
    case like
    case superlike
}

class MatchViewController: UIViewController {
    
    var perfilButton: UIButton = .iconMenu(named: "user", color: UIColor(named: "grayColor") ?? .darkGray)
    var chatButton: UIButton = .iconMenu(named: "chat", color: UIColor(named: "grayColor") ?? .darkGray)
    var logoButton: UIButton = .iconMenu(named: "logoDog", color: UIColor(named: "redColor") ?? .red)
    
    var deslikeButton: UIButton = .iconFooter(named: "close", color: UIColor(named: "redColor") ?? .red)
    var likeButton: UIButton = .iconFooter(named: "hearth", color: UIColor(named: "greenColor") ?? .green)
    var boostButton: UIButton = .iconFooter(named: "thunder", color: UIColor(named: "purpleColor") ?? .purple)
    var reloadButton: UIButton = .iconFooter(named: "refresh", color: UIColor(named: "yellowColor") ?? .yellow)
    var superLikeButton: UIButton = .iconFooter(named: "star", color: UIColor(named: "blueColor") ?? .blue)
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationController?.navigationBar.isHidden = true
        
        let loading = Loading(frame: view.frame)
        view.insertSubview(loading, at: 0)
        
        self.addHeader()
        self.addFooter()
        self.searchUsers()
    }
    
    func searchUsers() {
        
        UserService.shared.searchUsers { (users, err) in
            if let users = users {
                DispatchQueue.main.async {
                    self.users = users
                    self.addCards()
                }
            }
        }        
    }
}

extension MatchViewController {
    
    func addHeader() {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let top: CGFloat = window?.safeAreaInsets.top ?? 44
        
        let stackView = UIStackView(arrangedSubviews: [perfilButton, logoButton, chatButton])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.fill(top: view.topAnchor,
                       leading: view.leadingAnchor,
                       trailing: view.trailingAnchor,
                       bottom: nil,
                       padding: .init(top: top, left: 16, bottom: 0, right: 16))
        
        
    }
    
    func addFooter() {
        let stackView = UIStackView(arrangedSubviews: [reloadButton, deslikeButton, boostButton, likeButton, superLikeButton])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.fill(top: nil,
                       leading: view.leadingAnchor,
                       trailing: view.trailingAnchor,
                       bottom: view.bottomAnchor,
                       padding: .init(top: 0, left: 16, bottom: 36, right: 16))
        
        deslikeButton.addTarget(self, action: #selector(deslikeClickButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeClickButton), for: .touchUpInside)
        superLikeButton.addTarget(self, action: #selector(superLikeClickButton), for: .touchUpInside)
        
    }
}

extension MatchViewController {
    
    func addCards() {
        
        for user in users {
            
            let card = MatchCardView()
            card.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: view.bounds.height * 0.7)
            
            card.center = view.center
            card.user = user
            card.tag = user.id
            
            card.callback = { (data) in
                self.viewDetails(user: data)
            }
            
            let gesture = UIPanGestureRecognizer()
            gesture.addTarget(self, action: #selector(handleCard))
            
            card.addGestureRecognizer(gesture)
            
            view.insertSubview(card, at: 1)
        }
        
    }
    func removeCards(card: UIView) {
        card.removeFromSuperview()
        
        self.users = self.users.filter({ (user) -> Bool in
            return user.id != card.tag
        })
    }
    func verifyMatchs(user: User) {
        if user.match {
            print("woow")
            
            let TMatchVC = ThisMatchViewController()
            TMatchVC.user = user
            TMatchVC.modalPresentationStyle = .fullScreen
            
            self.present(TMatchVC, animated: true, completion: nil)
        }
    }
    func viewDetails(user: User) {
        let detailViewController = DetailViewController()
        detailViewController.user = user
        detailViewController.modalPresentationStyle = .fullScreen
        
        self.present(detailViewController, animated: true, completion: nil)
    }
    
}

extension MatchViewController {
    
    @objc func handleCard(_ gesture: UIPanGestureRecognizer) {
        if let card = gesture.view as? MatchCardView {
            let point = gesture.translation(in: view)

            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            let rotationAngle = point.x / view.bounds.width * 0.4
            
            if point.x > 0 {
                card.likeImageView.alpha = rotationAngle * 5
                card.deslikeImageView.alpha = 0.0
            } else {
                card.likeImageView.alpha = 0.0
                card.deslikeImageView.alpha = rotationAngle * 5 * -1 
            }
            
            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            
            if gesture.state == .ended {
                
                if card.center.x > self.view.bounds.width {
                    self.animatedCard(rotationAngle: rotationAngle, action: .like)
                    return
                }
                
                if card.center.x < -50 {
                    self.animatedCard(rotationAngle: rotationAngle, action: .deslike)
                    return
                }
                
                UIView.animate(withDuration: 0.2) {
                card.center = self.view.center
                card.transform = .identity
                }
            }
        }
    }
    @objc func deslikeClickButton() {
        self.animatedCard(rotationAngle: -0.4, action: .deslike)
    }
    @objc func likeClickButton() {
        self.animatedCard(rotationAngle: 0.4, action: .like)
    }
    @objc func superLikeClickButton() {
        self.animatedCard(rotationAngle: 0, action: .superlike)
    }
    
    func animatedCard(rotationAngle: CGFloat, action: Action) {
        if let user = self.users.first {
            for view in self.view.subviews {
                if view.tag == user.id {
                    if let card = view as? MatchCardView {
                        let center: CGPoint
                        var like: Bool
                        
                        switch action {
                        case .deslike:
                            center = CGPoint(x: card.center.x - self.view.bounds.width, y: card.center.y + 50)
                            like = false
                        case .like:
                            center = CGPoint(x: card.center.x + self.view.bounds.width, y: card.center.y + 50)
                            like = true
                        case .superlike:
                            center = CGPoint(x: card.center.x, y: card.center.y - self.view.bounds.height)
                            like = true
                        }
                        UIView.animate(withDuration: 0.2, animations: {
                            card.center = center
                            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
                            card.deslikeImageView.alpha = like == false ? 1 : 0
                            card.likeImageView.alpha = like == true ? 1 : 0
                        }) { (_) in
                            if like {
                                self.verifyMatchs(user: user)
                            }
                            
                            self.removeCards(card: card)
                        }
                    }
                }
            }
        }
    }
}
