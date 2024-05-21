//
//  RequestURL.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation

public
protocol RequestURL {
    var url:String { get }
    func makeOne() throws -> URLRequest
}


public
extension RequestURL {
    func makeOne()
    throws -> URLRequest {
        let url = try URL(url)
        return URLRequest(url: url)
    }
}
