//
//  ArticleGridCell.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/12/25.
//

import Kingfisher
import SwiftUI

struct ArticleGridCell: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: Article Image
            if let imageUrl = article.imageUrl, let url = URL(string: imageUrl) {
                KFImage(url)
                    .resizable()
                    .cancelOnDisappear(true)
                    .fade(duration: 0.2)
                    .scaledToFit()
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
            }

            // MARK: Article title
            Text(article.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)

            // MARK: Source name
            Text(article.source.name)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
