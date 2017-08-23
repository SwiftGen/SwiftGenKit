//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

private func uppercaseFirst(_ string: String) -> String {
  guard let first = string.characters.first else {
    return string
  }
  return String(first).uppercased() + String(string.characters.dropFirst())
}

/*
 - `modules`    : `Array<String>` — List of modules used by scenes and segues — typically used for "import" statements
 - `platform`   : `String` — Name of the target platform (only available if all storyboards target the same platform)
 - `storyboards`: `Array` — List of storyboards
    - `name`: `String` — Name of the storyboard
    - `platform`: `String` — Name of the target platform (iOS, macOS, tvOS, watchOS)
    - `initialScene`: `Dictionary` — Same structure as scenes item (absent if not specified)
    - `scenes`: `Array` - List of scenes
       - `identifier` : `String` — The scene identifier
       - `customClass`: `String` — The custom class of the scene (absent if generic UIViewController/NSViewController)
       - `customModule`: `String` — The custom module of the scene (absent if no custom class)
       - `baseType`: `String` — The base class type of the scene if not custom (absent if class is a custom class).
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `segues`: `Array` - List of segues
       - `identifier`: `String` — The segue identifier
       - `customClass`: `String` — The custom class of the segue (absent if generic UIStoryboardSegue)
       - `customModule`: `String` — The custom module of the segue (absent if no custom segue class)
*/
extension StoryboardParser {
  public func stencilContext() -> [String: Any] {
    let storyboards = self.storyboards
      .sorted { (lhs, rhs) in lhs.name < rhs.name }
      .map(map(storyboard:))

    return [
      "modules": modules.sorted(),
      "storyboards": storyboards,
      "customSceneTypes": customSceneTypes
        .map { map(customType: $0) },
      "platform": platform ?? ""
    ]
  }

  private func map(storyboard: Storyboard) -> [String: Any] {
    var result: [String: Any] = [
      "name": storyboard.name,
      "scenes": storyboard.scenes
        .filter { $0.identifier != "" }
        .sorted { $0.identifier < $1.identifier }
        .map { map(scene: $0) },
      "segues": storyboard.segues
        .filter { $0.identifier != "" }
        .sorted { $0.identifier < $1.identifier }
        .map { map(segue: $0, in: storyboard) },
      "platform": storyboard.platform
    ]

    if let scene = storyboard.initialScene {
      result["initialScene"] = map(scene: scene)
    }

    return result
  }

  private func map(scene: Storyboard.Scene, shallow: Bool = false) -> [String: Any] {
    var result: [String: Any] = shallow ? [:] : ["identifier": scene.identifier]

    if let customClass = scene.customClass {
      result["customClass"] = customClass
      result["customModule"] = scene.customModule ?? ""
    } else {
      result["baseType"] = uppercaseFirst(scene.tag)
    }

    return result
  }

  private func map(segue: Storyboard.Segue, in storyboard: Storyboard) -> [String: Any] {
    let scene = destination(for: segue.destination, in: storyboard)
    return map(segue: segue, destination: scene)
  }

  private func map(segue: Storyboard.Segue, destination: Storyboard.Scene?) -> [String: Any] {
    var result: [String: Any] = [
      "identifier": segue.identifier,
      "customClass": segue.customClass ?? "",
      "customModule": segue.customModule ?? ""
    ]

    if let destination = destination {
      result["destination"] = map(scene: destination, shallow: true)
    }

    return result
  }

  private func map(customType: Storyboard.CustomType) -> [String: Any] {
    return [
      "customClass": customType.type,
      "customModule": customType.module,
      "segues": customType.segues
        .sorted { $0.identifier < $1.identifier }
        .map { (segue) -> Any in
          let destination = customType.destinations[segue]
          return map(segue: segue, destination: destination)
        }
    ]
  }
}
