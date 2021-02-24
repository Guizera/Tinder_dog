//
//  MatchCardView.swift
//  tinder
//
//  Created by José Alves da Cunha on 19/02/21.
//

import UIKit

class MatchCardView: UIView {
    
    var user: User? {
        didSet {
            if let user = user {
                dogImageView.image = UIImage(named: user.photo)
                nameLabel.text = user.name
                ageLabel.text = String(user.age)
                descriptionLabel.text = user.description
                
            }
        }
    }
    
    let dogImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dog1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = .textBoldLabel(32, textColor: .white)
    
    let ageLabel: UILabel = .textBoldLabel(28, textColor: .white)
    
    let descriptionLabel: UILabel = .textLabel(18, textColor: .white, numberOfLines: 2)
    
    let deslikeImageView: UIImageView = .iconCard(named: "broken-hearth")
    let likeImageView: UIImageView = .iconCard(named: "hearth")
    
    var callback: ((User) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customerCard()
        
        nameLabel.text = "Luna"
        ageLabel.text = "2"
        descriptionLabel.text = "Sou uma doguinha muito amavel e carinhosa."
        
        nameLabel.addShadow()
        ageLabel.addShadow()
        descriptionLabel.addShadow()
        
        addSubview(dogImageView)
        addSubview(deslikeImageView)
        deslikeImageView.fill(
            top: topAnchor,
            leading: nil,
            trailing: trailingAnchor,
            bottom: nil,
            padding: UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 20))
        
        addSubview(likeImageView)
        likeImageView.fill(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: nil,
            bottom: nil,
            padding: UIEdgeInsets.init(top: 20, left: 20, bottom: 0, right: 0))
        
        dogImageView.fillSuperview()
        
        let nameAgeStackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel, UIView()])
        nameAgeStackView.spacing = 12
        
        let stackView = UIStackView(arrangedSubviews: [nameAgeStackView, descriptionLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.fill(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tap)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func viewClick() {
        if let user = self.user {
            self.callback?(user)
        }
    }
    
    func customerCard() {
        layer.borderWidth = 0.3
        layer.borderColor = UIColor(named: "lightGray")?.cgColor
        layer.cornerRadius = 8.0
        clipsToBounds = true
    }
}
