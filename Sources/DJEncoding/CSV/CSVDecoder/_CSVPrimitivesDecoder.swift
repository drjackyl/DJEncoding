class _CSVPrimitivesDecoder {
    
    // MARK: - API
    
    init(csvData: CSVData, options: CSVDecoder.Configuration.Options) {
        self.csvData = csvData
        self.options = options
    }
    
    func isPrimitiveType<T>(_ type: T.Type) -> Bool {
        return
            type == Bool.self ||
            type == String.self ||
            type == Double.self ||
            type == Float.self ||
            type == Int.self ||
            type == Int8.self ||
            type == Int16.self ||
            type == Int32.self ||
            type == Int64.self ||
            type == UInt.self ||
            type == UInt8.self ||
            type == UInt16.self ||
            type == UInt32.self ||
            type == UInt64.self
    }
    
    func isOptionalOfPrimitiveType<T>(_ type: T.Type) -> Bool {
        return
            type == Bool?.self ||
            type == String?.self ||
            type == Double?.self ||
            type == Float?.self ||
            type == Int?.self ||
            type == Int8?.self ||
            type == Int16?.self ||
            type == Int32?.self ||
            type == Int64?.self ||
            type == UInt?.self ||
            type == UInt8?.self ||
            type == UInt16?.self ||
            type == UInt32?.self ||
            type == UInt64?.self
    }
    
    func decode(_ type: Bool.Type, fromColumn column: String) throws -> Bool {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        switch csvValue {
        case options.booleanTrueValue: return true
        case options.booleanFalseValue: return false
        default:
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
    }
    
    func decode(_ type: String.Type, fromColumn column: String) throws -> String {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        return csvValue
    }
    
    func decode(_ type: Double.Type, fromColumn column: String) throws -> Double {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = Double(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    func decode(_ type: Float.Type, fromColumn column: String) throws -> Float {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = Float(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    func decode(_ type: Int.Type, fromColumn column: String) throws -> Int {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = Int(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    func decode(_ type: Int8.Type, fromColumn column: String) throws -> Int8 {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = Int8(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    func decode(_ type: Int16.Type, fromColumn column: String) throws -> Int16 {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = Int16(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    func decode(_ type: Int32.Type, fromColumn column: String) throws -> Int32 {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = Int32(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    func decode(_ type: Int64.Type, fromColumn column: String) throws -> Int64 {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = Int64(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    func decode(_ type: UInt.Type, fromColumn column: String) throws -> UInt {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = UInt(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    func decode(_ type: UInt8.Type, fromColumn column: String) throws -> UInt8 {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = UInt8(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    func decode(_ type: UInt16.Type, fromColumn column: String) throws -> UInt16 {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = UInt16(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    func decode(_ type: UInt32.Type, fromColumn column: String) throws -> UInt32 {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = UInt32(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    func decode(_ type: UInt64.Type, fromColumn column: String) throws -> UInt64 {
        guard let csvValue = csvData.getValueOfColumn(column) else {
            throw CSVDecoder.Error.noValueForColumnInRow(column: column, row: csvData.currentRow)
        }
        guard let decodedValue = UInt64(csvValue) else {
            throw CSVDecoder.Error.invalidValueForType(column: column, row: csvData.currentRow, value: csvValue, type: type)
        }
        return decodedValue
    }
    
    
    
    
    
    // MARK: - Private
    
    let csvData: CSVData
    let options: CSVDecoder.Configuration.Options
    
}
