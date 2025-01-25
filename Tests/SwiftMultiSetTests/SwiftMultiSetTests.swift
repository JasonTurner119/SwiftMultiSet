import Testing
@testable import SwiftMultiSet

// MARK: Basic Operations

@Test func emptySet() async throws {
	let set: MultiSet<Int> = []
	#expect(set.isEmpty)
	#expect(set.count == 0)
}

@Test func insertionDeletion() async throws {
	var set: MultiSet<Int> = []
	#expect(set.count == 0 && set.distinctCount == 0)
	set.insert(23)
	set.insert(100, count: 10)
	#expect(set.count == 11 && set.distinctCount == 2)
	set.remove(100, count: 9)
	set.insert(23, count: 2)
	#expect(set.count == 4 && set.distinctCount == 2)
	set.remove(100)
	set.remove(23)
	set.remove(23, count: 2)
	#expect(set.count == 0 && set.distinctCount == 0)
}

@Test func subscripting() async throws {
	var set: MultiSet<Int> = []
	#expect(set.count == 0 && set.distinctCount == 0)
	set.insert(23)
	#expect(set[23] == 1)
	#expect(set[24] == 0)
	set.insert(100, count: 10)
	#expect(set[100] == 10)
	set[100] = 0
	set[23] += 10
	#expect(set[100] == 0)
	#expect(set[23] == 11)
}

@Test func iteration() async throws {
	let set: MultiSet = [1, 5, 2, 7, 4, 2]
	let array = Array(set)
	#expect(array.count == 6)
	#expect(MultiSet(array) == set)
	let other = set.map { $0 }
	#expect(array.sorted() == other.sorted())
}

// MARK: Equatable & Hashable

@Test func equatableNoDuplicates() async throws {
	let first: MultiSet = [1, 2, 3, 5, 9]
	let second: MultiSet = [3, 1, 2, 5, 9]
	#expect(first == second)
	#expect(first.hashValue == second.hashValue)
}

@Test func equatableDuplicates() async throws {
	let first: MultiSet = [1, 2, 2, 3, 3, 5, 9]
	let second: MultiSet = [3, 2, 1, 2, 5, 3, 9]
	#expect(first == second)
	#expect(first.hashValue == second.hashValue)
}

@Test func equatableEmpty() async throws {
	let first: MultiSet<Int> = []
	let second: MultiSet<Int> = []
	#expect(first == second)
	#expect(first.hashValue == second.hashValue)
}

// MARK: Intersection

@Test func emptySetIntersection() async throws {
	let first: MultiSet<Int> = []
	let second: MultiSet<Int> = []
	let intersection = first.intersection(second)
	#expect(intersection == [])
	#expect(intersection.count == 0)
	#expect(intersection.distinctCount == 0)
}

@Test func noIntersection() async throws {
	let first: MultiSet = [1, 2, 3, 4, 5]
	let second: MultiSet = [6, 7, 8, 9, 10]
	let intersection = first.intersection(second)
	#expect(intersection == [])
	#expect(intersection.count == 0)
	#expect(intersection.distinctCount == 0)
}

@Test func partialIntersection() async throws {
	let first: MultiSet = [1, 2, 3, 3, 5, 9]
	let second: MultiSet = [2, 1, 2, 3, 3]
	let intersection = first.intersection(second)
	#expect(intersection == [1, 2, 3, 3])
	#expect(intersection.count == 4)
	#expect(intersection.distinctCount == 3)
}

@Test func totalIntersection() async throws {
	let first: MultiSet = [1, 2, 2, 3, 3, 5, 9]
	let second: MultiSet = [3, 2, 1, 2, 5, 3, 9]
	let intersection = first.intersection(second)
	#expect(intersection == [1, 2, 2, 3, 3, 5, 9])
	#expect(intersection.count == 7)
	#expect(intersection.distinctCount == 5)
}

