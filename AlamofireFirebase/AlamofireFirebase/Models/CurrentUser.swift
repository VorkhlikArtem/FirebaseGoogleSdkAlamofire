//
//  CurrentUser.swift
//  AlamofireFirebase
//
//  Created by Артём on 15.11.2022.
//

import Foundation

struct CurrentUser {
    let uid: String
    let name: String
    let email: String
    
    init?(uid: String, data: [String: Any]) {
        
        guard
            let name = data["name"] as? String,
            let email = data["email"] as? String
            else { return nil }
        
        self.uid = uid
        self.name = name
        self.email = email
    }
}
