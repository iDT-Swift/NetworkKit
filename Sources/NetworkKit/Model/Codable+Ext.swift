//
//  File.swift
//  
//
//  Created by Gustavo Halperin
//
import Foundation
import CryptoKit

enum CodableError: Error {
    case StringInitializer(encoding: String.Encoding)
}

public
extension Encodable {
    var dictionary: Any {
        get throws {
            let jsonData = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            
        }
    }
    var hashValue: Int {
        get throws {
            let encoder = JSONEncoder()
            // In order to ensure encoding consistency we set sorted keys formatting.
            encoder.outputFormatting = .sortedKeys
            let data = try encoder.encode(self)
            let encoding:String.Encoding = .utf8
            guard let jsonString = String(data: data, encoding: encoding) else {
                throw CodableError.StringInitializer(encoding: encoding)
            }
            let hash = SHA256.hash(data: Data(jsonString.utf8))
            return hash.compactMap { String(format: "%02x", $0) }.joined().hashValue
        }
    }
    func compareTo(_ right: Encodable) throws -> Bool {
        let leftHashValue = try self.hashValue
        let rightHashValue = try right.hashValue
        return leftHashValue == rightHashValue
    }
}

