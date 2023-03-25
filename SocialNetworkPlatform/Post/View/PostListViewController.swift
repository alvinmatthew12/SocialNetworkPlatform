//
//  PostListViewController.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import UIKit

internal final class PostListViewController: UIViewController {
    
    private var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView = UITableView()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseColor
        
        tableView.backgroundColor = .clear
        tableView.fixInView(self.view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(PostTableViewCell.nib, forCellReuseIdentifier: PostTableViewCell.identifier)
        
        posts = Post.dummy
    }
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let post = posts[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell
        else { return UITableViewCell() }
        cell.setupPost(post)
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
