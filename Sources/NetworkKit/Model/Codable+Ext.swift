//
//  File.swift
//  
//
//  Created by Gustavo Halperin
//
import Foundation

public
extension Encodable {
    var dictionary: Any {
        get throws {
            let jsonData = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            
        }
    }
}

