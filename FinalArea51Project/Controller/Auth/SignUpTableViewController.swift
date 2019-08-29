//
//  SignUpTableViewController.swift
//  FinalArea51Project
//
//  Created by Augusto Alva Campos on 8/24/19.
//  Copyright © 2019 Augusto Alva Campos. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var rptPassTextField: UITextField!
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    @IBAction func saveUserAction(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa el nombre", viewController: self)
            return
        }
        
        guard let lastname = lastnameTextField.text, !lastname.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa el apellido", viewController: self)
            return
        }
        
        guard let age = ageTextField.text, !age.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa la edad", viewController: self)
            return
        }
        
        guard let mail = mailTextField.text, !mail.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa el correo", viewController: self)
            return
        }
        guard let pass = passTextField.text, !pass.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa la contraseña", viewController: self)
            return
        }
        
        guard let rptPass = rptPassTextField.text, !rptPass.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa la contraseña", viewController: self)
            return
        }
        
        guard rptPass.elementsEqual(pass) else{
            AlertHelper().notificationAlert(title: "Alerta", message: "Las contraseñas no coinciden", viewController: self)
            return
        }
        
        SVProgressHUD.setForegroundColor(UIColor.orange)
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: mail, password: pass) { (auth, error) in
            if let err = error {
                SVProgressHUD.dismiss()
                AlertHelper().notificationAlert(title: "Error", message: "Ocurrió un error \(err.localizedDescription)", viewController: self)
                print(err.localizedDescription)
                return
            }
            
            let user = User(id: "", uid: auth!.user.uid, name: name, lastname: lastname, age: Int(age) ?? 0, email: mail)
            self.saveRemoteUsers(user: user)
            
        }
    }
    
    func saveRemoteUsers(user : User) {
        ref.child("users").childByAutoId().setValue(user.toAny(), withCompletionBlock: { (error, reference) in
            SVProgressHUD.dismiss()
            if let err = error {
                AlertHelper().notificationAlert(title: "Error", message: "Ocurrió un error \(err.localizedDescription)", viewController: self)
                print(err.localizedDescription)
                return
            }
            
            let alert = UIAlertController(title: "Exito", message: "El usuario ha sido creado", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel) { (ac) in
                UserDefaultsService().saveLoginStatus(withStatus: true)
                UserDefaultsService().saveUserID(userID: user.uid!)
                let stb = UIStoryboard(name: "Main", bundle: nil)
                let controller = stb.instantiateViewController(withIdentifier: "tabBarC")
                self.present(controller, animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        })
    }
}
