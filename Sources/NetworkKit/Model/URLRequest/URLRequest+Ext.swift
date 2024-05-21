//
//  APICodables.swift
//  MyDubble
//
//  Created by Gustavo Halperin
//

import SwiftUI

public
extension URLRequest {
    func modifier( header: RequestHeader) throws -> URLRequest {
        try header.modifierHeader(self)
    }
    func modifier( httpMethod: HTTPMethod) -> URLRequest {
        httpMethod.modifierHTTPMethod(self)
    }
    func modifier( requestBody: RequestBody) throws -> URLRequest {
        try requestBody.modifierBody(self)
    }
}

public
typealias URLRequestService = RequestURL & RequestHeader & HTTPMethod


public
extension URLRequest {
    /// Init a URLRequestService with an empty body.
    init<T>(_ requestService:T) throws
    where T: URLRequestService
    {
        self = try requestService.makeOne()
            .modifier(header: requestService)
            .modifier(httpMethod: requestService)
    }
    
    /// Init a URLRequestService with body.
    init<T, B>(_ requestService:T, bodyValue:B) throws
    where T: URLRequestService, B: RequestBody
    {
        self = try URLRequest(requestService)
            .modifier(requestBody: bodyValue)
    }
}
