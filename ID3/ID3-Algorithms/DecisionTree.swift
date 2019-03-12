//
//  DecisionTree.swift
//

import Foundation

// Decision Tree Node Structure
open class DecisionTree: CustomStringConvertible {

  // Key
  let _id: String

  // Inner data for subtrees, where id is the key of data record field
  // and the value can be either a discrete result or another tree node
  let _branches: [String: Any]

  // Convert the tree node into a string for printing
  public var description: String {
    return "{'\(_id)': \(_branches)}"
  }

  /// - parameters:
  ///   - id: key of data record field
  ///   - branches: subtrees
  public init(_ id: String, branches: [String: Any]) {
    _id = id
    _branches = branches
  }

  /// search for the decision by providing the data set
  /// - parameters:
  ///   - data: the data set to input
  /// - returns: a string value as a prediction
  /// - throws: exceptions
  public func search(_ data:[String: String]) throws -> String {
    if let value = data[_id] {
      if _branches[value] is DecisionTree,
        let node = _branches[value] as? DecisionTree {
        return try node.search(data)
      } else if _branches[value] is String,
        let result = _branches[value] as? String {
          return result
      } else {
        fatalError()
      }
    } else {
      fatalError()
    }
  }
}


/// General form of a decision tree builder
public protocol DecisionTreeBuilder {
  /// build a tree from a dictionary
  /// - parameters:
  ///   - for: outcome field name
  ///   - from: data source
  ///   - tag: optional, name of the data source
  /// - returns: a DecisionTree instance
  /// - throws: Exception
  static func Build(_ `for`: String, from: [[String: String]], tag: String) throws -> DecisionTree
}

