//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public final class XIBParser {
  var xibs: [String: (customClass: String?, module: String?)] = [:]

  public init() {}

  private class ParserDelegate: NSObject, XMLParserDelegate {
    fileprivate var fileOwnerClass: String?
    fileprivate var fileOwnerModule: String?

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String]) {
      if elementName == "placeholder" && attributeDict["placeholderIdentifier"] == "IBFilesOwner" {
        self.fileOwnerClass = attributeDict["customClass"]
        self.fileOwnerModule = attributeDict["customModule"]
      }
    }
  }

  public func addXIB(at path: Path) throws {
    let parser = XMLParser(data: try path.read())

    let delegate = ParserDelegate()
    parser.delegate = delegate
    parser.parse()

    let xibName = path.lastComponentWithoutExtension
    self.xibs[xibName] = (delegate.fileOwnerClass, delegate.fileOwnerModule)
  }

  public func parseDirectory(at path: Path) throws {
    let iterator = path.makeIterator()

    while let subPath = iterator.next() {
      if subPath.extension == "xib" {
        try addXIB(at: subPath)
      }
    }
  }
}
