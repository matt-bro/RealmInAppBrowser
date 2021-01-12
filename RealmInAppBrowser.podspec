#
# Be sure to run `pod lib lint RealmInAppBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RealmInAppBrowser'
  s.version          = '0.1.0'
  s.summary          = 'A short description of RealmInAppBrowser.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/matt-bro/RealmInAppBrowser'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'matt-bro' => 'matthias.brodalka@fresenius-netcare.com' }
  s.source           = { :git => 'https://github.com/matt-bro/RealmInAppBrowser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'Classes/**/*.{swift}'
  
  # s.resource_bundles = {
  #   'RealmInAppBrowser' => ['RealmInAppBrowser/Assets/*.png']
  # }

  #s.preserve_path = "${POD_ROOT}/Classes/RealmInAppBrowser.h"
  #s.xcconfig = { 'SWIFT_OBJC_BRIDGING_HEADER' => '${POD_ROOT}/Classes/RealmInAppBrowser.h' }
  #s.public_header_files = '${POD_ROOT}/Classes/RealmInAppBrowser.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Realm'
  s.dependency 'RealmSwift', '>= 4.4.1'
end
