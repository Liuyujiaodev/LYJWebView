#
#  Be sure to run `pod spec lint XQCategory.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name     = "LYJWebView"
s.version  = "1.0.0"
s.license  = "MIT"
s.summary  = "private web view"
s.homepage = "https://github.com/Liuyujiaodev/LYJWebView.git"
s.author   = "liuyujiao"
#s.social_media_url = "https://www.jianshu.com/u/16227d25bcf4"
s.source       = { :git => "https://github.com/Liuyujiaodev/LYJWebView.git", :tag => "#{s.version}" }
 s.description = %{LYJWebView }
s.source_files = "LYJWebView/**/*.{h,m}","LYJWebView/**/*.mm"
s.vendored_frameworks = "LYJWebView/**/framework/*.framework"
s.vendored_libraries = "LYJWebView/**/framework/libshujumoheSDK.a"
s.frameworks = "WebKit","CoreMedia","CoreMotion","Social"
s.requires_arc = true
s.platform = :ios, '9.0'
s.dependency "YJUtil"
s.dependency "AFNetworking"
s.dependency "BMKLocationKit"
s.dependency "UtilStr"
s.dependency "YJCategory"
s.dependency "SVGKit"
s.dependency "UMengAnalytics-NO-IDFA"
s.resource = "OwnWebView/lib/libshujumohe/*.bundle"
s.resource = "OwnWebView/lib/face++/*.bundle"
end
