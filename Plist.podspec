Pod::Spec.new do |s|
  s.name             = 'PlistSwift'
  s.version          = '1.0.1'
  s.summary          = 'Easy property list manager that is written in Swift 3'
 
  s.description      = <<-DESC
Easy property list manager that is written in Swift 3!
                       DESC
 
  s.homepage         = 'https://github.com/aybekckaya/Plist'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aybek Can Kaya' => 'aybekckaya@gmail.com' }
  s.source           = { :git => 'https://github.com/aybekckaya/Plist.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'Plist/Plist/Plist/PlistSwift.swift'
 
end