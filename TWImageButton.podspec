@version = "0.0.1"
Pod::Spec.new do |s|
  s.name         = 'TWImageButton'
  s.version      = @version
  s.summary      = 'top left right bottom image support'
  s.homepage     = 'https://github.com/taewan0530'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'taewan' => 'taewan0530@daum.net' }
  s.source       = { :git => "https://github.com/taewan0530/TWImageButton.git", :tag => @version }
  s.source_files = 'TWImageButton.swift'
  
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  
end