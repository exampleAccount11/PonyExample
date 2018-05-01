platform :ios, '11.0'
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

# List of all available pods
def core_dependencies
    pod 'Alamofire'
    pod 'AlamofireImage'
    pod 'PINRemoteImage'
    pod 'PromiseKit/Alamofire', '~> 4.0'
    pod 'PromiseKit'
    pod 'Cache'
end

# Main App Target
target 'PonyFaces' do
    core_dependencies
end
