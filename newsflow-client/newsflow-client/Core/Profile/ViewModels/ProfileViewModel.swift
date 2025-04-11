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
            await fetchUser()
            await fetchBookmarks()
        }
    }

    func fetchUser() async { user = await userService.getUser() }

    func fetchBookmarks() async { bookmarks = await userService.getUserBookmarks() }
}
