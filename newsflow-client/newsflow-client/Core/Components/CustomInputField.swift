//
//  CustomInputField.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct CustomInputField: View {
    let imageName: String
    let placeHolderText: String
    var isSecureField: Bool? = false
    @Binding var text: String

    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))

                if isSecureField ?? false {
                    SecureField(placeHolderText, text: $text)
                } else {
                    TextField(placeHolderText, text: $text)
                }
            }

            Divider()
                .background(Color(.darkGray))
        }
    }
}

struct TextFieldTrailingInfo: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(color)
            .opacity(0.7)
    }
}

#Preview {
    CustomInputField(imageName: "envelope", placeHolderText: "Email", isSecureField: false, text: .constant(""))
}
