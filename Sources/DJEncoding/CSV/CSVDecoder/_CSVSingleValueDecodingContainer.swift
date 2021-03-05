struct _CSVSingleValueDecodingContainer: SingleValueDecodingContainer {
    
    // MARK: - API
    
    init(decoder: _CSVDecoder) {
        self.decoder = decoder
    }
    
    
    
    
    
    // MARK: - SingleValueDecodingContainer
    
    var codingPath: [CodingKey] { decoder.codingPath }
    
    func decodeNil() -> Bool {
        var columnValue: String? = nil
        if let columnName = codingPath.last?.stringValue {
            columnValue = decoder.csvData.getValueOfColumn(columnName)
        }

        // If the retrieved columnValue is nil, the data doesn't exist, hence, true can be returned.
        // If the retrieved columnValue is the empty string, the data has no content, hence, true can be returned.
        return columnValue ?? "" == ""
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: String.Type) throws -> String {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        let column = try ensureColumnFromCodingPath()
        return try decoder.primitivesDecoder.decode(type, fromColumn: column)
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        // In the case of a property, which has a generic type, that is a primitive optional, this func is called. After
        // the Decoder queried whether the value was nil, the optional is decoded through this func.
        
        if type == Bool.self { return try decode(Bool.self) as! T }
        if type == String.self { return try decode(String.self) as! T }
        if type == Double.self { return try decode(Double.self) as! T }
        if type == Float.self { return try decode(Float.self) as! T }
        if type == Int.self { return try decode(Int.self) as! T }
        if type == Int8.self { return try decode(Int8.self) as! T }
        if type == Int16.self { return try decode(Int16.self) as! T }
        if type == Int32.self { return try decode(Int32.self) as! T }
        if type == Int64.self { return try decode(Int64.self) as! T }
        if type == UInt.self { return try decode(UInt.self) as! T }
        if type == UInt8.self { return try decode(UInt8.self) as! T }
        if type == UInt16.self { return try decode(UInt16.self) as! T }
        if type == UInt32.self { return try decode(UInt32.self) as! T }
        if type == UInt64.self { return try decode(UInt64.self) as! T }
        
        // Since CSVData cannot represent complex types, neither nested, nor as single value - which would be the
        // cell-content, this error is thrown.
        // CSVData always represents a row of columns, ie. a value-type with properties of primitive types.
        throw CSVDecoder.Error.notSupported(hint: "\(createLogReference()) type=\(type): Complex single values are not supported")
    }
    
    
    
    
    
    // MARK: - Private
    
    private let decoder: _CSVDecoder
    
    private func ensureColumnFromCodingPath() throws -> String {
        guard let column = codingPath.last?.stringValue else {
            throw CSVDecoder.Error.internalError(hint: "Coding-path is empty.")
        }
        guard decoder.csvData.headerRow.contains(column) else {
            throw CSVDecoder.Error.columnDoesNotExist(column: column)
        }
        return column
    }
    
    private func createLogReference(function: String = #function) -> String {
        return "\(Swift.type(of: self.self))." + function
    }
    
}
