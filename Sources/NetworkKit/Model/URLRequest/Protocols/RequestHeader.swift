//
//  RequestHeader.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation

protocol RequestHeader {
    func modifierHeader(_ request: URLRequest) -> URLRequest
}

extension URLRequest.Request {
    func modifierHeader(_ request: URLRequest) -> URLRequest {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = token {
            request.setValue(token, forHTTPHeaderField: "X-Cognito-Auth")
        }
        return request
    }
}

extension URLRequest.MultipartFormData {
    func modifierHeader(_ request: URLRequest) -> URLRequest {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        if let token = token {
            request.setValue(token, forHTTPHeaderField: "X-Cognito-Auth")
        }
        return request
    }
}
