# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'FlagQuiz' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Google-Mobile-Ads-SDK', '7.51.0'

  # Pods for FlagQuiz

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "13.0"
    end    
  end

  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
