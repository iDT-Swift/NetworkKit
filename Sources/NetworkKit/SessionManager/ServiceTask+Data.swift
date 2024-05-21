//
//  ServiceTask+Data.swift
//
//
//  Created by Gustavo Halperin
//

import Foundation


extension ServiceTask {
    /// In case that we are not really interested in the response, just in download some data from
    /// and specific URL we can use this function.
    public func data(url: String,
                     withCache: Bool = false,
                     delegate: (any URLSessionTaskDelegate)? = nil)
    async throws -> Data {
        let requestService = URLRequest.Request(httpMethod: .get,
                                                url: url)
        let request = try URLRequest(requestService)
        
        return try await self
            .callService(request,
                         withCache: withCache,
                         delegate: delegate)
            .data
    }
}
