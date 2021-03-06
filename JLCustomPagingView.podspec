#
# Be sure to run `pod lib lint JLCustomPagingView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JLCustomPagingView"
  s.version          = "0.1.5"
  s.summary          = "JLCustomPagingView presenting diferent views and view controller on diferent way."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "This is a library created to help all developers that do not want to use the scrollView or the PageViewController to present diferent views and viewcontrollers and do not want to waste precious time creating his own.Simple to implement and understand
JLCustomPagingView will help you to improve your time."

  s.homepage         = "https://github.com/josechagas/JLCustomPagingView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "José Lucas" => "joselucas1994@yahoo.com.br" }
  s.source           = { :git => "https://github.com/josechagas/JLCustomPagingView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Pod/Classes/*.swift'
#s.resource_bundles = {
#   'JLCustomPagingView' => ['JLCustomPagingView/Assets/*.png']
# }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
