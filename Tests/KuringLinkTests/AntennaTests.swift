//
//  AntennaTests.swift
//  
//
//  Created by Jaesung Lee on 2023/05/01.
//

import XCTest
@testable import KuringLink

final class AntennaTests: XCTestCase {
    let host = "{ENIGMA.HOST}"
    let fcmToken = "cZSHjO4_bUjirvsrxWzig5:APA91bHPojABL5oEXi5AcjJ8v4Vcp3KpJfFUD_3b-HhfV8m23_R6czJa3PwqcVqBZSHBb2t7Z3odUeD0cFKaMSkMmrGxTqyjJPfEZVfTPvmewV-xiMTWbrk-QKuc4Nrxd_BhEArO7Svo"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Univ notice types
    func test_allUnivNoticeTypes() async throws {
        let antenna = Antenna(host: host)
        let allUnivNoticeTypes = try await antenna.allUnivNoticeTypes
        print(allUnivNoticeTypes)
        XCTAssertFalse(allUnivNoticeTypes.isEmpty)
        XCTAssertTrue(allUnivNoticeTypes.count > 5)
    }
    
    func test_univNoticeTypesSubscribedByFcmToken() async throws {
        let antenna = Antenna(host: host)
        let subscriptions = try await antenna
            .univNoticeTypes(subscribedBy: fcmToken)
        print(subscriptions)
        XCTAssertFalse(subscriptions.isEmpty)
        XCTAssertEqual(
            Set(subscriptions.compactMap({ $0.name})),
            Set(["normal", "library", "bachelor"])
        )
    }
    
    func test_subscribeUnivNoticeTypesWithNamesAndFcmToken() async throws {
        let antenna = Antenna(host: host)
        let categories = ["normal", "library", "bachelor"]
        let isUpdated = try await antenna.subscribeUnivNoticeTypes(categories, fcmToken: fcmToken)
        XCTAssertTrue(isUpdated)
    }
    
    // MARK: - Department
    func test_allDepartments() async throws {
        let antenna = Antenna(host: host)
        let allDepartments = try await antenna.allDepartments
        #if DEBUG
        print(allDepartments)
        #endif
        XCTAssertFalse(allDepartments.isEmpty)
        XCTAssertTrue(allDepartments.count > 50)
    }
    
    func test_departmentsSubscribedByFcmToken() async throws {
        let antenna = Antenna(host: host)
        let subscriptions = try await antenna
            .departments(subscribedBy: fcmToken)
        print(subscriptions)
        XCTAssertFalse(subscriptions.isEmpty)
        XCTAssertEqual(
            Set(subscriptions.compactMap({ $0.hostPrefix})),
            Set(["cse", "korea"])
        )
    }
    
    func test_subscribeDepartmentsWithHostPrefixesAndFcmToken() async throws {
        let antenna = Antenna(host: host)
        let hostPrefixes = ["cse", "korea"]
        let isUpdated = try await antenna
            .subscribeDepartments(hostPrefixes, fcmToken: fcmToken)
        XCTAssertTrue(isUpdated)
    }
    
    // MARK: Search
    func test_noticesStartsWithKeyword() async throws {
        /// **ISSUE**: `url` 이 아닌 `baseUrl`로 내려옴
//        let antenna = Antenna(host: host)
//        let keyword = "2023"
//        let notices = try await antenna
//            .notices(startsWith: keyword)
//        XCTAssertFalse(notices.isEmpty)
//        XCTAssertTrue(notices[0].subject.contains(keyword))
    }
    
    func test_staffsStartsWithKeyword() async throws {
        let antenna = Antenna(host: host)
        let keyword = "김"
        let staffs = try await antenna
            .staffs(startsWith: keyword)
        XCTAssertFalse(staffs.isEmpty)
        XCTAssertTrue(staffs[0].name.contains(keyword))
    }
    
    // MARK: - Feedback
    func test_sendFeedback() async throws {
        let antenna = Antenna(host: host)
        let text = "iOS 쿠링링크 테스트메세지입니다. 테스트서버가 https 로 호스팅이 안되어서 프로덕션에 테스트합니다 - 재성"
        let osVersion = await UIDevice.current.systemVersion
        let isSucceed = try await antenna
            .sendFeedback(
                text,
                fcmToken: fcmToken,
                appVersion: "2.0.0",
                osVersion: osVersion
            )
        XCTAssertTrue(isSucceed)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
