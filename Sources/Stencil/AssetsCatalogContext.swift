//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

/*
 - `catalogs`: `Array` — list of asset catalogs
   - `name`  : `String` — the name of the catalog
   - `assets`: `Array` — tree structure of items, each item either
     - represents a group and has the following entries:
       - `type` : `String` — "group"
       - `name` : `String` — name of the folder
       - `items`: `Array` — list of items, can be either groups, colors or images
     - represents a color asset, and has the following entries:
       - `type` : `String` — "color"
       - `name` : `String` — name of the color
       - `value`: `String` — the actual full name for loading the color
     - represents an image asset, and has the following entries:
       - `type` : `String` — "image"
       - `name` : `String` — name of the image
       - `value`: `String` — the actual full name for loading the image
*/
extension AssetsCatalogParser {
  public func stencilContext() -> [String: Any] {
    let catalogs = self.catalogs
      .sorted { lhs, rhs in lhs.name < rhs.name }
      .map { catalog -> [String: Any] in
        let entries = catalog.entries.sorted { lhs, rhs in
            if case let .group(lhsName, _) = lhs, case let .group(rhsName, _) = rhs {
                return lhsName < rhsName
            }
            if case let .color(lhsName, _) = lhs, case let .color(rhsName, _) = rhs {
                return lhsName < rhsName
            }
            if case let .image(lhsName, _) = lhs, case let .image(rhsName, _) = rhs {
                return lhsName < rhsName
            }
            return false
        }
        return [
          "name": catalog.name,
          "assets": structure(entries: entries)
        ]
    }

    return [
      "catalogs": catalogs
    ]
  }

  private func structure(entries: [Catalog.Entry]) -> [[String: Any]] {
    return entries.map { entry in
      switch entry {
      case let .group(name: name, items: items):
        return [
          "type": "group",
          "name": name,
          "items": structure(entries: items)
        ]
      case let .color(name: name, value: value):
        return [
          "type": "color",
          "name": name,
          "value": value
        ]
      case let .image(name: name, value: value):
        return [
          "type": "image",
          "name": name,
          "value": value
        ]
      }
    }
  }
}
