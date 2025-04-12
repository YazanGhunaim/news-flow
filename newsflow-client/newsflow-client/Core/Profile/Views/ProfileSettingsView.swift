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

    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        List {
            Button("Log out", role: .destructive) { Task { await logout() } }

            Button("Delete account", role: .destructive) { Task { await deleteAccount() } }
        }
        .navigationTitle("Settings")
    }
}

extension ProfileSettingsView {
    func logout() async {
        do {
            try await authVM.logoutUser()
            UserDefaultsManager.shared.deleteAll()
            let _ = KeychainManager.shared.deleteAllTokens()
            router.popToRoot()
        } catch {
            showErrorAlert = true
            errorMessage = error.localizedDescription
        }
    }

    func deleteAccount() async {
        do {
            try await authVM.deleteUserAccount()
            UserDefaultsManager.shared.deleteAll()
            let _ = KeychainManager.shared.deleteAllTokens()
            router.popToRoot()
        } catch {
            showErrorAlert = true
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    ProfileSettingsView()
}
