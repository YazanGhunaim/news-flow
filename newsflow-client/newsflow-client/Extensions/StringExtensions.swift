//
//  StringExtensions.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/7/25.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self)
    }
}
