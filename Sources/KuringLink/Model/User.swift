//
//  User.swift
//  
//
//  Created by Jaesung Lee on 2023/05/01.
//

import Foundation

public struct User: Identifiable, Codable {
    public var id: String { uid }
    public let uid: String
    public let kuringId: String
    public let nickname: String?
    public let profileUrl: String?
}
