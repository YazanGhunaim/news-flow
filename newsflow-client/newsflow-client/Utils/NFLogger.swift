//
//  NFLogger.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/5/25.
//

import Foundation
import OSLog

class NFLogger {
    let logger: Logger

    static let shared = NFLogger()

    private init() {
        self.logger = Logger()
    }
}
