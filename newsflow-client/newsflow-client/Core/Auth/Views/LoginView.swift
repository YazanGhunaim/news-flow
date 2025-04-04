//
//  LoginView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var viewmodel
    @Environment(Router.self) private var router

    @State private var email = ""
    @State private var password = ""
    @State private var validEmail = true

    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""

    var formFilled: Bool {
        !email.isEmpty && !password.isEmpty && validEmail
    }

    func handleError(_ error: APIError) {
        switch error {
        case .unauthorized:
            showErrorAlert = true
            errorMessage = "Invalid login credentials. Please try again."
        case _:
            showErrorAlert = true
            errorMessage = "Something went wrong please try again."
        }
    }

    var body: some View {
        VStack {
            // MARK: header
            AuthHeaderView(infoText: "Sign in to your account")

            // MARK: Input fields
            inputFields

            // MARK: Forgot password button
            forgotPasswordButton

            // MARK: Sign in button
            CustomButton(enabled: formFilled, text: "Sign in") {
                Task {
                    do {
                        try await viewmodel.login(email: email, password: password)
                        router.navigate(to: .home)
                    } catch let error as APIError {
                        handleError(error)
                    }
                }
            }

            Spacer()

            // MARK: Navigation to signup
            dontHaveAccountButton
        }
        .alert(
            errorMessage, isPresented: $showErrorAlert,
            actions: {
                Button("Ok", role: .cancel) {}
            }
        )
        .onChange(of: email) {
            withAnimation(.easeInOut) {
                validEmail = viewmodel.isValidEmail(email)
            }
        }
    }
}

extension LoginView {
    var inputFields: some View {
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
    }

    var forgotPasswordButton: some View {
        HStack {
            Spacer()

            Button {
                // not implemented
            } label: {
                Text("Forgot Password?")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.NFPrimary)
                    .padding(.top)
                    .padding(.trailing, 24)
            }
        }
    }

    var dontHaveAccountButton: some View {
        Button {
            router.navigate(to: .register)
        } label: {
            HStack {
                Text("Dont have an account?")
                    .font(.footnote)

                Text("Sign Up")
                    .font(.footnote)
                    .fontWeight(.semibold)
            }
            .padding(.bottom, 32)
            .foregroundStyle(Color.NFPrimary)
        }
    }
}

#Preview {
    LoginView()
}
