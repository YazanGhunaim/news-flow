//
//  ArticleCard.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/5/25.
//

import Kingfisher
import SwiftUI

struct ArticleCard: View {
    @Binding var cards: [Article]

    @State private var offset: CGSize = .zero
    @State private var isExpanding: Bool = false

    let card: Article

    var body: some View {
        ZStack {
            KFImage(URL(string: card.imageUrl!))
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 400)
                .cornerRadius(20)
                .shadow(radius: 5)
                .overlay(
                    Text(card.title)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(),
                    alignment: .bottom
                )
        }
        .offset(x: offset.width, y: 0)
        .rotationEffect(.degrees(Double(offset.width / 20)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if offset.width > 150 {
                        bookmarkCard()
                    } else if offset.width < -150 {
                        skipCard()
                    } else {
                        offset = .zero
                    }
                }
        )
    }

    func bookmarkCard() {
        withAnimation {
            offset.width = 500  // Move off-screen to the right
            removeCard()
        }
    }

    func skipCard() {
        withAnimation {
            offset.width = -500  // Move off-screen to the left
            removeCard()
        }
    }

    func removeCard() {
        // allow time for animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            cards.removeAll { $0.id == card.id }
        }
    }
}

//#Preview {
//    ArticleCard()
//}
