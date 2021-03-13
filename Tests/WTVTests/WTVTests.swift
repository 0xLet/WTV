import XCTest
@testable import WTV

final class WTVTests: XCTestCase {
    enum Color: String, Hashable {
        case green
    }
    
    struct Dictionary {
        var value = [
            "someValue": [
                "what": "the", // ++
                "no": [
                    "what": "!!!", // ++
                    Color.green: [
                        2,5,6,7,
                        
                        ["what": "👋"] // ++
                    ]
                ]
            ]
        ]
    }
    
    struct Value {
        let somes = [
            Dictionary(), // += 3
            
            "what",
            "the",
            "variable",
            
            [
                "what": 3.14 // ++
            ],
            Dictionary() // += 3
        ] as [Any]
    }
    
    struct RootValue {
        let child: Value = Value()
    }
    
    struct OuterValue {
        let root = RootValue()
    }
    
    func testExample() {
        guard let output = WTV(OuterValue()).variable(named: "what") else {
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
