//
//  ViewController.swift
//  Outfit
//
//  Created by Lionel Maquet on 09/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var mainTableView: UITableView!
    var dbManager: DatabaseManager?
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        mainTableView.rowHeight = 600
        dbManager?.delegate = self
        dbManager!.getAllPosts()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell
        cell!.post = self.posts[indexPath.row]
        cell?.dbManager = self.dbManager
        return cell!
    }
    
    
    
    
}

extension HomeViewController: DatabaseManagerDelegate {
    func allPostsWereRetreived(posts: [Post]) {
        self.posts = posts
        print("here: ", posts[0])
        mainTableView.reloadData()
    }
}
