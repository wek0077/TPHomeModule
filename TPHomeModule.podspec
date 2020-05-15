#
# Be sure to run `pod lib lint TPHomeModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TPHomeModule'
  s.version          = '0.1.0'
  s.summary          = 'this is testing for only'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wek0077/TPHomeModule/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1243626554@qq.com' => 'wekchen@tupperware.com' }
  s.source           = { :git => 'https://github.com/wek0077/TPHomeModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TPHomeModule/Classes/**/*'
  

end
