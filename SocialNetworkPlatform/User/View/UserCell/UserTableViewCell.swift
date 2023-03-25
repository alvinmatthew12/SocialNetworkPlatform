//
//  UserTableViewCell.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import UIKit

internal final class UserTableViewCell: UITableViewCell {
    internal static var identifier = String(describing: UserTableViewCell.self)
    internal static var nib = UINib(nibName: identifier, bundle: nil)
    
    @IBOutlet private weak var profilePictureImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var selectedIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        selectedIcon.isHidden = true
    }
    
    internal func setupView(user: LocalUser, isSelected: Bool) {
        profilePictureImageView.image = UIImage(named: user.profilePictureName)
        usernameLabel.text = "@\(user.username)"
        nameLabel.text = user.name
        selectedIcon.isHidden = !isSelected
    }
}
