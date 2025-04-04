//
//  Router.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case login
    case register
    case setCategoryPreferences
}

@Observable
@MainActor
class Router {
    var path = NavigationPath()

    func navigate(to route: Route) {
        switch route {
        case .login:
            path.append(Route.login)
        case .register:
            path.append(Route.register)
        case .setCategoryPreferences:
            path.append(Route.setCategoryPreferences)
        }
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
