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

var sharedDatabaseManager: DatabaseManager?

protocol DatabaseManagerDelegate {
    func triedToRetreiveUsername(succeeded : Bool)
    func allPostsWereRetreived(posts: [Post])
}

extension DatabaseManagerDelegate {
    func triedToRetreiveUsername(succeeded : Bool){}
    func allPostsWereRetreived(posts: [Post]){}
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
    var postsWithUserDetailsFilled : Int = 0
    var postsWithProfileImagesFilled : Int = 0
    var completedPosts : Int = 0
    
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
    
    
    //MARK: - FETCHING POSTS
    
    
    // Function used in login to create or not a new user.
    func userHasAUsername() {
        if let mail = currentUserMail {
            db.collection("users").whereField("id",isEqualTo: mail).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("error getting documents \(err)")
                } else {
                    let numberOfDocs = querySnapshot?.documents.count
                    let isUsernameCreated = numberOfDocs != 0
                    self.delegate?.triedToRetreiveUsername(succeeded : isUsernameCreated)
                }
            }
        }
    }
    
    
    func getAllPosts(){
        DispatchQueue.global(qos: .utility).async {
            self.db.collection("posts").getDocuments { (snapshot, err) in
                if let err = err {
                    print("error getting all posts : ", err)
                } else {
                    let posts = self.transformDocumentsInPosts(docs: snapshot?.documents)
                    self.currentPosts = posts
                    self.fillCurrentPostsUserDetails()
                }
            }
        }
    }
    
    
    
    func fillCurrentPostsUserDetails(){
        guard currentPosts.count > 0 else {
            return
        }
        
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
                    
                    self.postsWithUserDetailsFilled += 1
                    
                    if(self.postsWithUserDetailsFilled == self.currentPosts.count){
                        self.fillPostsWithProfileImages()
                    }
                }
            }
        }
    }
    
    func fillPostsWithProfileImages(){
        for i in 0...currentPosts.count - 1 {
            let url = URL(string: self.currentPosts[i].user!.imageURL)
            DispatchQueue.global(qos: .utility).async {
                let data = (try? Data(contentsOf: url!))!
                let profileImage = UIImage(data: data)
                DispatchQueue.main.async {
                    let oldPost = self.currentPosts[i]
                    let newPost = Post(userID: oldPost.userID, user: oldPost.user, description: oldPost.description, commentCount: oldPost.commentCount, likeCount: oldPost.likeCount, imageURL: oldPost.imageURL, style: oldPost.style, sexe: oldPost.sexe, season: oldPost.season, profileImage: profileImage, postImage: nil, postDocumentID: oldPost.postDocumentID)
                    self.currentPosts[i] = newPost
                    self.postsWithProfileImagesFilled += 1
                    if(self.postsWithProfileImagesFilled == self.currentPosts.count){
                        self.fillPostsWithPostImages()
                    }
                }
            }
        }
    }
    
    func fillPostsWithPostImages(){
        for i in 0...currentPosts.count - 1 {
            let url = URL(string: self.currentPosts[i].imageURL!)
            DispatchQueue.global(qos: .utility).async {
                let data = (try? Data(contentsOf: url!))!
                let postImage = UIImage(data: data)
                DispatchQueue.main.async {
                    let oldPost = self.currentPosts[i]
                    let newPost = Post(userID: oldPost.userID, user: oldPost.user, description: oldPost.description, commentCount: oldPost.commentCount, likeCount: oldPost.likeCount, imageURL: oldPost.imageURL, style: oldPost.style, sexe: oldPost.sexe, season: oldPost.season, profileImage: oldPost.profileImage, postImage: postImage, postDocumentID: oldPost.postDocumentID)
                    self.currentPosts[i] = newPost
                    self.completedPosts += 1
                    if(self.completedPosts == self.currentPosts.count){
                        self.allPostsWereFilled()
                    }
                }
            }
        }
    }
    
    func allPostsWereFilled(){
        self.delegate?.allPostsWereRetreived(posts: currentPosts)
    }
    
    
    
    func transformDocumentsInPosts(docs : Any?) -> [Post] {
        var posts : [Post] = []
        let documents = docs as! [QueryDocumentSnapshot]
        
        guard documents.count > 0 else {
            return []
        }
        
        for i in 0...documents.count - 1 {
            let documentID = documents[i].documentID
            let userID = documents[i]["userID"] as! String
            let description = documents[i]["description"] as! String
            let commentCount = documents[i]["commentCount"] as! Int
            let likeCount = documents[i]["likeCount"] as! Int
            let imageURL = documents[i]["imageURL"] as! String
            let sexe = documents[i]["sexe"] as! String
            let season = documents[i]["season"] as! String
            let style = documents[i]["style"] as! String
            
            posts.append(Post(userID: userID, description: description, commentCount: commentCount, likeCount: likeCount, imageURL: imageURL, style: style, sexe: sexe, season: season, postDocumentID: documentID ))
        }
        return posts
    }
    
    
    //MARK: - UPLOADING POSTS
    
    // uploads the image, then tiggers upload post filled with download url
    func uploadImageAndPost(post: Post, image: UIImage){
        uploadMedia(image: image) { (uploadedImageURL) in
            let completedPost = Post(userID: post.userID, user: post.user, description: post.description, commentCount: post.commentCount, likeCount: post.likeCount, imageURL: uploadedImageURL, style: post.style, sexe: post.sexe, season: post.season)
            self.uploadPost(post: completedPost)
        }
    }
    
    func uploadPost(post: Post){
        
        self.db.collection("posts").addDocument(data: [ // Ajoute un document à la collection
            
            "commentCount" : post.commentCount,
            "description" : post.description,
            "imageURL" : post.imageURL,
            "likeCount" : post.likeCount,
            "season" : post.season,
            "sexe" : post.sexe,
            "style" : post.style,
            "userID" : post.userID
            
            
            
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
    
    func uploadMedia(image: UIImage, completion: @escaping (_ url: String?) -> Void) {
        
        let storageRef = Storage.storage().reference().child("\(self.randomStringWithLength(len: 15)).jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.15) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        completion(url?.absoluteString)
                    })
                }
            }
        }
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        for _ in 0...len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString
    }
    
}
