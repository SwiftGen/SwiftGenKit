def xcpretty(cmd, task)
  name = task.name.gsub(/:/,"_")
  if ENV['CI']
    sh "set -o pipefail && #{cmd} | tee \"#{ENV['CIRCLE_ARTIFACTS']}/#{name}_raw.log\" | xcpretty --color --report junit --output \"#{ENV['CIRCLE_TEST_REPORTS']}/xcode/#{name}.xml\""
  elsif `which xcpretty` && $?.success?
    sh "set -o pipefail && #{cmd} | xcpretty -c"
  else
    sh cmd
  end
end

namespace :xcode do
  desc 'Build using Xcode'
  task :build do |task|
    xcpretty("xcodebuild -workspace SwiftGenKit.xcworkspace -scheme Tests build-for-testing", task)
  end

  desc 'Run Xcode Unit Tests'
  task :test => :build do |task|
    xcpretty("xcodebuild -workspace SwiftGenKit.xcworkspace -scheme Tests test-without-building", task)
  end
end

desc 'Lint the Pod'
task :lint do |task|
  plain("pod lib lint SwiftGenKit.podspec --quick", task)
end

task :default => :test
