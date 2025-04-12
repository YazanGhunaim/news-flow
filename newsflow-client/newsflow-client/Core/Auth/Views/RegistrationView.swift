//
//  RegistrationView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(AuthViewModel.self) private var viewmodel
    @Environment(Router.self) private var router

    @State private var name = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var diffPasswords = false
    @State private var validEmail = true

    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""

    var formFilled: Bool {
        !email.isEmpty && !password.isEmpty && !username.isEmpty && !confirmPassword.isEmpty
            && (password == confirmPassword) && validEmail
    }

    func handleError(_ error: APIError) {
        switch error {
        case .conflict:
            showErrorAlert.toggle()
            errorMessage = "Account with email or username already exists. Please try logging in instead."
        case _:
            showErrorAlert.toggle()
            errorMessage = "Something went wrong please try again."
        }
    }

    var body: some View {
        VStack {
            // MARK: Header
            AuthHeaderView(infoText: "Create your account")

            // MARK: Text fields
            textFields

            // MARK: Sign up button
            CustomButton(enabled: formFilled, text: "Sign up") {
                Task {
                    do {
                        try await viewmodel.register(name: name, username: username, email: email, password: password)
                        router.navigate(to: .setCategoryPreferences)
                    } catch let error as APIError {
                        handleError(error)
                    }
                }
            }
            .padding()

            Spacer()

            // MARK: Already have an account button
            alreadyHaveAccountButton
        }
        .navigationBarBackButtonHidden()
        .alert(
            errorMessage, isPresented: $showErrorAlert,
            actions: {
                Button("Ok", role: .cancel) {}
            }
        )
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

extension RegistrationView {
    var textFields: some View {
        VStack(spacing: 40) {
            CustomInputField(
                imageName: "person",
                placeHolderText: "Full name",
                text: $name
            )

            CustomInputField(
                imageName: "person",
                placeHolderText: "Username",
                text: $username
            )

            VStack(alignment: .trailing, spacing: 8) {
                CustomInputField(
                    imageName: "envelope",
                    placeHolderText: "Email",
                    text: $email
                )

                if !validEmail {
                    TextFieldTrailingInfo(text: "Invalid email format.", color: .red)
                }
            }

            VStack(alignment: .trailing, spacing: 8) {
                CustomInputField(
                    imageName: "lock",
                    placeHolderText: "Password",
                    isSecureField: true,
                    text: $password
                )
                if diffPasswords {
                    TextFieldTrailingInfo(text: "Passwords do not match.", color: .red)
                }
            }

            VStack(alignment: .trailing, spacing: 8) {
                CustomInputField(
                    imageName: "lock",
                    placeHolderText: "Confirm Password",
                    isSecureField: true,
                    text: $confirmPassword
                )

                if diffPasswords {
                    TextFieldTrailingInfo(text: "Passwords do not match.", color: .red)
                }
            }

        }
        .padding(32)
    }

    var alreadyHaveAccountButton: some View {
        Button {
            router.pop()
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
}

#Preview {
    RegistrationView()
}
