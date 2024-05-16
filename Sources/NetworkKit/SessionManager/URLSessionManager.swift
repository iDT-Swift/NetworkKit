//
//  URLSessionManager.swift
//
//
//  Created by Gustavo Halperin
//
import Foundation

actor URLSessionManager {
    static func shared(withCache : Bool) -> URLSessionManager {
        withCache ? sharedWithCache : sharedWithoutCache
    }
    static let sharedWithoutCache = URLSessionManager(withCache: false)
    static let sharedWithCache = URLSessionManager(withCache: true)
    private let session: URLSession
    
    init(withCache:Bool = false) {
        var config: URLSessionConfiguration?
        if withCache {
            config = URLSessionConfiguration.default.copy() as? URLSessionConfiguration
            config?.requestCachePolicy = .returnCacheDataElseLoad // Use cached data if available, otherwise fetch from the server
            config?.urlCache = URLCache.shared // Use the shared URL cache, which is the built-in iOS cache system
        } else {
            config = URLSessionConfiguration.ephemeral.copy() as? URLSessionConfiguration
            config?.requestCachePolicy = .reloadIgnoringLocalCacheData
        }
        config?.timeoutIntervalForRequest = 30.0
        if let config = config {
            session = URLSession(configuration: config)
        } else {
            //TODO: Replace assertion by a log as soon as we have one log system implemented.
            var message = "Custon URLSessionConfiguration."
            message += withCache ? "default" : "ephemeral"
            message += ".copy() as? URLSessionConfiguration"
            assertionFailure(message)
            session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        }
    }
    
    func resume(from request: URLRequest,
                   delegate: (URLSessionTaskDelegate)? = nil
    ) async throws -> (Data, URLResponse) {
        return try await session.data(for:request, delegate:delegate)
    }
    
    nonisolated
    func dataTask(from request: URLRequest,
                  completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionTask {
        return  session.dataTask(with: request, completionHandler: completionHandler)
    }
}


