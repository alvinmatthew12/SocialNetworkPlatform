//
//  CreatePostInteractor.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import Foundation

internal final class CreatePostInteractor: CreatePostPresenterToInteractorProtocol {
    internal var presenter: CreatePostInteractorToPresenterProtocol?
    
    private let coreDataManager = CoreDataManager<PostModel>(entityName: "Post")
    
    internal func getCurrentUser() {
        let currentUser = UserManager.shared.getCurrentUser()
        presenter?.currentUser(user: currentUser)
    }
    
    internal func saveImage(data: Data?) {
        ImageFileManager.save(data: data) { [presenter] fileName, error in
            if let error = error {
                presenter?.saveImageFailed(error: error)
            } else if let fileName = fileName {
                presenter?.saveImageSuccess(imageName: "\(fileName).jpg")
            }
        }
    }
    
    internal func post(post: PostModel) {
        if let error = coreDataManager.create(post) {
            presenter?.postFailed(error: error.localizedDescription)
        } else {
            NewPostNotificationHelper.post()
            presenter?.postSuccess()
        }
    }
}
