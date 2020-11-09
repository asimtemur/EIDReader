Pod::Spec.new do |spec|

  spec.name         = "EIDReader"
  spec.version      = "1.0.14"
  spec.summary      = "This package handles reading an NFC Enabled passport using iOS 13 CoreNFC APIS"

  spec.homepage     = "https://github.com/asimtemur/EIDReader"
  spec.license      = "MIT"
  spec.author       = { "Andy Qua" => "asim.temur@gmail.com" }
  spec.platform = :ios
  spec.ios.deployment_target = "12.0"

  spec.source       = { :git => "https://github.com/asimtemur/EIDReader.git", :tag => "#{spec.version}" }

  spec.source_files  = "**/*.{swift}"

  spec.swift_version = "5.0"

  spec.dependency "OpenSSL-Universal/Framework"
  spec.xcconfig          = { 'OTHER_LDFLAGS' => '-weak_framework CryptoKit -weak_framework CoreNFC',
                             'ENABLE_BITCODE' => '"NO' }

  spec.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
