//
//  ViewExtensions.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import Foundation
import SwiftUI

extension View {
    func withRouter() -> some View {
        modifier(RouterViewModifier())
    }
}
