Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.name = "SimpleImageViewer"
  s.summary = "A snappy image viewer with zoom and interactive dismissal transition."
  s.dependency 'YYWebImage', '~> 1.0.5'
  s.dependency 'PinterestSegment', '~> 1.2.3'
  s.dependency 'SnapKit', '~> 4.2.0'
  s.requires_arc = true
  s.version = "1.1.1.24"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Lucas" => "lucas@afrogleap.com" }
  s.homepage = "https://github.com/aFrogleap/SimpleImageViewer"
  s.source = { :git => "https://github.com/aFrogleap/SimpleImageViewer.git", :tag => s.version.to_s }
  s.source_files = "ImageViewer/**/*.{swift}"
  s.resources = ["ImageViewer/**/*.{xib}", "ImageViewer/**/*.{xcassets}"]


end