//
//  Antenna.Search.swift
//  
//
//  Created by Jaesung Lee on 2023/05/02.
//

import Satellite
import Foundation

extension Antenna {
    // MARK: - Search
    
    
    func notices(startsWith keyword: String) async throws -> [Notice] {
        struct SearchResult: Codable {
            let noticeList: [SearchedNotice]
        }
        
        let response: Response<SearchResult> = try await satellite
            .response(
                for: Action.searchNotices.path,
                httpMethod: .get,
                queryItems: [
                    .init(name: "content", value: keyword)
                ]
            )
        return response.data.noticeList.map { $0.asNotice }
    }
    
    func staffs(startsWith keyword: String) async throws -> [Staff] {
        struct SearchResult: Codable {
            let staffList: [Staff]
        }
        
        let response: Response<SearchResult> = try await satellite
            .response(
                for: Action.searchStaffs.path,
                httpMethod: .get,
                queryItems: [
                    .init(name: "content", value: keyword)
                ]
            )
        return response.data.staffList
    }
}
