//
//  AuthHeaderView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct AuthHeaderView: View {
    let infoText: String

    var body: some View {
        VStack(alignment: .center) {
            // Logo
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .padding(25)
            // Info headline
            Text(infoText)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(height: 260)
        .padding(.leading)
    }
}

#Preview {
    AuthHeaderView(infoText: "Create your account")
}
