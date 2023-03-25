//
//  PostListViewController.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import UIKit

internal final class PostListViewController: UIViewController {
    
    private var posts: [PostModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView = UITableView()
    
    internal var presenter: PostViewToPresenterProtocol?
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseColor
        
        tableView.backgroundColor = .clear
        tableView.fixInView(self.view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(PostTableViewCell.nib, forCellReuseIdentifier: PostTableViewCell.identifier)
        
        presenter?.fetchPosts()
        
        NewPostNotificationHelper.observe { [weak self] _ in
            self?.presenter?.fetchPosts()
        }
    }
    
    deinit {
        NewPostNotificationHelper.removeObserver()
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
        cell.selectionStyle = .none
        cell.setupPost(post)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        cell.addGestureRecognizer(longPressGesture)
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @objc private func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            guard
                let cell = gestureRecognizer.view as? PostTableViewCell,
                let index = tableView.indexPath(for: cell)?.row
            else { return }
            openDeleteAlertBox(cellIndex: index)
        }
    }
    
    private func openDeleteAlertBox(cellIndex index: Int) {
        guard let post = posts[safe: index], let user = post.user else { return }
        
        let currentUser = UserManager.shared.getCurrentUser()
        if currentUser.id != user.id {
            let alertController = UIAlertController(title: "Unauthorized", message: "You cannot delete this post from your current account. Please switch to the post owner's account to delete it.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let alertController = UIAlertController(title: "Delete Post", message: "Are you sure want to delete this post?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.presenter?.deletePost(post: post)
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension PostListViewController: PostPresenterToViewProtocol {
    internal func showPosts(posts: [PostModel]) {
        self.posts = posts
    }
    
    internal func showError(message: String) {
        print(message)
    }
}
