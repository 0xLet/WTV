# WTV

*Where's The Variable?*


```swift
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
```

> OuterValue - Inside: root - Inside: child - Inside: somes - Inside: value - Inside: someValue - Inside: someValue - Inside: what...? - FOUND: (label: Optional("what...?"), value: 999)
