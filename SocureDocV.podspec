#
# Be sure to run `pod spec lint SocureDeviceRisk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SocureDocV"
  s.version          = "5.4.0"
  s.summary          = "Socure Document Verification SDK, iOS Version."

  s.description      = <<-DESC
The SocureDocV SDK provides a user interface that guides consumers through the document capture and upload process.
                       DESC

  s.homepage         = "https://github.com/socure-inc/socure-docv-sdk-ios"
  s.license           = { :type => 'Commercial', :file => 'SocureDocV.xcframework/LICENSE' }
  s.author           = {  "Socure Inc" => "support@socure.com" }
  s.source           = { :http => "https://sdk.socure.com/socure-sdks/docv/ios/socure-docv-5.4.0.zip"}
                                   
  s.platform = :ios

  s.ios.deployment_target = "13.0"
  s.ios.vendored_frameworks = 'SocureDocV.xcframework'
  s.ios.resource_bundles = { 'SocureDocV' => ['SocureDocV.xcframework/PrivacyInfo.xcprivacy'] }
  s.ios.frameworks = 'UIKit'
  
  s.dependency 'SocureDeviceRisk', '~> 4.8.1'
end
