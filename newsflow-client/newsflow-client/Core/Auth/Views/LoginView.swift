//
//  LoginView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var viewmodel

    @State private var email = ""
    @State private var password = ""
    @State private var validEmail = true

    var formFilled: Bool {
        !email.isEmpty && !password.isEmpty && validEmail
    }

    var body: some View {
        NavigationStack {
            VStack {
                // MARK: header
                AuthHeaderView(infoText: "Sign in to your account")

                // MARK: Input fields
                VStack(spacing: 40) {
                    VStack(alignment: .trailing, spacing: 8) {
                        CustomInputField(
                            imageName: "envelope", placeHolderText: "Email",
                            text: $email
                        )

                        if !validEmail {
                            TextFieldTrailingInfo(text: "Email format is invalid.", color: .red)
                        }
                    }

                    CustomInputField(
                        imageName: "lock", placeHolderText: "Password",
                        isSecureField: true, text: $password
                    )
                }
                .padding(.horizontal, 32)
                .padding(.top, 44)

                // TODO: Forgot password
                HStack {
                    Spacer()

                    NavigationLink {
                        Text("Reset Password View..")
                    } label: {
                        Text("Forgot Password?")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.NFPrimary)
                            .padding(.top)
                            .padding(.trailing, 24)
                    }
                }

                // MARK: Sign in
                CustomButton(disabled: formFilled, text: "Sign in") {
                    // TODO: logic
                }

                Spacer()

                // MARK: Navigation to signup
                NavigationLink {
                    RegistrationView()
                        .toolbar(.hidden, for: .navigationBar)
                } label: {
                    HStack {
                        Text("Dont have an account?")
                            .font(.footnote)

                        Text("Sign Up")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 32)
                .foregroundStyle(Color.NFPrimary)
            }
            .ignoresSafeArea()
            .onChange(of: email) {
                withAnimation(.easeInOut) {
                    validEmail = viewmodel.isValidEmail(email)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
