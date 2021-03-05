class _LogDecoder: Decoder {
    
    // MARK: - Decoder
    
    var codingPath: [CodingKey] = [] {
        willSet { print("\(codingPath.toString()) \(_LogEncoder.self).codingPath = \(newValue.toString())") }
    }
    
    var userInfo: [CodingUserInfoKey : Any] = [:] {
        willSet { print("\(codingPath.toString()) \(_LogEncoder.self).userInfo = \(newValue)") }
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        print("\(codingPath.toString()) \(_LogDecoder.self).\(#function)")
        let container = _LogKeyedDecodingContainer<Key>(decoder: self)
        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        print("\(codingPath.toString()) \(_LogDecoder.self).\(#function)")
        return _LogUnkeyedDecodingContainer(decoder: self)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        print("\(codingPath.toString()) \(_LogDecoder.self).\(#function)")
        return _LogSingleValueDecodingContainer(decoder: self)
    }
    
}
