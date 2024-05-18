//
//  HTTPMethod.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation

public
enum HTTMethodValue: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case deltete = "DELETE"
    case patch = "PATCH"
}

public
protocol HTTPMethod {
    var httpMethod: HTTMethodValue { get }
    func modifierHTTPMethod(_ request: URLRequest) -> URLRequest
}
public
extension HTTPMethod {
    func modifierHTTPMethod(_ request: URLRequest) -> URLRequest {
        var request = request
        request.httpMethod = httpMethod.rawValue
        return request
    }
}
