#
#  Be sure to run `pod spec lint PicDataSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

    # xcFrameworkPath = "PPCatalystTool/Products/PPCatalystTool.xcframework"
    pluginBundlePath = "PPCatalystPlugin/Products/PPCatalystPlugin.bundle"

    spec.name         = "PPCatalystTool"
    spec.version      = "1.0.5"
    spec.summary      = "Tools for run iOS on Mac Catalyst"
    spec.description  = <<-DESC
    Call AppKit in iOS, by catalyst plugin.
    DESC
    spec.homepage     = "https://github.com/Mensaoers/PPCatalystTool"
    spec.license      = "MIT"
    spec.author       = { "Garenge" => "garenge@outlook.com" }
    spec.source       = { :git => "https://github.com/Mensaoers/PPCatalystTool.git", :tag => spec.version.to_s }
    # spec.source_files = "PPCatalystTool.xcframework/ios-arm64_armv7/PPCatalystTool.framework/**/*.h"
    # spec.public_header_files = "PPCatalystTool/Products/PPCatalystTool.xcframework/ios-arm64/PPCatalystTool.framework/**/*.h"

    spec.source_files = 'PPCatalystTool/PPCatalystTool/**/*'
    spec.public_header_files = "PPCatalystTool/PPCatalystTool/**/*.h"

    spec.ios.deployment_target = "11.0"

    spec.pod_target_xcconfig = {
        'SUPPORTS_MACCATALYST' => 'YES',
        'DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER' => 'YES',
    }

    spec.resources = pluginBundlePath
    # spec.vendored_frameworks = xcFrameworkPath

end
