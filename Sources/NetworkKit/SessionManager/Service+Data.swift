//
//  Service+Data.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation

extension Service {
    public func data(url: String,
                     withCache: Bool = false,
                     delegate: (any URLSessionTaskDelegate)? = nil)
    async throws -> (Data, URLResponse) {
        let requestService = URLRequest.Request(httpMethod: .get,
                                                url: url,
                                                headerFieldValue: .init())
        let request = try URLRequest(requestService)
        
        return try await self
            .callService(request,
                         withCache: withCache,
                         delegate: delegate)
    }
}
