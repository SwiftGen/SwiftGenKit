#!/usr/bin/rake

## [ Constants ] ##############################################################

WORKSPACE = 'SwiftGenKit'
SCHEME_NAME = 'Tests'
CONFIGURATION = 'Debug'
POD_NAME = 'SwiftGenKit'


desc 'Generate Test Contexts'
task :generate_contexts => "xcode:build" do |task|
  Utils.print_header 'Generating contexts...'
  Utils.run(%Q(xcodebuild -workspace "#{WORKSPACE}.xcworkspace" -scheme "Generate Contexts" -configuration "#{CONFIGURATION}" test-without-building), task, xcrun: true, formatter: :xcpretty)
end

task :default => 'xcode:test'
