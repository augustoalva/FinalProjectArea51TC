//
//  User.swift
//  FinalArea51Project
//
//  Created by Augusto Alva Campos on 8/24/19.
//  Copyright © 2019 Augusto Alva Campos. All rights reserved.
//

import Foundation
import Firebase

class User : NSObject{
    var id: String?
    var uid: String?
    var name: String?
    var lastname: String?
    var age: Int?
    var email: String?
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshot.key
        uid = snapshotValue["uid"] as? String ?? ""
        name = snapshotValue["name"] as? String ?? ""
        lastname = snapshotValue["lastname"] as? String ?? ""
        email = snapshotValue["email"] as? String ?? ""
        age = snapshotValue["age"] as? Int ?? 0
    }
    
    init(id: String, uid: String, name: String, lastname: String, age: Int, email: String) {
        self.id = id
        self.uid = uid
        self.name = name
        self.lastname = lastname
        self.age = age
        self.email = email
    }
    
    func toAny() -> Any {
        return [
            "uid" : uid ?? "",
            "name" : name ?? "",
            "lastname" : lastname ?? "",
            "age" : age ?? 0,
            "email" : email ?? ""
        ]
    }
}
