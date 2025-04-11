//
//  newsflow_clientApp.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/30/25.
//

import SwiftUI

@main
struct newsflow_clientApp: App {
    @State private var authViewModel = AuthViewModel(userService: UserService())

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .withRouter()
                .environment(authViewModel)
        }
    }
}
