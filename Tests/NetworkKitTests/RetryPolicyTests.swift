//
//  RetryPolicyTests.swift
//  
//
//  Created by Gustavo Halperin on 5/24/24.
//

import XCTest
@testable import NetworkKit

final class RetryPolicyTests: XCTestCase {
    func testRetryPolicy() async throws {
        let errorCode = 404
        do {
            _ = try await Service(retryPolicy: .init(maxRetries: 3, stopOnCodes: .init([errorCode])))
                .data(url: "https://example.com/noimage.jpg")
            XCTFail("Unexpectd query succed")
        } catch NetworkError.statusError(_, let httpResponse) {
            XCTAssertEqual(httpResponse.statusCode, errorCode, "Unxpected status code \(httpResponse.statusCode)")
        } catch {
            throw error
        }
    }
    
    func testRetryStopCodesPolicy() async throws {
        let errorCode = 404
        do {
            _ = try await Service(retryPolicy: .init(maxRetries: 3, stopOnCodes: .init()))
                .data(url: "https://example.com/noimage.jpg")
            XCTFail("Unexpectd query succed")
        } catch NetworkError.statusError(_, let httpResponse) {
            XCTAssertEqual(httpResponse.statusCode, errorCode, "Unxpected status code \(httpResponse.statusCode)")
        } catch {
            throw error
        }
    }

}
