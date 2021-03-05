struct _CSVUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    
    // MARK: - API
    
    init(encoder: _CSVEncoder) {
        self.encoder = encoder
    }
    
    
    
    
    
    // MARK: - UnkeyedEncodingContainer
    
    var codingPath: [CodingKey] { encoder.codingPath }
    
    var count: Int { encoder.csvData.numberOfRows }
    
    func encodeNil() throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function)")
    }
    
    func encode(_ value: Bool) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: String) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Double) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Float) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int8) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int16) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int32) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int64) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt8) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt16) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt32) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt64) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVUnkeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        // TODO: Is the assumption and logic correct?
        
        // CSV-files are tables, which support one complex type per row. Nested complex types inside cells are not
        // supported.
        //
        // (Though, in the future, a configurable encoder for cell-contents could be supported.)
        guard codingPath.isEmpty else {
            throw CSVEncoder.Error.notSupported(hint: "Complex types can only exist on root-level, ie. per row.")
        }
        
        defer { encoder.csvData.moveToNextRow() }
        try value.encode(to: encoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        // TODO: Figure out proper handling
        
        // Creating entirely new instances for the nested container leads to nothing ending up in the
        // final result. I did not, yet fully grasp, what this call is for and when they are used.
        // Since they are not marked as throwing, I can't abort with an error here.
        let nestedCSVData = CSVData()
        let nestedEncoder = _CSVEncoder(csvData: nestedCSVData)
        let nestedContainer = _CSVKeyedEncodingContainer<NestedKey>(encoder: nestedEncoder)
        return KeyedEncodingContainer(nestedContainer)
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        // TODO: Figure out proper handling
        
        // Creating entirely new instances for the nested container leads to nothing ending up in the
        // final result. I did not, yet fully grasp, what this call is for and when they are used.
        // Since they are not marked as throwing, I can't abort with an error here.
        let nesedCSVData = CSVData()
        let nestedEncoder = _CSVEncoder(csvData: nesedCSVData)
        return _CSVUnkeyedEncodingContainer(encoder: nestedEncoder)
    }
    
    func superEncoder() -> Encoder {
        // TODO: Figure out proper handling
        
        // I did not, yet fully grasp, what this call is for and when they are used. Since they are
        // not marked as throwing, I can't abort with an error here.
        let superData = CSVData()
        return _CSVEncoder(csvData: superData)
    }

    
    
    
    
    // MARK: - Private
    
    private let encoder: _CSVEncoder
    
}
