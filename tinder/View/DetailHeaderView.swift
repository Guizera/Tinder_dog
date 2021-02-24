//
//  DetailHeaderView.swift
//  tinder
//
//  Created by José Alves da Cunha on 23/02/21.
//

import UIKit

class DetailHeaderView: UICollectionReusableView {
    
    var user: User? {
        didSet{
            if let user = user {
                dogImageView.image = UIImage(named: user.photo)
            }
        }
    }
    
    var dogImageView: UIImageView = .photoImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dogImageView)
        dogImageView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
