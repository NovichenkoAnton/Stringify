Pod::Spec.new do |spec|
  spec.name          = "Stringify"
  spec.version       = "0.0.1"
  spec.summary       = "A set of usefull string extensions."
  spec.homepage      = "https://github.com/NovichenkoAnton/Stringify"
  spec.license       = {:type => 'MIT', :file => 'LICENSE'}
  spec.author        = { "Anton Novichenko" => "novichenko.anton@gmail.by" }
  spec.platform      = :ios
  spec.source        = { :git => "https://github.com/NovichenkoAnton/Stringify.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/*.swift"
  spec.framework     = "UIKit"
  spec.requires_arc  = true
end
