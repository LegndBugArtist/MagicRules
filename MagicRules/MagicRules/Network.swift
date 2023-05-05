//
//  NET.swift
//  MagicRules
//
//  Created by Liu Zhe on 2023-05-05.
//

import Foundation

struct Network {
    enum Error: Swift.Error {
        case invalidURL
        case unexpectedStatusCode(Int)
        case requestError(Swift.Error)
        case emptyData
    }
    
    static func fetchString(from dataUrl: URL?) async throws -> String {
        guard let url = dataUrl else {
            throw Error.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.requestError(NSError(domain: "Invalid response", code: 0, userInfo: nil))
        }
        
        guard httpResponse.statusCode == 200 else {
            throw Error.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        guard let stringData = String(data: data, encoding: .utf8) else {
            throw Error.emptyData
        }
        
        return stringData
    }
}
