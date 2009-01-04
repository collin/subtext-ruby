require 'rubygems'
require 'extlib'

$LOADPATH << Pathname.new(__FILE__).dirname

module SubText
  Version = "0.0.0"
  require 'subtext/gap_set'
  require 'subtext/input'
  require 'subtext/inputs'
  require 'subtext/node'
  require 'subtext/node_set'
  require 'subtext/gap_set'
  require 'subtext/overlap_set'
  require 'subtext/table'
end
