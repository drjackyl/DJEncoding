import Foundation

/**
 Reads lines of data form given data
 */
class DataLineReader: LineReader {
    
    // MARK: - API
    
    /**
     - parameter data: The URL to the file to read from.
     - parameter lineDelimiter: The delimiter to use for detecting the end of a line.
     */
    init(data: Data, lineDelimiter: Data) {
        self.data = data
        self.lineDelimiter = lineDelimiter
    }
    
    
    
    
    
    // MARK: - LineReader
    
    /**
     Reads a line
     
     - Returns: The contens of the line or `nil` if no lines are left to read.
     */
    func readNextLine() -> Data? {
        if let delimiterRange = getRangeOfLineDelimiter(startIndex: lastIndex) {
            let startIndex = lastIndex
            lastIndex = delimiterRange.upperBound
            return data[startIndex..<delimiterRange.lowerBound]
        } else if lastIndex < data.endIndex {
            let startIndex = lastIndex
            lastIndex = data.endIndex
            return data[startIndex..<data.endIndex]
        } else {
            return nil
        }
    }
    
    
    
    
    
    // MARK: - Private
    
    private let data: Data
    private let lineDelimiter: Data
    private var lastIndex: Data.Index = 0
    
    private func getRangeOfLineDelimiter(startIndex: Data.Index) -> Range<Data.Index>? {
        data.range(of: lineDelimiter, options: [], in: startIndex..<data.endIndex)
    }
    
}
