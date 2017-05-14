Pod::Spec.new do |s|

  s.name         = "SwiftGenKit"
  s.version      = "1.1.0"
  s.summary      = "The SwiftGen framework responsible for parsing assets and turn them in a dictionary representation suitable for Stencil templates"

  s.description  = <<-DESC
                   This pod contains asset parsers for
                   [SwiftGen](https://github.com/SwiftGen/SwiftGen), as well as
                   methods for converting the data into contexts for
                   [Stencil](https://github.com/kylef/Stencil).
                   DESC

  s.homepage     = "https://github.com/SwiftGen/SwiftGenKit"
  s.license      = "MIT"
  s.author       = { "Olivier Halligon" => "olivier@halligon.net" }
  s.social_media_url = "https://twitter.com/aligatr"

  s.platform = :osx, '10.9'

  s.source       = { :git => "https://github.com/SwiftGen/SwiftGenKit.git", :tag => s.version.to_s }

  s.source_files = "Sources/**/*.swift"

  s.dependency 'PathKit', '~> 0.8.0'
  s.framework  = "Foundation"
end
