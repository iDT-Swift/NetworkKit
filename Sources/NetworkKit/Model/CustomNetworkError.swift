//
//  CustomNetworkError.swift
//
//
//  Created by Gustavo Halperin on 5/22/24.
//

import Foundation

enum CustomNetworkError<T>: Error
where T: Decodable
{
    case responseError(body: T, response:URLResponse?)
    case statusError(body: T, urlResponse:HTTPURLResponse)
}
