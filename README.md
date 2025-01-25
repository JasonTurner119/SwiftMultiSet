# SwiftMultiSet

A Swift package for a `MultiSet`.

A `MultiSet` is an unordered collection that has effcient insertion, removal, and membership testing similar to a `Set`.
Unlike a `Set`, however, a `MultiSet` can contain multiple duplicate elements.

## Basic Operations

* `insert(_: Element, count: Int = 1)`
  * insert `count` duplicates of the element into the `Multiset`.
  * O(1)
* `remvoe(_: Element, count: Int = 1)`
  * remove `count` duplicates of the element from the `Multiset`.
  * O(1)
* `contains(_: Element, count: Int = 1)`
  * returns a `Bool` indicating if there are `count` duplicates of the element in the `Multiset`.
  * O(1)
* `subscript(_: Element)`
  * returns the number of duplicates of the element in the `Multiset`.
  * O(1)
  
## Set Operations

* `union(_: MultiSet)`
  * returns the union of `self` and the parameter.
* `intersection(_: MultiSet)`
  * returns the intersection of `self` and the parameter.

## Example

**Find shared elements in Arrays:** 
```
func sharedElements(of first: [Int], and second: [Int]) -> [Int] {
  return Array(MultiSet(first).intersection(MultiSet(second)))
}
sharedElements(of: [1, 2, 2, 3, 3], and: [1, 2, 3, 3, 3]) == [1, 2, 3, 3]
```

## Installation

You can use `SwiftMultiSet` to an Xcode project by adding it to your project as a package using the link to this repository then importing `SwiftMultiSet` in your source files.

## License

This package is released under the [MIT License](https://en.wikipedia.org/wiki/MIT_License).
