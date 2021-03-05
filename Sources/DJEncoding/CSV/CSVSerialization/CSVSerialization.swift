import Foundation

public class CSVSerialization {
    
    // MARK: - API
    
    public init(options: CSVSerialization.Configuration.Options? = nil) {
        configuration.options = options ?? CSVSerialization.Configuration.Options()
    }
    
    public func deserialize(fileURL: URL) throws -> CSVData {
        let lineDelimiter = try ensureLineDelimiter()
        let lineReader = try prepareLineReaderForFileAt(fileURL, lineDelimiter: lineDelimiter)
        let header = try getHeaderByReadingNextLine(lineReader)
        
        let csvData = CSVData()
        while let lineData = lineReader.readNextLine() {
            try deserializeLine(lineData, usingHeader: header, into: csvData)
            csvData.moveToNextRow()
        }
        csvData.moveToFirstRow()
        return csvData
    }
    
    public enum Error: Swift.Error {
        case failedToOpenFile(url: URL, underlyingError: Swift.Error)
        case failedToReadHeader
        case failedToReadLine
        case numberOfColumnsDontMatchHeader(expected: Int, actual: Int, row: Int)
        case internalError(hint: String)
    }
    
    
    
    
    
    // MARK: - Configuring Options
    
    public class Configuration {
        
        public struct Options {
            var encoding: String.Encoding = .utf8
        }
        
        public fileprivate(set) var options: Options = .init()
        
        @discardableResult
        public func encoding(_ encoding: String.Encoding) -> CSVSerialization.Configuration {
            options.encoding = encoding
            return self
        }
        
    }
    
    public private(set) var configuration: CSVSerialization.Configuration = .init()
    
    
    
    
    
    
    
    
    
    
    // MARK: - Private
    
    private let csvRegex: NSRegularExpression = try! .init(pattern: #""(.*?)"(,|\n|$)"#, options: [])
    
    private var options: CSVSerialization.Configuration.Options { configuration.options }
    
    private func ensureLineDelimiter() throws -> Data {
        guard let lineDelimiter = "\n".data(using: options.encoding) else {
            throw Error.internalError(hint: "Failed to encode line-delimiter using encoding '\(options.encoding)'")
        }
        return lineDelimiter
    }
    
    private func prepareLineReaderForFileAt(_ fileURL: URL, lineDelimiter: Data) throws -> LineReader {
        do {
            let lineReader = LineReader(fileUrl: fileURL, lineDelimiter: lineDelimiter)
            try lineReader.openFile()
            return lineReader
        } catch let error {
            throw Error.failedToOpenFile(url: fileURL, underlyingError: error)
        }
    }
    
    private func getHeaderByReadingNextLine(_ lineReader: LineReader) throws -> [String] {
        guard let headersData = lineReader.readNextLine() else {
            throw Error.failedToReadHeader
        }
        return try getValuesFromLine(headersData)
    }
    
    private func deserializeLine(_ lineData: Data, usingHeader header: [String], into csvData: CSVData) throws {
        let values = try getValuesFromLine(lineData)
        guard values.count == header.count else {
            throw Error.numberOfColumnsDontMatchHeader(expected: header.count, actual: values.count, row: csvData.currentRow)
        }
        for index in 0..<values.count {
            csvData.setValue(values[index], forColumn: header[index])
        }
    }
    
    private func getValuesFromLine(_ data: Data) throws -> [String] {
        guard let line = String(data: data, encoding: options.encoding) else {
            throw Error.failedToReadLine
        }
        let matches = csvRegex.matches(in: line, options: [], range: NSRange.init(line.startIndex..<line.endIndex, in: line))
        return try matches.map {
            guard $0.numberOfRanges == 3 else {
                throw Error.internalError(hint: "RegEx did not yield expected number of ranges")
            }
            guard let rangeOfMatch = Range($0.range(at: 1), in: line) else {
                throw Error.internalError(hint: "Range of RegEx-match could not be converted to Range for String")
            }
            return String(line[rangeOfMatch])
        }
    }
    
}
