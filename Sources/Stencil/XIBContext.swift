//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

/*
 - `xibs`: `Array` — List of xibs
   - `name`: `String` — Name of the xib
   - `owner`: `String` — The custom class of the scene
   - `customModule`: `String` — The custom module of the scene (absent if no custom class)
 */
extension XIBParser {
  public func stencilContext() -> [String: Any] {
    let xibNames = Set(xibs.keys).sorted(by: <)
    let xibsMap = xibNames.map { (xibName: String) -> [String: String] in
      guard let (owner, module) = xibs[xibName] else {
        return [:]
      }

      var xibInformation = ["name": xibName]
      xibInformation["customOwner"] = owner
      xibInformation["customModule"] = module
      return xibInformation
    }

    return ["xibs": xibsMap]
  }
}
