//
//  ProfileSettingsView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/11/25.
//

import SwiftUI

struct ProfileSettingsView: View {
    @Environment(AuthViewModel.self) private var authVM
    @Environment(Router.self) private var router

    var body: some View {
        List {
            Button("Log out", role: .destructive) {
                Task {
                    await authVM.logoutUser()
                    UserDefaultsManager.shared.deleteAll()
                    let _ = KeychainManager.shared.deleteAllTokens()
                    router.popToRoot()
                }
            }

            Button("Delete account", role: .destructive) {
                Task {
                    await authVM.deleteUserAccount()
                    UserDefaultsManager.shared.deleteAll()
                    let _ = KeychainManager.shared.deleteAllTokens()
                    router.popToRoot()
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    ProfileSettingsView()
}
