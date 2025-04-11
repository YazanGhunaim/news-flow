//
//  ArticleView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import Kingfisher
import SwiftUI

// TODO: Bug with buttons ( play -> pause -> replay to recreate )
struct ArticleView: View {
    @State private var viewmodel: ArticleViewModel
    @State private var isSummarizing: Bool = false

    let article: Article

    init(article: Article, isSummarizing: Bool = false) {
        self.article = article
        self.isSummarizing = isSummarizing

        _viewmodel = State(initialValue: ArticleViewModel(article: article))
    }

    var body: some View {
        ZStack {
            // MARK: - ScrollView
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
            .overlay(alignment: .bottom, content: { playbackButtons })
            .onDisappear { viewmodel.stopReading() }  // stop TTS when user gets out of article view

            // MARK: - Dim
            if isSummarizing {
                Color.NFPrimary.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
            }
        }
        .navigationTitle(article.source.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isSummarizing)  // disable dismissing if summarizing
        .toolbar { ToolbarItem(placement: .topBarTrailing) { bookmarkButton } }
        .animation(.easeInOut, value: isSummarizing)  // Whenever the value of isSummarizing changes animate all views that depend on it
        .animation(.easeInOut, value: viewmodel.isSpeaking)
        .animation(.easeInOut, value: viewmodel.isPaused)
    }
}

extension ArticleView {
    var bookmarkButton: some View {
        Button {
            if viewmodel.articleIsBookmarked {
                Task { await viewmodel.unbookmarkArticle() }
            } else {
                Task { await viewmodel.bookmarkArticle() }
            }
        } label: {
            Image(systemName: viewmodel.articleIsBookmarked ? "bookmark.fill" : "bookmark")
        }
    }

    var playbackButtons: some View {
        HStack(alignment: .center, spacing: 24) {
            // MARK: Main TTS button
            FloatingButton(
                isAnimating: $isSummarizing, isDisabled: $viewmodel.isSpeaking, image: "airpods.max"
            ) {
                guard !isSummarizing && !viewmodel.isSpeaking else { return }
                isSummarizing = true

                Task {
                    let summary = await viewmodel.summarizeArticle()
                    isSummarizing = false
                    viewmodel.read(text: summary)
                }
            }
            .opacity(viewmodel.isSpeaking ? 0.5 : 1)

            // MARK: Pause / Resume
            if viewmodel.isSpeaking || viewmodel.isPaused {
                FloatingButton(
                    isAnimating: .constant(false), isDisabled: .constant(false),
                    image: viewmodel.isSpeaking ? "pause.fill" : "play.fill",
                    color: viewmodel.isSpeaking ? .red : .green
                ) {
                    if viewmodel.isPaused {
                        viewmodel.resumeReading()
                    } else {
                        viewmodel.pauseReading()
                    }
                }
            }

        }
        .padding(.horizontal, 20)
    }
}
#Preview {
    let mockArticle = Article(
        source: Source(name: "TechCrunch"),
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
