class _LogEncoder: Encoder {
    
    // MARK: - Encoder
    
    var codingPath: [CodingKey] = [] {
        willSet { print("\(codingPath.toString()) \(_LogEncoder.self).codingPath = \(newValue.toString())") }
    }
    
    var userInfo: [CodingUserInfoKey : Any] = [:] {
        willSet { print("\(codingPath.toString()) \(_LogEncoder.self).userInfo = \(newValue)") }
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        print("\(codingPath.toString()) \(_LogEncoder.self).\(#function)")
        let container = _LogKeyedEncodingContainer<Key>(encoder: self)
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        print("\(codingPath.toString()) \(_LogEncoder.self).\(#function)")
        return _LogUnkeyedEncodingContainer(encoder: self)
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        print("\(codingPath.toString()) \(_LogEncoder.self).\(#function)")
        return _LogSingleValueEncodingContainer(encoder: self)
    }
    
}
