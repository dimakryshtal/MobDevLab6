//
//  MyCollectionViewCell.swift
//  MobDevLab1
//
//  Created by Dima on 14.03.2021.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(url: String) {
        let child = SpinnerViewController()
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        child.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        myImageView.backgroundColor = .gray
        NetworkManager.sharad.getImage(with: url) { [weak self](image, error) in
            child.view.removeFromSuperview()
            child.removeFromParent()
            if let img = image {
                self?.myImageView.image = img
            }
        }
    }
}
