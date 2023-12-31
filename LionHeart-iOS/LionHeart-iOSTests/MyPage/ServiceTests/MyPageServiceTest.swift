//
//  MyPageServiceTest.swift
//  LionHeart-iOSTests
//
//  Created by 황찬미 on 2023/11/30.
//

import XCTest

@testable import LionHeart_iOS

final class MyPageServiceTest: XCTestCase {
    
    var jsonLoader: JSONLoader!
    var urlSession: URLSessionStub!
    var apiService: APIService!

    override func setUp() {
        jsonLoader = JSONLoader()
    }

    override func tearDown() {
        jsonLoader = nil
        urlSession = nil
        apiService = nil
    }
    func test_마이페이지API_성공_데이터가_있을때() async throws {
        // given
        let urlRequest = try makeURLRequest(fileName: "SuccessResponse")
        
        // when
        let returnData: MyPageResponse? = try await apiService.request(urlRequest)
        let result = try XCTUnwrap(returnData, "언래핑 실패")
        
        let expectation = MyPageResponse(babyNickname: "짠미", level: "LEVEL_ONE", notificationStatus: "ON")
        
        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_마이페이지API_서버에러일때() async throws {
        // given
        let urlRequest = try makeURLRequest(fileName: "ServerFailureResponse")
        
        // when
        var resultError: NetworkError?
        
        do {
            let _: MyPageResponse? = try await apiService.request(urlRequest)
            XCTFail("발생할 수 없는 결과")
        } catch {
            let error = error as! NetworkError
            resultError = error
        }
        
        let expectation = NetworkError.serverError
        
        // then
        XCTAssertEqual(resultError, expectation)
    }
    
    func test_마이페이지API_클라에러일때() async throws {
        // given
        let urlRequest = try makeURLRequest(fileName: "ClientFailureResponse")
        
        // when
        var resultError: NetworkError?
        
        do {
            let _: MyPageResponse? = try await apiService.request(urlRequest)
            XCTFail("발생할 수 없는 결과")
        } catch {
            let error = error as! NetworkError
            resultError = error
        }
        
        let expectation = NetworkError.clientError(code: "V001", message: "실패")
        
        // then
        XCTAssertEqual(resultError, expectation)

    }
}

extension MyPageServiceTest {
    func makeURLRequest(fileName: String) throws -> URLRequest {
        let fileURL = jsonLoader.load(fileName: fileName)
        let data = try Data(contentsOf: fileURL)
        
        urlSession = URLSessionStub(data: data)
        apiService = APIService(session: urlSession)
        
        return URLRequest(url: fileURL)
    }
}
