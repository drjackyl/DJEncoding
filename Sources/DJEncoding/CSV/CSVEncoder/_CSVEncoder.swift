class _CSVEncoder: Encoder {
    
    // MARK: - API
    
    init(csvData: CSVData) {
        self.csvData = csvData
    }
    
    let csvData: CSVData
    
    
    
    
    
    // MARK: - Encoder
    
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = _CSVKeyedEncodingContainer<Key>(encoder: self)
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return _CSVUnkeyedEncodingContainer(encoder: self)
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        return _CSVSingleValueEncodingContainer(encoder: self)
    }
    
}
