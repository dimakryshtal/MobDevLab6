//
//  CustomTableViewCell.swift
//  MobDevLab1
//
//  Created by Dima on 20.02.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var year: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var myContentView: UIView!
    @IBOutlet var myStackView: UIStackView!
    
    lazy var constr = [
        myContentView.bottomAnchor.constraint(greaterThanOrEqualTo: myImageView.bottomAnchor, constant: 10),
        myContentView.bottomAnchor.constraint(greaterThanOrEqualTo: myStackView.bottomAnchor, constant: 10)
    ]
    
    func setImageAndLabel(movie: Movie) {
        myImageView.image = nil
        if(movie.poster == "" || movie.poster == "N/A") {
            myImageView.image = nil
        } else {
            NetworkManager.sharad.getImage(with: movie.poster) {[weak self] (cover, error) in
                if let cover = cover {
                    self?.myImageView.image = cover
                }
            }
        }
        
        constr[0].priority = UILayoutPriority(999)
        constr[1].priority = UILayoutPriority(999)
        constr[0].isActive = true
        constr[1].isActive = true
        
        title.text = movie.title
        if(movie.year == "") {
            year.text = nil
            year.isHidden = true
        } else {
            year.isHidden = false
            year.text = movie.year
        }
        if(movie.type == "") {
            type.text = nil
            type.isHidden = true
            
        } else {
            type.isHidden = false
            type.text = movie.type
        }
        
    }
}
