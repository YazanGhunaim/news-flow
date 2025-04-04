//
//  CustomButton.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct CustomButton: View {
    var disabled: Bool
    let text: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 340, height: 50)
                .background(disabled ? Color.NFPrimary : Color.NFPrimary.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
        }
        .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
        .disabled(!disabled)
    }
}

#Preview {
    CustomButton(disabled: false, text: "Submit") {
        print("Submitted")
    }
}
