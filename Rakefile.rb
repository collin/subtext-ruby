require 'rubygems'
require 'pathname'
require 'spec'

__DIR__ = Pathname.new(__FILE__).dirname

task :default => 'spec:all'

namespace :spec do
  task :prepare do
    @specs= Dir.glob("#{__DIR__}/spec/**/*.rb").join(' ')
  end

  task :all => :prepare do
    system "spec #{@specs}"
  end
  
  task :doc => :prepare do
    system "spec #{@specs} --format specdoc"
  end
end

task :cleanup do 
  Dir.glob("**/*.*~")+Dir.glob("**/*~").each{|swap|FileUtils.rm(swap, :force => true)}
end

task :doc do
  `rdoc lib -U -N -S -F`
end

namespace :gem do
  task :version do
    require 'lib/subtext'
    @version = Subtext::Version
  end

  task :build => :spec do
    load __DIR__ + "subtext.gemspec"
    Gem::Builder.new(@subtext_gemspec).build
  end

  task :install => :build do
    cmd = "gem install subtext -l"
    system cmd unless system "sudo #{cmd}"
    FileUtils.rm(__DIR__ + "subtext-#{@version}.gem")
  end

  task :spec => :version do
    file = File.new(__DIR__ + "subtext.gemspec", 'w+')
    FileUtils.chmod 0755, __DIR__ + "subtext.gemspec"
    spec = %{
Gem::Specification.new do |s|
  s.name             = "subtext"
  s.version          = "#{@version}"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.has_rdoc         = true
  s.summary          = "An implementation of ideas from subtextual.org in Ruby"
  s.authors          = ["Collin Miller"]
  s.email            = "collintmiller@gmail.com"
  s.homepage         = "http://github.com/collin/subtext-ruby"
  s.files            = %w{#{(%w(README Rakefile.rb) + Dir.glob("{lib,spec}/**/*")).reject{|path| path.match /~$/ }.join(' ')}}
  
  s.add_dependency  "rake"
  s.add_dependency  "rspec"
  s.add_dependency  "extlib"
end
}

  @subtext_gemspec = eval(spec)
  file.write(spec)
  end
end
