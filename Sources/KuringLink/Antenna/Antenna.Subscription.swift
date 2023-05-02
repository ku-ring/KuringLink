//
//  Antenna.Subscription.swift
//  
//
//  Created by Jaesung Lee on 2023/05/02.
//

import Satellite
import Foundation

// MARK: Subscriptions

extension Antenna {
    
    // MARK: - Univ
    
    /// GET
    var allUnivNoticeTypes: [NoticeProvider] {
        get async throws {
            let response: Response<[NoticeProvider]> = try await satellite
                .response(
                    for: Action.getAllUnivNoticeType.path,
                    httpMethod: .get
                )
            return response.data
        }
    }
    
    /// GET
    func univNoticeTypes(subscribedBy fcmToken: String) async throws -> [NoticeProvider] {
        let response: Response<[NoticeProvider]> = try await satellite
            .response(
                for: Action.getSubscribedUnivNotices.path,
                httpMethod: .get,
                httpHeaders: [
                    "Content-Type": "application/json",
                    "User-Token": fcmToken
                ]
            )
        return response.data
    }
    
    /// POST
    func subscribeUnivNoticeTypes(_ names: [String], fcmToken: String) async throws -> Bool {
        let response: EmptyResponse = try await satellite
            .response(
                for: Action.subscribeUnivNotices.path,
                httpMethod: .post,
                httpHeaders: [
                    "Content-Type": "application/json",
                    "User-Token": fcmToken
                ],
                httpBody: UnivNoticeSubscription(categories: names)
            )
        let isSucceed = (200..<300) ~= response.code
        return isSucceed
    }
    
    
    
    // MARK: - Department
    
    /// GET
    var allDepartments: [NoticeProvider] {
        get async throws {
            let response: Response<[NoticeProvider]> = try await satellite
                .response(
                    for: Action.getAllDepartments.path,
                    httpMethod: .get
                )
            return response.data
        }
    }
    
    /// GET
    func departments(subscribedBy fcmToken: String) async throws -> [NoticeProvider] {
        let response: Response<[NoticeProvider]> = try await satellite
            .response(
                for: Action.getSubscribedDepartments.path,
                httpMethod: .get,
                httpHeaders: [
                    "Content-Type": "application/json",
                    "User-Token": fcmToken
                ]
            )
        return response.data
    }
    
    /// POST
    func subscribeDepartments(_ hostPrefixes: [String], fcmToken: String) async throws -> Bool {
        let response: EmptyResponse = try await satellite
            .response(
                for: Action.subscribeDepartments.path,
                httpMethod: .post,
                httpHeaders: [
                    "Content-Type": "application/json",
                    "User-Token": fcmToken
                ],
                httpBody: DepartmentSubscription(departments: hostPrefixes)
            )
        let isSucceed = (200..<300) ~= response.code
        return isSucceed
    }
}
