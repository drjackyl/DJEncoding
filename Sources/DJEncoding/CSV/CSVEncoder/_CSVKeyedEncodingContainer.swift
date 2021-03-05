struct _CSVKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    
    // MARK: - API
    
    init(encoder: _CSVEncoder) {
        self.encoder = encoder
    }
    
    
    
    
    
    // MARK: - KeyedEncodingContainerProtocol
    
    var codingPath: [CodingKey] { encoder.codingPath }
    
    func encodeNil(forKey key: Key) throws {
        encoder.csvData.setValue("", forColumn: key.stringValue)
    }
    
    func encode(_ value: Bool, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: String, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: Double, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: Float, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: Int, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: Int8, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: Int16, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: Int32, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: Int64, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: UInt, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: UInt8, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: UInt16, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: UInt32, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode(_ value: UInt64, forKey key: Key) throws {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        encoder.csvData.setValue("\(value)", forColumn: key.stringValue)
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        // TODO: Figure out proper handling
        
        // Creating entirely new instances for the nested container leads to nothing ending up in the
        // final result. I did not, yet fully grasp, what this call is for and when they are used.
        // Since they are not marked as throwing, I can't abort with an error here.
        let nestedCSVData = CSVData()
        let nestedEncoder = _CSVEncoder(csvData: nestedCSVData)
        let nestedContainer = _CSVKeyedEncodingContainer<NestedKey>(encoder: nestedEncoder)
        return KeyedEncodingContainer(nestedContainer)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        // TODO: Figure out proper handling
        
        // Creating entirely new instances for the nested container leads to nothing ending up in the
        // final result. I did not, yet fully grasp, what this call is for and when they are used.
        // Since they are not marked as throwing, I can't abort with an error here.
        let nesedCSVData = CSVData()
        let nestedEncoder = _CSVEncoder(csvData: nesedCSVData)
        return _CSVUnkeyedEncodingContainer(encoder: nestedEncoder)
    }
    
    func superEncoder() -> Encoder {
        // TODO: Figure out proper handling
        
        
        // I did not, yet fully grasp, what this call is for and when they are used. Since they are
        // not marked as throwing, I can't abort with an error here.
        let superData = CSVData()
        return _CSVEncoder(csvData: superData)
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        // TODO: Figure out proper handling
        
        // I did not, yet fully grasp, what this call is for and when they are used. Since they are
        // not marked as throwing, I can't abort with an error here.
        return superEncoder()
    }
    
    
    
    
    
    // MARK: - Private
    
    private let encoder: _CSVEncoder
    
}
