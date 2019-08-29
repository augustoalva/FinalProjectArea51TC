//
//  Product.swift
//  FinalArea51Project
//
//  Created by Augusto Alva Campos on 8/27/19.
//  Copyright © 2019 Augusto Alva Campos. All rights reserved.
//

import Foundation
import Firebase

class Product : NSObject{
    var id: String?
    var name: String?
    var price: Int?
    var isHardware: Bool?
    var desc: String?
    var image: String?
    var uid : String?
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as? String ?? ""
        name = snapshotValue["name"] as? String ?? ""
        price = snapshotValue["price"] as? Int ?? 0
        isHardware = snapshotValue["isHardware"] as? Bool ?? false
        desc = snapshotValue["desc"] as? String ?? ""
        image = snapshotValue["image"] as? String ?? ""
        uid = snapshotValue["uid"] as? String ?? ""
    }
    
    init(id: String, name: String, price: Int, isHardware: Bool, desc: String, image: String, uid: String) {
        self.id = id
        self.name = name
        self.price = price
        self.isHardware = isHardware
        self.desc = desc
        self.image = image
        self.uid = uid
    }
    
    func toAny() -> Any {
        return [
            "uid" : uid ?? "",
            "name" : name ?? "",
            "desc" : desc ?? "",
            "price" : price ?? 0,
            "image" : image ?? "",
            "isHardware" : isHardware ?? false
        ]
    }
}
