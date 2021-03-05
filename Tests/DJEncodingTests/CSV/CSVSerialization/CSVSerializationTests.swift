import XCTest
@testable import DJEncoding

class CSVSerializationTests: XCTestCase {
    
    func testDeserialize5x5String() throws {
        let expectedResult = Tools.createCSVData(numberOfColumns: 5, numberOfRows: 5).toData()
        let csv = CSVSerialization()
        
        let resultUnderTest = try csv.deserialize(fileURL: Tools.FileURL.fiveByFiveString).toData()
        
        XCTAssertEqual(resultUnderTest, expectedResult)
    }
    
    func testDeserialize5x5Double() throws {
        let expectedResult = Tools.createCSVDataWithFloatingPointNumbers(numberOfColumns: 5, numberOfRows: 5).toData()
        let csv = CSVSerialization()
        
        let resultUnderTest = try csv.deserialize(fileURL: Tools.FileURL.fiveByFiveDouble).toData()
        
        XCTAssertEqual(resultUnderTest, expectedResult)
    }
    
    func testDeserialize5x5Int() throws {
        let expectedResult = Tools.createCSVDataWithIntegers(numberOfColumns: 5, numberOfRows: 5).toData()
        let csv = CSVSerialization()
        
        let resultUnderTest = try csv.deserialize(fileURL: Tools.FileURL.fiveByFiveInt).toData()
        
        XCTAssertEqual(resultUnderTest, expectedResult)
    }
    
    func testDeserializeEventResultUsingASCII() throws {
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
}
