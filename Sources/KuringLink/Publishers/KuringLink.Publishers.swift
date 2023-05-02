//
//  KuringLink.Publishers.swift
//  
//
//  Created by Jaesung Lee on 2023/05/01.
//

import Combine
import Foundation

// 이벤트 퍼블리셔에 대한 extension 입니다.
extension KuringLink {
    public static let noticeNotificationPublisher: PassthroughSubject<Notice, Never> = .init()
    
    public static let customNotificationPublisher: PassthroughSubject<(String, String), Never> = .init()
}
