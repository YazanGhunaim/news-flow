//
//  OnboardingHeaderView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import SwiftUI

struct OnboardingHeaderView: View {
    let text: String

    var body: some View {
        VStack(alignment: .center) {
            HStack { Spacer() }
			
			// MARK: Header text
            Text(text)
                .multilineTextAlignment(.center)
                .font(.title.bold())
                .padding(.bottom,25)
                .padding(.top, 75)

        }
        .background(Color.NFPrimary)
        .foregroundStyle(.white)
        .clipShape(RoundedShape(corners: [.bottomLeft, .bottomRight]))
    }
}

#Preview {
    OnboardingHeaderView(text: "say hello to your personal\nAI News Assistant")
}
