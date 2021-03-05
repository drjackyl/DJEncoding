import Foundation

/**
 Reads lines of data form a given file using a given line-delimiter.
 
 ## Remarks
 
 - To not have a throwing initializer, the file has to be opened explicitly by calling `openFile()`.
 - Calling `closeFile()` is optional, as `LineReader`closes the file on deinit. But its recommended to make sure, that
   happens as early as possible.
 - If the line-delimiter is incorrect, the whole file is being read into memory and returned as a single line. There is
   no protection against invalid line-delimiters.
 */
class LineReader {
    
    // MARK: - API
    
    /**
     - parameter url: The URL to the file to read from.
     - parameter lineDelimiter: The delimiter to use for detecting the end of a line.
     - parameter blockSize: The number of bytes to read from  the file at once (default=1024).
     */
    init(fileUrl: URL, lineDelimiter: Data, blockSize: Int = 1024) {
        self.fileUrl = fileUrl
        self.lineDelimiter = lineDelimiter
        self.blockSize = blockSize
    }
    
    /**
     Tries to open the file by creating a FileHandle for reading.
     
     - Throws: A `LineReader.Error.failedToOpenFile`, which provides an underlying error.
     */
    func openFile() throws {
        if fileHandle != nil { return }
        
        do {
            fileHandle = try FileHandle(forReadingFrom: fileUrl)
            didReachEoF = false
        } catch let error {
            throw Error.failedToOpenFile(underlyingError: error)
        }
    }
    
    /**
     Closes the file.
     
     - Remark: `LineReader` closes the file on deinit, so calling this is optional, but recommended.
     */
    func closeFile() {
        fileHandle?.closeFile()
        fileHandle = nil
        didReachEoF = false
    }
    
    /**
     Reads a line
     
     - Returns: The contens of the line or `nil` if no lines are left to read.
     */
    func readNextLine() -> Data? {
        guard let fileHandle = fileHandle else { return nil }
        
        while hasDataToRead {
            if let delimiterRange = getRangeOfLineDelimiter() {
                let line = lineBuffer.subdata(in: lineBuffer.startIndex..<delimiterRange.lowerBound)
                lineBuffer.removeSubrange(lineBuffer.startIndex..<delimiterRange.upperBound)
                return line
            } else if didReachEoF && !lineBuffer.isEmpty {
                // This case occurs, when EoF was reached, the line buffer is not empty, but the previous condition
                // didn't find the delimiter, ie. "no newline at end of file".
                let remainingData = lineBuffer
                lineBuffer.removeAll()
                return remainingData
            } else {
                let block = fileHandle.readData(ofLength: blockSize)
                if block.count < blockSize {
                    didReachEoF = true
                }
                lineBuffer.append(block)
            }
        }
        
        return nil
    }
    
    enum Error: Swift.Error {
        case failedToOpenFile(underlyingError: Swift.Error)
    }
    
    
    
    
    // MARK: - Private
    
    private let fileUrl: URL
    private let blockSize: Int
    private let lineDelimiter: Data
    
    private var fileHandle: FileHandle?
    private var lineBuffer: Data = .init()
    private var didReachEoF: Bool = false
    
    private var hasDataToRead: Bool { !didReachEoF || !lineBuffer.isEmpty }
    
    private func getRangeOfLineDelimiter() -> Range<Data.Index>? {
        lineBuffer.range(of: lineDelimiter, options: [], in: lineBuffer.startIndex..<lineBuffer.endIndex)
    }
    
    deinit {
        fileHandle?.closeFile()
    }
    
}
