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
    let article: Article
    let textToSpeechService = TextToSpeechService()

    var errorMessage: String?
    var isSpeaking: Bool = false
    var isPaused: Bool = false
    var articleIsBookmarked: Bool = false

    init(article: Article) {
        self.article = article
        self.articleIsBookmarked = isArticleBookmarked()
    }

    // MARK: User Defaults
    private func isArticleBookmarked() -> Bool {
        let bookmarked_urls = UserDefaultsManager.shared.getStringArray(forKey: .userBookmarkUrls) ?? []
        return bookmarked_urls.contains(article.url)
    }

    private func addBookmarkedArticleToUserDefaults() {
        var bookmarked_urls = UserDefaultsManager.shared.getStringArray(forKey: .userBookmarkUrls) ?? []

        if bookmarked_urls.isEmpty {
            bookmarked_urls = [article.url]
        } else {
            guard !bookmarked_urls.contains(article.url) else { return }  // dont add url twice
            bookmarked_urls += [article.url]
        }

        UserDefaultsManager.shared.setStringArray(value: bookmarked_urls, forKey: .userBookmarkUrls)
        NFLogger.shared.logger.debug("Added article \(self.article.url) to bookmarked user defaults")
    }

    private func removeBookmarkedArticleFromUserDefaults() {
        var bookmarked_urls = UserDefaultsManager.shared.getStringArray(forKey: .userBookmarkUrls) ?? []

        guard let index = bookmarked_urls.firstIndex(of: article.url) else { return }
        bookmarked_urls.remove(at: index)

        UserDefaultsManager.shared.setStringArray(value: bookmarked_urls, forKey: .userBookmarkUrls)
        NFLogger.shared.logger.debug("Removed article \(self.article.url) from bookmarked user defaults")

    }

    // MARK: Article operation
    func bookmarkArticle() async {
        let response: Result<EmptyEntity, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .bookmarkArticle), method: .post, body: article,
        )

        switch response {
        case .success(_):
            NFLogger.shared.logger.info("Bookmarked article \(self.article.url)")
            addBookmarkedArticleToUserDefaults()
            articleIsBookmarked = true
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to bookmark article \(self.article.url): \(error)")
        }
    }

    func unbookmarkArticle() async {
        let params = ["article_url": article.url]
        let response: Result<EmptyEntity, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .bookmarkArticle, parameters: params), method: .delete
        )

        switch response {
        case .success(_):
            removeBookmarkedArticleFromUserDefaults()
            articleIsBookmarked = false
            NFLogger.shared.logger.info("Successfully unbookmarked article \(self.article.url)")
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to unbookmark article \(self.article.url): \(error)")
        }
    }

    func summarizeArticle() async -> String {
        let response: Result<ArticleSummary, APIError> = await APIClient.shared.request(
            url: EndpointManager.shared.url(for: .summarizeArticle), method: .post, body: article,
        )

        switch response {
        case .success(let article):
            NFLogger.shared.logger.info("Retrieved summary for \(self.article.url)")
            return article.summary
        case .failure(let error):
            NFLogger.shared.logger.error("Failed to retrieve summary for \(self.article.url): \(error)")
            return ""
        }
    }

    // MARK: - TTS
    func read(text: String) {
        isSpeaking = true
        NFLogger.shared.logger.debug("Reading article content...")

        do {
            try textToSpeechService.speak(
                text: text,
                withVoice: "com.apple.ttsbundle.siri_male_en-US_compact"
            ) {
                NFLogger.shared.logger.debug("Reading article content complete...")
                self.isSpeaking = false
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func pauseReading() {
        guard isSpeaking else { return }
        NFLogger.shared.logger.debug("Paused reading...")

        defer {
            isPaused = true
            isSpeaking = false
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
