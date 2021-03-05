struct _LogSingleValueEncodingContainer: SingleValueEncodingContainer {
    
    init(encoder: _LogEncoder) {
        self.encoder = encoder
    }
    
    let encoder: _LogEncoder
    
    
    
    
    
    // MARK: - SingleValueEncodingContainer
    
    var codingPath: [CodingKey] { encoder.codingPath }
    
    func encodeNil() throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function)")
    }
    
    func encode(_ value: Bool) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: String) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\"\(value)\"")
    }
    
    func encode(_ value: Double) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Float) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int8) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int16) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int32) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: Int64) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt8) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt16) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt32) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode(_ value: UInt64) throws {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value)")
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        print("\(codingPath.toString()) \(_LogSingleValueEncodingContainer.self)<\(T.self)>.\(#function) value<T>(\(type(of: value)))=\(value)")
    }
    
}
