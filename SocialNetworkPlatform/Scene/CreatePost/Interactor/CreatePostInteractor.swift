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
        guard let imageData = data else { return }
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            presenter?.saveImageFailed(error: "Failed to get documentsDirectory")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        
        let currentUsername = UserManager.shared.getCurrentUser().username
        let filename = "\(currentUsername)_\(dateFormatter.string(from: Date()))"
        let fileURL = documentDirectory.appendingPathComponent(filename).appendingPathExtension("jpg")
        do {
            try imageData.write(to: fileURL, options: .atomic)
            presenter?.saveImageSuccess(imageName: "\(filename).jpg")
        } catch {
            presenter?.saveImageFailed(error: error.localizedDescription)
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
