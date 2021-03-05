import XCTest
@testable import DJEncoding

class CSVDecoderUnkeyedTests: XCTestCase {
    
    // MARK: - Array of Non-Primitives
    
    func testArrayOfKeyedPrimitives() {
        struct KeyedPrimitives: Decodable, Equatable {
            let aBool: Bool
            let aString: String
            let aDouble: Double
            let anInt: Int
        }
        
        let numberOfRows = Int.random(in: 3...10)
        let expectedResult = (0..<numberOfRows).map {
            KeyedPrimitives(aBool: $0 % 2 == 0, aString: "\($0)", aDouble: Double($0), anInt: $0)
        }
        
        let csvData = CSVData()
        expectedResult.forEach {
            csvData.setValue("\($0.aBool)", forColumn: "aBool")
            csvData.setValue($0.aString, forColumn: "aString")
            csvData.setValue("\($0.aDouble)", forColumn: "aDouble")
            csvData.setValue("\($0.anInt)", forColumn: "anInt")
            csvData.moveToNextRow()
        }
        csvData.moveToFirstRow()
        
        do {
            let resultUnderTest = try CSVDecoder().decode([KeyedPrimitives].self, from: csvData)
            XCTAssertEqual(expectedResult, resultUnderTest)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }
    
    func testArrayOfKeyedPrimitivesWithOptional() {
        struct KeyedPrimitives: Decodable, Equatable {
            let aBool: Bool
            let aString: String
            let aDouble: Double?
            let anInt: Int
        }
        
        let numberOfRows = Int.random(in: 3...10)
        let expectedResult = (0..<numberOfRows).map { int -> KeyedPrimitives in
            let even = int % 2 == 0
            let aDouble = even ? Optional<Double>(Double(int)) : Optional<Double>(nil)
            return KeyedPrimitives(aBool: even, aString: "\(int)", aDouble: aDouble, anInt: int)
        }
        
        let csvData = CSVData()
        expectedResult.forEach {
            csvData.setValue("\($0.aBool)", forColumn: "aBool")
            csvData.setValue($0.aString, forColumn: "aString")
            let aDouble = $0.aDouble == nil ? "" : "\($0.aDouble!)"
            csvData.setValue("\(aDouble)", forColumn: "aDouble")
            csvData.setValue("\($0.anInt)", forColumn: "anInt")
            csvData.moveToNextRow()
        }
        csvData.moveToFirstRow()
        
        do {
            let resultUnderTest = try CSVDecoder().decode([KeyedPrimitives].self, from: csvData)
            XCTAssertEqual(expectedResult, resultUnderTest)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }
    
}
