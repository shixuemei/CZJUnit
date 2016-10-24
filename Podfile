platform :ios, '7.0'
inhibit_all_warnings!
use_frameworks!

target 'CZJUnit' do
	pod 'libksygpulive/libksygpulive', :path => '~/Downloads/KSYLive_iOS'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "!!!! #{target.name}"
  end
end
