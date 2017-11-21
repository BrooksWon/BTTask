Pod::Spec.new do |s|

  s.name        = "BTTask"  #名称
  s.version     = "0.0.1" #版本号
  s.summary     = "自定义 NSOperation"  #描述
  s.homepage    = "https://github.com/BrooksWon/BTTask" #描述页面
  s.license     = { :type => "MIT", :file => "LICENSE" }
  s.author      = { "Brooks" => "364674019@qq.com" }  #作者
  s.platform    = :ios, '8.0'   #支持的系统
  s.source      = { :git => "https://github.com/BrooksWon/BTTask.git", :tag => "0.0.1" }   #源码地址
  s.source_files= 'BTTask/BTTask/*.{h,m}' #源码
  s.requires_arc= true  #是否需要arc
  s.framework   = 'Foundation' #framework
  #s.libraries = 'z', 'bz2.1.0' #lib
  #s.dependency  'JSONKit',  '~> 1.4' #依赖的第三方库

end