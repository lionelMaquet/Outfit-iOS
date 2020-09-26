//
//  DescriptionViewController.swift
//  Outfit
//
//  Created by Lionel Maquet on 14/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import UIKit
import Firebase

class DescriptionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textfield: UITextField!
    var imagePicked: UIImage?
    var dbManager: DatabaseManager?

    @IBOutlet weak var styleChoice: UISegmentedControl!
    @IBOutlet weak var seasonChoice: UISegmentedControl!
    @IBOutlet weak var sexeChoice: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        dbManager = DatabaseManager(userID: Auth.auth().currentUser!.uid)
        textfield.delegate = self
    }
    
    @IBAction func validateTapped(_ sender: UIButton) {
        
        let description = textfield.text
        let pickedStyle = styleChoice.titleForSegment(at: styleChoice.selectedSegmentIndex)
        let pickedSexe = sexeChoice.titleForSegment(at: sexeChoice.selectedSegmentIndex)
        let pickedSeason = seasonChoice.titleForSegment(at: seasonChoice.selectedSegmentIndex)
        let newStyle = Style.fromEnglishStrings(style: pickedStyle!, sexe: pickedSexe!, season: pickedSeason!)
        let newPost = Post(userID: (Auth.auth().currentUser?.email)!, user: nil, description: description!, commentCount: 0, likeCount: 0, imageURL: nil, style: newStyle.style, sexe: newStyle.sexe, season: newStyle.season)
        let imageToUpload = imagePicked
        
        sharedDatabaseManager?.uploadImageAndPost(post: newPost, image: imageToUpload!)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textfield.resignFirstResponder()
    }
}
