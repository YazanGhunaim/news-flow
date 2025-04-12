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
            // MARK: Logo
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .padding(25)
            
            // MARK: Info headline
            Text(infoText)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .padding()
    }
}

#Preview {
    AuthHeaderView(infoText: "Create your account")
}
