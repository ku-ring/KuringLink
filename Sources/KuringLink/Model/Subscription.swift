//
//  Subscription.swift
//  
//
//  Created by Jaesung Lee on 2023/05/01.
//

import Foundation

public struct UnivNoticeSubscription: Codable {
    public let categories: [String]
}

public struct DepartmentSubscription: Codable {
    public let departments: [String]
}
