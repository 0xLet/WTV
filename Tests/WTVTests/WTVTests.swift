import XCTest
@testable import WTV

final class WTVTests: XCTestCase {
    struct Dictionary {
        var value = [
            "someValue": [
                "what...?": 999
            ]
        ]
    }
    
    struct Value {
        let somes = Dictionary()
    }
    
    struct RootValue {
        let child: Value = Value()
    }
    
    struct OuterValue {
        let root = RootValue()
    }
    
    func testExample() {
        guard let output = WTV(OuterValue()).variable(named: "what...?") else {
            XCTFail()
            return
        }
        
        print(output)
        
        XCTAssert(output.contains("FOUND"))
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}
