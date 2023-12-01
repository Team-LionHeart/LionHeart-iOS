//
//  ServiceTests.swift
//  LionHeart-iOSTests
//
//  Created by 김의성 on 12/01/23.
//

import XCTest
@testable import FirebaseMessaging
@testable import LionHeart_iOS

final class ServiceTests: XCTestCase {
    
    var apiService: Requestable!
    var urlSession: URLSessionStub!
    var jsonLoader: JSONLoader!
    var url: URL!

    override func setUpWithError() throws {
        self.jsonLoader = JSONLoader()
    }

    override func tearDownWithError() throws {
        self.jsonLoader = nil
        self.url = nil
    }

    func test_챌린지API_호출을_성공했을때() async throws {
        //given
        self.url = jsonLoader.load(fileName: "ChallengeSuccess")
        let data = try Data(contentsOf: self.url)
        let urlRequest = URLRequest(url: self.url)
        self.urlSession = URLSessionStub(data: data)
        self.apiService = APIService(session: urlSession)
        
        //when
        guard let result: ChallengeDataResponse = try await self.apiService.request(urlRequest) else {
            return XCTFail("옵셔널언래핑에 실패했습니다")
        }
        
        //then
        let expectation = ChallengeDataResponse(babyNickname: "Test닉네임", day: 10, level: "LEVEL_ONE", attendances: ["11/1","11/2","11/3"])
        XCTAssertEqual(result.babyNickname, expectation.babyNickname)
        XCTAssertEqual(result.day, expectation.day)
        XCTAssertEqual(result.attendances.count, expectation.attendances.count)
    }
    
    func test_챌린지API_호출했을때_서버에러가발생한경우() async throws {
        //given
        self.url = jsonLoader.load(fileName: "ChallengeFailure")
        let data = try Data(contentsOf: self.url)
        let urlRequest = URLRequest(url: self.url)
        self.urlSession = URLSessionStub(data: data)
        self.apiService = APIService(session: urlSession)

        //when
        var willOccureError: NetworkError?
        do {
            let _: ChallengeDataResponse? = try await self.apiService.request(urlRequest)
            XCTFail("성공할수없는 case입니다")
        } catch {
            let error = error as? NetworkError
            willOccureError = error
        }

        //then
        let expectation = NetworkError.serverError
        XCTAssertEqual(willOccureError, expectation)
    }
}
