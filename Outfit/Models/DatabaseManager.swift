//
//  DatabaseManager.swift
//  Outfit
//
//  Created by Lionel Maquet on 12/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import Foundation
import Firebase
import Kingfisher



protocol DatabaseManagerDelegate {
    func triedToRetreiveUsername(succeeded : Bool)
    func allPostsWereRetreived(posts: [Post])
    //func profileWasFetched(user: User)
}

extension DatabaseManagerDelegate {
    func triedToRetreiveUsername(succeeded : Bool){}
    func allPostsWereRetreived(posts: [Post]){}
    func profileWasFetched(user: User){}
}

class DatabaseManager {
    
    init(userID: String){
        self.userID = userID
    }
    
    
    let userID: String
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var delegate : DatabaseManagerDelegate?
    var currentPosts = [Post]()
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
                    }
                }
            }
        }
        
    }
    
    func userHasAUsername() {
        if let mail = currentUserMail {
            db.collection("users").whereField("id",isEqualTo: mail).getDocuments { (querySnapshot, err) in
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
    
    func getProfileDetails(userID: String) {
        db.collection("users").whereField("id",isEqualTo: userID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("error getting documents \(err)")
            } else {
                let data = querySnapshot?.documents[0].data()
                let id = data!["id"] as! String
                let imageURL = data!["imageURL"] as! String
                let username = data!["username"] as! String
                let user = User(userID: id, imageURL: imageURL, username: username)
                self.delegate?.profileWasFetched(user: user)
            }
        }
    }
    
    func getAllPosts(){
        db.collection("posts").getDocuments { (snapshot, err) in
            if let err = err {
                print("error getting all posts")
            } else {
                let posts = self.transformDocumentsInPosts(docs: snapshot?.documents)
                self.currentPosts = posts
                self.fillCurrentPostsUserDetails()
            }
        }
    }
    
    
    
    func fillCurrentPostsUserDetails(){
        for i in 0...currentPosts.count - 1 {
            db.collection("users").whereField("id",isEqualTo: currentPosts[i].userID).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("error getting documents \(err)")
                } else {
                    let data = querySnapshot?.documents[0].data()
                    let id = data!["id"] as! String
                    let imageURL = data!["imageURL"] as! String
                    let username = data!["username"] as! String
                    self.currentPosts[i].user = User(userID: id, imageURL: imageURL, username: username)
                    self.delegate?.allPostsWereRetreived(posts: self.currentPosts)
                }
            }
        }
    }
    
    func transformDocumentsInPosts(docs : Any?) -> [Post] {
        var posts : [Post] = []
        let documents = docs as! [QueryDocumentSnapshot]
        
        for i in 0...documents.count - 1 {
            let userID = documents[i]["userID"] as! String
            let description = documents[i]["description"] as! String
            let commentCount = documents[i]["commentCount"] as! Int
            let likeCount = documents[i]["likeCount"] as! Int
            let imageURL = documents[i]["imageURL"] as! String
            let sexe = documents[i]["sexe"] as! String
            let season = documents[i]["season"] as! String
            let style = documents[i]["style"] as! String
            
            posts.append(Post(userID: userID, description: description, commentCount: commentCount, likeCount: likeCount, imageURL: imageURL, style: style, sexe: sexe, season: season ))
        }
        return posts
    }
    
}
