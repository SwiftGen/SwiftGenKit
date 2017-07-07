//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

private extension String {
  var newlineEscaped: String {
    return self
      .replacingOccurrences(of: "\n", with: "\\n")
      .replacingOccurrences(of: "\r", with: "\\r")
  }
}

/*
 - `tables`: `Array` — List of string tables
   - `name`  : `String` — name of the `.strings` file (usually `"Localizable"`)
   - `levels`: `Array` — Tree structure of strings (based on dot syntax), each level has:
     - `name`    : `String` — name of the level (that is, part of the key split by `.` that we're describing)
     - `children`: `Array` — list of sub-levels, repeating the same structure as a level
     - `strings` : `Array` — list of strings at this level:
       - `name` : `String` — contains only the last part of the key (after the last `.`)
         (useful to do recursion when splitting keys against `.` for structured templates)
       - `key`  : `String` — the full translation key, as it appears in the strings file
       - `translation`: `String` — the translation for that key in the strings file
       - `types`: `Array<String>` — defined only if localized string has parameter placeholders like `%d` and `%@` etc.
          Contains a list of types like `"String"`, `"Int"`, etc
*/
extension StringsParser {
  public func stencilContext() -> [String: Any] {
    let entryToStringMapper = { (entry: Entry, keyPath: [String]) -> [String: Any] in
      let levelName = entry.keyStructure.last ?? ""

      var result: [String: Any] = [
        "name": levelName,
        "key": entry.key.newlineEscaped,
        "translation": entry.translation.newlineEscaped
      ]

      if entry.types.count > 0 {
        result["types"] = entry.types.map { $0.rawValue }
      }

      return result
    }

    let tables = self.tables.map { name, entries in
      return [
        "name": name,
        "levels": structure(
          entries: entries,
          usingMapper: entryToStringMapper
        )
      ]
    }

    return [
      "tables": tables
    ]
  }

  private func normalize(_ string: String) -> String {
    let components = string.components(separatedBy: CharacterSet(charactersIn: "-_"))
    return components.map { $0.capitalized }.joined(separator: "")
  }

  typealias Mapper = (_ entry: Entry, _ keyPath: [String]) -> [String: Any]
  private func structure(
    entries: [Entry],
    atKeyPath keyPath: [String] = [],
    usingMapper mapper: @escaping Mapper) -> [String: Any] {

    var structuredStrings: [String: Any] = [:]

    let strings = entries
      .filter { $0.keyStructure.count == keyPath.count+1 }
      .sorted { $0.key.lowercased() < $1.key.lowercased() }
      .map { mapper($0, keyPath) }

    if !strings.isEmpty {
      structuredStrings["strings"] = strings
    }

    if let lastKeyPathComponent = keyPath.last {
      structuredStrings["name"] = lastKeyPathComponent
    }

    var children: [[String: Any]] = []
    let nextLevelKeyPaths: [[String]] = entries
      .filter({ $0.keyStructure.count > keyPath.count+1 })
      .map({ Array($0.keyStructure.prefix(keyPath.count+1)) })

    // make key paths unique
    let uniqueNextLevelKeyPaths = Array(Set(
      nextLevelKeyPaths.map { keyPath in
        keyPath.map({
          $0.capitalized.replacingOccurrences(of: "-", with: "_")
        }).joined(separator: ".")
      }))
      .sorted()
      .map { $0.components(separatedBy: ".") }

    for nextLevelKeyPath in uniqueNextLevelKeyPaths {
      let entriesInKeyPath = entries.filter {
        Array($0.keyStructure.map(normalize).prefix(nextLevelKeyPath.count)) == nextLevelKeyPath.map(normalize)
      }
      children.append(
          structure(entries: entriesInKeyPath,
                    atKeyPath: nextLevelKeyPath,
                    usingMapper: mapper)
      )
    }

    if !children.isEmpty {
      structuredStrings["children"] = children
    }

    return structuredStrings
  }
}
