def xcpretty(cmd)
  if `which xcpretty` && $?.success?
    sh "set -o pipefail && #{cmd} | xcpretty -c"
  else
    sh cmd
  end
end

task :build_for_testing do
  xcpretty "xcodebuild -workspace SwiftGenKit.xcworkspace -scheme Tests build-for-testing"
end

desc 'Run Unit Tests'
task :test => :build_for_testing do
  xcpretty "xcodebuild -workspace SwiftGenKit.xcworkspace -scheme Tests test-without-building"
end

desc 'Lint the Pod'
task :lint do
  sh "pod lib lint SwiftGenKit.podspec --quick"
end

task :default => :test
