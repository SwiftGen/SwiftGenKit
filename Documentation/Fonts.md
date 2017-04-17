# Fonts parser

## Input

The fonts parser accepts a directory, which it'll recursively search for font files. Supported file types depend on the target platform, for example iOS only supports TTF and OTF font files.

## Output

The output context has the following structure:

 - `families`: `Array` — list of font families
   - `name` : `String` — name of family
   - `fonts`: `Array` — list of fonts in family
     - `style`: `String` — font style
     - `name` : `String` — font postscript name
