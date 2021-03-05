struct _LogUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    
    init(decoder: _LogDecoder) {
        self.decoder = decoder
    }
    
    let decoder: _LogDecoder
    
    struct UnkeyedKey: CodingKey {
        init?(intValue: Int) {
            self.intValue = intValue
        }
        
        init?(stringValue: String) { return nil }
        
        var stringValue: String { "\(intValue ?? -1)"  }
        var intValue: Int?
    }
    
    
    
    
    
    // MARK: - UnkeyedDecodingContainer
    
    var codingPath: [CodingKey] { decoder.codingPath }
    
    var count: Int? = 3 /*Int.random(in: 0...3)*/ {
        didSet { print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).count = \(String(describing: count))") }
    }
    
    var isAtEnd: Bool {
        let result = currentIndex >= count ?? currentIndex
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).isAtEnd ? currentIndex(\(currentIndex)) >= count(\(count!)) == \(result)")
        return result
    }
    
    var currentIndex: Int = 0 {
        didSet { print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).currentIndex = \(currentIndex)") }
    }
    
    mutating func decodeNil() throws -> Bool {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex)")
        defer { currentIndex += 1 }
        return Bool.random()
    }
    
    mutating func decode(_ type: Bool.Type) throws -> Bool {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return Bool.random()
    }
    
    mutating func decode(_ type: String.Type) throws -> String {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return "All decoded simple values are randoms..."
    }
    
    mutating func decode(_ type: Double.Type) throws -> Double {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return Double.random(in: -100.0...100.0)
    }
    
    mutating func decode(_ type: Float.Type) throws -> Float {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return Float.random(in: -100.0...100.0)
    }
    
    mutating func decode(_ type: Int.Type) throws -> Int {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return Int.random(in: Int.min...Int.max)
    }
    
    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return Int8.random(in: Int8.min...Int8.max)
    }
    
    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return Int16.random(in: Int16.min...Int16.max)
    }
    
    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return Int32.random(in: Int32.min...Int32.max)
    }
    
    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return Int64.random(in: Int64.min...Int64.max)
    }
    
    mutating func decode(_ type: UInt.Type) throws -> UInt {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return UInt.random(in: UInt.min...UInt.max)
    }
    
    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return UInt8.random(in: UInt8.min...UInt8.max)
    }
    
    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return UInt16.random(in: UInt16.min...UInt16.max)
    }
    
    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return UInt32.random(in: UInt32.min...UInt32.max)
    }
    
    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        defer { currentIndex += 1 }
        return UInt64.random(in: UInt64.min...UInt64.max)
    }
    
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type<T>=\(type)")
        
        decoder.codingPath.append(UnkeyedKey(intValue: currentIndex)!)
        defer {
            decoder.codingPath.removeLast()
            currentIndex += 1
        }
        
        return try T(from: decoder)
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex) type=\(type)")
        
        decoder.codingPath.append(UnkeyedKey(intValue: currentIndex)!)
        
        let container = _LogKeyedDecodingContainer<NestedKey>(decoder: decoder)
        return KeyedDecodingContainer(container)
    }
    
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex)")
        
        decoder.codingPath.append(UnkeyedKey(intValue: currentIndex)!)
        
        return _LogUnkeyedDecodingContainer(decoder: decoder)
    }
    
    mutating func superDecoder() throws -> Decoder {
        print("\(codingPath.toString()) \(_LogUnkeyedDecodingContainer.self).\(#function) currentIndex=\(currentIndex)")
        
        decoder.codingPath.removeLast()
        
        return decoder
    }
    
}
