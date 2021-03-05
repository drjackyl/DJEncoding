struct _LogSingleValueDecodingContainer: SingleValueDecodingContainer {
    
    init(decoder: _LogDecoder) {
        self.decoder = decoder
    }
    
    let decoder: _LogDecoder
    
    
    
    
    
    // MARK: - SingleValueDecodingContainer
    
    var codingPath: [CodingKey] { decoder.codingPath }
    
    func decodeNil() -> Bool {
        let result = Bool.random()
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) -> \(result) (random)")
        return result
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        let result = Bool.random()
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \(result) (random)")
        return result
    }
    
    func decode(_ type: String.Type) throws -> String {
        let result = "All decoded simple values are randoms..."
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        let result = Double.random(in: -100.0...100.0)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        let result = Float.random(in: -100.0...100.0)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        let result = Int.random(in: Int.min...Int.max)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        let result = Int8.random(in: Int8.min...Int8.max)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        let result = Int16.random(in: Int16.min...Int16.max)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        let result = Int32.random(in: Int32.min...Int32.max)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        let result = Int64.random(in: Int64.min...Int64.max)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        let result = UInt.random(in: UInt.min...UInt.max)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        let result = UInt8.random(in: UInt8.min...UInt8.max)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        let result = UInt16.random(in: UInt16.min...UInt16.max)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        let result = UInt32.random(in: UInt32.min...UInt32.max)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        let result = UInt64.random(in: UInt64.min...UInt64.max)
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type=\(type) -> \"\(result)\" (random)")
        return result
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        print("\(codingPath.toString()) \(_LogSingleValueDecodingContainer.self).\(#function) type<T>=\(type)")
        return try T(from: decoder)
    }
    
}
