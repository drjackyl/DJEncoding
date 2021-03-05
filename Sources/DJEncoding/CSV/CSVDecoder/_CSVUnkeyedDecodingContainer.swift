struct _CSVUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    
    // MARK: - API
    
    init(decoder: _CSVDecoder) {
        self.decoder = decoder
    }
    
    
    
    
    
    // MARK: - UnkeyedDecodingContainer
    
    var codingPath: [CodingKey] { decoder.codingPath }
    
    var count: Int? { decoder.csvData.numberOfRows }
    
    var isAtEnd: Bool { decoder.csvData.currentRow >= decoder.csvData.numberOfRows }
    
    var currentIndex: Int { decoder.csvData.currentRow }
    
    func decodeNil() throws -> Bool {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function)")
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: String.Type) throws -> String {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function) type=\(type)")
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        defer { decoder.csvData.moveToNextRow() }
        
        decoder.codingPath.append(_CSVDecoder.RowKey(intValue: currentIndex)!)
        defer { decoder.codingPath.removeLast() }
        return try T(from: decoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function)")
    }
    
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function)")
    }
    
    func superDecoder() throws -> Decoder {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVUnkeyedDecodingContainer.self).\(#function)")
    }
    
    
    
    
    
    // MARK: - Private
    
    private let decoder: _CSVDecoder
    
}
