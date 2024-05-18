//
//  RequestBody.swift
//  
//
//  Created by Gustavo Halperin
//

import Foundation

public
protocol RequestBody: Codable, Sendable {
    func modifierBody(_ request: URLRequest) throws -> URLRequest
}
extension RequestBody {
    func modifierBody(_ request: URLRequest) throws -> URLRequest {
        var request = request
        guard let body = try self.dictionary as? [String:Sendable] else {
            throw NetworkError.anyToDictionary(bodyObject: self)
        }
        request.httpBody = try JSONSerialization
            .data(withJSONObject: body,
                  options: [.sortedKeys, .withoutEscapingSlashes])
        return request
    }
}

enum FormData {
    case add(boundary:String)
    case end(boundary:String)
    func data() throws -> Data {
        switch self {
        case .add(let boundary):
            return try "--\(boundary)\r\n".tryData(using: .utf8)
        case .end(let boundary):
            return try "--\(boundary)--\r\n".tryData(using: .utf8)
        }
    }
}

enum StringError: Error {
    case conversionToDataFail(encoding: String.Encoding)
}

extension String {
    func tryData( using encoding: String.Encoding,
                  allowLossyConversion: Bool = false) throws -> Data {
        guard let data = self.data(using: encoding,
                                   allowLossyConversion: allowLossyConversion) else {
            throw StringError.conversionToDataFail(encoding: encoding)
        }
        return data
    }
}

extension Data {
    mutating
    func appendBoundaryForm(_ formData: FormData) throws {
        self.append(try formData.data())
    }
    mutating
    func appendForm(_ keyName: String, value:String) throws {
        self.append(try "Content-Disposition: form-data; name=\"".tryData(using: .utf8))
        self.append(try keyName.tryData(using: .utf8))
        self.append(try "\"".tryData(using: .utf8))
        self.append(try "\r\n\r\n".tryData(using: .utf8))
        self.append(try value.tryData(using: .utf8))
        self.append(try "\r\n".tryData(using: .utf8))
    }
    mutating
    func appendForm(_ keyName: String, imageFilePath: String) throws {
        let fileURL = URL(fileURLWithPath: imageFilePath)
        guard let fileName = fileURL.lastPathComponent as String? else {
            throw NetworkError.urlEmptyPath
        }
        guard let fileType = fileURL.pathExtension as String? else {
            throw NetworkError.urlWithoutFileExtension
        }
        let options: Data.ReadingOptions = [.alwaysMapped, .uncached]
        let imageData = try Data(contentsOf: fileURL, options: options)
        self.append(try "Content-Disposition: form-data; name=\"".tryData(using: .utf8))
        self.append(try keyName.tryData(using: .utf8))
        self.append(try "\"; filename=\"".tryData(using: .utf8))
        self.append(try fileName.tryData(using: .utf8))
        self.append(try "\"".tryData(using: .utf8))
        self.append(try "\r\n".tryData(using: .utf8))
        self.append(try "Content-Disposition: form-data; name=\"".tryData(using: .utf8))
        self.append(try fileType.tryData(using: .utf8))
        self.append(try "\r\n\r\n".tryData(using: .utf8))
        self.append(imageData)
        self.append(try "\r\n".tryData(using: .utf8))
    }
}
