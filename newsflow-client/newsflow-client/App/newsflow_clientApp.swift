//
//  newsflow_clientApp.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/30/25.
//

import SwiftUI

// TODO: Feed user defaults with cloud data on sign in and delete on sign out / delete acc
// TODO: Seperate preference selection [ custom keywoards / top headling news api categories ] and use /top-headline for them
@main
struct newsflow_clientApp: App {
    @State private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .withRouter()
                .environment(authViewModel)
        }
    }
}
