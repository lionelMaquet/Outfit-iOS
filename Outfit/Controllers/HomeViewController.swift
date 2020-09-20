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
        self.dbManager!.getAllPosts()
        dbManager?.delegate = self
        
        ///refresher
        mainTableView.addPullToRefresh(refresher) {
            self.dbManager?.getAllPosts()
        }
        mainTableView.refresher(at: .top)?.setEnable(isEnabled: false)
        
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search Here....."
        searchBar.sizeToFit()
        
        //mainTableView.tableHeaderView = searchBar
        
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
        cell?.postImageView.image = currentPost.postImage
        cell?.profileName.text = currentPost.user?.username
        
        
        cell?.addConstraint(NSLayoutConstraint(item: cell?.postImageView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: cell?.profileAndSocialStack ,
                                               attribute: .bottom,
                                               multiplier: 1,
                                               constant: DK.spaceBetweenPostAndProfile))
        
        cell?.postImageView.addConstraint(NSLayoutConstraint(item: cell?.postImageView!,
                                                             attribute: .height,
                                                             relatedBy: .equal,
                                                             toItem: cell!.postImageView,
                                                             attribute: .width,
                                                             multiplier: (cell!.postImageView.image!.size.height) / (cell!.postImageView.image!.size.width),
                                                             constant: 0))
        
        // make profile image round
        let image = cell?.profileImage
        image!.layer.masksToBounds = false
        image!.layer.borderColor = UIColor.black.cgColor
        image!.layer.cornerRadius = image!.frame.height/2
        image!.clipsToBounds = true
        
        return cell!
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
}
