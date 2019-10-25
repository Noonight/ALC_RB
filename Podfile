# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'ALC_RB' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ALC_RB
  # pod 'SwipeViewController'  
  pod 'Alamofire', '~> 4.7'
  pod 'AlamofireImage'
  #pod 'RxAlamofire'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'ActionSheetPicker-3.0'
  pod 'IQKeyboardManagerSwift'
  pod 'ESPullToRefresh'
  #pod 'StatusAlert'#, '~> 1.1.1' # like toast alert
  pod 'AMScrollingNavbar'
  pod 'Kingfisher', '~> 5.7' # loading image
  #pod 'SDWebImage', '~> 5.0'
  #pod "CollieGallery"
  pod 'Lightbox' # full screen images
  #pod "StatefulViewController", "~> 3.0"
  pod 'SwiftDate', '~> 5.0'
  pod 'UIScrollView-InfiniteScroll', '~> 1.1.0'
  
  pod 'SPStorkController'
  
  pod 'FloatingPanel'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      #config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['SWIFT_VERSION'] = '4.2' # <--- // 2nd add this
    end
  end
end
