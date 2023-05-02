//
//  Antenna.Notice.swift
//  
//
//  Created by Jaesung Lee on 2023/05/02.
//

import Satellite
import Foundation

extension Antenna {
    
    // MARK: - Notice
    
    func notices(
        count: Int,
        typeOf type: String,
        department: String? = nil,
        forPageAt page: Int
    ) async throws -> [Notice] {
        let response: Response<[Notice]> = try await satellite
            .response(
                for: Action.getNotices.path,
                httpMethod: .get,
                queryItems: [
                    .init(name: "type", value: type),
                    .init(name: "department", value: department),
                    .init(name: "page", value: String(page)),
                    .init(name: "size", value: String(count))
                ]
            )
        return response.data
    }
}
