//
//  RetryPolicy.swift
//
//
//  Created by Gustavo Halperin on 5/24/24.
//

import Foundation

fileprivate
let logger = Logging.category(.request)

extension URLRequest {
    public
    struct RetryPolicy {
        let maxRetries: Int
        let retryDelay: TimeInterval
        let stopOnCodes: Set<Int>
        public
        init(maxRetries: Int = 0,
             retryDelay: TimeInterval = 0.5,
             stopOnCodes: Set<Int> = .init() ) {
            self.maxRetries = maxRetries
            self.retryDelay = retryDelay
            self.stopOnCodes = stopOnCodes
        }
    }
}

public
typealias fetchDataAction = () async throws -> (data:Data, response:URLResponse)

public
extension URLRequest.RetryPolicy {
    func fetchData(with action: @escaping fetchDataAction) async throws -> (data:Data,
                                                                            response:URLResponse) {
        var data: Data
        var response: URLResponse
        var tries = 0
        while true {
            (data, response) = try await action()
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseError(data: data, response: response)
            }
            if httpResponse.status == .Complete {
                return (data, response)
            }
            if stopOnCodes.contains(httpResponse.statusCode) {
                throw NetworkError.statusError(data: data, httpResponse: httpResponse)
            }
            tries += 1
            guard tries <= maxRetries else {
                return (data, response)
            }
            logger.debug("New try number \(tries)")
        }
    }
}
