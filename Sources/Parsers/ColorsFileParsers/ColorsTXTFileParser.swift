//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

final class ColorsTextFileParser: ColorsFileTypeParser {
  static let extensions = ["txt"]

  private var colors = [String: UInt32]()

  private func addColor(named name: String, value: String) throws {
    try addColor(named: name, value: parse(hex: value, key: name))
  }

  private func addColor(named name: String, value: UInt32) {
    colors[name] = value
  }

  public func keyValueDict(from path: Path, withSeperator seperator: String = ":") throws -> [String:String] {
    let content = try path.read(.utf8)
    let lines = content.components(separatedBy: CharacterSet.newlines)
    let whitespace = CharacterSet.whitespaces
    let skippedCharacters = NSMutableCharacterSet()
    skippedCharacters.formUnion(with: whitespace)
    skippedCharacters.formUnion(with: skippedCharacters as CharacterSet)

    var dict: [String: String] = [:]
    for line in lines {
      let scanner = Scanner(string: line)
      scanner.charactersToBeSkipped = skippedCharacters as CharacterSet

      var key: NSString?
      var value: NSString?
      guard scanner.scanUpTo(seperator, into: &key) &&
        scanner.scanString(seperator, into: nil) &&
        scanner.scanUpToCharacters(from: whitespace, into: &value) else {
          continue
      }

      if let key: String = key?.trimmingCharacters(in: whitespace),
        let value: String = value?.trimmingCharacters(in: whitespace) {
        dict[key] = value
      }
    }

    return dict
  }

  private func colorValue(forKey key: String, onDict dict: [String: String]) -> String {
    var currentKey = key
    var stringValue: String = ""
    while let value = dict[currentKey]?.trimmingCharacters(in: CharacterSet.whitespaces) {
      currentKey = value
      stringValue = value
    }

    return stringValue
  }

  // Text file expected to be:
  //  - One line per entry
  //  - Each line composed by the color name, then ":", then the color hex representation
  //  - Extra spaces will be skipped
  func parseFile(at path: Path) throws -> Palette {
    do {
      let dict = try keyValueDict(from: path, withSeperator: ":")
      for key in dict.keys {
        try addColor(named: key, value: colorValue(forKey: key, onDict: dict))
      }
    } catch let error as ColorsParserError {
      throw error
    } catch let error {
      throw ColorsParserError.invalidFile(path: path, reason: error.localizedDescription)
    }

    let name = path.lastComponentWithoutExtension
    return Palette(name: name, colors: colors)
  }
}
