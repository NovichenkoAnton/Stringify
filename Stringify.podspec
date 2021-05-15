Pod::Spec.new do |spec|
  spec.name          = "Stringify"
  spec.version       = "1.0.19"
  spec.summary       = "A set of usefull string extensions."
  spec.homepage      = "https://github.com/NovichenkoAnton/Stringify"
  
  spec.license       = {:type => 'MIT', :file => 'LICENSE'}
  spec.author        = { "Anton Novichenko" => "novichenko.anton@gmail.com" }
  
  spec.platform      = :ios
  spec.ios.deployment_target = '10.0'
  
  spec.swift_version = '5.0'
  spec.source        = { :git => "https://github.com/NovichenkoAnton/Stringify.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/*.swift"
  spec.requires_arc  = true
end
