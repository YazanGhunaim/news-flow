//
//  ProfileView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/11/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewmodel = ProfileViewModel(userService: UserService())
    @Environment(Router.self) private var router

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // MARK: User data
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

                    // MARK: Edit and Settings buttons
                    HStack(spacing: 16) {
                        CustomButton(enabled: true, height: 40, text: "Settings") {
                            router.navigate(to: .profileSettingsView)
                        }

                        CustomButton(enabled: true, height: 40, text: "Edit Profile") {
                            router.navigate(to: .editProfileView)
                        }
                    }

                    // MARK: Bookmarks
                    if let bookmarks = viewmodel.bookmarks, !bookmarks.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bookmarked Articles")
                                .font(.headline)

                            let columns = [GridItem(.adaptive(minimum: 160))]
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(bookmarks) { article in
                                    ArticleGridCell(article: article)
                                        .onTapGesture { router.navigate(to: .articleView(article: article)) }
                                }
                            }
                        }
                    }

                    Spacer()
                }
                .padding()
                .task { await viewmodel.fetchBookmarks() }
                .navigationTitle("\(viewmodel.user?.name ?? "Profile")")
            }
        }
    }
}

#Preview {
    ProfileView()
}
