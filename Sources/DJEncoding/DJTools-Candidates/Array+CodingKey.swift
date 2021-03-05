extension Array where Element == CodingKey {
    func toString() -> String {
        "/" + self.map {
            if let intValue = $0.intValue {
                return "\(intValue)"
            } else {
                return $0.stringValue
            }
        }
        .joined(separator: "/")
    }
}
