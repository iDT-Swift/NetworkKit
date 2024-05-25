//
//  Service.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation

fileprivate
let logger = Logging.category(.request)

public
protocol ErrorProcessor {
    static var checkStatus: Bool { get }
}

///
/// This actor serves as the package interface.
///
/// Multiple instances may be created without affecting performance.
///
/// The actor design pattern is employed not for performance reasons, but as a convenient means to ensure that
/// its asynchronous functions execute in the background.
///
/// Networking requests to the server are performed via either a shared URLSession without cache policy or
/// a shared URLSession that includes a caching policy, which could be used for example in case of media downloads.
///
public
actor Service {
    /// Create a URLSessionManager with or without cache startegy, return the data and the response
    /// if the response has status code `200..<300>` otherwise throws a `NetworkError`unless
    ///  There RetryPolicy says otherway

    let retryPolicy: URLRequest.RetryPolicy
    public init() {
        self.init(retryPolicy: .init())
    }
    public init(retryPolicy: URLRequest.RetryPolicy) {
        self.retryPolicy = retryPolicy
    }
    
    public func callService(_ request:URLRequest,
                        withCache: Bool,
                        delegate: (any URLSessionTaskDelegate)? = nil)
    async throws -> (data:Data, response:URLResponse)
    {
        let (data, response) = try await retryPolicy
            .fetchData() {
                try await URLSessionManager
                    .shared(withCache: withCache)
                    .resume(from: request, delegate: delegate)
            }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.responseError(data: data, response: response)
        }
        guard httpResponse.status == .Complete else {
            throw NetworkError.statusError(data: data, httpResponse: httpResponse)
        }
        return (data, response)
    }
    
    /// Call to callService(_:withCache:delegate) and before pass over the data and response checks
    /// if the data is decodable using the `errorProcessorType` and if it's decodable by it throws a
    /// `NetworkError.customError(data:)`
    public func callService<T>(_ request:URLRequest,
                               withCache: Bool,
                               errorProcessorType: T.Type,
                               delegate: (any URLSessionTaskDelegate)? = nil
    )
    async throws -> (Data, URLResponse)
    where T: (Decodable & Error & ErrorProcessor)
    {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await self
                .callService(request, withCache: withCache, delegate: delegate)
        } catch NetworkError.statusError(let data, let urlResponse) {
            let body = try JSONDecoder().decode(T.self, from: data)
            throw CustomNetworkError.statusError(body: body, urlResponse: urlResponse)
        } catch {
            throw error
        }
        
        if T.checkStatus == false {
            let body = try JSONDecoder().decode(T.self, from: data)
            throw CustomNetworkError.responseError(body: body, response: response)
        }
        
        return (data, response)
    }
}
