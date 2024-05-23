//
//  APIError.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation

public
enum NetworkError: Error {
    case urlNotFound
    case invalidFileFormat
    case stringToDataFailure
    case urlInitializer(string:String)
    case urlEmptyPath
    case urlWithoutFileExtension
    case responseError(data: Data?, response:URLResponse?)
    case statusError(data: Data, urlResponse:HTTPURLResponse)
    case anyToDictionary(bodyObject: Encodable & Sendable)
    case customError(data:Data)
}

extension URL {
    init(_ url: String) throws {
        guard let url = URL(string: url ) else {
            throw NetworkError.urlNotFound
        }
        self = url
    }
}
