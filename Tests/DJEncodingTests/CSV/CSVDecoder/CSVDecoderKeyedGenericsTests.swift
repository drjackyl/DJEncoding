import XCTest
@testable import DJEncoding

class CSVDecoderKeyedGenericsTests: XCTestCase {
    
    // Because Swift does not support assertion of enum-cases without conforming them to Equatable, negated assertions,
    // ie. guard case combined with XCTFail are used.
    
    // Decoding of primitive types, which are a generic-typed property of a non-primitive type go through the
    // `KeyedDecodingKontainer`'s `decode<T>(_:forKey:)`.
    //
    // Example: `AnyValue<String>`'s property `decodedValue`, which is a string in that instance, still goes through
    //          `decode<T>(_:forKey:)`, even though it's known to be a String.
    //
    // A `Decoder` to which this type is handed to, will then spawn a `SingleValueDecodingContainer` and decode the
    // value using that one.
    
    struct KeyedGeneric<T: Decodable>: Decodable {
        let decodedValue: T
    }
    
    // MARK: - Empty
    
    func testGenericWithEmptyData() {
        let csvData = CSVData()
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Double>.self, from: csvData)
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
    
    func testGenericWithOptionalAndEmptyData() {
        let csvData = CSVData()
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Double?>.self, from: csvData)
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
    
