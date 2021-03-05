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
    
}
