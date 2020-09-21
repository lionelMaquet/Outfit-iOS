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
        
        
        
        /// profile and social stack
        cell!.contentView.addConstraint(NSLayoutConstraint(item: cell?.profileAndSocialStack, attribute: .right, relatedBy: .equal, toItem: cell?.mainVerticalStack, attribute: .right, multiplier: 1, constant: -DK.landrSpaceProfileStack))
        cell!.contentView.addConstraint(NSLayoutConstraint(item: cell?.profileAndSocialStack, attribute: .left, relatedBy: .equal, toItem: cell?.mainVerticalStack, attribute: .left, multiplier: 1, constant: DK.landrSpaceProfileStack))
        
        /// post image view
        cell?.contentView.addConstraint(NSLayoutConstraint(item: cell?.postImageView, attribute: .left, relatedBy: .equal, toItem: cell?.mainVerticalStack, attribute: .left, multiplier: 1, constant: 0))
        cell?.contentView.addConstraint(NSLayoutConstraint(item: cell?.postImageView, attribute: .right, relatedBy: .equal, toItem: cell?.mainVerticalStack, attribute: .right, multiplier: 1, constant: 0))
        cell?.postImageView.addConstraint(NSLayoutConstraint(item: cell?.postImageView!,
                                                             attribute: .height,
                                                             relatedBy: .equal,
                                                             toItem: cell!.postImageView,
                                                             attribute: .width,
                                                             multiplier: (cell!.postImageView.image!.size.height) / (cell!.postImageView.image!.size.width),
                                                             constant: 0))
        
        cell?.contentView.addConstraint(NSLayoutConstraint(item: cell?.postImageView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: cell?.profileAndSocialStack ,
                                               attribute: .bottom,
                                               multiplier: 1,
                                               constant: DK.spaceBetweenPostAndProfile))
        
        
        
        /// description label
        cell?.descriptionLabel.sizeToFit()
        cell!.contentView.addConstraint(NSLayoutConstraint(item: cell?.descriptionLabel, attribute: .top, relatedBy: .equal, toItem: cell?.postImageView, attribute: .bottom, multiplier: 1, constant: DK.spaceBetweenPostImageAndDesc))
        
        
        
        // make profile image round
        let image = cell?.profileImage
        image!.layer.masksToBounds = false
        image!.layer.borderColor = UIColor.white.cgColor
        image!.layer.borderWidth = CGFloat(2)
        image!.layer.cornerRadius = image!.frame.height/2
        image!.clipsToBounds = true
        
        /// gradient
        //image?.addCircleGradiendBorder(7)
        
        
        
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

extension UIImageView {
    
    func addCircleGradiendBorder(_ width: CGFloat) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: bounds.size)
        let colors: [CGColor] = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        
        let cornerRadius = frame.size.width / 2
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        let shape = CAShapeLayer()
       
        let path = UIBezierPath(ovalIn: bounds)
        
        shape.lineWidth = width
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor // clear
        gradient.mask = shape
        gradient.borderColor = UIColor.white.cgColor
        
        
        layer.insertSublayer(gradient, below: layer)
    }
    
}
