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
    
    @IBOutlet weak var profileAndSocialStack: UIStackView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postStyle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    var dbManager: DatabaseManager?
    var post: Post?
    
    var delegate : HomeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
