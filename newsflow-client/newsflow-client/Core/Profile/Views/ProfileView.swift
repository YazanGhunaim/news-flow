//
//  ProfileView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/11/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewmodel = ProfileViewModel()
    @Environment(Router.self) private var router

    var body: some View {
        NavigationView {
            ScrollView {
                // MARK: User data
                VStack(alignment: .leading, spacing: 24) {
                    if let user = viewmodel.user {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Username: @\(user.username)")

                            Text("Email: \(user.email)")
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .font(.subheadline.bold())
                        .cornerRadius(8)
                    }

                    HStack(spacing: 16) {
                        CustomButton(enabled: true, height: 40, text: "Settings") {
                            router.navigate(to: .profileSettingsView)
                        }

                        CustomButton(enabled: true, height: 40, text: "Edit Profile") {
                            router.navigate(to: .editProfileView)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Bookmarked Articles")
                            .font(.title2)
                            .padding(.bottom, 4)

                        // Empty placeholder
                        Text("No bookmarks yet.")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
                .padding()
            }
            .navigationTitle("\(viewmodel.user?.name ?? "Profile")")
        }
    }
}

#Preview {
    ProfileView()
}
