//
//  Article.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/5/25.
//

import Foundation

// TODO: Actual model
let categories = ["Business", "Technology", "Health", "Entertainment", "Sports"]
struct Article: Identifiable {
    let id = UUID()
    let imageURL: String
    let title: String
    let date: Date = Date()
    let category: String = categories.randomElement()!
}
