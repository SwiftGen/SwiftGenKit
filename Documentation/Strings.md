# Strings parser

## Input

The strings parser accepts a `strings` file, typically `Localizable.stirngs`. It will parse each string in this file, including the type information for formatting parameters. 

The strings file will be converted into a structured tree version, where each string is separated into components by the `.` character. We call this the `dot syntax`, each component representing a level.

## Output

The output context has the following structure:

 - `tables`: `Array` — List of string tables
   - `name`   : `String` — name of the `.strings` file (usually `"Localizable"`)
   - `strings`: `Array` — Tree structure of strings (based on dot syntax), each level has:
     - `name`   : `String` — name of the level
     - `strings`: `Array` — list of strings at this level:
       - `key`: `String` — the full translation key
       - `translation`: `String` — the translated text
       - `types`: `Array<String>` — defined only if localized string has parameters.
          Containing types like `"String"`, `"Int"`, etc
       - `keytail`: `String` containing the rest of the key after the next first `.`
         (useful to do recursion when splitting keys against `.` for structured templates)
     - `subenums`: `Array` — list of sub-levels, repeating the structure mentioned above
