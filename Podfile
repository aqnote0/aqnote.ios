platform :ios, '6.0'

#source 'git@github.com:aqnote/specs.git'
source 'https://github.com/aqnotecom/com.aqnote.ios.specs.git'
source 'https://github.com/CocoaPods/Specs.git'

#post_install do |installer_representation|
#    installer_representation.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['CLANG_ENABLE_OBJC_WEAK'] ||= 'YES'
#        end
#    end
#end

target "aqnote" do
  pod 'AQFoundation', '~> 1.2.0'
  #pod 'OpenSSL-Universal'#, '~>1.0.1.j'
  pod 'OpenSSL-Universal', :git => 'https://github.com/krzyzanowskim/OpenSSL.git', :branch => :master
end

target "aqnoteTests" do
  pod 'AQFoundation', '~> 1.2.0'
  #pod 'OpenSSL-Universal'#, '~>1.0.1.j'
  pod 'OpenSSL-Universal', :git => 'https://github.com/krzyzanowskim/OpenSSL.git', :branch => :master
end


target "aqnoteUITests" do
  pod 'AQFoundation', '~> 1.2.0'
end
