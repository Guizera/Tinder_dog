//
//  DetailViewController.swift
//  tinder
//
//  Created by José Alves da Cunha on 22/02/21.
//

import UIKit

class HeaderLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach({ (attribute) in
            if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                
                guard let collectionView = collectionView else { return }
                
                let contentOffSetY = collectionView.contentOffset.y
                
                attribute.frame = CGRect(x: 0,
                                         y: contentOffSetY,
                                         width: collectionView.bounds.width,
                                         height: attribute.bounds.height - contentOffSetY)
                
            }
        })
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

class DetailViewController: UICollectionViewController {
    
    var user: User? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let cellId = "cell"
    let headerId = "headerId"
    let perfilId = "perfilId"
    let photosId = "photosId"
    
    var deslikeButton: UIButton = .iconFooter(named: "close", color: UIColor(named: "redColor") ?? .red)
    var likeButton: UIButton = .iconFooter(named: "hearth", color: UIColor(named: "greenColor") ?? .green)
    
    var backPerfilButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-down"), for: .normal)
        button.backgroundColor = UIColor(named: "redColor")
        button.clipsToBounds = true
        
        return button
    }()
    
    var callback: ((User?, Action) -> Void)?
    
    init() {
        super.init(collectionViewLayout: HeaderLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 134, right: 0)
        
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(DetailPerfilCell.self, forCellWithReuseIdentifier: perfilId)
        collectionView.register(DetailPhotosCell.self, forCellWithReuseIdentifier: photosId)
        
        self.addBackPerfilButton()
        self.addFooter()
    }
    func addBackPerfilButton() {
        
        view.addSubview(backPerfilButton)
        backPerfilButton.frame = CGRect(x: view.bounds.width - 69,
                                        y: view.bounds.height * 0.7 - 24,
                                        width: 48,
                                        height: 48)
        backPerfilButton.layer.cornerRadius = 24
        backPerfilButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
    }
    func addFooter() {
        let stackView = UIStackView(arrangedSubviews: [UIView(),deslikeButton, likeButton, UIView()])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.fill(top: nil,
                       leading: view.leadingAnchor,
                       trailing: view.trailingAnchor,
                       bottom: view.bottomAnchor,
                       padding: .init(top: 0, left: 16, bottom: 34, right: 16))
        
        deslikeButton.addTarget(self, action: #selector(deslikeClick), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeClick), for: .touchUpInside)
    }
    @objc func backClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deslikeClick() {
        print("deslike")
        self.callback?(self.user, Action.deslike)
        self.backClick()
    }
    @objc func likeClick() {
        print("like")
        self.callback?(self.user, Action.like)
        self.backClick()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! DetailHeaderView
        header.user = self.user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.bounds.width, height: view.bounds.height * 0.7)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: perfilId, for: indexPath) as! DetailPerfilCell
            cell.user = self.user
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photosId, for: indexPath) as! DetailPhotosCell
            return cell
        }
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        let originY = view.bounds.height * 0.7 - 24
        
        if scrollView.contentOffset.y > 0 {
            self.backPerfilButton.frame.origin.y = originY - scrollView.contentOffset.y
        } else {
            self.backPerfilButton.frame.origin.y = originY + scrollView.contentOffset.y * -1
        }
    }
}
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = UIScreen.main.bounds.width
        var height: CGFloat = UIScreen.main.bounds.width * 0.66
        
        if indexPath.item == 0 {
            
            let cell = DetailPerfilCell(frame: CGRect(x: 0, y: 0, width: width, height: height))
            cell.user = self.user
            cell.layoutIfNeeded()
            
            let size = cell.systemLayoutSizeFitting(CGSize(width: width, height: 1000))
            height = size.height
        }
        return .init(width: width, height: height)
        
    }
}
