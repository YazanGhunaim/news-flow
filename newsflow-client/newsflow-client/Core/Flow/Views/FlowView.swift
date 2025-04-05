//
//  FlowView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import SwiftUI

struct FlowView: View {
    @State private var cards: [Article] = [
        Article(
            imageURL: "https://media.cnn.com/api/v1/images/stellar/prod/image-one-wasp.jpg?c=16x9&q=w_800,c_fill",
            title: "Card 1"),
        Article(
            imageURL: "https://variety.com/wp-content/uploads/2025/03/GettyImages-2204767080.jpg?w=1000",
            title: "Card 1"),
        Article(
            imageURL: "https://media.cnn.com/api/v1/images/stellar/prod/image-one-wasp.jpg?c=16x9&q=w_800,c_fill",
            title: "Card 2"),
    ]
    
    var body: some View {
        ZStack {
            ForEach(cards) { card in
                ArticleCard(cards: $cards, card: card)
            }
        }
    }
}

#Preview {
    FlowView()
}
