Gem::Specification.new do |s|
  s.name        = 'muesli'
  s.version     = '0.0.1'
  s.date        = '2014-07-18'
  s.summary     = "Provides serialization of models into hashes with attribute whitelisting and authorization for passing to views or as an API response."
  s.description = "Provides serialization of models into hashes with attribute whitelisting and authorization for passing to views or as an API response."
  s.authors     = ["Dan Connor"]
  s.email       = 'danconn@danconnor.com'
  s.files       = [
    "lib/cancan.rb",
    "lib/base_serializer.rb"
  ]
  s.homepage    = 'https://github.com/onyxrev/muesli'
  s.license     = 'MIT'
end
