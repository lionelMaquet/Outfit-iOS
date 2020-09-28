//
//  ViewController.swift
//  Outfit
//
//  Created by Lionel Maquet on 09/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import UIKit
import PullToRefresh

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var mainTableView: UITableView!
    var dbManager: DatabaseManager?
    var posts = [Post]()
    let refresher = PullToRefresh()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ///tableview
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = 300
        
        ///dbManager
        dbManager?.delegate = self
        self.dbManager!.getAllPosts()
        
        
        ///refresher
        mainTableView.addPullToRefresh(refresher) {
            self.dbManager!.getAllPosts()
        }
        mainTableView.refresher(at: .top)?.setEnable(isEnabled: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell
        cell?.delegate = self
        cell?.dbManager = self.dbManager
        cell!.post = self.posts[indexPath.row]
        
        /// fills all infos
        let currentPost = self.posts[indexPath.row]
        cell?.commentCount.text = "\(currentPost.commentCount)"
        cell?.descriptionLabel.text = currentPost.description
        cell?.likeCount.text = "\(currentPost.likeCount)"
        cell?.postStyle.text = currentPost.styleName
        cell?.profileImage.image = currentPost.profileImage
        cell?.postImageView.image = currentPost.postImage!
        cell?.profileName.text = currentPost.user?.username
        cell?.postDocumentID = currentPost.postDocumentID
        
        // post image view
        cell?.contentView.addConstraint(NSLayoutConstraint(item: cell!.postImageView!,
                                                           attribute: .left,
                                                           relatedBy: .equal,
                                                           toItem: cell?.mainVerticalStack,
                                                           attribute: .left,
                                                           multiplier: 1,
                                                           constant: 0))
        
        
        
        cell?.contentView.addConstraint(NSLayoutConstraint(item: cell!.postImageView!,
                                                           attribute: .right,
                                                           relatedBy: .equal,
                                                           toItem: cell?.mainVerticalStack,
                                                           attribute: .right,
                                                           multiplier: 1,
                                                           constant: 0))
        
        /// If we change this postImageView in contentView, it doesn't work.
        cell?.postImageView.addConstraint(NSLayoutConstraint(item: cell!.postImageView!,
                                                             attribute: .height,
                                                             relatedBy: .equal,
                                                             toItem: cell!.postImageView,
                                                             attribute: .width,
                                                             multiplier: (cell!.postImageView.image!.size.height) / (cell!.postImageView.image!.size.width),
                                                             constant: 0))
           
        
        // description label
        cell?.descriptionLabel.sizeToFit()
        cell!.contentView.addConstraint(NSLayoutConstraint(item: cell!.descriptionLabel!,
                                                           attribute: .top,
                                                           relatedBy: .equal,
                                                           toItem: cell?.postImageView,
                                                           attribute: .bottom,
                                                           multiplier: 1,
                                                           constant: DK.spaceBetweenPostImageAndDesc))
        
        
        
        // make profile image round
        let image = cell?.profileImage
        image!.layer.masksToBounds = false
        image!.layer.borderColor = UIColor.white.cgColor
        image!.layer.borderWidth = CGFloat(2)
        image!.layer.cornerRadius = image!.frame.height/2
        image!.clipsToBounds = true
        
        ///Profile border view
        cell!.profileBorderView.layer.borderColor = UIColor.white.cgColor
        cell!.profileBorderView.layer.borderWidth = 1
        cell?.profileBorderView.layer.cornerRadius = (cell?.profileBorderView.frame.height)!/2
        
        /// heart filled icon if post is already liked
        if(currentUser?.likedPosts!.contains(cell!.postDocumentID!) == true){
            cell!.likeButton.setImage(UIImage(named: "heart-filled"), for: .normal)
            cell!.isLiked = true
        } else {
            cell!.likeButton.setImage(UIImage(named: "heart-empty"), for: .normal)
            cell!.isLiked = false
        }
        
        
        /// bookmark filled icon if post is bookmarked
        if(currentUser?.bookmarkedPosts!.contains((cell?.postDocumentID)!) == true){
            cell?.bookmarkButton.setImage(UIImage(named: "bookmark-filled"), for: .normal)
            cell?.isBookmarked = true
        } else {
            cell?.bookmarkButton.setImage(UIImage(named: "bookmark-empty"), for: .normal)
            cell?.isBookmarked = false
        }
        
        for view in cell!.mainVerticalStack.arrangedSubviews {
            cell?.mainVerticalStack.sendSubviewToBack(view)
        }
        
        return cell!
        
    }
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isReachingEnd = scrollView.contentOffset.y >= 0
              && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        if (isReachingEnd){
            print("You reached the end!")
        }
    }
    
    deinit {
        mainTableView.removeAllPullToRefresh()
    }
}

extension HomeViewController: DatabaseManagerDelegate {
    func allPostsWereRetreived(posts: [Post]) {
        self.posts = posts
        mainTableView.endRefreshing(at: .top)
        mainTableView.reloadData()
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    func goToProfile(user: User) {
        self.performSegue(withIdentifier: "goToProfile", sender: self)
    }
}



