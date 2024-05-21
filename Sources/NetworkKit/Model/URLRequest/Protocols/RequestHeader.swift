//
//  RequestHeader.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation

public
protocol RequestHeader {
    func modifierHeader(_ request: URLRequest) throws -> URLRequest
}

public
extension URLRequest.Request {
    func modifierHeader(_ request: URLRequest) throws -> URLRequest {
        var request = request
        let keyValueList = try headerFieldValue.keyValues
        for (field,value) in keyValueList {
            request.setValue(value, forHTTPHeaderField: field)
        }
        return request
    }
}

public
extension URLRequest.MultipartFormData {
    func modifierHeader(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        let keyValueList = try headerFieldValue.keyValues
        for (field,value) in keyValueList {
            request.setValue(value, forHTTPHeaderField: field)
        }
        // Standards field/values
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue(token, forHTTPHeaderField: "X-Cognito-Auth")
        return request
    }
}
