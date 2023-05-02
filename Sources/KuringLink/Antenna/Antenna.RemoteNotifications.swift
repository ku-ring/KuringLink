//
//  Antenna.RemoteNotifications.swift
//  
//
//  Created by Jaesung Lee on 2023/05/02.
//

import UIKit
import Satellite

extension Antenna {
    // MARK: - Remote Notifications
    
    var isCustomNotificationEnabled: Bool { true }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) {
        guard let userInfo = userInfo as? [String: Any] else { return }
        onTapRemoteNotification(with: userInfo)
    }
    
    /// 포어그라운드에서 푸시 알림을 처리합니다.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        guard let userInfo = notification.request.content.userInfo as? [String: Any] else {
            completionHandler([])
            return
        }
        
        /// 커스텀 알림이지만 알림off 인경우 즉각 리턴
        if isCustomNotification(userInfo), !isCustomNotificationEnabled {
            completionHandler([])
            return
        }
        completionHandler([.banner, .sound])
    }
    
    
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) {
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else { return }
        onTapRemoteNotification(with: userInfo)
    }
    
    /// userInfo 를 새 공지 알림이나 커스텀 알림으로 변경하고 이벤트와 배너를 제공합니다.
    func onTapRemoteNotification(with userInfo: [String: Any]) {
        if let json = try? JSONSerialization.data(withJSONObject: userInfo),
           let notice = try? JSONDecoder().decode(Notice.self, from: json) {
            KuringLink.noticeNotificationPublisher.send(notice)
        } else if isCustomNotification(userInfo) {
            // 기타 알림만 체크
            guard isCustomNotificationEnabled else { return }
            guard let title = userInfo["title"] as? String else { return }
            let body = userInfo["body"] as? String ?? ""
            KuringLink.customNotificationPublisher.send((title, body))
        } else { return }
    }
    
    func isCustomNotification(_ userInfo: [String: Any]) -> Bool {
        guard let type = userInfo["type"] as? String else { return false }
        switch type {
        case "admin": return true
        default: return false
        }
    }
}
