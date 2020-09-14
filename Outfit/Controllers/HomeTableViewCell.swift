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

    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postStyle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var likeButton: UIButton!
    var dbManager: DatabaseManager?
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageSlideShow.contentScaleMode = .scaleAspectFit
        dbManager?.delegate = self
        dbManager?.getProfileDetails(userID: post!.userID)
    }
    
    override func layoutSubviews() {
        
        likeCount.text = "\(post!.likeCount)"
        commentCount.text = "\(post!.commentCount)"
        descriptionLabel.text = post!.description
        profileName.text = post?.user?.username
        postStyle.text = post?.styleName
        setPostImage()
        setProfileImage()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    func setPostImage(){
        let url = URL(string: post!.imageURL)
        let data = (try? Data(contentsOf: url!))!
        imageSlideShow.setImageInputs([
            ImageSource(image: (UIImage(data:data))!)
        ])
    }
    
    func setProfileImage(){
        let url = URL(string: post!.user!.imageURL)
        let data = (try? Data(contentsOf: url!))!
        let profileImage = UIImage(data: data)
        self.profileImage.image = profileImage
    }
}

extension HomeTableViewCell: DatabaseManagerDelegate {
    func profileWasFetched(user: User) {
        print("here", user.username)
    }
}
