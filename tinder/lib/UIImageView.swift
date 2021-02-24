//
//  UIImageView.swift
//  tinder
//
//  Created by José Alves da Cunha on 20/02/21.
//

import UIKit

extension UIImageView {
    
    static func photoImageView(named: String? = nil) -> UIImageView {
        let imageView = UIImageView()
        if let named = named {
            imageView.image = UIImage(named: named)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    static func iconCard (named: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: named)
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.red
        imageView.size(size: .init(width: 50, height: 50))
        imageView.alpha = 0.0
        return imageView
    }
}
