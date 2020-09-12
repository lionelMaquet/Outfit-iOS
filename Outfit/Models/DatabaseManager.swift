//
//  DatabaseManager.swift
//  Outfit
//
//  Created by Lionel Maquet on 12/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import Foundation
import Firebase

protocol DatabaseManagerDelegate {
    func triedToRetreiveUsername(succeeded : Bool)
}

struct DatabaseManager {
    let userID: String
    let db = Firestore.firestore()
    var delegate : DatabaseManagerDelegate?
    var currentUserMail : String? {
        if let mail = Auth.auth().currentUser?.email {
            return mail
        } else {
            print("ERROR : couldn't get user mail")
            return "nomail"
        }
        
    }
    
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
    
    
    func userHasAUsername() {
        
        
        if let mail = currentUserMail {
            db.collection("users").whereField("mail",isEqualTo: mail).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("error getting documents \(err)")
                } else {
                    var numberOfDocs = querySnapshot?.documents.count
                    let isUsernameCreated = numberOfDocs != 0
                    self.delegate?.triedToRetreiveUsername(succeeded : isUsernameCreated)
                }
            }
            
        }
        
        
        
        
    }
}
