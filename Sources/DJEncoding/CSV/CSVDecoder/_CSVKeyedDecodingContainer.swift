struct _CSVKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    
    // MARK: - API
    
    init(decoder: _CSVDecoder) {
        self.decoder = decoder
    }
    
    
    
    
    
    // MARK: - KeyedDecodingContainerProtocol
    
    var codingPath: [CodingKey] { decoder.codingPath }
    
    var allKeys: [Key] { decoder.csvData.headerRow.compactMap { Key(stringValue: $0) } }
    
    func contains(_ key: Key) -> Bool {
        decoder.csvData.headerRow.contains(key.stringValue)
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        decoder.csvData.getValueOfColumn(key.stringValue) == ""
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        try decoder.primitivesDecoder.decode(type, fromColumn: key.stringValue)
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        // Decoding of primitive types, which are a generic-typed property of a non-primitive type go through the
        // this func.
        //
        // Example: `AnyValue<String>`'s property `decodedValue`, which is a string in that instance, still goes through
        //          `decode<T>(_:forKey:)`, even though it's known to be a String.
        //
        // A `Decoder` to which this type is handed to, will then spawn a `SingleValueDecodingContainer` and decode the
        // value using that one.
        //
        // Without that behavior, this func would generally throw a `CSVDecoder.Error.notSupported`.
        
        if let customDecoder = decoder.getCustomDecoderForType(type) {
            let csvValue = try ensureValueInColumn(key.stringValue)
            let decodedValue = try decodeCSVValue(csvValue, ofColumn: key.stringValue, using: customDecoder)
            
            guard let typedDecodedValue = decodedValue as? T else {
                throw CSVDecoder.Error.invalidValueForType(type: type, actual: csvValue, expected: "\(T.self)")
            }
            return typedDecodedValue
        }
        
        guard decoder.primitivesDecoder.isPrimitiveType(type) || decoder.primitivesDecoder.isOptionalOfPrimitiveType(type) else {
            throw CSVDecoder.Error.notSupported(hint: "\(_CSVKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key.stringValue): Decoding complex types inside a container is not supported")
        }
        guard contains(key) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: key.stringValue, row: decoder.csvData.currentRow)
        }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        return try T(from: decoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVKeyedDecodingContainer.self).\(#function)")
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVKeyedDecodingContainer.self).\(#function)")
    }
    
    func superDecoder() throws -> Decoder {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVKeyedDecodingContainer.self).\(#function)")
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        throw CSVDecoder.Error.notImplemented(hint: "\(_CSVKeyedDecodingContainer.self).\(#function)")
    }
    
    
    
    
    
    // MARK: - Private
    
    private let decoder: _CSVDecoder
    
    private func ensureValueInColumn(_ columnName: String) throws -> String {
        guard let csvValue = decoder.csvData.getValueOfColumn(columnName) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: columnName, row: decoder.csvData.currentRow)
        }
        return csvValue
    }
    
    private func decodeCSVValue(_ csvValue: String, ofColumn columnName: String, using customDecoder: (String) throws -> Any) throws -> Any {
        do {
            return try customDecoder(csvValue)
        } catch let error {
            throw CSVDecoder.Error.customDecoderFailed(column: columnName, row: decoder.csvData.currentRow, underlyingError: error)
        }
    }
    
}
