//
//  NoticeProvider.swift
//  
//
//  Created by Jaesung Lee on 2023/05/01.
//

import Foundation

public struct NoticeProvider: Codable, Identifiable {
    public var id: String { hostPrefix }
    public let name: String
    public let hostPrefix: String
    public let korName: String
}
