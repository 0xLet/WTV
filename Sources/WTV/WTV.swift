public struct WTV {
    public var value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
}

extension WTV {
    public func variable(named name: String) -> String? {
        let output = Mirror(reflecting: value).children
            .compactMap { (label: String?, value: Any) -> String? in
                variable(named: name, out: "\(type(of: self.value)) - ", child: (label, value))
            }
        
        guard !output.isEmpty else {
            return nil
        }
        
        return output.joined(separator: "\n")
    }
    
    private func variable(
        named name: String,
        out: String?,
        child: (label: String?, value: Any)
    ) -> String? {
        if let keyValue = child.value as? (key: AnyHashable, value: Any) {
            return variable(named: name, out: (out ?? "") + "Inside: \(keyValue.key) - ", child: (keyValue.key.description, keyValue.value))
        }
        
        guard let childName = child.label else {
            return nil
        }
        
        guard name != childName else {
            return (out ?? "-1") + "FOUND: \(child)"
        }
        
        let children = Mirror(reflecting: child.value).children
        guard !children.isEmpty else {
            return nil
        }
        
        let childrenOutput = children
            .compactMap { (label: String?, value: Any) -> String? in
                variable(named: name, out: (out ?? "") + "Inside: \(childName) - ", child: (label, value))
            }
        
        guard !childrenOutput.isEmpty else {
            return nil
        }
        
        return childrenOutput.joined(separator: "\n")
    }
}
