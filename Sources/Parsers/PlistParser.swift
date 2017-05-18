//
//  PlistParser.swift
//  SwiftGenKit
//
//  Created by Toshihiro Suzuki on 4/12/17.
//  Copyright © 2017 SwiftGen. All rights reserved.
//

import Foundation
import PathKit

// Replace special characters with "_"
private func format(_ string: String) -> String {
  return string.characters.map { String($0) }.map { c in
    guard ("a"..<"z").contains(c) || ("A"..<"Z").contains(c) || ("0"..<"9").contains(c) else {
      return "_"
    }
    return c
  }.joined()
}

public final class PlistParser {

  var stringKeys: [Meta] = []
  var intKeys: [Meta] = []
  var boolKeys: [Meta] = []
  var dateKeys: [Meta] = []
  var dataKeys: [Meta] = []
  var arrayKeys: [Meta] = []
  var dictKeys: [Meta] = []
  var unknownKeys: [Meta] = []
  var isEmpty: Bool {
    return stringKeys.isEmpty && intKeys.isEmpty && boolKeys.isEmpty &&
      dateKeys.isEmpty && dataKeys.isEmpty && arrayKeys.isEmpty && dictKeys.isEmpty &&
      unknownKeys.isEmpty
  }

  struct Meta {
    let key: String
    init(key: String) {
      self.key = format(key)
    }
  }

  public init() {}

  public func parse(at path: Path) {
    load(at: path)
  }

  private func load(at path: Path) {
    guard let data = try? path.read() else {
      return
    }
    // try to parse plist
    guard let v = try? PropertyListSerialization.propertyList(from: data, format: nil),
      let values = v as? [String: Any] else {
        return
    }

    for (k, v) in values {
      switch v {
      case is NSString:
        stringKeys.append(Meta(key: k))
      case is NSInteger:
        // Integer need to be parsed before Bool
        intKeys.append(Meta(key: k))
      case is Bool:
        boolKeys.append(Meta(key: k))
      case is Date:
        dateKeys.append(Meta(key: k))
      case is Data:
        dataKeys.append(Meta(key: k))
      case is NSArray:
        arrayKeys.append(Meta(key: k))
      case is [String: Any]:
        dictKeys.append(Meta(key: k))
      default:
        unknownKeys.append(Meta(key: k))
      }
    }
  }
}
