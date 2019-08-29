//
//  HardFavTableViewCell.swift
//  FinalArea51Project
//
//  Created by Augusto Alva Campos on 8/28/19.
//  Copyright © 2019 Augusto Alva Campos. All rights reserved.
//

import UIKit
import Kingfisher

class HardFavTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var product : Product? {
        didSet {
            if let product = product {
                nameLabel.text = product.name
                descLabel.text = product.desc
                if let price = product.price {
                    priceLabel.text = "Precio: S/. \(price)"
                }
                if let image = product.image {
                    productImage.kf.setImage(with: URL(string: image))
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productImage.layer.cornerRadius = 45
        productImage.clipsToBounds = true
        productImage.contentMode = .scaleAspectFill
    }
}
