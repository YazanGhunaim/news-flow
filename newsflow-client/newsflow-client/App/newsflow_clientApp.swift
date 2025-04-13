//
//  newsflow_clientApp.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/30/25.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

@main
struct newsflow_clientApp: App {
    @State private var authViewModel = AuthViewModel(authService: AuthService(), userService: UserService())
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .withRouter()
                .environment(authViewModel)
        }
    }
}
