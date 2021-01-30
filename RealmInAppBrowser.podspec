#
# Be sure to run `pod lib lint RealmInAppBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RealmInAppBrowser'
  s.version          = '0.2.0'
  s.summary          = 'View your Realm DB inside your App'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This View is going to enable you to view your Realm Database in your app, so you can see and debug your realm db at any time.

  The goal of this project is that the browser would roughly work like Realm Browser.
                       DESC

  s.homepage         = 'https://github.com/matt-bro/RealmInAppBrowser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'matt-bro' => 'matthias.brodalka@fresenius-netcare.com' }
  s.source           = { :git => 'https://github.com/matt-bro/RealmInAppBrowser.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_versions = ['5.1', '5.2', '5.3']

  s.exclude_files = ['Classes/**/TestModels.swift']
  s.source_files = 'Classes/**/*.{swift}'

  s.dependency 'Realm'
  s.dependency 'RealmSwift', '>= 4.4.1'
end
