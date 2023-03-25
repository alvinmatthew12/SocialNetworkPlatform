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
    
    internal func setupPost(_ post: PostModel) {
        profilePictureImageView.image = UIImage(named: post.user?.profilePictureName ?? "")
        nameLabel.text = post.user?.name
        usernameLabel.text = "@\(post.user?.username ?? "")"
        postLabel.text = post.post
        if let imageName = post.postImageName {
            if let namedImage = UIImage(named: imageName) {
                postImageView.image = resizeImage(image: namedImage, newHeight: 120)
                postImageView.isHidden = false
            } else if let localImage = getLocalImage(name: imageName) {
                postImageView.image = resizeImage(image: localImage, newHeight: 120)
                postImageView.isHidden = false
            } else {
                postImageView.isHidden = true
            }
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
    
    private func getLocalImage(name: String) -> UIImage? {
        let fileManager = FileManager.default
        do {
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let imageURL = documentsURL.appendingPathComponent(name)
            guard
                let imageData = try? Data(contentsOf: imageURL),
                let image = UIImage(data: imageData)
            else { return nil }
            return image
        } catch {
            print(">>> ", error)
            return nil
        }
    }
}
