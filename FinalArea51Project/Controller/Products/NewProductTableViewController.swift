//
//  NewProductTableViewController.swift
//  FinalArea51Project
//
//  Created by Augusto Alva Campos on 8/28/19.
//  Copyright © 2019 Augusto Alva Campos. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

protocol NewProductProtocolVC {
    func updateProducts()
}

class NewProductTableViewController: UITableViewController {

    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescTextField: UITextField!
    @IBOutlet weak var urlImageTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var hardwareSwitch: UISwitch!
    
    var delegate : NewProductProtocolVC?
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    func saveProducts(product : Product) {
        ref.child("products").childByAutoId().setValue(product.toAny(), withCompletionBlock: { (error, reference) in
            SVProgressHUD.dismiss()
            if let err = error {
                AlertHelper().notificationAlert(title: "Error", message: "Ocurrió un error \(err.localizedDescription)", viewController: self)
                print(err.localizedDescription)
                return
            }
            
            let alert = UIAlertController(title: "Exito", message: "El producto se ha añadido correctamente", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel) { (ac) in
                self.delegate?.updateProducts()
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        })
    }

    @IBAction func saveProductsAction(_ sender: UIBarButtonItem) {
        guard let name = productNameTextField.text, !name.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingrese el nombre del producto", viewController: self)
            return
        }
        
        guard let desc = productDescTextField.text, !desc.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingrese la descripción del producto", viewController: self)
            return
        }
        
        guard let url = urlImageTextField.text, !url.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingrese la ruta de la imagen", viewController: self)
            return
        }
        
        guard let price = productPriceTextField.text, !price.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingrese el precio del producto", viewController: self)
            return
        }
        
        SVProgressHUD.setForegroundColor(UIColor.orange)
        SVProgressHUD.show()
        let uid = UserDefaultsService().getUserID()
        saveProducts(product: Product(id: "", name: name, price: Int(price)!, isHardware: hardwareSwitch.isOn, desc: desc, image: url, uid: uid!))
    }
}
