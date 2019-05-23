# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'ExistAPI' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  pod 'PromiseKit', '~> 6.0'
end

def testPods
  pod 'PromiseKit', '~> 6.0'
  pod 'Nimble', '~> 7.1.1' # writing asserts in tests, works with Quick
end


target "ExistAPITests" do
  testPods
end
