//
//  ProfileViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/11/25.
//

import Foundation

@Observable
@MainActor
class ProfileViewModel {
    let userService: UserService

    var bookmarks: [Article]?
    var user: User?

    init(userService: UserService) {
        self.userService = userService

        Task {
            self.user = await fetchUser()
            self.bookmarks = await userService.getUserBookmarks()
        }
    }

    func fetchUser() async -> User? { return await userService.getUser() }

    func fetchBookmarks() async -> [Article]? { return await userService.getUserBookmarks() }
}
