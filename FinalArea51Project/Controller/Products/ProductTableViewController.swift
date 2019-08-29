//
//  ProductsTableViewController.swift
//  FinalArea51Project
//
//  Created by Augusto Alva Campos on 8/24/19.
//  Copyright © 2019 Augusto Alva Campos. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ProductTableViewController: UITableViewController, NewProductProtocolVC {
    
    @IBOutlet var productTableView: UITableView!
    
    var products = [Product]()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        SVProgressHUD.setForegroundColor(UIColor.orange)
        loadProducts()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.products[indexPath.row].isHardware! {
            let cell = tableView.dequeueReusableCell(withIdentifier: "hardwareCellID", for: indexPath) as! HardwareTableViewCell
            cell.product = self.products[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "softwareCellID", for: indexPath) as! SoftwareTableViewCell
            cell.product = self.products[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func loadProducts() {
        SVProgressHUD.show()
        let uid = UserDefaultsService().getUserID()
        ref.child("products").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observeSingleEvent(of: .value) { (snapshot) in
            SVProgressHUD.dismiss()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let product = Product(snapshot: child)
                self.products.append(product)
            }
            self.productTableView.reloadData()
        }
    }
    
    func updateProducts() {
        products.removeAll()
        loadProducts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newProductSegue" {
            let contr = segue.destination as! NewProductTableViewController
            contr.delegate = self
        }
    }
    
    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
        UserDefaultsService().removeLoginStatus()
        UserDefaultsService().removeUserID()
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let controller = stb.instantiateViewController(withIdentifier: "loginVC")
        self.present(controller, animated: true, completion: nil)
    }
}
