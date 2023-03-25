//
//  CreatePostProtocol.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import Foundation

internal protocol CreatePostViewToPresenterProtocol {
    var view: CreatePostPresenterToViewProtocol? { get set }
    var interactor: CreatePostPresenterToInteractorProtocol? { get set }
    var currentUser: LocalUser? { get set }
    
    func getCurrentUser()
    func post(text: String, imageData: Data?)
}

internal protocol CreatePostPresenterToViewProtocol {
    func setCurrentUser(user: LocalUser)
    func postSuccess()
    func postFailed(error: String)
}

internal protocol CreatePostPresenterToInteractorProtocol {
    var presenter: CreatePostInteractorToPresenterProtocol? { get set }
    func getCurrentUser()
    func saveImage(data: Data?)
    func post(post: PostModel)
}

internal protocol CreatePostInteractorToPresenterProtocol {
    func currentUser(user: LocalUser)
    func saveImageSuccess(imageName: String)
    func saveImageFailed(error: String)
    func postSuccess()
    func postFailed(error: String)
}
