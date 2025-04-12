//
//  FlowView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/6/25.
//

import SwiftUI

struct FlowView: View {
    @State private var viewmodel = FlowViewModel(
        articleService: ArticleService(), textToSpeechService: TextToSpeechService()
    )

    @State private var offset: CGSize = .zero
    @State private var shouldDismissTopCard = false
    @State private var hasStartedReading = false

    var body: some View {
        NavigationView {
            VStack {
                // MARK: Article cards
                ZStack {
                    ForEach(viewmodel.topArticles) { article in
                        ArticleCard(
                            articles: $viewmodel.topArticles,
                            article: article,
                            isTop: article.id == viewmodel.topArticles.last?.id,
                            shouldDismiss: $shouldDismissTopCard
                        )
                    }
                }
                .padding(.top)

                Spacer()  // pushing views up
            }
            .onChange(of: viewmodel.topArticles) {
                guard hasStartedReading else { return }
                guard let next = viewmodel.topArticles.last else { return }
                guard !viewmodel.isSpeaking, !shouldDismissTopCard else { return }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    viewmodel.read(text: next.summary ?? "") {
                        shouldDismissTopCard = true
                    }
                }
            }
            .onDisappear { viewmodel.pauseReading() }
            .onAppear { viewmodel.refreshCards() }
            .overlay(alignment: .bottom) { playbuttons }
            .navigationTitle("Daily Flow")
        }
    }
}

extension FlowView {
    var playbuttons: some View {
        HStack(spacing: 24) {
            // Pause/Resume
            FloatingButton(
                isAnimating: .constant(false),
                isDisabled: .constant(!viewmodel.isSpeaking && !viewmodel.isPaused),
                image: viewmodel.isPaused ? "play.fill" : "pause.fill",
            ) {
                if viewmodel.isPaused {
                    viewmodel.resumeReading()
                } else {
                    viewmodel.pauseReading()
                }
            }
            .opacity((!viewmodel.isSpeaking && !viewmodel.isPaused) ? 0.5 : 1.0)

            // Play
            FloatingButton(
                isAnimating: .constant(false),
                isDisabled: .constant(hasStartedReading),
                image: "airpods.max"
            ) {
                guard !viewmodel.isSpeaking else { return }
                hasStartedReading = true
                viewmodel.read(text: viewmodel.topArticles.last?.summary ?? "") {
                    shouldDismissTopCard = true
                }
            }
            .opacity(hasStartedReading ? 0.5 : 1.0)

            // Skip
            FloatingButton(
                isAnimating: .constant(false),
                isDisabled: .constant(viewmodel.topArticles.isEmpty),
                image: "forward.fill"
            ) {
                viewmodel.stopReading()
                shouldDismissTopCard = true
                viewmodel.isPaused = false
            }
            .opacity(viewmodel.topArticles.isEmpty ? 0.5 : 1.0)

        }
        .padding(.bottom, 32)
    }
}

#Preview {
    FlowView()
        .preferredColorScheme(.light)
}
