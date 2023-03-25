//
//  CreatePostPresenter.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import Foundation

internal final class CreatePostPresenter: CreatePostViewToPresenterProtocol {
    internal var view: CreatePostPresenterToViewProtocol?
    internal var interactor: CreatePostPresenterToInteractorProtocol?
    internal var currentUser: LocalUser?
    
    private var currentProcessPost: PostModel?
    
    internal func getCurrentUser() {
        interactor?.getCurrentUser()
    }
    
    internal func post(text: String, imageData: Data?) {
        guard let user = currentUser, !text.isEmpty else {
            view?.postFailed(error: "Sorry, something went wrong")
            return
        }
        let post = PostModel(post: text, postImageName: nil, userID: user.id)
        currentProcessPost = post
        
        if let imageData = imageData {
            interactor?.saveImage(data: imageData)
        } else {
            interactor?.post(post: post)
        }
    }
}


extension CreatePostPresenter: CreatePostInteractorToPresenterProtocol {
    internal func currentUser(user: LocalUser) {
        currentUser = user
        view?.setCurrentUser(user: user)
    }
    
    func saveImageSuccess(imageName: String) {
        if var post = currentProcessPost {
            post.postImageName = imageName
            interactor?.post(post: post)
        }
    }
    
    func saveImageFailed(error: String) {
        currentProcessPost = nil
        view?.postFailed(error: "Sorry, something went wrong")
    }
    
    func postSuccess() {
        currentProcessPost = nil
        view?.postSuccess()
    }
    
    func postFailed(error: String) {
        currentProcessPost = nil
        view?.postFailed(error: "Sorry, something went wrong")
    }
}
