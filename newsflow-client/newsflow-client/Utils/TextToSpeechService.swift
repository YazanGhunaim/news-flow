//
//  TextToSpeechService.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/7/25.
//

import AVFoundation
import Foundation

enum TextToSpeechError: Error {
    case audioSessionSetupFailed
    case audioSessionDeactivationFailed(Error)
}

class TextToSpeechService: NSObject, AVSpeechSynthesizerDelegate {
    private var synthesizer: AVSpeechSynthesizer
    private var currentUtterance: AVSpeechUtterance?

    var onFinishSpeaking: (() throws -> Void)?

    override init() {
        synthesizer = AVSpeechSynthesizer()
        super.init()
        synthesizer.delegate = self
    }

    func speak(text: String, withVoice voiceIdentifier: String? = nil, completion: @escaping () -> Void) throws {
        let audioSession = AVAudioSession.sharedInstance()

        // setup
        do {
            try audioSession.setCategory(.playback, mode: .voicePrompt, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            throw TextToSpeechError.audioSessionSetupFailed
        }

        let utterance = AVSpeechUtterance(string: text)
        if let voiceID = voiceIdentifier, let selectedVoice = AVSpeechSynthesisVoice(identifier: voiceID) {
            utterance.voice = selectedVoice
        } else {
            let defaultLanguage = Locale.current.language.languageCode?.identifier ?? "en-US"
            utterance.voice = AVSpeechSynthesisVoice(language: defaultLanguage)
        }

        if currentUtterance != nil, synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        self.currentUtterance = utterance
        onFinishSpeaking = {
            completion()
            try self.restoreAudioSession()
        }

        synthesizer.speak(utterance)
    }

    func stopSpeaking() throws {
        if synthesizer.isSpeaking, currentUtterance != nil {
            synthesizer.stopSpeaking(at: .immediate)
            currentUtterance = nil
            try restoreAudioSession()
        }
    }

    private func restoreAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            throw TextToSpeechError.audioSessionDeactivationFailed(error)
        }
    }
}
