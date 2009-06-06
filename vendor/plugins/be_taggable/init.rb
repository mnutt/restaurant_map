require 'tag'
require 'tagship'
require 'be_taggable'

ActiveRecord::Base.send(:include, BeTaggable)