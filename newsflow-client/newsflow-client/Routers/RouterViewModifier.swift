//
//  RouterViewModifier.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import Foundation
import SwiftUI

struct RouterViewModifier: ViewModifier {
    @State private var router = Router()

    private func routeView(for route: Route) -> some View {
        Group {
            switch route {
            case .login:
                LoginView()
            case .register:
                RegistrationView()
            case .setCategoryPreferences:
                OnboardingView()
            case .tabView:
                TabBarView()
            case .articleView(let article):
                ArticleView(article: article)
            case .profileView:
                ProfileView()
            case .profileSettingsView:
                ProfileSettingsView()
            case .editProfileView:
                EditProfileView()
            }
        }
        .environment(router)
    }

    func body(content: Content) -> some View {
        NavigationStack(path: $router.path) {
            content
                .environment(router)
                .navigationDestination(for: Route.self) { route in
                    routeView(for: route)
                }
        }
        .tint(Color.NFPrimary)
    }
}
