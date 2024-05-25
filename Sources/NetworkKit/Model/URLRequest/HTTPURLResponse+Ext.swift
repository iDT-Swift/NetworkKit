//
//  HTTPURLResponse+Ext.swift
//
//
//  Created by Gustavo Halperin on 5/24/24.
//

import Foundation

extension HTTPURLResponse {
    enum Status {
        case Complete
        case Error
    }
    var status: Status {
        (200..<300).contains(self.statusCode) ? .Complete : .Error
    }
}
