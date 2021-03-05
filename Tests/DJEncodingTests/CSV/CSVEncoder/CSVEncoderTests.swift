import XCTest
@testable import DJEncoding

class CSVEncoderTests: XCTestCase {

    func testSingleModel() {
        let dataToEncode = TestStruct1(
            prop1Boolean: true,
            prop2Int: 1337,
            prop3String: "Just text"
        )
        
        let expectedOutput = """
        "Col: Boolean","Col: Int","Col: String"
        "true","1337","Just text"
        """.data(using: .utf8)!
        
        let encoderUnderTest = CSVEncoder()
        let resultUnderTest = try! encoderUnderTest.encode(dataToEncode)
        
        XCTAssertEqual(resultUnderTest, expectedOutput)
    }
    
    func testArrayOfModels() {
        /*
         Log-output:
         
         _CSVEncoder.unkeyedContainer()
             _CSVUnkeyedEncodingContainer.encode(_:) value(TestStruct1)=TestStruct1(prop1Boolean: true, prop2Int: 1337, prop3String: "Just text")
                 _CSVEncoder.container(keyedBy:) keyedBy type=CodingKeys
                     _CSVKeyedEncodingContainer<CodingKeys>.encode(_:forKey:) value(Bool)=true key=CodingKeys(stringValue: "Col: Boolean", intValue: nil)
                     _CSVKeyedEncodingContainer<CodingKeys>.encode(_:forKey:) value(Int)=1337 key=CodingKeys(stringValue: "Col: Int", intValue: nil)
                     _CSVKeyedEncodingContainer<CodingKeys>.encode(_:forKey:) value(String)=Just text key=CodingKeys(stringValue: "Col: String", intValue: nil)
             _CSVUnkeyedEncodingContainer.encode(_:) value(TestStruct1)=TestStruct1(prop1Boolean: false, prop2Int: 2342, prop3String: "More text")
                 _CSVEncoder.container(keyedBy:) keyedBy type=CodingKeys
                     _CSVKeyedEncodingContainer<CodingKeys>.encode(_:forKey:) value(Bool)=false key=CodingKeys(stringValue: "Col: Boolean", intValue: nil)
                     _CSVKeyedEncodingContainer<CodingKeys>.encode(_:forKey:) value(Int)=2342 key=CodingKeys(stringValue: "Col: Int", intValue: nil)
                     _CSVKeyedEncodingContainer<CodingKeys>.encode(_:forKey:) value(String)=More text key=CodingKeys(stringValue: "Col: String", intValue: nil)
         */
        
        let dataToEncode = [
            TestStruct1(
                prop1Boolean: true,
                prop2Int: 1337,
                prop3String: "Just text"
            ),
            TestStruct1(
                prop1Boolean: false,
                prop2Int: 2342,
                prop3String: "More text"
            )
        ]
        
        let expectedOutput = """
        "Col: Boolean","Col: Int","Col: String"
        "true","1337","Just text"
        "false","2342","More text"
        """.data(using: .utf8)!
        
        let encoderUnderTest = CSVEncoder()
        let resultUnderTest = try! encoderUnderTest.encode(dataToEncode)
        
        XCTAssertEqual(resultUnderTest, expectedOutput)
    }
    
}

struct TestStruct1: Encodable {
    let prop1Boolean: Bool
    let prop2Int: Int
    let prop3String: String
    
    enum CodingKeys: String, CodingKey {
        case prop1Boolean = "Col: Boolean"
        case prop2Int = "Col: Int"
        case prop3String = "Col: String"
    }
}
