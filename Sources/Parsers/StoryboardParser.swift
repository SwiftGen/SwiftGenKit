//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit

public final class StoryboardParser: Parser {
  var storyboards = [Storyboard]()
  public var warningHandler: Parser.MessageHandler?

  public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
    self.warningHandler = warningHandler
  }

  public func parse(path: Path) throws {
    if path.extension == "storyboard" {
      try addStoryboard(at: path)
    } else {
      let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])

      for file in dirChildren where file.extension == "storyboard" {
        try addStoryboard(at: file)
      }
    }
  }

  func addStoryboard(at path: Path) throws {
    guard let document = Kanna.XML(xml: try path.read(), encoding: .utf8) else {
      throw ColorsParserError.invalidFile(path: path, reason: "Unknown XML parser error.")
    }

    let name = path.lastComponentWithoutExtension
    storyboards += [Storyboard(with: document, name: name)]
  }

  var modules: Set<String> {
    return Set<String>(storyboards.flatMap(collectModules(from:)))
  }

  private func collectModules(from storyboard: Storyboard) -> [String] {
    var result: [String] = storyboard.scenes.flatMap { $0.customModule } +
      storyboard.segues.flatMap { $0.customModule }

    if let module = storyboard.initialScene?.customModule {
      result += [module]
    }

    return result
  }

  var platform: String? {
    let platforms = Set<String>(storyboards.map { $0.platform })

    if platforms.count > 1 {
      return nil
    } else {
      return platforms.first
    }
  }

  func destination(for sceneID: String, in storyboard: Storyboard) -> Storyboard.Scene? {
    // directly to a scene
    if let scene = storyboard.scenes.first(where: { $0.sceneID == sceneID }) {
      return scene
    }

    // to a scene placeholder
    if let placeholder = storyboard.placeholders.first(where: { $0.sceneID == sceneID }),
      let storyboard = storyboards.first(where: { $0.name == placeholder.storyboardName }) {

      // can be either a scene by identifier, or the initial scene
      if let referencedIdentifier = placeholder.referencedIdentifier,
        let scene = storyboard.scenes.first(where: { $0.identifier == referencedIdentifier }) {
        return scene
      } else if placeholder.referencedIdentifier == nil {
        return storyboard.initialScene
      }
    }

    return nil
  }
}
