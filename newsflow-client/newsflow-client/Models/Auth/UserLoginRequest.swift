//
//  UserLoginRequest.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import Foundation

struct UserLoginRequest: Codable {
    let email: String
    let password: String
}
