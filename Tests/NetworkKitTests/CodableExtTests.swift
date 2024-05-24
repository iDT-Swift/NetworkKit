//
//  CodableExtTests.swift
//  
//
//  Created by Gustavo Halperin on 5/24/24.
//

import XCTest

final class CodableExtTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        struct MyStruc: Codable {
            let id: String
            let name: String
            let value: Int
        }
        let id = UUID().uuidString
        let name = UUID().uuidString
        let value =  Int.random(in: 1..<10_000)
        let myStruct = MyStruc(id: id, name: name, value: value)
        let prettyPrinted = try myStruct.prettyPrinted
        // The identation used by Foundation is two spaces
        let mock = """
        {
          "id" : "\(id)",
          "name" : "\(name)",
          "value" : \(value)
        }
        """
        XCTAssertEqual(prettyPrinted, mock, "prettyPrinted and mock must be equal")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
