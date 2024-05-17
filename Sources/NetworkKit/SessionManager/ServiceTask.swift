//
//  ServiceTask.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation

fileprivate
let logger = Logging.category(.request)

public
actor ServiceTask {
    /// Create a URLSessionManager with or without cache startegy, return the data and the response
    /// if the response has status code `200` otherwise throws a `NetworkError`.
    public init() {}
    deinit {
        if sessionTask?.state == .running {
            logger.debug("sessionTask is about to be cancelled.")
        }
        sessionTask?.cancel()
    }
    private var sessionTask: URLSessionTask?
    
    public func cancelRequest() {
        sessionTask?.cancel()
    }
    public func callService(_ request:URLRequest,
                     withCache: Bool,
                     delegate: (any URLSessionTaskDelegate)? = nil)
    async throws -> (data:Data, response:URLResponse)
    {
        return try await withCheckedThrowingContinuation { continuation in
            let session = URLSessionManager
                .shared(withCache: withCache)
            sessionTask = session
                .dataTask(from: request,
                          completionHandler: { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let urlResponse = response as? HTTPURLResponse else {
                        let error = NetworkError.responseError(response: response)
                        continuation.resume(throwing: error)
                        return
                    }
                    guard urlResponse.statusCode == 200 else {
                        let error = NetworkError.error(urlResponse: urlResponse)
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let data = data else {
                        let error = NetworkError.emptyData
                        continuation.resume(throwing: error)
                        return
                        
                    }
                    continuation.resume(returning: (data:data,urlResponse) )
            })
            sessionTask?.delegate = delegate
            sessionTask?.resume()
        }
    }
}
