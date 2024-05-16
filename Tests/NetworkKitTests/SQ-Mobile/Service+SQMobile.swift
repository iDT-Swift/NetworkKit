//
//  Service+API.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation
@testable import NetworkKit

extension Service {
    /// Requests the full collection represented by a `URLRequest.Response.Collection`.
    ///
    /// - Parameters:
    ///   - url: URL of the JSON file
    /// - Returns: A list of URLRequest.Response.Employee
    /// - Throws: `NetworkError` if an error occurs.
    
    public func employees(url: String)
    async throws -> [URLRequest.Response.Employee] {
        let data = try await self.data(url: url, withCache: false)
        var employees = try JSONDecoder()
            .decode(URLRequest.Response.Employees.self, from: data)
            .employees
        var uuidSet = Set<String>()
        employees = employees.filter {
            if uuidSet.contains($0.uuid) { return false }
            uuidSet.insert($0.uuid)
            return true
        }
        return employees
    }
}

