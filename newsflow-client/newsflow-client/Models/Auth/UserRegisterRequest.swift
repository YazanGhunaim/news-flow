//
//  UserRegisterRequest.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import Foundation

struct UserData: Codable {
    let username: String
    let name: String
}

struct UserOptions: Codable {
    let data: UserData
}

struct UserRegisterRequest: Codable {
    let email: String
    let password: String
    let options: UserOptions
}
