import XCTest
@testable import DJEncoding

class LineReaderTests: XCTestCase {
    
    let lineDelimiter = "\n".data(using: .utf8)!
    
    func testOpenFileDoesNotThrow() throws {
        let lineReader = LineReader(fileUrl: Tools.FileURL.pirateIpsumTxt, lineDelimiter: lineDelimiter)
        try lineReader.openFile()
    }
    
    func testOpFileDoesThrowWithInvalidURL() {
        let probablyInvalidFileURL = URL(fileURLWithPath: "/tmp/\(UUID().uuidString)")
        let lineReader = LineReader(fileUrl: probablyInvalidFileURL, lineDelimiter: lineDelimiter)
        do  {
            try lineReader.openFile()
        } catch let error as LineReader.Error {
            guard case .failedToOpenFile(_) = error else {
                XCTFail("Wrong error was thrown: \(error)"); return
            }
        } catch let error {
            XCTFail("Wrong error was thrown: \(error)")
        }
    }
    
    func testReadFileWithOneLineNoNewlineAtEoF() throws {
        let lineReader = LineReader(fileUrl: Tools.FileURL.oneLineNoNewlineAtEoFTxt, lineDelimiter: lineDelimiter)
        try lineReader.openFile()
        var lines: [Data] = .init()
        while let line = lineReader.readNextLine() {
            lines.append(line)
        }
        
        XCTAssertEqual(lines.count, 1)
        let resultUnderTest = String(data: lines[0], encoding: .utf8)
        XCTAssertEqual(resultUnderTest, "Hello World!")
    }
    
    func testReadFileWithOneLineWithNewlineAtEoF() throws {
        let lineReader = LineReader(fileUrl: Tools.FileURL.oneLineWithNewlineAtEoFTxt, lineDelimiter: lineDelimiter)
        try lineReader.openFile()
        var lines: [Data] = .init()
        while let line = lineReader.readNextLine() {
            lines.append(line)
        }
        
        XCTAssertEqual(lines.count, 1)
        let resultUnderTest = String(data: lines[0], encoding: .utf8)
        XCTAssertEqual(resultUnderTest, "Hello World!")
    }
    
    func testReadEmptyFile() throws {
        let lineReader = LineReader(fileUrl: Tools.FileURL.emptyFileTxt, lineDelimiter: lineDelimiter)
        try lineReader.openFile()
        var lines: [Data] = .init()
        while let line = lineReader.readNextLine() {
            lines.append(line)
        }
        
        XCTAssertEqual(lines.count, 0)
    }
    
    func testReadEmptyFileWithThreeNewlines() throws {
        let lineReader = LineReader(fileUrl: Tools.FileURL.threeNewlinesTxt, lineDelimiter: lineDelimiter)
        try lineReader.openFile()
        var lines: [Data] = .init()
        while let line = lineReader.readNextLine() {
            lines.append(line)
        }
        
        XCTAssertEqual(lines.count, 3)
        XCTAssertEqual(lines, [Data(), Data(), Data()])
    }
    
    func testReadPirateIpsum() throws {
        let lineReader = LineReader(fileUrl: Tools.FileURL.pirateIpsumTxt, lineDelimiter: lineDelimiter)
        try lineReader.openFile()
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
