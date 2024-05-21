//
//  URLRequest+Body.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation


extension URLRequest.Request {
    struct Body: RequestBody { }
}

extension URLRequest.MultipartFormData {
    struct Body: RequestBody {
        let boundary: String
        let keyValues: [String:String]
        let dataFileKey: String
        let dataFilePath: String
    }
}

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
