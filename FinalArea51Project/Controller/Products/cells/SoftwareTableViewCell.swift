//
//  SoftwareTableViewCell.swift
//  FinalArea51Project
//
//  Created by Augusto Alva Campos on 8/27/19.
//  Copyright © 2019 Augusto Alva Campos. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import Firebase

class SoftwareTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var ref : DatabaseReference!
    
    var product : Product? {
        didSet {
            if let product = product {
                nameLabel.text = product.name
                descLabel.text = product.desc
                if let price = product.price {
                    priceLabel.text = "Precio: S/. \(price)"
                }
                if let image = product.image {
                    productImageView.kf.setImage(with: URL(string: image))
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
        productImageView.layer.cornerRadius = 45
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
    }
    
    @IBAction func addFavsAction(_ sender: UIButton) {
        if let prod = product{
            SVProgressHUD.show()
            ref.child("favs").childByAutoId().setValue(prod.toAny(), withCompletionBlock: { (error, reference) in
                SVProgressHUD.dismiss()
                if let err = error {
                    AlertHelper().notificationAlert(title: "Error", message: "Ocurrió un error \(err.localizedDescription)", viewController: ProductTableViewController())
                    print(err.localizedDescription)
                    return
                }
                
                let alert = UIAlertController(title: "Exito", message: "El producto se ha añadido correctamente", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel) { (ac) in
                }
                alert.addAction(action)
            })
        }
    }
    
}
