//
//  ContactTableViewController.swift
//  FinalArea51Project
//
//  Created by Augusto Alva Campos on 8/28/19.
//  Copyright © 2019 Augusto Alva Campos. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ContactTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var lastnameLabel: UITextField!
    @IBOutlet weak var mailLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    
    var ref : DatabaseReference!
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        SVProgressHUD.setForegroundColor(UIColor.orange)
        loadInfo()
    }

    @IBAction func updateDataAccountAction(_ sender: UIBarButtonItem) {
        guard let name = nameLabel.text, !name.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa el nombre", viewController: self)
            return
        }
        
        guard let lastname = lastnameLabel.text, !lastname.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa el apellido", viewController: self)
            return
        }
        
        guard let age = ageLabel.text, !age.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa la edad", viewController: self)
            return
        }
        
        guard let mail = mailLabel.text, !mail.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa el correo", viewController: self)
            return
        }
        
        user.name = name
        user.lastname = lastname
        user.age = Int(age)
        user.email = mail
        
        SVProgressHUD.setForegroundColor(UIColor.orange)
        SVProgressHUD.show()
        updateUser(user: user!)
    }
    
    func loadInfo(){
        SVProgressHUD.show()
        let uid = UserDefaultsService().getUserID()
        ref.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observeSingleEvent(of: .value) { (snapshot) in
            SVProgressHUD.dismiss()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                self.user = User(snapshot: child)
            }
            
            if let lUser = self.user{
                self.nameLabel.text = lUser.name
                self.lastnameLabel.text = lUser.lastname
                self.ageLabel.text = String(lUser.age!)
                self.mailLabel.text = lUser.email
            }
            
        }
    }
    
    func updateUser(user : User) {
        ref.child("users").child(user.id!).updateChildValues(["name":user.name!, "lastname":user.lastname!, "email": user.email!, "age" : user.age!]) { (error, reference) in
            SVProgressHUD.dismiss()
            if let err = error {
                AlertHelper().notificationAlert(title: "Error", message: "Ocurrió un error \(err.localizedDescription)", viewController: self)
                print(err.localizedDescription)
                return
            }
            
            let alert = UIAlertController(title: "Exito", message: "Sus datos se han actualizado", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel) { (ac) in
                
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
