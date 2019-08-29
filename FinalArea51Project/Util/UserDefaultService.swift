//
//  UserDefaultService.swift
//  FinalArea51Project
//
//  Created by Augusto Alva Campos on 8/24/19.
//  Copyright © 2019 Augusto Alva Campos. All rights reserved.
//

import Foundation

class UserDefaultsService : NSObject {
    
    func saveLoginStatus(withStatus userLogged: Bool) {
        UserDefaults.standard.set(userLogged, forKey: "islogged")
        UserDefaults.standard.synchronize()
    }
    
    func getLoginStatus() -> Bool? {
        return UserDefaults.standard.object(forKey: "islogged") as? Bool
    }
    
    func removeLoginStatus() {
        UserDefaults.standard.removeObject(forKey: "islogged")
        UserDefaults.standard.synchronize()
    }
    
    func saveUserID(userID: String) {
        UserDefaults.standard.set(userID, forKey: "UID")
        UserDefaults.standard.synchronize()
    }
    
    func getUserID() -> String? {
        return UserDefaults.standard.object(forKey: "UID") as? String
    }
    
    func removeUserID() {
        UserDefaults.standard.removeObject(forKey: "UID")
        UserDefaults.standard.synchronize()
    }
}
