//
//  PickUsernameViewController.swift
//  Outfit
//
//  Created by Lionel Maquet on 12/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import UIKit

class PickUsernameViewController: UIViewController {
    @IBOutlet weak var usernameTf: UITextField!
    
    var dbManager : DatabaseManager?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func validateUsernameButtonWasTapped(_ sender: UIButton) {
        dbManager?.initialiseFirstTimeUser(username: usernameTf.text!)
        performSegue(withIdentifier: "goToHomeVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! HomeViewController
        destinationVC.dbManager = self.dbManager!
    }
    
}
