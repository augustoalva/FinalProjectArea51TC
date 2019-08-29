//
//  ViewController.swift
//  FinalArea51Project
//
//  Created by Augusto Alva Campos on 8/18/19.
//  Copyright © 2019 Augusto Alva Campos. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = UserDefaultsService().getLoginStatus() {
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let controller = stb.instantiateViewController(withIdentifier: "tabBarC")
            present(controller, animated: true, completion: nil)
        }
    }

    @IBAction func logInAction(_ sender: UIButton) {
        guard let mail = mailTextField.text, !mail.isEmpty else {
            //Alerta
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa tu correo", viewController: self)
            return
        }
        guard let pass = passwordTextField.text, !pass.isEmpty else {
            AlertHelper().notificationAlert(title: "Alerta", message: "Ingresa tu contraseña", viewController: self)
            return
        }
        
        SVProgressHUD.setForegroundColor(UIColor.orange)
        SVProgressHUD.show()
        //Logica de login
        Auth.auth().signIn(withEmail: mail, password: pass) { (auth, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                print(error.localizedDescription)
                AlertHelper().notificationAlert(title: "Error", message: "Ocurrió un error \(error.localizedDescription)", viewController: self)
                return
            }
            //El usuario ya se logueó
            //Mandar a la siguiente vista
            UserDefaultsService().saveLoginStatus(withStatus: true)
            UserDefaultsService().saveUserID(userID: auth!.user.uid)
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let controller = stb.instantiateViewController(withIdentifier: "tabBarC")
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let controller = stb.instantiateViewController(withIdentifier: "signUpVC")
        self.present(controller, animated: true, completion: nil)
    }
}

