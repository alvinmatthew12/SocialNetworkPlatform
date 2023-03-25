//
//  CreatePostPresenterTest.swift
//  SocialNetworkPlatformTests
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import XCTest

@testable import SocialNetworkPlatform

internal final class CreatePostPresenterTest: XCTestCase {
    private var mockView = MockCreatePostView()
    private var mockInteractor = MockCreatePostInteractor()
    private var presenter = CreatePostPresenter()

    override internal func setUp() {
        presenter.view = mockView
        presenter.interactor = mockInteractor
        mockInteractor.presenter = presenter
        super.setUp()
    }
    
    internal func testSuccessCreatePost() {
        mockInteractor.currentUser = LocalUser.user2
        presenter.getCurrentUser()
        XCTAssertEqual(mockView.currentUser, LocalUser.user2)
        
        mockInteractor.isSuccessPost = true
        mockInteractor.isSuccessSaveImage = true
        presenter.post(text: "Test", imageData: nil)
        XCTAssertTrue(mockView.isPostSuccess)
    }
    
    internal func testCreatePostWithoutGetUserError() {
        mockInteractor.isSuccessPost = true
        mockInteractor.isSuccessSaveImage = true
        presenter.post(text: "Test", imageData: nil)
        XCTAssertNotEqual(mockView.postFailedError, "")
    }
    
    internal func testCreatePostWithEmptyTextError() {
        presenter.getCurrentUser()
        mockInteractor.isSuccessPost = true
        mockInteractor.isSuccessSaveImage = true
        presenter.post(text: "", imageData: nil)
        XCTAssertNotEqual(mockView.postFailedError, "")
    }
    
    internal func testCreatePostFailed() {
        presenter.getCurrentUser()
        mockInteractor.isSuccessPost = false
        presenter.post(text: "Test", imageData: nil)
        XCTAssertEqual(mockView.postFailedError, "Post Failed")
    }
    
    internal func testCreatePostSaveImageFailed() {
        presenter.getCurrentUser()
        mockInteractor.isSuccessPost = true
        mockInteractor.isSuccessSaveImage = false
        presenter.post(text: "Test", imageData: Data())
        XCTAssertEqual(mockView.postFailedError, "Save Image Failed")
    }
}

internal final class MockCreatePostView: CreatePostPresenterToViewProtocol {
    internal var currentUser = LocalUser.user1
    internal var isPostSuccess: Bool = false
    internal var postFailedError: String = ""
    
    internal func setCurrentUser(user: LocalUser) {
        currentUser = user
    }
    
    internal func postSuccess() {
        isPostSuccess = true
    }
    
    internal func postFailed(error: String) {
        postFailedError = error
    }
}

internal final class MockCreatePostInteractor: CreatePostPresenterToInteractorProtocol {
    internal var currentUser = LocalUser.user1
    internal var isSuccessSaveImage: Bool = false
    internal var isSuccessPost: Bool = false
    
    internal var presenter: CreatePostInteractorToPresenterProtocol?
    
    internal func getCurrentUser() {
        presenter?.currentUser(user: currentUser)
    }
    
    internal func saveImage(data: Data?) {
        if isSuccessSaveImage {
            presenter?.saveImageSuccess(imageName: "test.jpg")
        } else {
            presenter?.saveImageFailed(error: "Save Image Failed")
        }
    }
    
    internal func post(post: PostModel) {
        if isSuccessPost {
            presenter?.postSuccess()
        } else {
            presenter?.postFailed(error: "Post Failed")
        }
    }
    
    
}
