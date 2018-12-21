Pod::Spec.new do |spec|

    spec.platform = :ios
    spec.ios.deployment_target = '12.0'
    spec.name         = "ExistAPI"
    spec.version      = "0.0.8"
    spec.summary      = "An iOS framework for working with the Exist API."
    spec.requires_arc = true
    spec.description  = <<-DESC
    ExistAPI is a Swift framework that makes it easy to work with the Exist API in iOS projects. Find out more about Exist at https://exist.io or read the API docs at https://developer.exist.io
                       DESC
      spec.homepage     = "http://github.com/bellebethcooper/existAPI"
      # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
    spec.license      = { :type => "MIT", :file => "LICENSE" }
    spec.author             = { "Belle Beth Cooper" => "belle@hellocode.co" }
    spec.social_media_url   = "https://twitter.com/bellebcooper"
    spec.source       = { :git => "git@github.com:bellebethcooper/existAPI.git", :tag => spec.version }
    spec.source_files  = "Classes/**/*.{h,swift}"
    # spec.resources = "ExistAPI/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
    spec.swift_version = "4.2"
    spec.framework = "UIKit"
    spec.dependency 'PromiseKit', '~> 6.0'

end
