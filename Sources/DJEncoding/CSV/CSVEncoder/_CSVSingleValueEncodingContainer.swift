struct _CSVSingleValueEncodingContainer: SingleValueEncodingContainer {
    
    // MARK: - API
    
    init(encoder: _CSVEncoder) {
        self.encoder = encoder
    }
    
    
    
    
    
    // MARK: - SingleValueEncodingContainer
    
    var codingPath: [CodingKey] { encoder.codingPath }
    
    func encodeNil() throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function)")
    }
    
    func encode(_ value: Bool) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: String) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Double) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Float) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int8) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int16) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int32) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int64) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt8) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt16) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt32) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt64) throws {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        throw CSVEncoder.Error.notImplemented(hint: "\(_CSVSingleValueEncodingContainer.self)<\(T.self)>.\(#function) value(\(type(of: value)))=\(value)")
    }
    
    
    
    
    
    // MARK: - Private
    
    private let encoder: _CSVEncoder
    
}
