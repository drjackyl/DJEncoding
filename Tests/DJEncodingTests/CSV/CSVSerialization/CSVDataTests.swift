import XCTest
@testable import DJEncoding

class CSVDataTests: XCTestCase {
    
    // MARK: - Serialization
    
    func testSetValueForColumn() {
        let column = "Column"
        let value = "Value"
        
        let expectedData = """
        "\(column)"
        "\(value)"
        """.data(using: .utf8)
        
        let csvData = CSVData()
        csvData.setValue(value, forColumn: column)
        let resultUnderTest = csvData.toData()
        
        XCTAssertEqual(resultUnderTest, expectedData)
    }
    
    func testSetValuesForColumns() {
        let numberOfColumns = 10
        let columns = (0..<numberOfColumns).map { "Column \($0)" }
        let values = (0..<numberOfColumns).map { "Value \($0)" }
        
        let expectedData = """
        "\(columns.joined(separator: "\",\""))"
        "\(values.joined(separator: "\",\""))"
        """.data(using: .utf8)
        
        let csvData = CSVData()
        for index in 0..<numberOfColumns {
            csvData.setValue(values[index], forColumn: columns[index])
        }
        let resultUnderTest = csvData.toData()
        
        XCTAssertEqual(resultUnderTest, expectedData)
    }
    
    func testOverwriteValueInColumn() {
        let column1 = "Column 1"
        let column2 = "Column 2"
        let column3 = "Column 3"
        let value = "Value"
        let newValue = "New Value"
        
        let expectedData = """
        "\(column1)","\(column2)","\(column3)"
        "\(value)","\(newValue)","\(value)"
        """.data(using: .utf8)
        
        let csvData = CSVData()
        csvData.setValue(value, forColumn: column1)
        csvData.setValue(value, forColumn: column2)
        csvData.setValue(value, forColumn: column3)
        csvData.setValue(newValue, forColumn: column2)
        let resultUnderTest = csvData.toData()
        
        XCTAssertEqual(resultUnderTest, expectedData)
    }
    
    func testMultipleRows() {
        let numberOfColumns = 10
        let numberOfRows = 10
        let columns = (0..<numberOfColumns).map { "Column \($0)" }
        let values = (0..<numberOfRows).map { row in
            (0..<numberOfColumns).map { column in
                "\(row)/\(column)"
            }
        }
        
        let expectedDataString = """
        "\(columns.joined(separator: "\",\""))"
        \(values.map { row in
            "\"\(row.joined(separator: "\",\""))\""
        }.joined(separator: "\n"))
        """
        
        let expectedData = expectedDataString.data(using: .utf8)
        
        let csvData = CSVData()
        for rowIndex in 0..<values.count {
            for columnIndex in 0..<columns.count {
                csvData.setValue(values[rowIndex][columnIndex], forColumn: columns[columnIndex])
            }
            csvData.moveToNextRow()
        }
        let resultUnderTest = csvData.toData()
        
        XCTAssertEqual(resultUnderTest, expectedData)
    }
    
    
    
    
    
    // MARK: - Control
    
    func testMoveToNextRow() {
        let csvDataUnderTest = CSVData()
        
        let randomNumberOfMoves = Int.random(in: 3...10)
        for current in 0..<randomNumberOfMoves {
            XCTAssertEqual(current, csvDataUnderTest.currentRow)
            csvDataUnderTest.moveToNextRow()
        }
    }
    
    func testMoveToFirstRow() {
        let csvDataUnderTest = CSVData()
        
        let randomNumberOfMoves = Int.random(in: 3...10)
        for _ in 0..<randomNumberOfMoves {
            csvDataUnderTest.moveToNextRow()
        }
        csvDataUnderTest.moveToFirstRow()
        
        let resultUnderTest = csvDataUnderTest.currentRow
        
        XCTAssertEqual(resultUnderTest, 0)
    }
    
    
    
    
    
    // MARK: - Querying
    
    func testGetValueForColumnInRow() {
        let csvDataUnderTest = Tools.createCSVData(numberOfColumns: 5, numberOfRows: 5)
        
        let resultUnderTest = csvDataUnderTest.getValueOfColumn("Column 2", inRow: 2)
        
        XCTAssertEqual("2/2", resultUnderTest)
    }
    
    func testGetValueForColumnOutOfBoundsInRow() {
        let csvDataUnderTest = Tools.createCSVData(numberOfColumns: 2, numberOfRows: 2)
        
        let resultUnderTest = csvDataUnderTest.getValueOfColumn("Column 5", inRow: 0)
        
        XCTAssertEqual(nil, resultUnderTest)
    }
    
    func testGetValueForColumnInRowOutOfBounds() {
        let csvDataUnderTest = Tools.createCSVData(numberOfColumns: 3, numberOfRows: 3)
        
        let resultUnderTest = csvDataUnderTest.getValueOfColumn("Column 0", inRow: 5)
        
        XCTAssertEqual(nil, resultUnderTest)
    }
    
    func testGetValueForColumnInRowBothOutOfBoudns() {
        let csvDataUnderTest = Tools.createCSVData(numberOfColumns: 1, numberOfRows: 1)
        
        let resultUnderTest = csvDataUnderTest.getValueOfColumn("Column 5", inRow: 5)
        
        XCTAssertEqual(nil, resultUnderTest)
    }
    
    func testGetValueForColumnInCurrentRow() {
        let csvDataUnderTest = Tools.createCSVData(numberOfColumns: 7, numberOfRows: 5)
        
        let randomColumn = Int.random(in: 0..<7)
        let randomRow = Int.random(in: 0..<5)
        for _ in 0..<randomRow {
            csvDataUnderTest.moveToNextRow()
        }
        let resultUnderTest = csvDataUnderTest.getValueOfColumn("Column \(randomColumn)")
        
        XCTAssertEqual("\(randomRow)/\(randomColumn)", resultUnderTest)
    }
    
    func testNumberOfRows() {
        let csvDataUnderTest = Tools.createCSVData(numberOfColumns: 3, numberOfRows: 7)
        
        let resultUnderTest = csvDataUnderTest.numberOfRows
        
        XCTAssertEqual(resultUnderTest, 7)
    }
    
}
