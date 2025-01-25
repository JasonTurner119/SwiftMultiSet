
public struct MultiSet<Element: Hashable> {
	
	public private(set) var count: Int
	
	private var _counts: [Element: Int]
	
	public init() {
		self.count = 0
		self._counts = [:]
	}
	
	public init(_ elements: some Sequence<Element>) {
		self.init()
		for element in elements {
			self.insert(element)
		}
	}
	
	public mutating func insert(_ element: Element, count: Int = 1) {
		precondition(count >= 0)
		self[element] += count
	}
	
	public mutating func remove(_ element: Element, count: Int = 1) {
		precondition(self[element] >= count)
		self[element] -= count
	}
	
	public subscript(element: Element) -> Int {
		_read {
			yield self._counts[element, default: 0]
		}
		_modify {
			let oldValue = self._counts[element, default: 0]
			yield &self._counts[element, default: 0]
			let newValue = self._counts[element, default: 0]
			precondition(newValue >= 0)
			self.count += (newValue - oldValue)
			if self._counts[element] == 0 {
				self._counts[element] = nil
			}
		}
	}
	
}

extension MultiSet {
	
	public var isEmpty: Bool { count == 0 }
	public var distintCount: Int { _counts.count }
	public var distintElements: some Sequence<Element> { _counts.keys }
	
}

extension MultiSet: Sequence {
	
	public func makeIterator() -> Iterator {
		return Iterator(self)
	}
	
	public struct Iterator: IteratorProtocol {
		
		private var dictionaryIterator: [Element: Int].Iterator
		private var current: (element: Element, remaining: Int)?
		
		fileprivate init(_ multiSet: MultiSet) {
			self.dictionaryIterator = multiSet._counts.makeIterator()
			self.current = nil
		}
		
		public mutating func next() -> Element? {
			if self.current == nil {
				guard let next = self.dictionaryIterator.next() else { return nil }
				self.current = (element: next.key, remaining: next.value)
			}
			assert(self.current != nil)
			let result = self.current!.element
			self.current!.remaining -= 1
			if self.current!.remaining == 0 {
				self.current = nil
			}
			return result
		}
		
	}
	
}

extension MultiSet: ExpressibleByArrayLiteral {
	
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
	
}

extension MultiSet: Equatable {
	
	public static func == (lhs: MultiSet<Element>, rhs: MultiSet<Element>) -> Bool {
		guard lhs.count == rhs.count else { return false }
		guard lhs.distintCount == rhs.distintCount else { return false }
		for element in lhs.distintElements {
			if lhs[element] != rhs[element] { return false }
		}
		return true
	}
	
}

extension MultiSet: Hashable { }

extension MultiSet {
	
	public func union(_ other: MultiSet<Element>) -> MultiSet<Element> {
		var union = self
		for element in other.distintElements {
			union[element] = Swift.max(self[element], other[element])
		}
		return union
	}
	
	public func intersection(_ other: MultiSet<Element>) -> MultiSet<Element> {
		var intersection = MultiSet<Element>()
		for element in other.distintElements {
			intersection[element] = Swift.min(self[element], other[element])
		}
		return intersection
	}
	
	public mutating func formUnion(_ other: MultiSet<Element>) {
		self = self.union(other)
	}
	
	public mutating func formIntersection(_ other: MultiSet<Element>) {
		self = self.intersection(other)
	}
	
}

extension MultiSet: CustomStringConvertible {
	
	public var description: String {
		"MultiSet(\(_counts.description))"
	}
	
}

private extension Dictionary {
	
	func sorted<T: Comparable>(by mapping: (Element) -> T) -> [Element] {
		return self.sorted(by: { mapping($0) < mapping($1) })
	}
	
}
