//
//  ServiceTask+Data.swift
//
//
//  Created by Gustavo Halperin
//

import Foundation


extension ServiceTask {
    public func data(url: String,
                     withCache: Bool = false,
                     delegate: (any URLSessionTaskDelegate)? = nil)
    async throws -> Data {
        let requestService = URLRequest.Request(httpMethod: .get,
                                                url: url,
                                                token: nil)
        let request = try URLRequest(requestService)
        
        return try await self
            .callService(request,
                         withCache: withCache,
                         delegate: delegate)
            .data
    }
}
