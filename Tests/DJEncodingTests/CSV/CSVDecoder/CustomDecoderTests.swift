import XCTest
@testable import DJEncoding

class CustomDecoderTests: XCTestCase {
    
    func testCustomDecoder() {
        struct Complex: Decodable {
            let aTime: LapTime
        }
        
        struct LapTime: Decodable {
            let time: TimeInterval
        }
        
        let csvData = CSVData()
        csvData.setValue("13.37", forColumn: "aTime")
        
        let decoder = CSVDecoder()
        decoder.configuration
            .addCustomDecoder {
                LapTime(time: Double($0)!)
            }
        
        do {
            let result = try decoder.decode([Complex].self, from: csvData)
            XCTAssertEqual(result[0].aTime.time, 13.37)
        } catch let error {
            XCTFail("An error was thrown: \(error)")
        }
    }
    
    func testCustomDecoderThrows() {
        struct Complex: Decodable {
            let aTime: LapTime
        }
        
        struct LapTime: Decodable {
            let time: TimeInterval
        }
        
        enum CustomDecoderError: Error {
            case decodingFailed
        }
        
        let csvData = CSVData()
        csvData.setValue("23.42", forColumn: "aTime")
        
        let decoder = CSVDecoder()
        decoder.configuration
            .addCustomDecoder { (value) throws -> LapTime in
                throw CustomDecoderError.decodingFailed
            }
        
        do {
            _ = try decoder.decode([Complex].self, from: csvData)
            XCTFail("No error was thrown")
        } catch let error as CSVDecoder.Error {
            guard case let .customDecoderFailed(_, _, underlyingError) = error else {
                XCTFail("Wrong error was thrown"); return
            }
            XCTAssertEqual(CustomDecoderError.decodingFailed, underlyingError as? CustomDecoderError)
        } catch let error {
            XCTFail("Wrong error was thrown: \(error)")
        }
    }
    
}
