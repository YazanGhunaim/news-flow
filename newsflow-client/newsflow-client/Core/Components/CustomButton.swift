//
//  CustomButton.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct CustomButton: View {
    var enabled: Bool
    var height: CGFloat? = 50
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, height == nil ? 12 : 0)
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .background(enabled ? Color.NFPrimary : Color.NFPrimary.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
        }
        .disabled(!enabled)
    }
}

#Preview {
    CustomButton(enabled: true, text: "Submit") {
        print("Submitted")
    }
    .padding()
}
