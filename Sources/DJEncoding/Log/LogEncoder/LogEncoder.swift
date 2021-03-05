/*
 This playground of an encoder, which just logs it's function calls is the result of reading 2 sources:
 
 - [SO: Custom Swift Encoder/Decoder for the Strings Resource Format](https://stackoverflow.com/questions/45169254/custom-swift-encoder-decoder-for-the-strings-resource-format)
 - [Mike Ash: Friday Q&A 2017-07-28: A Binary Coder for Swift](https://www.mikeash.com/pyblog/friday-qa-2017-07-28-a-binary-coder-for-swift.html)
 - [GitHub: JSONEncoder](https://github.com/apple/swift/blob/main/stdlib/public/Darwin/Foundation/JSONEncoder.swift)
 */

class LogEncoder {
    
    // MARK: - API
    
    func encode<T: Encodable>(_ value: T) throws {
        let logEncoder = _LogEncoder()
        try value.encode(to: logEncoder)
    }
    
}
