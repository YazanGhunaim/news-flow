//
//  ArticleCard.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/5/25.
//

import Kingfisher
import SwiftUI

struct ArticleCard: View {
    @Binding var articles: [Article]
    let article: Article
    let isTop: Bool
    @Binding var shouldDismiss: Bool

    @State private var offset: CGSize = .zero
    @State private var isExpanding: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Image
            KFImage(URL(string: article.imageUrl ?? ""))
                .placeholder {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.NFPrimary)
                        .frame(width: 320, height: 440)
                }
                .resizable()
                .scaledToFill()
                .frame(width: 320, height: 440)
                .clipped()
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 8)

            // MARK: Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(24)

            // MARK: Info Content
            VStack(alignment: .leading, spacing: 8) {
                Spacer()

                Text(article.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)

                Text(article.description)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(2)
            }
            .padding()
        }
        .frame(width: 320, height: 440)
        .offset(offset)
        .rotationEffect(.degrees(Double(offset.width / 20)))
        .onChange(of: shouldDismiss) { oldValue, newValue in
            if newValue && isTop {
                withAnimation(.easeInOut(duration: 0.3)) {
                    offset = CGSize(width: 500, height: 0)
                }
                removeSelfAfterDelay()
            }
        }
    }

    private func removeSelfAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let index = articles.firstIndex(where: { $0.id == article.id }) {
                articles.remove(at: index)
            }
            shouldDismiss = false  // reset for next card
        }
    }
}
