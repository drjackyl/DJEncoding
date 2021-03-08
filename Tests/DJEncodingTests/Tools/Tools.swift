@testable import DJEncoding
import Foundation

class Tools {
    
    enum FileURL {
        // MARK: CSV-files
        static let fiveByFiveString = Bundle.module.url(forResource: "5x5-String", withExtension: "csv")!
        static let fiveByFiveInt = Bundle.module.url(forResource: "5x5-Int", withExtension: "csv")!
        static let fiveByFiveDouble = Bundle.module.url(forResource: "5x5-Double", withExtension: "csv")!
        static let eventResult = Bundle.module.url(forResource: "eventresult_35372000", withExtension: "csv")!
        
        // MARK: Text-files
        static let emptyFileTxt = Bundle.module.url(forResource: "EmptyFile", withExtension: "txt")!
        static let oneLineWithNewlineAtEoFTxt = Bundle.module.url(forResource: "OneLineWithNewlineAtEoF", withExtension: "txt")!
        static let oneLineNoNewlineAtEoFTxt = Bundle.module.url(forResource: "OneLineNoNewlineAtEoF", withExtension: "txt")!
        static let pirateIpsumTxt = Bundle.module.url(forResource: "PirateIpsum", withExtension: "txt")!
        static let threeNewlinesTxt = Bundle.module.url(forResource: "ThreeNewlines", withExtension: "txt")!
    }
    
    class func createCSVData(numberOfColumns: Int, numberOfRows: Int) -> CSVData {
        let columns = (0..<numberOfColumns).map { "Column \($0)" }
        let values = (0..<numberOfRows).map { row in
            (0..<numberOfColumns).map { column in
                "\(row)/\(column)"
            }
        }
        let csvData = CSVData()
        for rowIndex in 0..<values.count {
            for columnIndex in 0..<columns.count {
                csvData.setValue(values[rowIndex][columnIndex], forColumn: columns[columnIndex])
            }
            csvData.moveToNextRow()
        }
        csvData.moveToFirstRow()
        return csvData
    }
    
    class func createCSVDataWithFloatingPointNumbers(numberOfColumns: Int, numberOfRows: Int) -> CSVData {
        let columns = (0..<numberOfColumns).map { "Column \($0)" }
        let values = (0..<numberOfRows).map { row in
            (0..<numberOfColumns).map { column in
                "\(row).\(column)"
            }
        }
        let csvData = CSVData()
        for rowIndex in 0..<values.count {
            for columnIndex in 0..<columns.count {
                csvData.setValue(values[rowIndex][columnIndex], forColumn: columns[columnIndex])
            }
            csvData.moveToNextRow()
        }
        csvData.moveToFirstRow()
        return csvData
    }
    
    class func createCSVDataWithIntegers(numberOfColumns: Int, numberOfRows: Int) -> CSVData {
        precondition(numberOfRows < 100 && numberOfColumns < 100, "For unique combinations of rows and columns in the cell-value, the number of rows and columns must be limited to 100.")
        let columns = (0..<numberOfColumns).map { "Column \($0)" }
        let values = (0..<numberOfRows).map { row in
            (0..<numberOfColumns).map { column in
                "\(row * 100)\(column)"
            }
        }
        let csvData = CSVData()
        for rowIndex in 0..<values.count {
            for columnIndex in 0..<columns.count {
                csvData.setValue(values[rowIndex][columnIndex], forColumn: columns[columnIndex])
            }
            csvData.moveToNextRow()
        }
        csvData.moveToFirstRow()
        return csvData
    }
    
}

extension URL {
    func load() -> Data {
        try! Data(contentsOf: self)
    }
}
