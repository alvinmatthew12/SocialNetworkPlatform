//
//  PostPresenterTest.swift
//  SocialNetworkPlatformTests
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import XCTest

@testable import SocialNetworkPlatform

internal final class PostPresenterTest: XCTestCase {
    private var mockView = MockPostView()
    private var mockInteractor = MockPostInteractor()
    private var presenter = PostPresenter()

    override internal func setUp() {
        presenter.view = mockView
        presenter.interactor = mockInteractor
        mockInteractor.presenter = presenter
        super.setUp()
    }
    
    internal func testFetchPostsSuccess() {
        let posts = [PostModel(post: "Test", postImageName: nil, userID: 1)]
        mockInteractor.fetchPostResult = .success(posts)
        presenter.fetchPosts()
        XCTAssertEqual(mockView.posts, posts)
    }
    
    internal func testFetchPostsFailed() {
        let error = CoreDataError.fetchError
        mockInteractor.fetchPostResult = .failure(error)
        presenter.fetchPosts()
        XCTAssertEqual(mockView.errorMessage, error.localizedDescription)
    }
    
    internal func testDeletePostSuccess() {
        let postsAfterDelete = [PostModel(post: "Test", postImageName: nil, userID: 1)]
        mockInteractor.isDeletePostSuccess = true
        mockInteractor.fetchPostResult = .success(postsAfterDelete)
        presenter.deletePost(post: .init(post: "", postImageName: nil, userID: 1))
        XCTAssertEqual(mockView.posts, postsAfterDelete)
    }
    
    internal func testDeleteFailed() {
        mockInteractor.isDeletePostSuccess = false
        presenter.deletePost(post: .init(post: "", postImageName: nil, userID: 1))
        XCTAssertEqual(mockView.errorMessage, "Delete Failed")
    }
}

internal final class MockPostView: PostPresenterToViewProtocol {
    internal var posts: [PostModel] = []
    internal var errorMessage: String = ""
    
    internal func showPosts(posts: [PostModel]) {
        self.posts = posts
    }
    
    internal func showError(message: String) {
        self.errorMessage = message
    }
}

internal final class MockPostInteractor: PostPresenterToInteractorProtocol {
    internal var fetchPostResult: Result<[PostModel], CoreDataError> = .success([])
    internal var isDeletePostSuccess: Bool = false
    
    internal var presenter: PostInteractorToPresenterProtocol?
    
    internal func fetchPost() {
        presenter?.postFetched(result: fetchPostResult)
    }
    
    internal func deletePost(post: PostModel) {
        if isDeletePostSuccess {
            presenter?.deletePostSuccess()
        } else {
            presenter?.deletePostFailed(error: "Delete Failed")
        }
    }
}
