//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

extension Storyboard {
  struct CustomType {
    let type: String
    let module: String
    var segues = Set<Segue>()
    var destinations = [Segue: Scene]()

    init(scene: Scene) {
      type = scene.customClass ?? ""
      module = scene.customModule ?? ""
    }

    mutating func add(segue: Segue, destination: Scene?, warningHandler: Parser.MessageHandler?) {
      segues.insert(segue)

      // store destination, or check it's at least the same type
      if let destination = destination {
        if let current = destinations[segue] {
          if !areEqual(current, destination) {
            let message = "warning: The segue with identifier '\(segue.identifier)' in \(module).\(type) has " +
              "multiple destination types: \(destination.customModule ?? "").\(destination.customClass ?? "") and " +
              "\(destination.customModule ?? "").\(destination.customClass ?? "")."
            warningHandler?(message, #file, #line)
          }
        } else {
          destinations[segue] = destination
        }
      }
    }

    private func areEqual(_ lhs: Scene, _ rhs: Scene) -> Bool {
      return lhs.tag != rhs.tag ||
            lhs.customClass != rhs.customClass ||
            lhs.customModule != rhs.customModule
    }
  }
}

extension StoryboardParser {
  var customSceneTypes: [Storyboard.CustomType] {
	var result: [String: Storyboard.CustomType] = [:]

    // collect scenes by custom type
    for storyboard in storyboards {
      for scene in storyboard.scenes where scene.customClass != nil {
        let key = "\(scene.customModule ?? "").\(scene.customClass ?? "")"
        var customType = result[key] ?? Storyboard.CustomType(scene: scene)

        for segue in scene.segues {
          let destination = self.destination(for: segue.destination, in: storyboard)
          customType.add(segue: segue, destination: destination, warningHandler: warningHandler)
        }

        result[key] = customType
      }
    }

    return result
      .sorted { $0.0 < $1.0 }
      .map { (_, value) in value }
  }
}
