//
//  DescriptionViewController.swift
//  Outfit
//
//  Created by Lionel Maquet on 14/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    @IBOutlet weak var textfield: UITextField!
    var imagePicked: UIImage?

    @IBOutlet weak var styleChoice: UISegmentedControl!
    @IBOutlet weak var seasonChoice: UISegmentedControl!
    @IBOutlet weak var sexeChoice: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func validateTapped(_ sender: UIButton) {
        
        let description = textfield.text
        let pickedStyle = styleChoice.titleForSegment(at: styleChoice.selectedSegmentIndex)
        let pickedSexe = sexeChoice.titleForSegment(at: sexeChoice.selectedSegmentIndex)
        let pickedSeason = seasonChoice.titleForSegment(at: seasonChoice.selectedSegmentIndex)
        let style = Style.fromEnglishStrings(style: pickedStyle! , sexe: pickedSexe!, season: pickedSeason!)
        
        /// Todo : Upload file to storage then upload these infos to a new post
    }
    

}
