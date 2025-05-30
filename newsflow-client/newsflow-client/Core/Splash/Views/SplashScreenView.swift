//
//  SplashScreenView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/7/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    @State private var scale: CGFloat = 0.8

    var body: some View {
        Group {
            if isActive {
                ContentView()
                    .preferredColorScheme(.light)
            } else {
                VStack {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .padding(25)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.2)) {
                                opacity = 1.0
                                scale = 1.0
                            }
                        }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .preferredColorScheme(.light)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
