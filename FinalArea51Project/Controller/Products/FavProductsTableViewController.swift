//
//  FavProductsTableViewController.swift
//  FinalArea51Project
//
//  Created by Augusto Alva Campos on 8/28/19.
//  Copyright © 2019 Augusto Alva Campos. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class FavProductsTableViewController: UITableViewController {

    @IBOutlet var favsTableView: UITableView!
    
    var products = [Product]()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        SVProgressHUD.setForegroundColor(UIColor.orange)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateProducts()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.products[indexPath.row].isHardware! {
            let cell = tableView.dequeueReusableCell(withIdentifier: "hardwareFavCellID", for: indexPath) as! HardFavTableViewCell
            cell.product = self.products[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "softwareFavCellID", for: indexPath) as! SoftFavTableViewCell
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
        ref.child("favs").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observeSingleEvent(of: .value) { (snapshot) in
            SVProgressHUD.dismiss()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let product = Product(snapshot: child)
                self.products.append(product)
            }
            self.favsTableView.reloadData()
        }
    }
    
    func updateProducts() {
        products.removeAll()
        loadProducts()
    }

}
