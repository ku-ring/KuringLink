//
//  NoticeStock.swift
//  
//
//  Created by Jaesung Lee on 2023/05/02.
//

import Cache
import Combine
import Foundation
import OrderedCollections

// TODO: 
/// 1. 캐싱은 반드시 최근 20개만
/// 2. 20개 이상의 데이터는 변수로 런타임동안만 들고 있기 (앱단에서 해야할 필요는 없는가)
/// 3. 초기에 한번만 캐싱데이터 **퍼블리싱**
/// 4. 새 데이터 가져올때마다 **퍼블리싱**
/// 5. 새 데이터는 런타임변수에 upsert 해서 업데이트
class NoticeStock {
    public struct Params {
        let type: String
        let department: String?
        let page: Int
        let count: Int
        
        public init(type: String, department: String? = nil, page: Int, count: Int) {
            self.type = type
            self.department = department
            self.page = page
            switch count {
            case ..<1: self.count = 1
            case 1..<20: self.count = count
            default: self.count = 20
            }
        }
    }
    
    let stockKey = "com.kuring.link/cache/notice"
    let stock = DiskCache<[Notice]>(fileManager: DefaultFileManager())
    
    var notices: [String: OrderedSet<Notice>] = [:]
    var hasMores: [String: Bool] = [:]
    let publisher = PassthroughSubject<[Notice], Error>()
    let orderParams: Params
    
    init(orderParams: Params) {
        self.orderParams = orderParams
    }
    
    // 카테고리 별로 저장
    func save(_ notices: [Notice], forCategory name: String, department: String? = nil) throws {
        let path = department != nil ? "\(stockKey)/\(name)/\(department!).json" : "\(stockKey)/\(name).json"
        try stock.save(notices, forKey: path)
        publisher.send(notices)
    }
    
    func cachedData(forCategory name: String, department: String? = nil) throws {
        let path = department != nil
        ? "\(stockKey)/\(name)/\(department!).json"
        : "\(stockKey)/\(name).json"
        
        let cahedData = try stock.value(forKey: path)
        publisher.send(cahedData ?? [])
    }
    
    func order() {
        Task {
            let key = orderParams.department != nil
            ? "\(orderParams.type).\(orderParams.department!)"
            : orderParams.type
            let hasMore = hasMores[key] ?? true
            
            guard hasMore else { return }
            let newNotices = try await KuringLink
                .notices(
                    count: orderParams.count,
                    typeOf: orderParams.type,
                    department: orderParams.department,
                    forPageAt: orderParams.page
                )
            
            hasMores.updateValue(newNotices.count == orderParams.count, forKey: key)
            
            guard !newNotices.isEmpty else { return }
            self.upsertNewNotice(newNotices, forKey: key)
            publisher.send(newNotices)
        }
    }
    
    func upsertNewNotice(_ newNotices: [Notice], forKey key: String) {
        // 시간순으로 order 되도록 Notice 수정하기
        var currentNotices = notices[key] ?? []
        currentNotices.append(contentsOf: newNotices)
        
        notices.updateValue(currentNotices, forKey: key)
    }
}
