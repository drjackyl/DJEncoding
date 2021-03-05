struct _LogKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    
    init(encoder: _LogEncoder) {
        self.encoder = encoder
    }
    
    let encoder: _LogEncoder
    
    
    
    
    
    // MARK: - KeyedEncodingContainerProtocol
    
    var codingPath: [CodingKey] { encoder.codingPath }
    
    func encodeNil(forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) key=\(key)")
    }
    
    func encode(_ value: Bool, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: String, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\"\(value)\" key=\(key)")
    }
    
    func encode(_ value: Double, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: Float, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: Int, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: Int8, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: Int16, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: Int32, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: Int64, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: UInt, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: UInt8, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: UInt16, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: UInt32, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode(_ value: UInt64, forKey key: Key) throws {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value(\(type(of: value)))=\(value) key=\(key)")
    }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) value<T>(\(type(of: value)))=\(value) key=\(key)")
        
        encoder.codingPath.append(key)
        defer { encoder.codingPath.removeLast() }
        
        try value.encode(to: encoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) key=\(key)")
        
        encoder.codingPath = codingPath + [key]
        defer { encoder.codingPath.removeLast() }
        
        let container = _LogKeyedEncodingContainer<NestedKey>(encoder: encoder)
        return KeyedEncodingContainer(container)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) key=\(key)")
        
        encoder.codingPath = codingPath + [key]
        defer { encoder.codingPath.removeLast() }
        
        return _LogUnkeyedEncodingContainer(encoder: encoder)
    }
    
    func superEncoder() -> Encoder {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function)")
        encoder.codingPath.removeLast()
        return encoder
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) key=\(key)")
        
        if let indexOfKeyInPath = encoder.codingPath.firstIndex(where: { $0.stringValue == key.stringValue }) {
            encoder.codingPath.removeSubrange(indexOfKeyInPath..<codingPath.count)
        } else {
            print("\(codingPath.toString()) \(_LogKeyedEncodingContainer.self).\(#function) key=\(key) Key not found in codingPath")
        }
        
        return encoder
    }
    
}
