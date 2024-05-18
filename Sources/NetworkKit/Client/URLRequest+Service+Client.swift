//
//  URLRequest+Service.swift
//
//
//  Created by Gustavo Halperin
//

import Foundation

/// List of structs respresents, each of them, a container of all the variables required
/// to build the URL, set the request method, and updated the HTTP heather value.
/// The structs below conform with URLRequestService because this conformance is
/// if the URLRequest will be created using the `NetworkingKit` `init` function
/// `URLRequest((_:bodyValue))`, 
public
extension URLRequest {
    struct Request: URLRequestService {
        public var httpMethod: HTTMethodValue
        public let url: String
        public let token: String?
    }
    
    struct MultipartFormData: URLRequestService {
        static var uniqueBoundaryIdentifier: String { "Boundary-\(UUID().uuidString)" }
        public var httpMethod: HTTMethodValue { .post }
        public let url: String
        public let boundary: String
        public let token: String?
    }
}
