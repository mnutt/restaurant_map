# This generator generates be_taggable migrations and unit test.
# 
# Usage:
#   script/generate be_taggable_tables MODEL1 MODEL2 ...
#   
# where models are ones to be taggable. For example,
#   script/generate be_taggable_tables Article Bookmark
#      
class BeTaggableTablesGenerator < Rails::Generator::NamedBase
  attr_accessor :models  # to generate tags_cache column and update default value.
  def initialize(*args)
    super
    @models = args.shift
  end
  
  def manifest
    record do |m|
      m.migration_template "add_be_taggable.rb", "db/migrate",
                           :migration_file_name => "add_be_taggable"
      m.template "be_taggable_test.rb", "test/unit/be_taggable_test.rb"
    end
  end
end
