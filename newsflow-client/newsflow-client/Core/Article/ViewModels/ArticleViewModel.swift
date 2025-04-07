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
    let articleContent: String
    let textToSpeechService = TextToSpeechService()

    var errorMessage: String?
    var isSpeaking: Bool = false

    init(content: String) {
        self.articleContent = content
    }

    func readContent() {
        isSpeaking = true

        defer { isSpeaking = false }

        do {
            try textToSpeechService.speak(
                text: articleContent, withVoice: "com.apple.ttsbundle.siri_male_en-US_compact"
            ) {
                NFLogger.shared.logger.info("Reading article content complete.")
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
