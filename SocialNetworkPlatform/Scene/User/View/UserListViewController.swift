//
//  UserListViewController.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import UIKit

internal final class UserListViewController: UIViewController {
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Click on the list below to switch users."
        label.textColor = .textColor
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let tableView = UITableView()
    
    private var users: [LocalUser] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        captionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        captionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16).isActive = true
        
        tableView.fixInView(self.view, attributes: [.bottom, .leading, .trailing])
        tableView.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 16).isActive = true
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserTableViewCell.nib, forCellReuseIdentifier: UserTableViewCell.identifier)
        
        users = LocalUser.users
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let user = users[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell
        else { return UITableViewCell() }
        let isSelected = UserManager.shared.getCurrentUser().id == user.id
        cell.selectionStyle = .none
        cell.setupView(user: user, isSelected: isSelected)
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = users[safe: indexPath.row] else { return }
        UserManager.shared.setUserTo(id: user.id)
        tableView.reloadData()
    }
}