    func testOptionalGenericWithOptionalAndEmptyData() {
        let csvData = CSVData()
        
        let resultUnderTest: KeyedGeneric<Double?>?
        do {
             resultUnderTest = try CSVDecoder().decode(KeyedGeneric<Double?>?.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertNil(resultUnderTest)
    }
    
    // MARK: - Nil
    
    func testGenericNilTrue() {
        let csvData = CSVData()
        csvData.setValue("", forColumn: "decodedValue")
        
        let resultunderTest: KeyedGeneric<Double?>
        do {
            resultunderTest = try CSVDecoder().decode(KeyedGeneric<Double?>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultunderTest.decodedValue, nil)
    }
    
    func testGenericNilFalse() {
        let csvData = CSVData()
        csvData.setValue("23.42", forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Double?>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<Double?>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 23.42)
    }
    
    // MARK: - Bool
    
    func testGenericBoolTrue() {
        let csvData = CSVData()
        csvData.setValue("true", forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Bool>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<Bool>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, true)
    }
    
    func testGenericBoolFalse() {
        let csvData = CSVData()
        csvData.setValue("false", forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Bool>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<Bool>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, false)
    }
    
    func testGenericBoolInvalid() {
        let csvData = CSVData()
        csvData.setValue("invalid", forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Bool>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, "invalid")
            XCTAssertTrue(type == Bool.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericBoolCustomTrue() {
        let csvData = CSVData()
        let customTrue = "Bärbel"
        csvData.setValue(customTrue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Bool>
        do {
            let decoder = CSVDecoder()
            decoder.configuration
                .decodeBoolean(trueValue: customTrue)
            resultUnderTest = try decoder.decode(KeyedGeneric<Bool>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, true)
    }
    
    func testGenericBoolCustomFalse() {
        let csvData = CSVData()
        let customFalse = "Bärbel"
        csvData.setValue(customFalse, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Bool>
        do {
            let decoder = CSVDecoder()
            decoder.configuration
                .decodeBoolean(falseValue: customFalse)
            resultUnderTest = try decoder.decode(KeyedGeneric<Bool>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
            return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, false)
    }
    
    func testGenericBoolCustomInvalid() {
        let csvData = CSVData()
        let customTrue = "Bärbel"
        csvData.setValue("Egon", forColumn: "decodedValue")
        
        do {
            let decoder = CSVDecoder()
            decoder.configuration
                .decodeBoolean(trueValue: customTrue)
            _ = try decoder.decode(KeyedGeneric<Bool>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, "Egon")
            XCTAssertTrue(type == Bool.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - Double
    
    func testGenericDoubleValid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Double>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<Double>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13.37)
    }
    
    func testGenericDoubleInvalid() {
        let csvData = CSVData()
        let stringValue = "13-37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Double>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, "13-37")
            XCTAssertTrue(type == Double.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericDoubleEmpty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Double>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, "")
            XCTAssertTrue(type == Double.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - Float
    
    func testGenericFloatValid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Float>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<Float>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13.37)
    }
    
    func testGenericFloatInvalid() {
        let csvData = CSVData()
        let stringValue = "13-37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Float>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, "13-37")
            XCTAssertTrue(type == Float.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericFloatEmpty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Float>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, "")
            XCTAssertTrue(type == Float.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    // MARK: - Int
    
    func testGenericIntValid() {
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Int>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<Int>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13)
    }
    
    func testGenericIntInvalid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Int>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, "13.37")
            XCTAssertTrue(type == Int.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericIntEmpty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Int>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
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
    
    func testGenericInt8Valid() {
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Int8>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<Int8>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13)
    }
    
    func testGenericInt8Invalid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Int8>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int8.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericInt8Empty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Int8>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
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
    
    func testGenericInt16Valid() {
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Int16>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<Int16>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13)
    }
    
    func testGenericInt16Invalid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Int16>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int16.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericInt16Empty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Int16>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
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
    
    func testGenericInt32Valid() {
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Int32>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<Int32>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13)
    }
    
    func testGenericInt32Invalid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Int32>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int32.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericInt32Empty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Int32>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
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
    
    func testGenericInt64Valid() {
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<Int64>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<Int64>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13)
    }
    
    func testGenericInt64Invalid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Int64>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == Int64.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericInt64Empty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<Int64>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
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
    
    func testGenericUIntValid() {
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<UInt>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<UInt>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13)
    }
    
    func testGenericUIntInvalid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<UInt>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericUIntEmpty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<UInt>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
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
    
    func testGenericUInt8Valid() {
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<UInt8>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<UInt8>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13)
    }
    
    func testGenericUInt8Invalid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<UInt8>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt8.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericUInt8Empty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<UInt8>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
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
    
    func testGenericUInt16Valid() {
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<UInt16>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<UInt16>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13)
    }
    
    func testGenericUInt16Invalid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<UInt16>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt16.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericUInt16Empty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<UInt16>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
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
    
    func testGenericUInt32Valid() {
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<UInt32>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<UInt32>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13)
    }
    
    func testGenericUInt32Invalid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<UInt32>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt32.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericUInt32Empty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<UInt32>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
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
    
    func testGenericUInt64Valid() {
        let csvData = CSVData()
        let stringValue = "13"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        let resultUnderTest: KeyedGeneric<UInt64>
        do {
            resultUnderTest = try CSVDecoder().decode(KeyedGeneric<UInt64>.self, from: csvData)
        } catch let error {
            XCTFail("An error was thrown: \(error)"); return
        }
        
        XCTAssertEqual(resultUnderTest.decodedValue, 13)
    }
    
    func testGenericUInt64Invalid() {
        let csvData = CSVData()
        let stringValue = "13.37"
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<UInt64>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
            XCTAssertEqual(row, 0)
            XCTAssertEqual(csvValue, stringValue)
            XCTAssertTrue(type == UInt64.self)
            return
        } catch let error {
            XCTFail("Incorrect error was thrown: \(error)"); return
        }
        
        XCTFail("No error was thrown")
    }
    
    func testGenericUInt64Empty() {
        let csvData = CSVData()
        let stringValue = ""
        csvData.setValue(stringValue, forColumn: "decodedValue")
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<UInt64>.self, from: csvData)
        } catch let error as CSVDecoder.Error {
            guard case let .invalidValueForType(column, row, csvValue, type) = error else {
                XCTFail("Incorrect error was thrown: \(error)"); return
            }
            
            XCTAssertEqual(column, "decodedValue")
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
    
    func testGenericWithCustomComplexNotSupported() {
        struct CustomComplex: Decodable { let value: Double }
        
        let csvData = CSVData()
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<CustomComplex>.self, from: csvData)
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
    
    func testGenericWithCustomComplexOptionalNotSupported() {
        struct CustomComplex: Decodable { let value: Double }
        
        let csvData = CSVData()
        
        do {
            _ = try CSVDecoder().decode(KeyedGeneric<CustomComplex?>.self, from: csvData)
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
