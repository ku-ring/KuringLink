import UIKit
import UserNotifications

/// ```swift
/// import Enigma
/// import KuringLink
///
/// let host = Enigma.kuring.decode(key: "{KEY.FOR.HOST}")
/// KuringLink.setup(host: host)
/// ```
///
/// To get start `KuringLink`, you have to set up `host` and `scheme` to use `Satellite` instance.
/// - IMPORTANT: To set up `host`, you need `Enigma`, the private Swift package that `ku-ring` members can acess only.
public class KuringLink {
    private static var antenna = Antenna(host: "")
    
    /// To get start `KuringLink`, you have to set up `host` and `scheme` to use `Satellite` instance.
    ///
    /// - IMPORTANT: To set up `host`, you need `Enigma`, the private Swift package that `ku-ring` members can acess only.
    ///
    /// ```swift
    /// import Enigma
    /// import KuringLink
    ///
    /// let host = Enigma.kuring.decode(key: "{KEY.FOR.HOST}")
    /// KuringLink.setup(host: host)
    /// ```
    public static func setup(host: String, scheme: Satellite.Scheme = .https) {
        antenna = Antenna(host: host, scheme: scheme)
    }
    
    public static var fcmToken: String? {
        get { antenna.fcmToken }
        set { antenna.fcmToken = newValue }
    }
    
    // MARK: - Notice
    
    public static func notices(
        count: Int,
        typeOf type: String,
        department: String? = nil,
        forPageAt page: Int
    ) async throws -> [Notice] {
        try await antenna.notices(
            count: count,
            typeOf: type,
            department: department,
            forPageAt: page
        )
    }
    
    // MARK: - Remote Notifications
    
    public static var isCustomNotificationEnabled: Bool {
        antenna.isCustomNotificationEnabled
    }
    
    public static func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) {
        antenna.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    /// 포어그라운드에서 푸시 알림을 처리합니다.
    public static func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        antenna.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
    }
    
    public static func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) {
        antenna.userNotificationCenter(center, didReceive: response)
    }
    
    // MARK: - Search
    
    
    public static func notices(startsWith keyword: String) async throws -> [Notice] {
        try await antenna.notices(startsWith: keyword)
    }
    
    public static func staffs(startsWith keyword: String) async throws -> [Staff] {
        try await antenna.staffs(startsWith: keyword)
    }
    
    
    // MARK: - Subscriptions
    
    // MARK: - Univ
    
    /// GET
    public static var allUnivNoticeTypes: [NoticeProvider] {
        get async throws {
            try await antenna.allUnivNoticeTypes
        }
    }
    
    /// GET
    public static func univNoticeTypes(subscribedBy fcmToken: String) async throws -> [NoticeProvider] {
        try await antenna.univNoticeTypes(subscribedBy: fcmToken)
    }
    
    /// POST
    public static func subscribeUnivNoticeTypes(_ names: [String], fcmToken: String) async throws -> Bool {
        try await antenna.subscribeUnivNoticeTypes(names, fcmToken: fcmToken)
    }
    
    
    
    // MARK: - Department
    
    /// GET
    public static var allDepartments: [NoticeProvider] {
        get async throws {
            try await antenna.allDepartments
        }
    }
    
    /// GET
    public static func departments(subscribedBy fcmToken: String) async throws -> [NoticeProvider] {
        try await antenna.departments(subscribedBy: fcmToken)
    }
    
    /// POST
    public static func subscribeDepartments(_ hostPrefixes: [String], fcmToken: String) async throws -> Bool {
        try await  antenna.subscribeDepartments(hostPrefixes, fcmToken: fcmToken)
    }
    
    // MARK: - Feedback
    
    /// `"User-Agent": "Kuring/1.2.0 iOS/14.1"`
    public static func sendFeedback(
        _ text: String,
        fcmToken: String,
        appVersion: String,
        osVersion: String
    ) async throws -> Bool {
        try await antenna.sendFeedback(
            text,
            fcmToken: fcmToken,
            appVersion: appVersion,
            osVersion: osVersion
        )
    }
}

import Satellite

extension KuringLink {
    public static func console(error: Swift.Error) {
        if let satelliteError = error as? Satellite.Error {
            print(satelliteError.description)
        } else {
            print(error.localizedDescription)
        }
        
    }
}

extension KuringLink {
    public enum Error: Swift.Error, CustomStringConvertible {
        case fcmTokenIsNil
        
        public var description: String {
            switch self {
            case .fcmTokenIsNil:
                return "FCM token is nil"
            }
        }
    }
}
