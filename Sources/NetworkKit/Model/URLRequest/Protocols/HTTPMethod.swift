//
//  HTTPMethod.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation

enum HTTMethodValue: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case deltete = "DELETE"
    case patch = "PATCH"
}

protocol HTTPMethod {
    var httpMethod: HTTMethodValue { get }
    func modifierHTTPMethod(_ request: URLRequest) -> URLRequest
}
extension HTTPMethod {
    func modifierHTTPMethod(_ request: URLRequest) -> URLRequest {
        var request = request
        request.httpMethod = httpMethod.rawValue
        return request
    }
}
