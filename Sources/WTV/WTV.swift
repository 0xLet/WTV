public struct WTV {
    public var value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
}

extension WTV {
    public func variable(named name: String) -> String? {
        variable(named: name,
                 depth: 0)
    }
    
    private func variable(
        named name: String,
        depth: Int = 0
    ) -> String? {
        let output = Mirror(reflecting: value).children
            .compactMap { (label: String?, value: Any) -> String? in
                variable(named: name,
                         out: "\(String(repeating: "\t", count: depth))\(type(of: self.value))",
                         depth: depth,
                         child: (label, value))
            }
        
        guard !output.isEmpty else {
            return nil
        }
        
        return  output.joined(separator: "\n")
    }
    
    private func variable(
        named name: String,
        out: String?,
        depth: Int = 0,
        child: (label: String?, value: Any)
    ) -> String? {
        if let keyValue = child.value as? (key: AnyHashable, value: Any) {
            return variable(named: name,
                            out: (out ?? "") + "[\(keyValue.key is String ? "\"\(keyValue.key)\"" : keyValue.key)]",
                            depth: depth + 1,
                            child: (keyValue.key.description, keyValue.value))
        } else if let keyValue = child.value as? [Any] {
            let output = keyValue.enumerated()
                .compactMap { (index: Int, value: Any) -> String? in
                    guard let wtvOutput = WTV(value).variable(named: name,
                                                              depth: depth) else {
                        return nil
                    }
                    
                    return (out ?? "") + (child.label.map { ".\($0)[\(index)] = [\n\(String(repeating: "\t", count: depth + 1))" } ?? "") + wtvOutput + "\n\(String(repeating: "\t", count: depth))]"
                }
            
            guard !output.isEmpty else {
                return nil
            }
            
            return output.joined(separator: "\n")
        }
        
        guard let childName = child.label else {
            return nil
        }
        
        guard name != childName else {
            return (out ?? "-1") + " 👉 FOUND: \(child)"
        }
        
        let children = Mirror(reflecting: child.value).children
        guard !children.isEmpty else {
            return nil
        }
        
        let childrenOutput = children
            .compactMap { (label: String?, value: Any) -> String? in
                variable(named: name,
                         out: (out ?? "") + ".\(childName)",
                         child: (label, value))
            }
        
        guard !childrenOutput.isEmpty else {
            return nil
        }
        
        return childrenOutput.joined(separator: "\n\t")
    }
}
