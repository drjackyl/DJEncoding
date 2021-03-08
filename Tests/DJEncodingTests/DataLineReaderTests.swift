import XCTest
@testable import DJEncoding

class DataLineReaderTests: XCTestCase {
    
    let lineDelimiter = "\n".data(using: .utf8)!
    
    func testReadDataWithOneLineNoNewlineAtEoF() throws {
        let data = Tools.FileURL.oneLineNoNewlineAtEoFTxt.load()
        let lineReader = DataLineReader(data: data, lineDelimiter: lineDelimiter)
        
        var lines: [Data] = .init()
        while let line = lineReader.readNextLine() {
            lines.append(line)
        }
        
        XCTAssertEqual(lines.count, 1)
        let resultUnderTest = String(data: lines[0], encoding: .utf8)
        XCTAssertEqual(resultUnderTest, "Hello World!")
    }
    
    func testReadDataWithOneLineWithNewlineAtEoF() throws {
        let data = Tools.FileURL.oneLineWithNewlineAtEoFTxt.load()
        let lineReader = DataLineReader(data: data, lineDelimiter: lineDelimiter)
        
        var lines: [Data] = .init()
        while let line = lineReader.readNextLine() {
            lines.append(line)
        }
        
        XCTAssertEqual(lines.count, 1)
        let resultUnderTest = String(data: lines[0], encoding: .utf8)
        XCTAssertEqual(resultUnderTest, "Hello World!")
    }
    
    func testReadDataOfEmptyFile() throws {
        let data = Tools.FileURL.emptyFileTxt.load()
        let lineReader = DataLineReader(data: data, lineDelimiter: lineDelimiter)
        
        var lines: [Data] = .init()
        while let line = lineReader.readNextLine() {
            lines.append(line)
        }
        
        XCTAssertEqual(lines.count, 0)
    }
    
    func testReadEmptyData() throws {
        let lineReader = DataLineReader(data: Data(), lineDelimiter: lineDelimiter)
        
        while let _ = lineReader.readNextLine() {
            XCTFail("No line should ever be readable from empty data")
        }
    }
    
    func testReadDataWithThreeNewlines() throws {
        let data = Tools.FileURL.threeNewlinesTxt.load()
        let lineReader = DataLineReader(data: data, lineDelimiter: lineDelimiter)
        
        var lines: [Data] = .init()
        while let line = lineReader.readNextLine() {
            lines.append(line)
        }
        
        XCTAssertEqual(lines.count, 3)
        XCTAssertEqual(lines, [Data(), Data(), Data()])
    }
    
    func testReadPirateIpsum() throws {
        let data = Tools.FileURL.pirateIpsumTxt.load()
        let lineReader = DataLineReader(data: data, lineDelimiter: lineDelimiter)
        
        var lines: [Data] = .init()
        while let line = lineReader.readNextLine() {
            lines.append(line)
        }
        
        XCTAssertEqual(47, lines.count)
        let expectedResult = "Deadlights killick nipper pirate spike pillage Letter of Marque mutiny smartly reef strike colors stern. Spike black jack blow the man down swab gally hulk marooned parley scallywag Yellow Jack bilge main sheet. Plunder spirits fathom quarter gunwalls Privateer flogging hogshead man-of-war bowsprit gangway heave down. Matey Barbary Coast chase guns boatswain fore black spot tackle splice the main brace Pirate Round draught mizzen wherry. Lateen sail port cackle fruit hogshead Sea Legs Admiral of the Black gibbet list barque lass spirits reef sails. Plunder lanyard clap of thunder American Main Sea Legs salmagundi weigh anchor swab walk the plank Privateer take"
        let resultUnderTest = String(data: lines.last!, encoding: .utf8)
        XCTAssertEqual(resultUnderTest, expectedResult)
    }
    
}
