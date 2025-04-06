//
//  ArticleCell.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import Kingfisher
import SwiftUI

struct ArticleCell: View {
    let article: Article

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // MARK: Article Image
            KFImage(URL(string: article.imageUrl!))
                .placeholder {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 125, height: 125)
                }
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                .cornerRadius(8)

            // MARK: Article metadata
            VStack(alignment: .leading) {
                Text(article.source.name)

                Spacer()

                Text(article.title)
                    .lineLimit(2)
                    .font(.headline)

                Spacer()

                Text(article.date, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .frame(height: 125)
    }
}

//#Preview {
//    ArticleCell(
//        article: Article(
//            imageURL: "https://variety.com/wp-content/uploads/2025/03/GettyImages-2204767080.jpg?w=1000",
//            title: "Breaking News: SwiftUI Makes Beautiful UIs Easy"
//        )
//    )
//}
