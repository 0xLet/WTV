import Foundation

public struct WTV {
    public var value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    public func variable(named name: String) -> String? {
        variable(named: name,
                 compareMethod: .equals,
                 depth: 0)
    }
    
    public func variable(nameContains name: String) -> String? {
        variable(named: name,
                 compareMethod: .contains,
                 depth: 0)
    }
}

extension WTV {
    private enum Comparison {
        case equals
        case contains
    }
    
    private func variable(
        named name: String,
        compareMethod: Comparison,
        depth: Int = 0,
        shouldIncludeChildName: Bool = true
    ) -> String? {
        let output = Mirror(reflecting: value).children
            .compactMap { (label: String?, value: Any) -> String? in
                variable(named: name,
                         compareMethod: compareMethod,
                         out: "\(String(repeating: "\t", count: depth))\(type(of: self.value))",
                         depth: depth,
                         child: (label, value),
                         shouldIncludeChildName: shouldIncludeChildName)
            }
        
        guard !output.isEmpty else {
            return nil
        }
        
        return  output.joined(separator: "\n")
    }
    
    private func variable(
        named name: String,
        compareMethod: Comparison,
        out: String?,
        depth: Int = 0,
        child: (label: String?, value: Any),
        shouldIncludeChildName: Bool = true
    ) -> String? {
        if let keyValue = child.value as? (key: AnyHashable, value: Any) {
            return variable(named: name,
                            compareMethod: compareMethod,
                            out: (out ?? "") + "[\(keyValue.key is String ? "\"\(keyValue.key)\"" : keyValue.key)]",
                            depth: depth,
                            child: (keyValue.key.description, keyValue.value),
                            shouldIncludeChildName: false)
        } else if let keyValue = child.value as? [Any] {
            let output = keyValue.enumerated()
                .compactMap { (index: Int, value: Any) -> String? in
                    guard let wtvOutput = WTV(value).variable(named: name,
                                                              compareMethod: compareMethod,
                                                              depth: depth + 1,
                                                              shouldIncludeChildName: true) else {
                        return nil
                    }
                    
                    return self.output(out,
                                       appending: (
                                        child.label.map { shouldIncludeChildName ? ".\($0)[\(index)] = [\n" : "[\(index)] = [\n" } ?? "") +
                                        "\(wtvOutput)\n" +
                                        "\(String(repeating: "\t", count: depth))]"
                    )
                }
            
            guard !output.isEmpty else {
                return nil
            }
            
            return output.joined(separator: "\n")
        }
        
        guard let childName = child.label else {
            return nil
        }
        
        switch compareMethod {
        case .equals:
            if name == childName {
                return (out ?? "-1") + "\(shouldIncludeChildName ? ".\(childName)" : "") 👉 FOUND: \(child)"
            }
        case .contains:
            if childName.contains(name) {
                return (out ?? "-1") + "\(shouldIncludeChildName ? ".\(childName)" : "") 👉 FOUND: \(child)"
            }
        }
        
        let childrenOutput = Mirror(reflecting: child.value).children
            .compactMap { (label: String?, value: Any) -> String? in
                variable(named: name,
                         compareMethod: compareMethod,
                         out: output(out, appending: shouldIncludeChildName ? ".\(childName)" : ""),
                         depth: depth,
                         child: (label, value))
            }
        
        if childrenOutput.isEmpty {
            return nil
        }
        
        return childrenOutput.joined(separator: "\n")
    }
    
    private func output(_ out: String?, appending: String) -> String {
        (out ?? "") + appending
    }
}
