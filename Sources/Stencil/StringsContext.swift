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
   - `name`   : `String` — name of the `.strings` file (usually `"Localizable"`)
   - `strings`: `Array` — Tree structure of strings (based on dot syntax), each level has:
     - `name`   : `String` — name of the level (that is, part of the key split by `.` that we're describing)
     - `strings`: `Array` — list of strings at this level:
       - `key`: `String` — the full translation key
       - `translation`: `String` — the translated text
       - `types`: `Array<String>` — defined only if localized string has parameter placeholders like `%d` and `%@` etc.
          Contains a list of types like `"String"`, `"Int"`, etc
       - `keytail`: `String` containing the rest of the key after the next first `.`
         (useful to do recursion when splitting keys against `.` for structured templates)
     - `subenums`: `Array` — list of sub-levels, repeating the structure mentioned above
*/
extension StringsFileParser {
  public func stencilContext(enumName: String = "L10n", tableName: String = "Localizable") -> [String: Any] {

    let entryToStringMapper = { (entry: Entry, keyPath: [String]) -> [String: Any] in
      var keyStructure = entry.keyStructure
      Array(0..<keyPath.count).forEach { _ in keyStructure.removeFirst() }
      let keytail = keyStructure.joined(separator: ".")

      var result: [String: Any] = [
        "key": entry.key.newlineEscaped,
        "translation": entry.translation.newlineEscaped,
        "keytail": keytail
      ]

      if entry.types.count > 0 {
        result["types"] = entry.types.map { $0.rawValue }

        // NOTE: params is deprecated
        result["params"] = [
          "types": entry.types.map { $0.rawValue },
          "count": entry.types.count,
          "declarations": entry.types.indices.map { "let p\($0)" },
          "names": entry.types.indices.map { "p\($0)" },
          "typednames": entry.types.enumerated().map { "p\($0): \($1.rawValue)" }
        ]
      }

      return result
    }

    let strings = entries
      .sorted { $0.key.caseInsensitiveCompare($1.key) == .orderedAscending }
      .map { entryToStringMapper($0, []) }
    let structuredStrings = structure(
      entries: entries,
      usingMapper: entryToStringMapper
    )
    let tables: [[String: Any]] = [[
      "name": tableName,
      "strings": structuredStrings
    ]]

    return [
      "tables": tables,

      // NOTE: These are deprecated variables
      "enumName": enumName,
      "param": ["enumName": enumName],
      "strings": strings,
      "structuredStrings": structuredStrings,
      "tableName": tableName
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

    var subenums: [[String: Any]] = []
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
      subenums.append(
          structure(entries: entriesInKeyPath,
                    atKeyPath: nextLevelKeyPath,
                    usingMapper: mapper)
      )
    }

    if !subenums.isEmpty {
      structuredStrings["subenums"] = subenums
    }

    return structuredStrings
  }
}
