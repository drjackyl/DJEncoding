struct _LogKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    
    init(decoder: _LogDecoder) {
        self.decoder = decoder
    }
    
    let decoder: _LogDecoder
    
    
    
    
    
    // MARK: - KeyedDecodingContainerProtocol
    
    var codingPath: [CodingKey] { decoder.codingPath }
    
    var allKeys: [Key] = [] {
        willSet { print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).allKeys = \(allKeys)") }
    }
    
    func contains(_ key: Key) -> Bool {
        let result = Bool.random()
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) key=\(key) -> \(result) (random)")
        return result
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        let result = Bool.random()
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) key=\(key) -> \(result) (random)")
        return result
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        let result = Bool.random()
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \(result) (random)")
        return result
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        let result = "All decoded simple values are randoms..."
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        let result = Double.random(in: -100.0...100.0)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        let result = Float.random(in: -100.0...100.0)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        let result = Int.random(in: Int.min...Int.max)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        let result = Int8.random(in: Int8.min...Int8.max)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        let result = Int16.random(in: Int16.min...Int16.max)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        let result = Int32.random(in: Int32.min...Int32.max)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        let result = Int64.random(in: Int64.min...Int64.max)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        let result = UInt.random(in: UInt.min...UInt.max)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        let result = UInt8.random(in: UInt8.min...UInt8.max)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        let result = UInt16.random(in: UInt16.min...UInt16.max)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        let result = UInt32.random(in: UInt32.min...UInt32.max)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        let result = UInt64.random(in: UInt64.min...UInt64.max)
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type=\(type) key=\(key) -> \"\(result)\" (random)")
        return result
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) type<T>=\(type) key=\(key)")
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        return try T(from: decoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) key=\(key)")
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        let container = _LogKeyedDecodingContainer<NestedKey>(decoder: decoder)
        return KeyedDecodingContainer(container)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) key=\(key)")
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        return _LogUnkeyedDecodingContainer(decoder: decoder)
    }
    
    func superDecoder() throws -> Decoder {
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function)")
        decoder.codingPath.removeLast()
        return decoder
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) key=\(key)")
        
        if let indexOfKeyInPath = decoder.codingPath.firstIndex(where: { $0.stringValue == key.stringValue }) {
            decoder.codingPath.removeSubrange(indexOfKeyInPath..<codingPath.count)
        } else {
            print("\(codingPath.toString()) \(_LogKeyedDecodingContainer.self).\(#function) key=\(key) Key not found in codingPath")
        }
        
        return decoder
    }
    
}
