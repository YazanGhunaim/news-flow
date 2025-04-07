//
//  ArticleViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/7/25.
//

import Foundation

@MainActor
@Observable
class ArticleViewModel {
    let textToSpeechService = TextToSpeechService()

    var errorMessage: String?
    var isSpeaking: Bool = false

    func summarizeArticle(_ article: Article) async -> String {
        let response: Result<ArticleSummary, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.getEndpointURL(for: .summarizeArticle), method: .post, body: article,
        )

        switch response {
        case .success(let article):
            NFLogger.shared.logger.info("Retrieved summary for \(article.url)")
            return article.summary
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to retrieve summary for \(article.url): \(error)")
            return ""
        }
    }

    // MARK: - TTS
    func read(text: String) {
        isSpeaking = true
        NFLogger.shared.logger.info("Reading article content...")

        do {
            try textToSpeechService.speak(
                text: text,
                withVoice: "com.apple.ttsbundle.siri_male_en-US_compact"
            ) {
                NFLogger.shared.logger.info("Reading article content complete...")
                self.isSpeaking = false
            }
        } catch {
            errorMessage = error.localizedDescription
        }
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
