//
//  DetailPhotosCell.swift
//  tinder
//
//  Created by José Alves da Cunha on 24/02/21.
//

import UIKit

class DetailPhotosCell: UICollectionViewCell {
    
    let descriptionLabel: UILabel = .textBoldLabel(16)
    
    let sliderViewController = SliderViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        descriptionLabel.text = "Fotos recentes do instagram"
        
        addSubview(descriptionLabel)
        descriptionLabel.fill(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        addSubview(sliderViewController.view)
        sliderViewController.view.fill(top: descriptionLabel.bottomAnchor,
                                       leading: leadingAnchor,
                                       trailing: trailingAnchor,
                                       bottom: bottomAnchor)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
