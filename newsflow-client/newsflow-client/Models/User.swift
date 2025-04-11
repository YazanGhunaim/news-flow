//
//  User.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/11/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let name: String
    let username: String
    let email: String
}
