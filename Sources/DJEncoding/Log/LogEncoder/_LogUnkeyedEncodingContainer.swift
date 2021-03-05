struct _LogUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    
    init(encoder: _LogEncoder) {
        self.encoder = encoder
    }
    
    let encoder: _LogEncoder
    
    struct UnkeyedKey: CodingKey {
        init?(intValue: Int) {
            self.intValue = intValue
        }
        
        init?(stringValue: String) { return nil }
        
        var stringValue: String { "\(intValue ?? -1)"  }
        var intValue: Int?
    }
    
    
    
    
    
    // MARK: - UnkeyedEncodingContainer
    
    var codingPath: [CodingKey] { encoder.codingPath }
    
    var count: Int = 0  {
        didSet { print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).count = \(count)") }
    }
    
    mutating func encodeNil() throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count)")
        count += 1
    }
    
    mutating func encode(_ value: Bool) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode(_ value: String) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\"\(value)\"")
        count += 1
    }
    
    mutating func encode(_ value: Double) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode(_ value: Float) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode(_ value: Int) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode(_ value: Int8) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode(_ value: Int16) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode(_ value: Int32) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
    }
    
    mutating func encode(_ value: Int64) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode(_ value: UInt) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode(_ value: UInt8) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode(_ value: UInt16) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode(_ value: UInt32) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode(_ value: UInt64) throws {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value(\(type(of: value)))=\(value)")
        count += 1
    }
    
    mutating func encode<T>(_ value: T) throws where T : Encodable {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) value<T>(\(type(of: value)))=\(value)")
        
        encoder.codingPath.append(UnkeyedKey(intValue: count)!)
        defer { encoder.codingPath.removeLast() }
        
        try value.encode(to: encoder)
        count += 1
    }
    
    mutating func encode<T>(contentsOf sequence: T) throws where T : Sequence, T.Element == String {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count) sequence<T>(\(type(of: sequence)))=\(sequence)")
        count += 1
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function)<NestedKey=\(NestedKey.self)> count=\(count) keyType=\(keyType)")
        
        encoder.codingPath.append(UnkeyedKey(intValue: count)!)
        
        let container = _LogKeyedEncodingContainer<NestedKey>(encoder: encoder)
        return KeyedEncodingContainer(container)
    }
    
    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count)")
        
        encoder.codingPath.append(UnkeyedKey(intValue: count)!)
        
        return _LogUnkeyedEncodingContainer(encoder: encoder)
    }
    
    mutating func superEncoder() -> Encoder {
        print("\(codingPath.toString()) \(_LogUnkeyedEncodingContainer.self).\(#function) count=\(count)")
        
        encoder.codingPath.removeLast()
        return encoder
    }
    
}
