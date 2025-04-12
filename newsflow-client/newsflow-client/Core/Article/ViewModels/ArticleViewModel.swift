//
//  ArticleViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/7/25.
//

import Foundation

@MainActor
@Observable
final class ArticleViewModel {
    let articleService: ArticleService
    let textToSpeechService: TextToSpeechService
    let article: Article

    var errorMessage: String?
    var isSpeaking: Bool = false
    var isPaused: Bool = false
    var articleIsBookmarked: Bool = false

    init(articleService: ArticleService, textToSpeechService: TextToSpeechService, article: Article) {
        self.articleService = articleService
        self.textToSpeechService = textToSpeechService
        self.article = article

        self.articleIsBookmarked = isArticleBookmarked()
    }
	
	// MARK: Article Operations
    func bookmarkArticle() async {
        do {
            try await articleService.bookmarkArticle(article)
            addBookmarkedArticleToUserDefaults()
            articleIsBookmarked = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func unbookmarkArticle() async {
        do {
            try await articleService.unbookmarkArticle(article)
            removeBookmarkedArticleFromUserDefaults()
            articleIsBookmarked = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func summarizeArticle() async -> String {
        do {
            let articleSummary = try await articleService.summarizeArticle(article)
            return articleSummary
        } catch {
            errorMessage = error.localizedDescription
            return ""
        }
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

    // MARK: - TTS
    func read(text: String) {
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
