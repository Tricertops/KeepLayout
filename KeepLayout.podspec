Pod::Spec.new do |s|
  s.name         = "KeepLayout"
  s.version      = "1.7.0"
  s.summary      = "Making Auto Layout easier to code."
  s.homepage     = "https://github.com/Tricertops/KeepLayout"

  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       = 'Tricertops'

  s.source       = { :git => "https://github.com/Tricertops/KeepLayout.git", :tag => "v1.7.0" }

  s.source_files = 'Sources'
  s.requires_arc = true
end
