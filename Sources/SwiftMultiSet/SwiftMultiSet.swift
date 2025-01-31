
/// A [MultiSet](https://en.wikipedia.org/wiki/Multiset) that represents a set of `Element`s.
/// A `MuliSet` behaves much like a `Set` except duplicates are permitted.
/// Duplicates are determined by the `Element`'s conformance to `Equatable` and `Hashable`.
///
/// The primary operations of `insert(_: count:)`, `remove(_: count:)`, and `contains(_:)` are O(1).
///
/// Maintinaing any information beyond the element's conformance `Hashable` is not guarenteed.
/// For example, if `Element` is a class, the elements' identities (determined with `===`) may not be maintained.
///
/// Conforms to `Sequence`, `ExpressibleByArrayLiteral`, `Equatable`, and `Hashable`.
/// Conditionally conforms to `Sendable` when `Element` is `Sendable`.
public struct MultiSet<Element: Hashable> {
	
	/// The total count of elements in the `MultiSet`, including duplicates.
	///
	/// Use `distinctCount` for the count ingnoring duplicates.
	/// Time Complexity: O(1)
	public private(set) var count: Int
	
	private var elementCounts: [Element: Int]
	
	/// Initializes an empty `Multiset` from another `Sequence`.
	///
	/// Time Complexity: O(1)
	public init() {
		self.count = 0
		self.elementCounts = [:]
	}
	
	/// Initializes a `Multiset` from another `Sequence`.
	///
	/// Time Complexity: O(n)
	public init(_ elements: some Sequence<Element>) {
		self.init()
		for element in elements {
			self.insert(element)
		}
	}
	
	/// Inserts `count` copies of `element`s into the `MultiSet` .
	///
	/// `count` defaults to `1` and must be non-negative.
	/// Time Complexity: O(1)
	public mutating func insert(_ element: Element, count: Int = 1) {
		precondition(count >= 0)
		self[countOf: element] += count
	}
	
	/// Removes `count` copies of `element`s from the `MultiSet` .
	///
	/// `count` defaults to `1` and must be non-negative.
	/// Removing more of an `element` than the `MultiSet` contains will result in a precondition failure.
	/// Time Complexity: O(1)
	public mutating func remove(_ element: Element, count: Int = 1) {
		precondition(count >= 0)
		precondition(self[countOf: element] >= count)
		self[countOf: element] -= count
	}
	
	/// Returns if the `MultiSet` contains `count` copies of `element`s .
	///
	/// `count` defaults to `1` and must be non-negative.
	/// Time Complexity: O(1)
	public func contains(_ element: Element, count: Int = 1) -> Bool {
		precondition(count >= 0)
		return self[countOf: element] >= count
	}
	
	/// Gets the number of duplicates of `element` in the `Multiset`.
	///
	/// The result will be `0` if `self` does not contain `element`.
	/// The result will never be negative.
	/// Time Complexity: O(1)
	public subscript(countOf element: Element) -> Int {
		_read {
			yield self.elementCounts[element, default: 0]
		}
		_modify {
			let oldValue = self.elementCounts[element, default: 0]
			yield &self.elementCounts[element, default: 0]
			let newValue = self.elementCounts[element, default: 0]
			precondition(newValue >= 0)
			self.count += (newValue - oldValue)
			if self.elementCounts[element] == 0 {
				self.elementCounts[element] = nil
			}
		}
	}
	
}

extension MultiSet {
	
	/// Whether the `MutliSet` contains any elements.
	///
	/// Time Complexity: O(1)
	public var isEmpty: Bool { count == 0 }
	
	/// The count of distinct elements in the `MultiSet`, ingnoring duplicates.
	///
	/// Use `count` for the count including duplicates.
	/// Time Complexity: O(1)
	public var distinctCount: Int { elementCounts.count }
	
	/// A `Sequence` of the distinct elements of the `MultiSet`.
	///
	/// This will contain `distintCount` elements.
	/// Time Complexity: O(1)
	public var distinctElements: some Sequence<Element> { elementCounts.keys }
	
}

extension MultiSet: Sequence {
	
	public func makeIterator() -> Iterator {
		return Iterator(self)
	}
	
	/// An iterator for a `MutliSet`.
	public struct Iterator: IteratorProtocol {
		
		private var dictionaryIterator: [Element: Int].Iterator
		private var current: (element: Element, remaining: Int)?
		
		fileprivate init(_ multiSet: MultiSet) {
			self.dictionaryIterator = multiSet.elementCounts.makeIterator()
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
	
	/// Initializes a `MultiSet` from an array literal.
	///
	/// Time Complexity: O(n)
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
	
}

extension MultiSet: Equatable { }

extension MultiSet: Hashable { }

extension MultiSet {
	
	/// Returns a `MultiSet` that represents the union of `self` and `other`.
	///
	/// The result contains the maximum number of duplicates of an element in either `self` or `other`.
	/// Time Complexity: O(self.distinctCount + other.distinctCount)
	public func union(_ other: MultiSet<Element>) -> MultiSet<Element> {
		var union = self
		union.formUnion(other)
		return union
	}
	
	/// Returns a `MultiSet` that represents the intersection of `self` and `other`.
	///
	/// The result contains the minimum number of duplicates of an element in either `self` or `other`.
	/// Time Complexity: O(other.distinctCount)
	public func intersection(_ other: MultiSet<Element>) -> MultiSet<Element> {
		var intersection = MultiSet<Element>()
		for element in other.distinctElements {
			intersection[countOf: element] = Swift.min(self[countOf: element], other[countOf: element])
		}
		return intersection
	}
	
	/// Mutates `self`to become the union of `self` and `other`.
	///
	/// `self` will contain the maximum number of duplicates of an element in either `self` or `other`.
	/// Time Complexity: O(other.distinctCount)
	public mutating func formUnion(_ other: MultiSet<Element>) {
		for element in other.distinctElements {
			self[countOf: element] = Swift.max(self[countOf: element], other[countOf: element])
		}
	}
	
	/// Mutates `self` to become the intersection of `self` and `other`.
	///
	/// `self` will contain the minimum number of duplicates of an element in either `self` or `other`.
	/// Time Complexity: O(self.distinctCount + other.distinctCount)
	public mutating func formIntersection(_ other: MultiSet<Element>) {
		self = self.intersection(other)
	}
	
}

extension MultiSet: CustomStringConvertible {
	
	public var description: String {
		"MultiSet(\(elementCounts.description))"
	}
	
}

extension MultiSet: Sendable where Element: Sendable { }
