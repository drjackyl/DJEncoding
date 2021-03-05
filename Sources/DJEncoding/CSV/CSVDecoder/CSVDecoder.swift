import Foundation

public class CSVDecoder {
    
    // MARK: - API
    
    public init(options: CSVDecoder.Configuration.Options? = nil) {
        self.configuration.options = options ?? CSVDecoder.Configuration.Options()
    }
    
    //----->
    // Add feature to decode from data
    //
//    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
//        // TODO: Deserialization
//        let csvData = CSVData()
//        return try decode(type, from: csvData)
//    }
    //<-----
    
    public func decode<T: Decodable>(_ type: T.Type, fromFile fileURL: URL) throws -> T {
        let csvData = try deserializeFileAtURL(fileURL)
        return try decode(type, from: csvData)
    }
    
    public enum Error: Swift.Error {
        case deserializingFileFailed(underlyingError: Swift.Error, fileURL: URL)
        case invalidValueForType(type: Any.Type, actual: String, expected: String)
        case noValueForColumnInRow(column: String, row: Int)
        case columnDoesNotExist(column: String)
        case notSupported(hint: String)
        case notImplemented(hint: String)
        case internalError(hint: String)
    }
    
    
    
    
    
    // MARK: - Confugring Options
    
    public class Configuration {
        
        public struct Options {
            var stringEncoding: String.Encoding = .utf8
            var booleanTrueValue: String = "\(true)"
            var booleanFalseValue: String = "\(false)"
            var customDecoders: [String:((String) -> Any)] = .init()
        }
        
        public fileprivate(set) var options: Options = .init()
        
        @discardableResult
        public func stringEncoding(_ encoding: String.Encoding) -> Configuration {
            options.stringEncoding = encoding
            return self
        }
        
        @discardableResult
        public func decodeBoolean(trueValue: String? = nil, falseValue: String? = nil) -> Configuration {
            if let trueValue = trueValue {
                options.booleanTrueValue = trueValue
            }
            if let falseValue = falseValue {
                options.booleanFalseValue = falseValue
            }
            return self
        }
        
        @discardableResult
        public func addCustomDecoder<T>(_ decode: @escaping (String) -> T) -> Configuration {
            options.customDecoders["\(T.self)"] = decode
            return self
        }
        
    }
    
    public private(set) var configuration: CSVDecoder.Configuration = .init()
    
    
    
    
    
    // MARK: - Internal
    
    func decode<T: Decodable>(_ type: T.Type, from csvData: CSVData) throws -> T {
        let csvDecoder = _CSVDecoder(csvData: csvData, options: configuration.options)
        return try T(from: csvDecoder)
    }
    
    
    
    
    
    // MARK: - Private
    
    private func deserializeFileAtURL(_ fileURL: URL) throws -> CSVData {
        let csvSerialization = CSVSerialization()
        csvSerialization.configuration
            .encoding(configuration.options.stringEncoding)
        
        do {
            return try csvSerialization.deserialize(fileURL: fileURL)
        } catch let error {
            throw Error.deserializingFileFailed(underlyingError: error, fileURL: fileURL)
        }
    }
    
}
