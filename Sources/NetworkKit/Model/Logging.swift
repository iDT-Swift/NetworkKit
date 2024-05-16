//
//  Logging.swift
//  Aqualung3D
//
//  Created by Gustavo Halperin
//

import OSLog

enum Logging: String {
    case request = "Request"
    case response = "Response"
    case decoding = "Decoding"
    
    static let subsystem = "com.ideastouch.networkkit"
    static let shared: Logger = {
        Logger(subsystem: subsystem,
               category: "NetworkKit")
    }()
    static func category(_ category: Logging) -> Logger {
        Logger(subsystem: subsystem,
               category: category.rawValue)
    }
}
