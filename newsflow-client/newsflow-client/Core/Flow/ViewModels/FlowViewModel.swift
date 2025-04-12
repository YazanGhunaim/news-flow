//
//  FlowViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/12/25.
//

import Foundation

//			return Article(fromArticle: article, withSummary: articleSummary.summary)
@Observable
@MainActor
final class FlowViewModel: ObservableObject {
    let articleService: ArticleService
    let textToSpeechService: TextToSpeechService

    private var tempTopArticles = [Article]()
    var topArticles = [Article]()

    var failed = false
    var isSpeaking: Bool = false
    var isPaused: Bool = false
    var errorMessage: String?

    init(articleService: ArticleService, textToSpeechService: TextToSpeechService) {
        self.articleService = articleService
        self.textToSpeechService = textToSpeechService

        Task {
            await initializeDailyFlow()
            topArticles = tempTopArticles
        }
    }

    func initializeDailyFlow() async {
        let articles = await fetchTopHeadlines()

        for article in articles {
            do {
                let summarizedArticle = try await self.summarizeArticle(forArticle: article)
                tempTopArticles.append(summarizedArticle)
            } catch {
                NFLogger.shared.logger.info("Failed to summarize article \(article.title) with error: \(error)")
                continue
            }
        }
    }

    func refreshCards() {
        topArticles = tempTopArticles
    }

    // MARK: Articles
    func fetchTopHeadlines() async -> [Article] {
        guard let topHeadlines = try? await articleService.getTopHeadlines(forCategory: "technology", pageSize: 10)
        else {
            failed = true
            return []
        }

        return topHeadlines
    }

    func summarizeArticle(forArticle article: Article) async throws -> Article {
        let summary = try await articleService.summarizeArticle(article)
        return Article(fromArticle: article, withSummary: summary)
    }

    // MARK: - TTS
    func read(text: String, onComplete: @escaping () -> Void) {
        guard !isSpeaking else { return }

        NFLogger.shared.logger.debug("Reading article content...")
        isSpeaking = true

        do {
            try textToSpeechService.speak(
                text: text,
                withVoice: "com.apple.ttsbundle.Allison-premium"
            ) {
                NFLogger.shared.logger.debug("Reading article content complete...")
                self.isSpeaking = false
                onComplete()
            }
        } catch {
            errorMessage = error.localizedDescription
            isSpeaking = false
        }
    }

    func pauseReading() {
        guard isSpeaking else { return }
        NFLogger.shared.logger.debug("Paused reading...")

        defer {
            isPaused = true
            isSpeaking = true  // to keep play button disabled
        }

        textToSpeechService.pauseSpeaking()
    }

    func resumeReading() {
        guard isPaused else { return }
        NFLogger.shared.logger.debug("Resume reading...")

        defer {
            isPaused = false
            isSpeaking = true
        }

        textToSpeechService.resumeSpeaking()
    }

    func stopReading() {
        guard isSpeaking else { return }
        defer { isSpeaking = false }

        do {
            try textToSpeechService.stopSpeaking()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
