//
//  HomeTableViewCell.swift
//  Outfit
//
//  Created by Lionel Maquet on 09/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import UIKit
import ImageSlideshow

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var postStyle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var likeButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //imageSlideShow.currentSlideshowItem?.imageView.contentMode = .top
        imageSlideShow.contentScaleMode = .scaleAspectFit
        
        
        imageSlideShow.setImageInputs([
            ImageSource(image: UIImage(named: "example-profile-image")!),
            ImageSource(image: UIImage(named: "example-image")!),
            ImageSource(image: UIImage(named: "example-image")!)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
