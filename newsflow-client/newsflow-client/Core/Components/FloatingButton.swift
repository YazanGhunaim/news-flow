//
//  FloatingButton.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/7/25.
//

import SwiftUI

struct FloatingButton: View {
    @Binding var isAnimating: Bool
    @Binding var isDisabled: Bool

    @State private var animate = false

    let image: String
    let color: Color

    let action: () -> Void

    init(
        isAnimating: Binding<Bool>,
        isDisabled: Binding<Bool>,
        image: String,
        color: Color = Color.NFPrimary,
        action: @escaping () -> Void
    ) {
        self._isAnimating = isAnimating
        self._isDisabled = isDisabled

        self.image = image
        self.color = color
        self.action = action
    }

    var body: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .stroke(.primary, lineWidth: 0.5)
            .frame(width: animate ? 100 : 75, height: animate ? 100 : 75)
            .shadow(color: color, radius: 10, x: 0, y: 5)
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
                if $1 {
                    startPulsing()
                } else {
                    stopPulsing()
                }
            }
            .onTapGesture {
                guard !isDisabled else { return }
                action()
            }
    }

    private func startPulsing() {
        guard !isDisabled else { return }
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
    FloatingButton(
        isAnimating: .constant(true), isDisabled: .constant(true), image: "airpods.max", color: .red,
        action: {
            print("Hello")
        }
    )
    .preferredColorScheme(.light)
}
