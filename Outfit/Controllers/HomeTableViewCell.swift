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
    func finishedLoadingPhoto()
}

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
    
    var finishedLoadingProfilePicture: Bool = false
    var finishedLoadingMainPicture: Bool = false
    
    var delegate : HomeTableViewCellDelegate?
    
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
        DispatchQueue.global(qos: .utility).async {
            let url = URL(string: self.post!.imageURL!)
            print(url)
            let data = (try? Data(contentsOf: url!))!
            DispatchQueue.main.async {
                let displayedImage = UIImage(data: data)
                self.imageSlideShow.setImageInputs([
                    ImageSource(image: displayedImage!)
                ])
                self.finishedLoadingProfilePicture = true
                
                let constraint = NSLayoutConstraint(item: self.imageSlideShow, attribute: .height, relatedBy: .equal, toItem: self.imageSlideShow, attribute: .width, multiplier: displayedImage!.size.height / displayedImage!.size.width, constant: 0)
                
                self.imageSlideShow.addConstraint(constraint)
                self.autoresizesSubviews = false
                
                if (self.finishedLoadingMainPicture == true){
                    self.delegate?.finishedLoadingPhoto()
                }
                
            }
        }
    }
    
    func setProfileImage(){
        DispatchQueue.global(qos: .utility).async {
            let url = URL(string: self.post!.user!.imageURL)
            let data = (try? Data(contentsOf: url!))!
            let profileImage = UIImage(data: data)
            DispatchQueue.main.async {
                self.profileImage.image = profileImage
                self.finishedLoadingProfilePicture = true
                if (self.finishedLoadingMainPicture == true) {
                    self.delegate?.finishedLoadingPhoto()
                }
                
            }
            
        }
    }
}

extension HomeTableViewCell: DatabaseManagerDelegate {
    func profileWasFetched(user: User) {
        print("here", user.username)
    }
}
