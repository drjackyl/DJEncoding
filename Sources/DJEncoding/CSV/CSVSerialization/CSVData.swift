import Foundation

public class CSVData {
    
    // MARK: - API
    
    /**
     Specifies the columns in the table.
     */
    private(set) var headerRow: [String] = .init()
    var numberOfRows: Int { valueRows.count }
    
    /**
     Points to the current row being edited.
     
     The row-pointer has been introduced to solve the problem of not knowing to which row a value should be added, when
     adding data from a `KeyedEncodingContainer`. There is probably a better way to do that and that might be improved
     at some point.
     */
    private(set) var currentRow: Int = 0
    
    func setValue(_ value: String, forColumn column: String) {
        let columnIndex = getOrCreateColumnInHeaderRow(column)
        var valueRow = getOrCreateValueRow(currentRow)
        setValue(value, forColumn: columnIndex, inRow: &valueRow)
        setValueRow(valueRow, forRow: currentRow)
    }
    
    /**
     Gets the value of a cell in a given column and row.
     
     The default value is an empty string. So if a cell is empty, it is represented by an empty string.
     */
    func getValueOfColumn(_ column: String, inRow row: Int? = nil) -> String? {
        let rowToQuery = row ?? currentRow
        guard let index = columnNameToIndex[column],
              rowToQuery < valueRows.count,
              index < valueRows[rowToQuery].count else {
            return nil
        }
        
        return valueRows[rowToQuery][index]
    }
    
    /**
     Moves the row-pointer to the next row
     
     The row-pointer has been introduced to solve the problem of not knowing to which row a value should be added, when
     adding data from a `KeyedEncodingContainer`. There is probably a better way to do that and that might be improved
     at some point.
     */
    func moveToNextRow() {
        currentRow += 1
    }
    
    /**
     Moves the row-pointer to the first row
     
     The row-pointer has been introduced to solve the problem of not knowing to which row a value should be added, when
     adding data from a `KeyedEncodingContainer`. There is probably a better way to do that and that might be improved
     at some point.
     */
    func moveToFirstRow() {
        currentRow = 0
    }
    
    func toData() -> Data {
        normalizeData()
        
        var csv: String = createCSVRowFromRow(headerRow)
        valueRows.forEach { valueRow in
            csv += "\n" + createCSVRowFromRow(valueRow)
        }
        
        return csv.data(using: .utf8) ?? Data()
    }
    
    // MARK: - Private
    
    /**
     Stores a dictionary of column-names to index of column in the header-row
     */
    private var columnNameToIndex: [String:Int] = .init()
    private var valueRows: [[String]] = .init()
    
    /**
     Gets the index of the column with the given name or creates a column and returns the index
     
     - parameter column: The column to get the index for.
     - returns: The index of the column with the given name
     */
    private func getOrCreateColumnInHeaderRow(_ column: String) -> Int {
        if let index = columnNameToIndex[column] {
            return index
        } else {
            headerRow.append(column)
            let columnIndex = headerRow.count - 1
            columnNameToIndex[column] = columnIndex
            return columnIndex
        }
    }
    
    private func getOrCreateValueRow(_ rowIndex: Int) -> [String] {
        if rowIndex < valueRows.count {
            return valueRows[rowIndex]
        } else {
            let numberOfMissingRows = (rowIndex + 1) - valueRows.count
            for _ in 0..<numberOfMissingRows {
                valueRows.append(.init())
            }
            return valueRows[rowIndex]
        }
    }
    
    private func setValue(_ value: String, forColumn columnIndex: Int, inRow valueRow: inout [String]) {
        if columnIndex < valueRow.count {
            valueRow[columnIndex] = value
        } else {
            let numberOfMissingIntermediateColumns = columnIndex - valueRow.count
            for _ in 0..<numberOfMissingIntermediateColumns {
                valueRow.append(.init())
            }
            valueRow.append(value)
        }
    }
    
    private func setValueRow(_ valueRow: [String], forRow rowIndex: Int) {
        if rowIndex < valueRows.count {
            valueRows[rowIndex] = valueRow
        } else {
            let numberOfMissingIntermediateRows = rowIndex - valueRows.count
            for _ in 0..<numberOfMissingIntermediateRows {
                valueRows.append(.init())
            }
            valueRows.append(valueRow)
        }
    }
    
    /**
     Ensures, all arrays are of the expected dimension
     */
    private func normalizeData() {
        let numberOfColumns = columnNameToIndex.keys.count
        
        if headerRow.count < numberOfColumns {
            let numberOfMissingColumns = headerRow.count - numberOfColumns
            for _ in 1...numberOfMissingColumns {
                headerRow.append(.init())
            }
        }
        
        for rowIndex in 0..<valueRows.count {
            var valueRow = valueRows[rowIndex]
            if numberOfColumns < valueRows.count {
                let numberofMissingColumns = valueRows.count - numberOfColumns
                for _ in 0..<numberofMissingColumns {
                    valueRow.append(.init())
                }
            }
            valueRows[rowIndex] = valueRow
        }
    }
    
    private func createCSVRowFromRow(_ row: [String]) -> String {
        return "\"\(row.joined(separator: "\",\""))\""
    }
}
