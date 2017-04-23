//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

/*
 - `families`: `Array` — list of font families
   - `name` : `String` — name of family
   - `fonts`: `Array` — list of fonts in family
     - `name` : `String` — the font's postscript name
     - `path` : `String` — the path to the font, relative to the folder being scanned
     - `style`: `String` — the designer's description of the font's style, like bold, oblique, …
*/

extension FontsFileParser {
  public func stencilContext(enumName: String = "FontFamily") -> [String: Any] {
    // turn into array of dictionaries
    let families = entries.map { (name: String, family: Set<Font>) -> [String: Any] in
      let fonts = family.map { (font: Font) -> [String: String] in
        // Font
        return [
          "name": font.postScriptName,
          "path": font.filePath,
          "style": font.style,

          // NOTE: This is a deprecated variable
          "fontName": font.postScriptName
        ]
      }.sorted { $0["fontName"] ?? "" < $1["fontName"] ?? "" }
      // Family
      return [
        "name": name,
        "fonts": fonts
      ]
    }.sorted { $0["name"] as? String ?? "" < $1["name"] as? String ?? "" }

    return [
      "families": families,

      // NOTE: This is a deprecated variable
      "enumName": enumName,
      "param": ["enumName": enumName]
    ]
  }
}
