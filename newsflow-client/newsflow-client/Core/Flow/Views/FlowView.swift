//
//  FlowView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import SwiftUI

struct FlowView: View {
    @State private var cards: [Article] = []
    
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
