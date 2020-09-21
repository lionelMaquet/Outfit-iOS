//
//  HomeTableViewCell.swift
//  Outfit
//
//  Created by Lionel Maquet on 09/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import UIKit
import ImageSlideshow

protocol HomeTableViewCellDelegate {
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileBorderView: UIView!
    @IBOutlet weak var mainVerticalStack: UIStackView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var profileAndSocialStack: UIStackView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postStyle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    var isLiked: Bool = false
    var dbManager: DatabaseManager?
    var post: Post?
    
    var delegate : HomeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        /// 1 : change icon
        if (isLiked == false){
            isLiked = true
            likeButton.setImage(UIImage(named: "heart-filled"), for: .normal)
        } else {
            isLiked = false
            likeButton.setImage(UIImage(named: "heart-empty"), for: .normal)
        }
        
        /// 2 : put my current id in the list of likes from the post
        
        
        /// 3 : When the post is displayed, check if it's liked from the user !
    }
}
