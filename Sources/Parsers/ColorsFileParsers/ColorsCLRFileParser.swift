//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

final class ColorsCLRFileParser: ColorsFileTypeParser {
  static let extensions = ["clr"]

  private enum Keys {
    static let userColors = "UserColors"
  }

  func parseFile(at path: Path) throws -> Palette {
    if let colorsList = NSColorList(name: Keys.userColors, fromFile: path.string) {
      var colors = [String: UInt32]()

      for colorName in colorsList.allKeys {
        colors[colorName] = colorsList.color(withKey: colorName)?.hexValue
      }

      let name = path.lastComponentWithoutExtension
      return Palette(name: name, colors: colors)
    } else {
      throw ColorsParserError.invalidFile(path: path, reason: "Invalid color list")
    }
  }
}
