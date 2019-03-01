//
//  ID3Memory.swift
//
//  Created by Rocky Wei on 2017-10-11.
//  Copyright © 2017 Rocky Wei. All rights reserved.
//

import Foundation

public struct ID3EvaluationSheet {
  public var gain = 0.0
  public var distribution: [String: Double] = [:]
  public var sorted: [String] {
    return distribution.map { ($0, self.gain - $1) }.sorted(by: { $0.1 > $1.1} ).map { $0.0 }
  }
}

open class DTBuilderID3Memory {
    
    /*
    public static func Build(_ `for`: String, from: [[String: String]], tag: String = "") throws -> DecisionTree {
        guard let tree = try buildRecursively(`for`, from: from) as? DecisionTree else {
            throw DecisionTree.Exception.GeneralFailure
        }
        return tree
    }
*/
  /// Build a decision tree node recursively.
  public static func buildRecursively(_ topValue: String, from table: [[String: String]]) throws -> Any {
    // Obtain top branch and possible paths gains
    let factors = try Evaluate(topValue, from: table)
    print("\nfactors: \(factors)\n")
    
    // If top gain is 0, finish
    guard factors.gain > 0 else {
      guard let firstLine = table.first,
        let firstValue = firstLine[topValue] else {
          throw DecisionTree.Exception.UnexpectedValue
      }
      return firstValue
    }
    
    // Checks for the value with biggest gain
    guard let primary = factors.sorted.first else {
      throw DecisionTree.Exception.UnexpectedKey
    }
    print("\nBeggest gain path: \(primary)\n")
    
    var subviews: [String: [[String: String]]] = [:]
    for row in table {
      var tempRow = row
      guard let value = tempRow.removeValue(forKey: primary) else {
        throw DecisionTree.Exception.UnexpectedKey
      }
      if subviews[value] != nil {
        subviews[value]?.append(tempRow)
      } else {
        subviews[value] = [tempRow]
      }
    }
    
    // Recursion for next levels
    var branches: [String: Any] = [:]
    for (value, view) in subviews {
      let branch = try buildRecursively(topValue, from: view)
      branches[value] = branch
    }
    return DecisionTree(primary, branches: branches)
  }

  /// evaluate all factors for a specific outcome
  /// - parameters:
  ///   - for: outcome field name
  ///   - from: data source
  /// - returns: an array of field names other than the outcome, sorted by its entropy
  /// - throws: Exceptions:
  ///   - EmptyDataset: when data source is empty
  ///   - UnexpectedKey: when data source hasn't a valid outcome field
    public static func Evaluate(_ topValue: String, from table: [[String: String]]) throws -> ID3EvaluationSheet {
    // Recover final responses off all data
    let responses: [String] = table.map { $0[topValue] ?? "" }
    print("responses: \(responses)")
    
    let entropy = Entropy(of: responses)
    
    // If entropy is 0.0, return
    guard entropy > 0.0 else {
      return ID3EvaluationSheet()
    }
    
    // Check if there are still rows
    guard let sample = table.first else {
      throw DecisionTree.Exception.EmptyDataset
    }
    
    // Declare keys array and check if key im making my tree for, exists
    let fields: [String] = sample.keys.map { $0 }
    guard fields.contains(topValue) else {
      throw DecisionTree.Exception.UnexpectedKey
    }
    
    // Declare array of fields without main one and checks if it has more than one element
    let factors = fields.filter { $0 != topValue }
    guard factors.count > 1 else {
      throw DecisionTree.Exception.EmptyColumnset
    }
    
    // Calculate gain for each factor
    var gains: [String: Double] = [:]
    for factor in factors {
      gains[factor] = try Entropy(of: factor, for: topValue, from: table)
    }
        
    // Return struct of type ID3EvaluationSheet
    return ID3EvaluationSheet(gain: entropy, distribution: gains)
  }

  /// calculate the entropy of a specific column / field
  public static func Entropy(of: [String]) -> Double {
    let distribution = Possibility(of: of)
    // Use Entropy formula
    let entropy = distribution.reduce(0) { $0 - $1.value * log2($1.value) }
    print("Entropy:  \(entropy)")
    return entropy
  }

  // Calculate the conditional entropy of two columns
  public static func Entropy(of: String, for topValue: String, from table: [[String: String]]) throws -> Double {
    
    // Makes subviews for every posible decision to create next branch division
    var subview: [String:[String]] = [:]
    for row in table {
        
        // Checks if a row with decision exists
      if let column = row[of], let decision = row[topValue] {
        
        // Checks if subview for new alue exists, then appends its final decision or creates a new subview
        if subview[column] != nil {
          subview[column]?.append(decision)
        } else {
          subview[column] = [decision]
        }
        
      } else {
        throw DecisionTree.Exception.UnexpectedKey
      }
    }
    
    print("\nsubview:  \(subview)\n")
    
    // Obtain entropies for each possible path
    let subEntropies = Dictionary(uniqueKeysWithValues: subview.map { ($0, Entropy(of: $1)) })
    print("\nsubEntropies:  \(subEntropies)\n")

    // Obtain possible paths, its final decision frecuencies and total decision frecuencies
    let possiblePaths: [String] = subview.keys.map { $0 }
    let possiblePathsFrequencies = Dictionary(uniqueKeysWithValues:
      subview.map { ($0.key, $0.value.count)})
    let totalFrecuencies = Double(possiblePathsFrequencies.reduce(0) { $0 + $1.value })
    // Distribution of sub branches
    let distribution: [String: Double] = Dictionary(uniqueKeysWithValues: possiblePathsFrequencies.map {
      ($0, Double($1) / totalFrecuencies) })
    
    // Sum all sub entropies
    var subEntropiesSum = 0.0
    for path in possiblePaths {
      if let i = distribution[path], let j = subEntropies[path] {
        subEntropiesSum += (i * j)
      }
    }
    return subEntropiesSum
  }

  // Generate possibility distribution based on frequency
  public static func Possibility(of: [String]) -> [String: Double] {
    let counters = Frequency(of: of)
    // Counts total values ocurrences
    let total = Double(counters.reduce(0) { $0 + $1.value })
    print("total: \(total)")
    // Cretes new dictionary:
    // keys = given frequency keys
    // values = given values between total
    let distribution = Dictionary(uniqueKeysWithValues: counters.map {
      ($0, Double($1) / total)
    })
    print("\ndistribution: \(distribution)\n")
    return distribution
  }

  // Counts the number of times each element appears in column and returns a dicctionary with name and appearances
  public static func Frequency(of: [String]) -> [String: Int] {
    var counters : [String: Int] = [:]
    of.forEach { value in
      if let existing = counters[value] {
        counters[value] = existing + 1
      } else {
        counters[value] = 1
      }
    }
    print("\nFrequency: \(counters)\n")
    return counters
  }

}
