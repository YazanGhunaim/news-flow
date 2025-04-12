//
//  FlowViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/12/25.
//

import Foundation

@Observable
@MainActor
final class FlowViewModel: ObservableObject {
    let textToSpeechService = TextToSpeechService()

    private var tempTopArticles = [Article]()
    var topArticles = [Article]()

    var failed = false
    var isSpeaking: Bool = false
    var isPaused: Bool = false
    var errorMessage: String?

    init() {
        Task {
            await initializeDailyFlow()
            topArticles = tempTopArticles
        }
    }

    func refreshCards() { topArticles = tempTopArticles }

    func initializeDailyFlow() async {
        let articles = await getTopArticles() ?? []

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

    private func getTopArticles() async -> [Article]? {
        let params = ["category": "technology", "page_size": "5"]
        let url = EndpointManager.shared.url(for: .topHeadlines, parameters: params)
        let response: Result<NewsResponse, APIError> = await APIClient.shared.request(url: url, method: .get)

        switch response {
        case .success(let newsResponse):
            NFLogger.shared.logger.debug("Sucessfully fetched top articles for today.")
            return newsResponse.articles
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to fetch to articles for today with error: \(error)")
            failed = true
            return nil
        }
    }

    private func summarizeArticle(forArticle article: Article) async throws -> Article {
        let response: Result<ArticleSummary, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .summarizeArticle),
            method: .post,
            body: article
        )

        switch response {
        case .success(let articleSummary):
            NFLogger.shared.logger.info("Retrieved summary for \(article.url)")
            return Article(fromArticle: article, withSummary: articleSummary.summary)
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to retrieve summary for \(article.url): \(error)")
            throw error
        }
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
