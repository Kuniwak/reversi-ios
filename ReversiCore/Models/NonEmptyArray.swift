struct NonEmptyArray<T> {
    let first: T
    let rest: [T]


    init?<S: Collection>(_ array: S) where S.Element == T {
        guard let first = array.first else {
            return nil
        }
        self.first = first
        self.rest = Array(array.dropFirst())
    }


    func randomElement() -> T {
        // NOTE: toArray must return non-empty array, so the randomElement must return an element.
        self.toArray().randomElement()!
    }


    func toArray() -> [T] {
        var result = self.rest
        result.insert(self.first, at: 0)
        return result
    }
}