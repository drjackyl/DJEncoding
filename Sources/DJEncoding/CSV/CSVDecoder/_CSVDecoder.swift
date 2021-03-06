class _CSVDecoder: Decoder {
    
    // MARK: - API
    
    init(csvData: CSVData, options: CSVDecoder.Configuration.Options) {
        self.csvData = csvData
        self.options = options
        
        self.primitivesDecoder = _CSVPrimitivesDecoder(csvData: csvData, options: options)
    }
    
    let csvData: CSVData
    let options: CSVDecoder.Configuration.Options
    let primitivesDecoder: _CSVPrimitivesDecoder
    
    func getCustomDecoderForType<T>(_ type: T.Type) -> ((String) throws -> Any)? {
        options.customDecoders["\(T.self)"]
    }
    
    struct RowKey: CodingKey {
        init?(intValue: Int) {
            self.intValue = intValue
        }
        
        init?(stringValue: String) { return nil }
        
        var stringValue: String { "\(intValue ?? -1)"  }
        var intValue: Int?
    }
    
    
    
    
    
    // MARK: - Decoder
    
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let container = _CSVKeyedDecodingContainer<Key>(decoder: self)
        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return _CSVUnkeyedDecodingContainer(decoder: self)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return _CSVSingleValueDecodingContainer(decoder: self)
    }
    
}
