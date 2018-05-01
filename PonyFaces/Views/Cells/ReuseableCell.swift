protocol ReusableCell: class {
    static var identifier: String { get }
}

extension ReusableCell {
    static var identifier: String { return String(describing: self) }
}
