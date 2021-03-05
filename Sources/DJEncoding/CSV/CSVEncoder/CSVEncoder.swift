import Foundation

class CSVEncoder {
    
    // MARK: - API
    
    func encode<T: Encodable>(_ value: T) throws -> Data {
        let csvData = CSVData()
        let csvEncoder = _CSVEncoder(csvData: csvData)
        try value.encode(to: csvEncoder)
        return csvData.toData()
    }
    
    public enum Error: Swift.Error {
        case notSupported(hint: String)
        case notImplemented(hint: String)
    }
    
}










