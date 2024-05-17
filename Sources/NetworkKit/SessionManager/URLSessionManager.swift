//
//  URLSessionManager.swift
//
//
//  Created by Gustavo Halperin
//
import Foundation

fileprivate
let logger = Logging.category(.setup)

/// Currently we support two configurations, with or without memory cache.
/// The second configuration relaies on existing App Cache configuration.
/// If the cache memory was set, it will be used, otherwise it will silenty not be
/// relevant during the HTTP calls.
//
/// This kit provides with the actor `URLSessionManager` that contains a `URLSession`.
/// At this point there is no direct control over the `URLSession` rather than request
/// its init with or without suppor for URLCache.
/// And if this feature is requested, it will be implemented through the `URLCache.shared`
/// object, and this is way in order to this cache memory been used is required that before
/// the creation of a `URLSessionManager`, that `shared` proerty be initiated already.
//
/// There is a `URLSessionManager.init(withCache)` funnction which is public, if this function
/// is used,a new `URLSession` will be create with each call to this function.
/// Another option is to use tha shared objects `sharedWithCache` and `sharedWithoutCache`, which
/// as their name shows, they where created with and without support for cache mamory.

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
            logger.critical("\(message)")
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


