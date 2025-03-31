//
//  RegistrationView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AuthViewModel.self) private var viewmodel

    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var diffPasswords = false
    @State private var validEmail = true

    var formFilled: Bool {
        !email.isEmpty && !password.isEmpty && !username.isEmpty && !confirmPassword.isEmpty
            && (password == confirmPassword) && validEmail
    }

    var body: some View {
        VStack {
            // MARK: Header
            AuthHeaderView(infoText: "Create your account")

            // MARK: Text fields
            VStack(spacing: 40) {
                CustomInputField(
                    imageName: "person", placeHolderText: "Username",
                    text: $username)

                VStack(alignment: .trailing, spacing: 8) {
                    CustomInputField(
                        imageName: "envelope", placeHolderText: "Email",
                        text: $email)

                    if !validEmail {
                        TextFieldTrailingInfo(text: "Invalid email format.", color: .red)
                    }
                }

                VStack(alignment: .trailing, spacing: 8) {
                    CustomInputField(
                        imageName: "lock", placeHolderText: "Password",
                        isSecureField: true, text: $password
                    )
                    if diffPasswords {
                        TextFieldTrailingInfo(text: "Passwords do not match.", color: .red)
                    }
                }

                VStack(alignment: .trailing, spacing: 8) {
                    CustomInputField(
                        imageName: "lock", placeHolderText: "Confirm Password",
                        isSecureField: true, text: $confirmPassword
                    )

                    if diffPasswords {
                        TextFieldTrailingInfo(text: "Passwords do not match.", color: .red)
                    }
                }

            }
            .padding(32)

            // MARK: Sign up
            Button {
                // TODO: logic
            } label: {
                Text("Sign up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(formFilled ? Color.NFPrimary : Color.NFPrimary.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            .disabled(!formFilled)

            Spacer()

            // MARK: Already have an account
            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)

                    Text("Sign in")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            .foregroundStyle(Color.NFPrimary)
            .padding(.bottom, 32)

        }
        .ignoresSafeArea()
        .onChange(of: [password, confirmPassword]) {
            withAnimation(.easeInOut) {
                diffPasswords = password != confirmPassword
            }
        }
        .onChange(of: email) {
            withAnimation(.easeInOut) {
                validEmail = viewmodel.isValidEmail(email)
            }
        }
    }
}

#Preview {
    RegistrationView()
}
