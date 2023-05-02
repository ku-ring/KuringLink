//
//  Stock.swift
//  
//
//  Created by Jaesung Lee on 2023/05/07.
//

import Cache
import Combine
import Foundation
import OrderedCollections

// TODO: Generic class
class Stock<ProductItem: Codable, OrderInfo: Codable> {
    let stockPath: String
    let stock = DiskCache<ProductItem>(fileManager: DefaultFileManager())
    
    var item: ProductItem
    var remoteItem: (_ orderInfo: OrderInfo) async throws -> ProductItem
    
    let publisher = PassthroughSubject<ProductItem, Error>()
    
    init(
        stockPath: String,
        item: ProductItem,
        remoteItem: @escaping (_ orderInfo: OrderInfo) -> ProductItem
    ) {
        self.stockPath = stockPath
        self.item = item
        self.remoteItem = remoteItem
    }
    
    func localItem() throws {
        let localItem = try stock.value(forKey: stockPath)
        if let localItem {
            item = localItem
        }
        publisher.send(localItem ?? item)
    }
}
