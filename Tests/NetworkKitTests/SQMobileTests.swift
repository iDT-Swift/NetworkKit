import XCTest
@testable import NetworkKit

// XCTest Documentation
// https://developer.apple.com/documentation/xctest

// Defining Test Cases and Test Methods
// https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
final class SQMobileTests: XCTestCase {
    func testEmployeeList() async throws {
        let url = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
        
        let employeeList = try await Service().employees(url: url)
        
        XCTAssertEqual(employeeList.count > 0, true, "Expected a list of more than one employee.")
    }
    func testEmployeeEmptyList() async throws {
        let url = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"
        
        let employeeList = try await Service().employees(url: url)
        
        XCTAssertEqual(employeeList.count, 0, "Expected a list of more than one employee.")
    }
    func testEmployeeEmptyMalformedList() async throws {
        let url = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
        do {
            let _ = try await Service().employees(url: url)
            XCTFail("The call with the URL above should fail because of data malformed")
        } catch DecodingError.keyNotFound(_, let context) {
            let _ = try XCTUnwrap(context.debugDescription, "Debug description should not be nil")
        } catch {
            XCTFail("The error expected must be of type `DecodingError`, case `.dataCorrupted(_:)`")
        }
    }
    func testDataNotFound() async throws {
        let url = "https://example.com/noimage.jpg"
        do {
            let _ = try await ServiceTask().data(url: url)
            XCTFail("The call with the URL above should fail because there is not data at this URL")
        } catch NetworkError.statusError( _, let urlResponse) {
            XCTAssertEqual(urlResponse.statusCode, 404, "The status code is \(urlResponse.statusCode) instead of 404")
        } catch {
            XCTFail("The error expected must be `NetworkError.error` with status code 404")
        }
    }
}
