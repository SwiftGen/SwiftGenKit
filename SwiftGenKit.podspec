Pod::Spec.new do |s|

  s.name         = "SwiftGenKit"
  s.version      = "0.0.1"
  s.summary      = "The SwiftGen framework responsible for parsing assets and turn them in a dictionary representation suitable for Stencil templates"

  s.description  = <<-DESC
                   TODO
                   DESC

  s.homepage     = "https://github.com/SwiftGen/SwiftGenKit"
  s.license      = "MIT"
  s.author       = { "Olivier Halligon" => "olivier@halligon.net" }
  s.social_media_url = "https://twitter.com/aligatr"

  s.platform = :osx, '10.9'

  s.source       = { :git => "https://github.com/SwiftGen/SwiftGenKit.git", :tag => s.version.to_s }

  s.source_files = "Sources/**/*.swift"

  s.dependency 'PathKit', '~> 0.7.0'
  s.framework  = "Foundation"
end
