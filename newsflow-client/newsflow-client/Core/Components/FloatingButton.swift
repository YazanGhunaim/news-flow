//
//  FloatingButton.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/7/25.
//

import SwiftUI

struct FloatingButton: View {
    @State private var size: CGFloat = 75
    @State private var scale: CGFloat = 1.5

    let image: String
    let action: () -> Void

    var body: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .stroke(.primary, lineWidth: 0.5)
            .frame(width: size, height: size)
            .shadow(color: Color.NFPrimary, radius: 10, x: 0, y: 5)
            .overlay {
                Image(systemName: image)
                    .scaleEffect(scale)
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.75)) {
                    self.size = 100
                    self.scale = 2
                }
                // Animate back after time delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 0.75)) {
                        self.size = 75
                        self.scale = 1.5
                    }
                }
                action()
            }
    }
}

#Preview {
    FloatingButton(image: "airpods.max") {
        print("You pressed me!")
    }
    .preferredColorScheme(.light)
}
