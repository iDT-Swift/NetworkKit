//
//  URLRequest+Body.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation


public
extension URLRequest.Request {
    struct Body: RequestBody { 
        public init() {}
    }
}

public
extension URLRequest.MultipartFormData {
    struct Body: RequestBody {
        public let boundary: String
        public let keyValues: [String:String]
        public let dataFileKey: String
        public let dataFilePath: String
        public init(boundary: String,
                    keyValues: [String : String],
                    dataFileKey: String,
                    dataFilePath: String) {
            self.boundary = boundary
            self.keyValues = keyValues
            self.dataFileKey = dataFileKey
            self.dataFilePath = dataFilePath
        }
    }
}

public
extension URLRequest.MultipartFormData.Body {
    func modifierBody(_ request: URLRequest) throws -> URLRequest {
        var request = request
        var body = Data()
        let keyValueList = try keyValues.keyValues
        for (key,value) in keyValueList {
            try body.appendBoundaryForm(.add(boundary: boundary))
            try body.appendForm(key, value: value)
        }
        try body.appendBoundaryForm(.add(boundary: boundary))
        try body.appendForm(dataFileKey, dataFilePath: dataFilePath)
        try body.appendBoundaryForm(.end(boundary: boundary))
        request.httpBody = body
        return request
    }
}
