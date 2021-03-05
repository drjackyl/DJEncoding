/*
 [GitHub: __JSONDecoder](https://github.com/apple/swift/blob/main/stdlib/public/Darwin/Foundation/JSONEncoder.swift#L1222)
 */

import Foundation

class LogDecoder {
    
    // MARK: - API
    
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let logDecoder = _LogDecoder()
        return try T(from: logDecoder)
    }
    
}
