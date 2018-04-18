Pod::Spec.new do |s|
  s.name             = 'TextbookRSA'
  s.version          = '1.0.0'
  s.summary          = 'A textbook implementation of RSA encryption, for teaching purposes.'

  s.description      = <<-DESC
        WARNING: NOT FOR REAL-WORLD ENCRYPTION!

        TextbookRSA was written with the goal of providing a (very) simplified and readable implementation of RSA encryption for beginners. On top of that, it contains an implementation of "decryption through period finding", which shows how RSA encryption could be broken if one had a fast period-finding oracle (e.g. a quantum computer with an implementation of Shor's algorithm).
                       DESC

  s.homepage         = 'https://github.com/imagineon/TextbookRSA'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tomás Silveira Salles' => 'ts@imagineon.de' }
  s.source           = { :git => 'https://github.com/imagineon/TextbookRSA.git', :tag => s.version.to_s }
  s.social_media_url = 'http://www.imagineon.de/en/'

  s.platform = :osx
  s.osx.deployment_target = "10.10"
  s.swift_version = '4.0'

  s.source_files = 'TextbookRSA/**/*'
end
