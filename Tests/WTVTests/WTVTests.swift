import XCTest
@testable import WTV

final class WTVTests: XCTestCase {
    enum Color: String, Hashable {
        case green
    }
    
    struct SomeObject {
        enum SomeCase {
            case what
        }
        
        enum SomeStringCase: String {
            case what
        }
        
        enum WoahCase {
            case woah(what: Any)
        }
        
        let dictionary = [
            SomeCase.what: "ðĻ", // ++
            SomeStringCase.what: "ðą" // ++
        ] as [AnyHashable : String]
        
        let what = "ð" // ++
        
        let woah = WoahCase.woah(
            what: {
                let what = "ðŦ"
                
                let dictionary = [
                    SomeCase.what: "ðŠĶ",
                    SomeStringCase.what: "ðĐ"
                ] as [AnyHashable : String]
            } // ++
        )
    }
    
    struct Dictionary {
        var value = [
            "someValue": [
                "what": "the", // ++
                "no": [
                    "what": "!!!", // ++
                    Color.green: [
                        2,5,6,7,
                        
                        [
                            "what": "ð", // ++
                            
                            "???": [
                                "what": "ð", // ++
                                "-->": SomeObject() // += 6
                            ]
                        ]
                    ]
                ]
            ]
        ]
    }
    
    struct Value {
        let somes = [
            "what": 3.14, // ++
            "deeper": Something()
        ] as [String : Any]
        
        let thing = Dictionary()
    }
    
    struct RootValue {
        let child: Value = Value()
    }
    
    struct OuterValue {
        let root = RootValue()
    }
    
    struct Something {
        let what = "else" // ++
        let wow = [
            "what": 3.14, // ++
        ]
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
        ("testExample", testExample)
    ]
}
