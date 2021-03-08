import XCTest
@testable import DJEncoding

class CSVSerializationTests: XCTestCase {
    
    // MARK: - From File
    
    func testDeserialize5x5StringFromFile() throws {
        let expectedResult = Tools.createCSVData(numberOfColumns: 5, numberOfRows: 5).toData()
        let csv = CSVSerialization()
        
        let resultUnderTest = try csv.deserialize(fileURL: Tools.FileURL.fiveByFiveString).toData()
        
        XCTAssertEqual(resultUnderTest, expectedResult)
    }
    
    func testDeserialize5x5DoubleFromFile() throws {
        let expectedResult = Tools.createCSVDataWithFloatingPointNumbers(numberOfColumns: 5, numberOfRows: 5).toData()
        let csv = CSVSerialization()
        
        let resultUnderTest = try csv.deserialize(fileURL: Tools.FileURL.fiveByFiveDouble).toData()
        
        XCTAssertEqual(resultUnderTest, expectedResult)
    }
    
    func testDeserialize5x5IntFromFile() throws {
        let expectedResult = Tools.createCSVDataWithIntegers(numberOfColumns: 5, numberOfRows: 5).toData()
        let csv = CSVSerialization()
        
        let resultUnderTest = try csv.deserialize(fileURL: Tools.FileURL.fiveByFiveInt).toData()
        
        XCTAssertEqual(resultUnderTest, expectedResult)
    }
    
    func testDeserializeEventResultUsingASCIIFromFile() throws {
        let expectedNumberOfColumns = 35
        let expectedValueOfNameInRowFour = "Team SlowMo(tion)_099"
        
        let csv = CSVSerialization()
        csv.configuration
            .encoding(.ascii)
        
        let resultUnderTest = try csv.deserialize(fileURL: Tools.FileURL.eventResult)
        
        XCTAssertEqual(resultUnderTest.headerRow.count, expectedNumberOfColumns)
        
        let valueOfNameInRowFour = resultUnderTest.getValueOfColumn("Name", inRow: 47)
        XCTAssertEqual(valueOfNameInRowFour, expectedValueOfNameInRowFour)
    }
    
    // MARK: - From Data
    
    func testDeserialize5x5StringFromData() throws {
        let expectedResult = Tools.createCSVData(numberOfColumns: 5, numberOfRows: 5).toData()
        let csv = CSVSerialization()
        
        let resultUnderTest = try csv.deserialize(data: Tools.FileURL.fiveByFiveString.load()).toData()
        
        XCTAssertEqual(resultUnderTest, expectedResult)
    }
    
    func testDeserialize5x5DoubleFromData() throws {
        let expectedResult = Tools.createCSVDataWithFloatingPointNumbers(numberOfColumns: 5, numberOfRows: 5).toData()
        let csv = CSVSerialization()
        
        let resultUnderTest = try csv.deserialize(data: Tools.FileURL.fiveByFiveDouble.load()).toData()
        
        XCTAssertEqual(resultUnderTest, expectedResult)
    }
    
    func testDeserialize5x5IntFromData() throws {
        let expectedResult = Tools.createCSVDataWithIntegers(numberOfColumns: 5, numberOfRows: 5).toData()
        let csv = CSVSerialization()
        
        let resultUnderTest = try csv.deserialize(data: Tools.FileURL.fiveByFiveInt.load()).toData()
        
        XCTAssertEqual(resultUnderTest, expectedResult)
    }
    
    func testDeserializeEventResultUsingASCIIFromData() throws {
        let expectedNumberOfColumns = 35
        let expectedValueOfNameInRowFour = "Team SlowMo(tion)_099"
        
        let csv = CSVSerialization()
        csv.configuration
            .encoding(.ascii)
        
        let resultUnderTest = try csv.deserialize(data: Tools.FileURL.eventResult.load())
        
        XCTAssertEqual(resultUnderTest.headerRow.count, expectedNumberOfColumns)
        
        let valueOfNameInRowFour = resultUnderTest.getValueOfColumn("Name", inRow: 47)
        XCTAssertEqual(valueOfNameInRowFour, expectedValueOfNameInRowFour)
    }
    
}
