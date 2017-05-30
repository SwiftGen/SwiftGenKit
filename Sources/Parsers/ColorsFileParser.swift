//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum ColorsParserError: Error, CustomStringConvertible {
  case duplicateExtensionParser(ext: String, existing: String, new: String)
  case invalidHexColor(string: String, key: String?)
  case invalidFile(path: Path, reason: String)
  case unsupportedFileType(path: Path, supported: [String])

  public var description: String {
    switch self {
    case .duplicateExtensionParser(let ext, let existing, let new):
      return "error: Parser \(new) tried to register the file type '\(ext)' already registered by \(existing)."
    case .invalidHexColor(let string, let key):
      let keyInfo = key.flatMap { " for key \"\($0)\"" } ?? ""
      return "error: Invalid hex color \"\(string)\" found\(keyInfo)."
    case .invalidFile(let path, let reason):
      return "error: Unable to parse file at \(path). \(reason)"
    case .unsupportedFileType(let path, let supported):
      return "error: Unsupported file type for \(path). " +
        "The supported file types are: \(supported.joined(separator: ", "))"
    }
  }
}

struct Palette {
  let name: String
  let colors: [String: UInt32]
}

protocol ColorsFileTypeParser: class {
  static var extensions: [String] { get }

  init()
  func parseFile(at path: Path) throws -> Palette
}

public final class ColorsFileParser {
  private var parsers = [String: ColorsFileTypeParser.Type]()
  var palettes = [Palette]()

  public init() throws {
    try register(parser: ColorsCLRFileParser.self)
    try register(parser: ColorsJSONFileParser.self)
    try register(parser: ColorsTextFileParser.self)
    try register(parser: ColorsXMLFileParser.self)
  }

  public func parseFile(at path: Path) throws {
    guard let parserType = parsers[path.extension?.lowercased() ?? ""] else {
      throw ColorsParserError.unsupportedFileType(path: path, supported: Array(parsers.keys))
    }

    let parser = parserType.init()
    let palette = try parser.parseFile(at: path)

    palettes += [palette]
  }

  func register(parser: ColorsFileTypeParser.Type) throws {
    for ext in parser.extensions {
      guard parsers[ext] == nil else {
        throw ColorsParserError.duplicateExtensionParser(ext: ext,
                                                         existing: String(describing: parsers[ext]!),
                                                         new: String(describing: parser))
      }
      parsers[ext] = parser
    }
  }
}

// MARK: - Private Helpers

func parse(hex hexString: String, key: String? = nil) throws -> UInt32 {
  let scanner = Scanner(string: hexString)

  let prefixLen: Int
  if scanner.scanString("#", into: nil) {
    prefixLen = 1
  } else if scanner.scanString("0x", into: nil) {
    prefixLen = 2
  } else {
    prefixLen = 0
  }

  var value: UInt32 = 0
  guard scanner.scanHexInt32(&value) else {
    throw ColorsParserError.invalidHexColor(string: hexString, key: key)
  }

  let len = hexString.lengthOfBytes(using: .utf8) - prefixLen
  if len == 6 {
    // There were no alpha component, assume 0xff
    value = (value << 8) | 0xff
  }

  return value
}

extension NSColor {
  var rgbColor: NSColor? {
    guard colorSpace.colorSpaceModel != .RGB else { return self }

    return usingColorSpaceName(NSCalibratedRGBColorSpace)
  }

  var hexValue: UInt32 {
    guard let rgb = rgbColor else { return 0 }

    let hexRed   = UInt32(round(rgb.redComponent   * 0xFF)) << 24
    let hexGreen = UInt32(round(rgb.greenComponent * 0xFF)) << 16
    let hexBlue  = UInt32(round(rgb.blueComponent  * 0xFF)) << 8
    let hexAlpha = UInt32(round(rgb.alphaComponent * 0xFF))

    return hexRed | hexGreen | hexBlue | hexAlpha
  }
}
