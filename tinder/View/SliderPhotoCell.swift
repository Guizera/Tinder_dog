//
//  SliderPhotoCell.swift
//  tinder
//
//  Created by José Alves da Cunha on 24/02/21.
//

import UIKit

class SliderPhotoCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = .photoImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(photoImageView)
        photoImageView.fillSuperview()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
