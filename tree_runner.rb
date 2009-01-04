require 'rubygems'
require 'continuous_builder'

class LogicRunner < ContinuousBuilder
  watches :tree,
    :files  => "tree.rb",
    :update => :tree
    
 
 def tree path
  system 'ruby tree.rb -v'
 end 
end

w = LogicRunner.new
w.build_all
w.build_continuously
