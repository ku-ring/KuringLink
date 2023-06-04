//
//  Notice.swift
//  
//
//  Created by Jaesung Lee on 2023/05/01.
//

import Foundation

public struct Notice: Codable, Hashable {
    /// e.g., `"5b45b56"`
    public let articleId: String
    /// e.g., `"post_date_1"`
    public let postedDate: String
    /// e.g., `"subject_1"`
    public let subject: String
    /// e.g., `"https://www.konkuk.ac.kr/do/MessageBoard/ArticleRead.do?id=5b45b56"`
    public let url: String
    /// e.g., `"student"`
    public let category: String
    /// e.g., `true`
    public let important: Bool

    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

public struct SearchedNotice: Codable, Hashable {
    /// e.g., `"5b45b56"`
    public let articleId: String
    /// e.g., `"post_date_1"`
    public let postedDate: String
    /// e.g., `"subject_1"`
    public let subject: String
    /// e.g., `"https://www.konkuk.ac.kr/do/MessageBoard/ArticleRead.do?id=5b45b56"`
    public let baseUrl: String
    /// e.g., `"student"`
    public let category: String

    public func hash(into hasher: inout Hasher) {
        hasher.combine(baseUrl)
    }
    
    var asNotice: Notice {
        Notice(
            articleId: articleId,
            postedDate: postedDate,
            subject: subject,
            url: baseUrl,
            category: category,
            important: false
        )
    }
}
