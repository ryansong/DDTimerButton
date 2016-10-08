  Write an awesome description for your new site here. You can edit this
d::Spec.new do |s|
  s.name             = "DDTimerButton"
  s.version          = "1.0.0"
  s.summary          = "A verify code button"
  s.description      = <<-DESC
   i                    It is a button count down for sending verify code, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/ryansong/DDTimerButton"
  s.license          = 'MIT'
  s.author           = { "RyanSong" => "song.ryan90@gmail.com" }
  s.source           = { :git => "https://github.com/ryansong/DDTimerButton.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/NAME'

  s.platform     = :ios, '7.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'DDTimerButton/*'
  # s.resources = 'Assets'

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end

