//
//  FloatingButton.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/7/25.
//

import SwiftUI

struct FloatingButton: View {
    @Binding var isAnimating: Bool
    @State private var animate = false

    let image: String
    let action: () -> Void

    var body: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .stroke(.primary, lineWidth: 0.5)
            .frame(width: animate ? 100 : 75, height: animate ? 100 : 75)
            .shadow(color: Color.NFPrimary, radius: 10, x: 0, y: 5)
            .overlay {
                Image(systemName: image)
                    .scaleEffect(animate ? 2 : 1.5)
            }
            .onAppear {
                if isAnimating {
                    startPulsing()
                }
            }
            .onChange(of: isAnimating) {
                print($1)
                if $1 {
                    startPulsing()
                } else {
                    stopPulsing()
                }
            }
            .onTapGesture {
                action()
            }
    }

    private func startPulsing() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            animate = true
        }
    }

    private func stopPulsing() {
        withAnimation {
            animate = false
        }
    }
}

#Preview {
    FloatingButton(isAnimating: .constant(true), image: "airpods.max") {
        print("You pressed me!")
    }
    .preferredColorScheme(.light)
}
