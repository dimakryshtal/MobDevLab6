//
//  MyCollectionViewCell.swift
//  MobDevLab1
//
//  Created by Dima on 14.03.2021.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet var myImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(image: UIImage?) {
        myImageView.backgroundColor = .gray
        myImageView.image = image
    }
}
