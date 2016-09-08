platform :ios, '6.0'

#source 'git@github.com:aqnote/specs.git'
source 'https://github.com/aqnote/specs.git'

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_ENABLE_OBJC_WEAK'] ||= 'YES'
        end
    end
end

target "AQDemo" do
  pod 'AQFoundation', '~> 1.0.0'
end

target "AQDemoTests" do
  pod 'AQFoundation', '~> 1.0.0'
end


target "AQDemoUITests" do
  pod 'AQFoundation', '~> 1.0.0'
end
