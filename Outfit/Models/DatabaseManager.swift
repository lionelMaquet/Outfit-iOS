//
//  DatabaseManager.swift
//  Outfit
//
//  Created by Lionel Maquet on 12/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import Foundation
import Firebase


struct DatabaseManager {
    let userID: String
    let db = Firestore.firestore()
    
    func initialiseFirstTimeUser(username: String) {
        //SAVE DATA to google firestore
        if let newUserMail = Auth.auth().currentUser?.email {
            self.db.collection("users").addDocument(data: [ // Ajoute un document à la collection
                
                "id": newUserMail,
                "username":username,
                
                
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    DispatchQueue.main.async {
                        //self.delegate?.newUserWasCreated()
                    }
                    
                }
            }
        }
        
    }
}