@Test func formEmptySetIntersection() async throws {
	var first: MultiSet<Int> = []
	let second: MultiSet<Int> = []
	first.formIntersection(second)
	#expect(first == [])
	#expect(first.count == 0)
	#expect(first.distinctCount == 0)
}

@Test func formNoIntersection() async throws {
	var first: MultiSet = [1, 2, 3, 4, 5]
	let second: MultiSet = [6, 7, 8, 9, 10]
	first.formIntersection(second)
	#expect(first == [])
	#expect(first.count == 0)
	#expect(first.distinctCount == 0)
}

@Test func formPartialIntersection() async throws {
	var first: MultiSet = [1, 2, 3, 3, 5, 9]
	let second: MultiSet = [2, 1, 2, 3, 3]
	first.formIntersection(second)
	#expect(first == [1, 2, 3, 3])
	#expect(first.count == 4)
	#expect(first.distinctCount == 3)
}

@Test func formTotalIntersection() async throws {
	var first: MultiSet = [1, 2, 2, 3, 3, 5, 9]
	let second: MultiSet = [3, 2, 1, 2, 5, 3, 9]
	first.formIntersection(second)
	#expect(first == [1, 2, 2, 3, 3, 5, 9])
	#expect(first.count == 7)
	#expect(first.distinctCount == 5)
}

// MARK: Union

@Test func emptySetUnion() async throws {
	let first: MultiSet<Int> = []
	let second: MultiSet<Int> = []
	let intersection = first.union(second)
	#expect(intersection == [])
	#expect(intersection.count == 0)
	#expect(intersection.distinctCount == 0)
}

@Test func nonOverlappingUnion() async throws {
	let first: MultiSet = [1, 2, 3, 4, 5]
	let second: MultiSet = [6, 7, 8, 9, 10]
	let intersection = first.union(second)
	#expect(intersection == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
	#expect(intersection.count == 10)
	#expect(intersection.distinctCount == 10)
}

@Test func partiallyOverlappingUnion() async throws {
	let first: MultiSet = [1, 2, 3, 3, 5, 9]
	let second: MultiSet = [2, 1, 2, 3, 3]
	let intersection = first.union(second)
	#expect(intersection == [1, 2, 2, 3, 3, 5, 9])
	#expect(intersection.count == 7)
	#expect(intersection.distinctCount == 5)
}

@Test func totallyOverlappingUnion() async throws {
	let first: MultiSet = [1, 2, 2, 3, 3, 5, 9]
	let second: MultiSet = [3, 2, 1, 2, 5, 3, 9]
	let intersection = first.union(second)
	#expect(intersection == [1, 2, 2, 3, 3, 5, 9])
	#expect(intersection.count == 7)
	#expect(intersection.distinctCount == 5)
}

@Test func formEmptySetUnion() async throws {
	var first: MultiSet<Int> = []
	let second: MultiSet<Int> = []
	first.formUnion(second)
	#expect(first == [])
	#expect(first.count == 0)
	#expect(first.distinctCount == 0)
}

@Test func formNonOverlappingUnion() async throws {
	var first: MultiSet = [1, 2, 3, 4, 5]
	let second: MultiSet = [6, 7, 8, 9, 10]
	first.formUnion(second)
	#expect(first == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
	#expect(first.count == 10)
	#expect(first.distinctCount == 10)
}

@Test func formPartiallyOverlappingUnion() async throws {
	var first: MultiSet = [1, 2, 3, 3, 5, 9]
	let second: MultiSet = [2, 1, 2, 3, 3]
	first.formUnion(second)
	#expect(first == [1, 2, 2, 3, 3, 5, 9])
	#expect(first.count == 7)
	#expect(first.distinctCount == 5)
}

@Test func formTotallyOverlappingUnion() async throws {
	var first: MultiSet = [1, 2, 2, 3, 3, 5, 9]
	let second: MultiSet = [3, 2, 1, 2, 5, 3, 9]
	first.formUnion(second)
	#expect(first == [1, 2, 2, 3, 3, 5, 9])
	#expect(first.count == 7)
	#expect(first.distinctCount == 5)
}
