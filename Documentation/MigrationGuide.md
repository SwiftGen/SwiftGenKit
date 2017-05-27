## SwiftGenKit 2.0 (SwiftGen 5.0)

### For template writers:

#### Colors

- `enumName`: has been replaced by `param.enumName`, should provide default value.
- For each `color`:
  - `rgb` and `rgba`: can be composed from the other components.

#### Fonts

- `enumName`: has been replaced by `param.enumName`, should provide default value.
- For each `font`:
  - `fontName`: has been replaced by the `name` property.

#### Images

- `enumName`: has been replaced by `param.enumName`, should provide default value.
- `images`: just old, `catalogs` contains the structured information.

#### Storyboards

- `extraImports`: replaced by `modules` (https://github.com/AliSoftware/SwiftGen/pull/243)
- `sceneEnumName`: has been replaced by `param.sceneEnumName`, should provide default value.
- `segueEnumName`: has been replaced by `param.segueEnumName`, should provide default value.
- For each `scene`:
  - `isBaseViewController`: removed. You can replace it with a test for `baseType == "ViewController"`.

#### Strings

- `enumName`: has been replaced by `param.enumName`, should provide default value.
- `strings` and `structuredStrings`: replaced by `tables` array, where each table has a structured `levels` property.
- `tableName`: replaced by `tables` array, where each table has a `name` property.
- for each `level`:
  - `subenums`: renamed to `children`.
- for each `string`:
  - `keytail`: renamed to `name`.
  - `params` structure with the `names`, `typednames`, `types`, `count` and `declarations` arrays: removed.
  - These have been replaced by `types` which is an array of types. The previous variables
 can now be reconstructed using template tags now that Stencil has become more powerful.

### For developers using SwiftGenKit as a dependency:

Previously the parser context generation method (`stencilContext()`) accepted parameters such as `enumName`, this has been removed in favor of the `--param` system. Templates will automatically receive a `param` object with parameters from the CLI invocation, and should provide default values in case no value was present in the invocation.
