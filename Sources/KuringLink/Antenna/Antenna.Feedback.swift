//
//  Antenna.Feedback.swift
//  
//
//  Created by Jaesung Lee on 2023/05/02.
//

import Satellite
import Foundation

extension Antenna {
    
    // MARK: - Feedback
    
    /// `"User-Agent": "Kuring/1.2.0 iOS/14.1"`
    func sendFeedback(
        _ text: String,
        fcmToken: String,
        appVersion: String,
        osVersion: String
    ) async throws -> Bool {
        let response: EmptyResponse = try await satellite
            .response(
                for: Action.sendFeedback.path,
                httpMethod: .post,
                httpHeaders: [
                    "Content-Type": "application/json",
                    "User-Token": fcmToken,
                    "User-Agent": "Kuring/\(appVersion) iOS/\(osVersion)"
                ],
                httpBody: Feedback(content: text)
            )
        let isSucceed = (200..<300) ~= response.code
        return isSucceed
    }
}
