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
    let retryPolicy: URLRequest.RetryPolicy
    public init() {
        self.init(retryPolicy: .init())
    }
    public init(retryPolicy: URLRequest.RetryPolicy) {
        self.retryPolicy = retryPolicy
    }
    
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
                    guard let data = data, let response = response,
                          let httpResponse = response as? HTTPURLResponse else {
                        let error = NetworkError.responseError(data: data, response: response)
                        continuation.resume(throwing: error)
                        return
                    }
                    guard httpResponse.status == .Complete else {
                        let error = NetworkError.statusError(data: data, httpResponse: httpResponse)
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume(returning: (data:data,httpResponse) )
            })
            sessionTask?.delegate = delegate
            sessionTask?.resume()
        }
    }
}
