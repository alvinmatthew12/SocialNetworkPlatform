//
//  PostTableViewCell.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import UIKit

internal final class PostTableViewCell: UITableViewCell {
    internal static var identifier = String(describing: PostTableViewCell.self)
    internal static var nib = UINib(nibName: identifier, bundle: nil)
    
    @IBOutlet private weak var profilePictureImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var postLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        postImageView.isHidden = true
    }
    
    internal func setupPost(_ post: Post) {
        profilePictureImageView.image = UIImage(named: post.user.profilePictureName)
        nameLabel.text = post.user.name
        usernameLabel.text = "@\(post.user.username)"
        postLabel.text = post.post
        if let imageName = post.postImageName {
            postImageView.isHidden = false
            postImageView.image = resizeImage(image: UIImage(named: imageName), newHeight: 120)
        } else {
            postImageView.isHidden = true            
        }
    }
    
    private func resizeImage(image: UIImage?, newHeight: CGFloat) -> UIImage? {
        guard let image = image else { return image }
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
