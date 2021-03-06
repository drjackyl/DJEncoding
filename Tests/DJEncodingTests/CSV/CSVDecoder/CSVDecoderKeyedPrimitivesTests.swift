import XCTest
@testable import DJEncoding

class CSVDecoderKeyedPrimitivesTests: XCTestCase {
    
    // MARK: - Empty Data
    
    func testKeyedPrimitiveWithEmptyData() {
        struct KeyedPrimitive: Decodable { let value: Double }
        
        let csvData = CSVData()
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case .noValueForColumnInRow(_, row: _) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedPrimitiveWithOptionalAndEmptyData() {
        // Because the optional property is the only property, the data is checked as to whether it contains the key
        // for that property. When returning false, the decoded value can be constructed with nil as value for that
        // property. Hence, no error is expected from that case.
        
        struct KeyedPrimitive: Decodable { let value: Double? }
        
        let csvData = CSVData()
        
        do {
            let resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
            XCTAssertNil(resultUnderTest.value)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
    }
    
    func testOptionalKeyedPrimitiveAndEmptyData() {
        // Because the type to decode is an optional, a SingleValueDecoder is spawned, which will then, due to the lack
        // of a coding-path, return true for `decodeNil()`. Hence, the result is nil as Optional<KeyedPrimitive>.
        struct KeyedPrimitive: Decodable { let value: Double }
        
        let csvData = CSVData()
        
        do {
            let resultUnderTest = try CSVDecoder().decode(KeyedPrimitive?.self, from: csvData)
            XCTAssertNil(resultUnderTest)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
    }
    
    func testOptionalKeyedPrimitiveWithOptionalAndEmptyData() {
        // Because the type to decode is an optional, a SingleValueDecoder is spawned, which will then, due to the lack
        // of a coding-path, return true for `decodeNil()`. Hence, the result is nil as Optional<KeyedPrimitive>.
        struct KeyedPrimitive: Decodable { let value: Double? }
        
        let csvData = CSVData()
        
        do {
            let resultUnderTest = try CSVDecoder().decode(KeyedPrimitive?.self, from: csvData)
            XCTAssertNil(resultUnderTest)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
    }
    
    // MARK: - Nil
    
    func testKeyedNilTrue() {
        struct KeyedPrimitive: Decodable { let value: Double? }
        
        let csvData = CSVData()
        csvData.setValue("", forColumn: "value")
        
        let resultunderTest: KeyedPrimitive
        do {
            resultunderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultunderTest.value, nil)
    }
    
    func testKeyedNilFalse() {
        struct KeyedPrimitive: Decodable { let value: Double? }
        
        let csvData = CSVData()
        csvData.setValue("23.42", forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultUnderTest.value, 23.42)
    }
    
    // MARK: - Bool
    
    func testKeyedBoolTrue() {
        struct KeyedPrimitive: Decodable { let value: Bool }
        
        let csvData = CSVData()
        csvData.setValue("true", forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultUnderTest.value, true)
    }
    
    func testKeyedBoolFalse() {
        struct KeyedPrimitive: Decodable { let value: Bool }
        
        let csvData = CSVData()
        csvData.setValue("false", forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultUnderTest.value, false)
    }
    
    func testKeyedBoolInvalid() {
        struct KeyedPrimitive: Decodable { let value: Bool }
        
        let csvData = CSVData()
        csvData.setValue("invalid", forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, "invalid")
            XCTAssertTrue(type == Bool.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedBoolCustomTrue() {
        struct KeyedPrimitive: Decodable { let value: Bool }
        
        let csvData = CSVData()
        let customTrue = "Bärbel"
        csvData.setValue(customTrue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            let decoder = CSVDecoder()
            decoder.configuration
                .decodeBoolean(trueValue: customTrue)
            resultUnderTest = try decoder.decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultUnderTest.value, true)
    }
    
    func testKeyedBoolCustomFalse() {
        struct KeyedPrimitive: Decodable { let value: Bool }
        
        let csvData = CSVData()
        let customFalse = "Bärbel"
        csvData.setValue(customFalse, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            let decoder = CSVDecoder()
            decoder.configuration
                .decodeBoolean(falseValue: customFalse)
            resultUnderTest = try decoder.decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultUnderTest.value, false)
    }
    
    func testKeyedBoolCustomInvalid() {
        struct KeyedPrimitive: Decodable { let value: Bool }
        
        let csvData = CSVData()
        let customTrue = "Bärbel"
        csvData.setValue("Egon", forColumn: "value")
        
        do {
            let decoder = CSVDecoder()
            decoder.configuration
                .decodeBoolean(trueValue: customTrue)
            _ = try decoder.decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, "Egon")
            XCTAssertTrue(type == Bool.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - String
    
    func testKeyedStringValid() {
        struct KeyedPrimitive: Decodable { let value: String }
        
        let csvData = CSVData()
        let stringValue = "Hello World!"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, stringValue)
    }
    
    // Since CSVData is based on strings, a string-value cannot be invalid, as the "no-value" is an empty string. Hence
    // the tests for invalid and empty strings are not needed.
    
    // MARK: - Double
    
    func testKeyedDoubleValid() {
        struct KeyedPrimitive: Decodable { let value: Double }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13.37)
    }
    
    func testKeyedDoubleInvalid() {
        struct KeyedPrimitive: Decodable { let value: Double }
        
        let csvData = CSVData()
        let stringValue = "13-37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Double.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedDoubleEmpty() {
        struct KeyedPrimitive: Decodable { let value: Double }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Double.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - Float
    
    func testKeyedFloatValid() {
        struct KeyedPrimitive: Decodable { let value: Float }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13.37)
    }
    
    func testKeyedFloatInvalid() {
        struct KeyedPrimitive: Decodable { let value: Float }
        
        let csvData = CSVData()
        let stringValue = "13-37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Float.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedFloatEmpty() {
        struct KeyedPrimitive: Decodable { let value: Float }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Float.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - Int
    
    func testKeyedIntValid() {
        struct KeyedPrimitive: Decodable { let value: Int }
        
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13)
    }
    
    func testKeyedIntInvalid() {
        struct KeyedPrimitive: Decodable { let value: Int }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedIntEmpty() {
        struct KeyedPrimitive: Decodable { let value: Int }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - Int8
    
    func testKeyedInt8Valid() {
        struct KeyedPrimitive: Decodable { let value: Int8 }
        
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13)
    }
    
    func testKeyedInt8Invalid() {
        struct KeyedPrimitive: Decodable { let value: Int8 }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int8.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedInt8Empty() {
        struct KeyedPrimitive: Decodable { let value: Int8 }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int8.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - Int16
    
    func testKeyedInt16Valid() {
        struct KeyedPrimitive: Decodable { let value: Int16 }
        
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13)
    }
    
    func testKeyedInt16Invalid() {
        struct KeyedPrimitive: Decodable { let value: Int16 }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int16.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedInt16Empty() {
        struct KeyedPrimitive: Decodable { let value: Int16 }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int16.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - Int32
    
    func testKeyedInt32Valid() {
        struct KeyedPrimitive: Decodable { let value: Int32 }
        
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13)
    }
    
    func testKeyedInt32Invalid() {
        struct KeyedPrimitive: Decodable { let value: Int32 }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int32.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedInt32Empty() {
        struct KeyedPrimitive: Decodable { let value: Int32 }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int32.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - Int64
    
    func testKeyedInt64Valid() {
        struct KeyedPrimitive: Decodable { let value: Int64 }
        
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13)
    }
    
    func testKeyedInt64Invalid() {
        struct KeyedPrimitive: Decodable { let value: Int64 }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int64.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedInt64Empty() {
        struct KeyedPrimitive: Decodable { let value: Int64 }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int64.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - UInt
    
    func testKeyedUIntValid() {
        struct KeyedPrimitive: Decodable { let value: UInt }
        
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13)
    }
    
    func testKeyedUIntInvalid() {
        struct KeyedPrimitive: Decodable { let value: UInt }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedUIntEmpty() {
        struct KeyedPrimitive: Decodable { let value: UInt }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - UInt8
    
    func testKeyedUInt8Valid() {
        struct KeyedPrimitive: Decodable { let value: UInt8 }
        
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13)
    }
    
    func testKeyedUInt8Invalid() {
        struct KeyedPrimitive: Decodable { let value: UInt8 }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt8.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedUInt8Empty() {
        struct KeyedPrimitive: Decodable { let value: UInt8 }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt8.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - UInt16
    
    func testKeyedUInt16Valid() {
        struct KeyedPrimitive: Decodable { let value: UInt16 }
        
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13)
    }
    
    func testKeyedUInt16Invalid() {
        struct KeyedPrimitive: Decodable { let value: UInt16 }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt16.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedUInt16Empty() {
        struct KeyedPrimitive: Decodable { let value: UInt16 }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt16.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - UInt32
    
    func testKeyedUInt32Valid() {
        struct KeyedPrimitive: Decodable { let value: UInt32 }
        
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13)
    }
    
    func testKeyedUInt32Invalid() {
        struct KeyedPrimitive: Decodable { let value: UInt32 }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt32.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedUInt32Empty() {
        struct KeyedPrimitive: Decodable { let value: UInt32 }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt32.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - UInt64
    
    func testKeyedUInt64Valid() {
        struct KeyedPrimitive: Decodable { let value: UInt64 }
        
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "value")
        
        let resultUnderTest: KeyedPrimitive
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.value, 13)
    }
    
    func testKeyedUInt64Invalid() {
        struct KeyedPrimitive: Decodable { let value: UInt64 }
        
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt64.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedUInt64Empty() {
        struct KeyedPrimitive: Decodable { let value: UInt64 }
        
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(KeyedPrimitive.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "value")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt64.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - Custom Non-Primitive Types
    
    func testKeyedCustomComplexNotSupported() {
        struct KeyedPrimitive: Decodable { let value: Double }
        struct CustomKeyedComplex: Decodable { let value: KeyedPrimitive }
        
        let csvData = CSVData()
        csvData.setValue("Doesn't matter", forColumn: "value")
        
        do {
            _ = try CSVDecoder().decode(CustomKeyedComplex.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case .notSupported = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testKeyedCustomComplexOptionalNotSupported() {
        struct KeyedPrimitive: Decodable { let value: Double }
        struct CustomKeyedComplex: Decodable { let value: KeyedPrimitive? }
        
        let csvData = CSVData()
        csvData.setValue("Doesn't matter", forColumn: "value")
        
        do {
            let result = try CSVDecoder().decode(CustomKeyedComplex.self, from: csvData)
            print(result)
        } catch let error as CSVDecoder.Error {
            guard case .notSupported = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
}
