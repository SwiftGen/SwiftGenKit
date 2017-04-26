# SwiftGenKit CHANGELOG

---

## Master

### Bug Fixes

* Fixed color's hex value rounding error.  
  [Yusuke Onishi](https://github.com/yusuke024)
  [#19](https://github.com/SwiftGen/SwiftGenKit/pull/19)

### Breaking Changes

_None_

### New Features

* More variables have been deprecated, while new variables have been added.  
  [David Jennes](https://github.com/djbe)
  [#13](https://github.com/SwiftGen/SwiftGenKit/issues/13)
  [#27](https://github.com/SwiftGen/SwiftGenKit/issues/27)
  * The `strings`, `structuredStrings` and `tableName` have been replaced by `tables`, which is an array of string tables, each with a `name` and a `strings` property.
  * For each string, the `params` variable and it's subvariables (such as `names`, `count`, ...) have been replaced by `types`, which is an array of types.
  * `enumName`, `sceneEnumName` and `segueEnumName` have been replaced by `param.enumName`, `param.sceneEnumName` and `param.segueEnumName` respectively. Templates should provide a default value for these in case the variables are empty.

### Internal Changes

* Switch from Travis CI to Circle CI, clean up the Rakefile in the process.  
  [David Jennes](https://github.com/djbe)
  [#10](https://github.com/SwiftGen/SwiftGenKit/issues/10)
  [#28](https://github.com/SwiftGen/SwiftGenKit/issues/28)

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
