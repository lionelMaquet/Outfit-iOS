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
    var postDocumentID: String?
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
        if (isLiked == false){
            isLiked = true
            likeButton.setImage(UIImage(named: "heart-filled"), for: .normal)
            dbManager?.addOrRemovePostToLikedPosts(postDocumentID: self.postDocumentID!, action: "add")
            dbManager?.updateLikeCount(of: self.postDocumentID!, do: "increment")
            self.likeCount.text = "\(Int(self.likeCount.text!)! + 1)"
        } else if (isLiked == true) {
            isLiked = false
            likeButton.setImage(UIImage(named: "heart-empty"), for: .normal)
            dbManager?.addOrRemovePostToLikedPosts(postDocumentID: self.postDocumentID!, action: "remove")
            dbManager?.updateLikeCount(of: self.postDocumentID!, do: "decrement")
            self.likeCount.text = "\(Int(self.likeCount.text!)! - 1)"
        }
        
        
    }
}
