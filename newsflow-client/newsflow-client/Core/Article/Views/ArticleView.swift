//
//  ArticleView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import Kingfisher
import SwiftUI

struct ArticleView: View {
    @State private var viewmodel: ArticleViewModel
    let article: Article

    init(article: Article) {
        self.article = article
        _viewmodel = State(initialValue: ArticleViewModel(content: article.content))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: Article Image
                KFImage(URL(string: article.imageUrl ?? ""))
                    .resizable()
                    .placeholder { ProgressView() }
                    .scaledToFill()
                    .frame(height: 200)
                    .cornerRadius(12)

                // MARK: Title
                Text(article.title)
                    .font(.title2)
                    .fontWeight(.bold)

                // MARK: Source and Date
                HStack {
                    if let author = article.author {
                        Text("By \(author)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Text(article.date?.formattedDateString() ?? "Unknown")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Divider()

                // MARK: Description
                Text(article.description)
                    .font(.body)
                    .foregroundColor(.primary)

                // MARK: Full Content
                Text(article.content)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .padding()
        }
        .overlay(
            alignment: .bottom,
            content: { FloatingButton(image: "airpods.max") { viewmodel.readContent() } }
        )
        .navigationTitle(article.source.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let mockArticle = Article(
        source: Source(id: "techcrunch", name: "TechCrunch"),
        author: "Jane Doe",
        title: "SwiftUI Just Got Better!",
        description: "Apple has announced amazing improvements in SwiftUI at WWDC...",
        url: "https://www.example.com/article",
        imageUrl: "https://developer.apple.com/news/images/og/swiftui-og.png",
        content: "This is the full content of the article. It goes into detail about everything you want to know.",
        dateString: "2025-04-05T10:45:00Z"
    )

    return NavigationStack {
        ArticleView(article: mockArticle)
    }
    .preferredColorScheme(.light)
}
