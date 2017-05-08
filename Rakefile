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

## [ Release a new version ] ##################################################

namespace :release do
  desc 'Create a new release on CocoaPods'
  task :new => [:check_versions, 'xcode:tests', :cocoapods]

  desc 'Check if all versions from the podspecs and CHANGELOG match'
  task :check_versions do
    results = []

    # Check if bundler is installed first, as we'll need it for the cocoapods task (and we prefer to fail early)
    `which bundler`
    results << Utils.table_result( $?.success?, 'Bundler installed', 'Please install bundler using `gem install bundler` and run `bundle install` first.')

    # Extract version from SwiftGen.podspec
    version = Utils.podspec_version('SwiftGenKit')
    Utils.table_info('SwiftGenKit.podspec', version)

    # Check if entry present in CHANGELOG
    changelog_entry = system(%Q{grep -q '^## #{Regexp.quote(version)}$' CHANGELOG.md})
    results << Utils.table_result(changelog_entry, "CHANGELOG, Entry added", "Please add an entry for #{version} in CHANGELOG.md")

    changelog_master = system(%q{grep -qi '^## Master' CHANGELOG.md})
    results << Utils.table_result(!changelog_master, "CHANGELOG, No master", 'Please remove entry for master in CHANGELOG')

    exit 1 unless results.all?

    print "Release version #{version} [Y/n]? "
    exit 2 unless (STDIN.gets.chomp == 'Y')
  end

  desc 'pod trunk push SwiftGenKit to CocoaPods'
  task :cocoapods do
    Utils.print_header "Pushing pod to CocoaPods Trunk"
    sh 'bundle exec pod trunk push SwiftGenKit.podspec'
  end
end


task :default => 'xcode:test'
