# SwiftGenKit CHANGELOG

---

## Master

Due to the removal of legacy code, there are a few breaking changes in this new version that affect both template writers as well as developers. We've provided a migration guide to help you through these changes, which you can find here:
[Migration Guide for 2.0](https://github.com/SwiftGen/SwiftGenKit/blob/master/Documentation/MigrationGuide.md#swiftgenkit-20-swiftgen-50)

### Bug Fixes

* Fixed color's hex value rounding error.  
  [Yusuke Onishi](https://github.com/yusuke024)
  [#19](https://github.com/SwiftGen/SwiftGenKit/pull/19)
* Improved format string regex to handle escaped "%"s that precede a variable.  
  [Tamas Lustyik](https://github.com/lvsti)
  [#29](https://github.com/SwiftGen/SwiftGenKit/pull/29)

### Breaking Changes

* Removed deprecated variables. See [SwiftGenKit#5](https://github.com/SwiftGen/SwiftGenKit/issues/5) for more information.   
  [David Jennes](https://github.com/djbe)
  [#35](https://github.com/SwiftGen/templates/issues/35)
  [#42](https://github.com/SwiftGen/templates/issues/42)

### New Features

* Throw an error if a format string has mismatching types for the same placeholde position.  
  [David Jennes](https://github.com/djbe)
  [#44](https://github.com/SwiftGen/SwiftGenKit/issues/44)

### Internal Changes

* Fix swiftlint errors on enum names not conforming to the Swift 3 syntax.  
  [Liquidsoul](https://github.com/liquidsoul)
  [#31](https://github.com/SwiftGen/SwiftGenKit/issues/31)
* Switch to a DOM-based XML parser.  
  [David Jennes](https://github.com/djbe)
  [#18](https://github.com/SwiftGen/templates/issues/18)
  [#38](https://github.com/SwiftGen/templates/issues/38)
* Images: switch back from `actool` to an internal parser to fix numerous issues with the former.  
  [David Jennes](https://github.com/djbe)
  [#43](https://github.com/SwiftGen/templates/issues/43)

## 1.1.0

### Bug Fixes

* Don't convert colors to the calibrated RGB color space if it isn't needed.
  [David Jennes](https://github.com/djbe)
  [#23](https://github.com/SwiftGen/SwiftGenKit/issues/23)

### New Features

* More variables have been deprecated, while new variables have been added.  
  [David Jennes](https://github.com/djbe)
  [#5](https://github.com/SwiftGen/SwiftGenKit/issues/5)
  [#13](https://github.com/SwiftGen/SwiftGenKit/issues/13)
  [#27](https://github.com/SwiftGen/SwiftGenKit/issues/27)
  [#33](https://github.com/SwiftGen/SwiftGenKit/issues/33)
  * The `strings`, `structuredStrings` and `tableName` have been replaced by `tables`, which is an array of string tables, each with a `name` and a `strings` property.
  * For each string, the `params` variable and it's subvariables (such as `names`, `count`, ...) have been replaced by `types`, which is an array of types.
  * `enumName`, `sceneEnumName` and `segueEnumName` have been replaced by `param.enumName`, `param.sceneEnumName` and `param.segueEnumName` respectively. Templates should provide a default value for these in case the variables are empty.
* Added the `path` variable to the fonts context (so that we can use it to genrate `Info.plist` entries and such).  
  [Olivier Halligon](https://github.com/AliGator)
  [#25](https://github.com/SwiftGen/SwiftGenKit/pull/25)
  
### Internal Changes

* Switch from Travis CI to Circle CI, clean up the Rakefile in the process.  
  [David Jennes](https://github.com/djbe)
  [#10](https://github.com/SwiftGen/SwiftGenKit/issues/10)
  [#28](https://github.com/SwiftGen/SwiftGenKit/issues/28)
* We can now re-generate the contexts used for testing by using the "Generate Contexts" Xcode scheme.  
  [David Jennes](https://github.com/djbe)
  [#14](https://github.com/SwiftGen/SwiftGenKit/issues/14)
* Documented the input & output of each parser.  
  [David Jennes](https://github.com/djbe)
  [#24](https://github.com/SwiftGen/SwiftGenKit/issues/24)

## 1.0.1

### Internal Changes

* Update `PathKit` dependency to 0.8.0

## 1.0.0

### Bug Fixes

* Asset catalog parser: ignore unsupported types (such as appiconset).  
  [David Jennes](https://github.com/djbe)
  [#7](https://github.com/SwiftGen/SwiftGenKit/issues/7)

### New Features

### Internal Changes

## Pre-1.0.0

_See SwitftGen's own CHANGELOG pre SwiftGen 4.2 version, before the refactoring that led us to split the code in frameworks_
