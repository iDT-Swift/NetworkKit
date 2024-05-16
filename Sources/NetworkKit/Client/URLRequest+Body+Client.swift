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

extension URLRequest.Request.Body {
    func modifierBody(_ request: URLRequest) throws -> URLRequest {
        return try Self.modifierBody(self,  request: request)
    }
}

extension URLRequest.MultipartFormData {
    struct Body: RequestBody {
        let boundary: String
        let urlPath: String
    }
}

extension URLRequest.MultipartFormData.Body {
    func modifierBody(_ request: URLRequest) throws -> URLRequest {
        var request = request
        var body = Data()
        try body.appendBoundaryForm(.add(boundary: boundary))
        try body.appendForm("data", imageFilePath: urlPath)
        try body.appendBoundaryForm(.end(boundary: boundary))
        request.httpBody = body
        return request
    }
}
