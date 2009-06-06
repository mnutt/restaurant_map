require File.dirname(__FILE__) + '/../test_helper'

# mock models
%w(test_books test_dvds test_softwares).each{|tbl|
  ActiveRecord::Base.connection.drop_table tbl rescue nil
  
  ActiveRecord::Base.connection.create_table tbl do |t|
    t.column :name,        :string
    t.column :description, :string
  end
}

ActiveRecord::Base.connection.add_column(
  :test_books, :tags_cache, :string, :default => "--- []")
  
class TestBook < ActiveRecord::Base
  be_taggable
end

class TestDvd < ActiveRecord::Base
  be_taggable
end
  
module Store           # test models within modules
  class TestSoftware < ActiveRecord::Base
    set_table_name "test_softwares"
    be_taggable
  end
end

# test cases

class BeTaggableTest < Test::Unit::TestCase
  def setup
    @book_rails = TestBook.create(:name => "AWDWR")
    @book_ajax = TestBook.create(:name => "pragmatic ajax")
    @software_rails = Store::TestSoftware.create(:name => "Rails-1.2.3")
    @software_proto = Store::TestSoftware.create(:name => "Prototype-1.5")      
    @dvd_rails  = TestDvd.create(:name => "intro to rails")
    @dvd_rails2 = TestDvd.create(:name => "advanced rails")
    @dvd_rails3 = TestDvd.create(:name => "rails internal")
  end
  
    
  def test_validation
    assert_difference(Tag, :count) do
      tag = Tag.create(:name => "apple", :model_type => "TestBook")
    end
    
    assert_difference(Tag, :count, 0) do
      tag = Tag.create(:name => "a"*100)  # limit from 1 to 64 char
    end
  end
  
  def test_split_tag_names
    str = "a1, B2 ,, C3, c3, C3"
    assert_equal(["a1", "b2", "c3"], TestBook.split_tag_names(str))
  end
      
  def test_create_tag
    assert_difference(Tagship, :count, 2) do
      assert_difference(Tag, :count, 2) do
        @book_rails.tag("programming, rails")
        assert_equal(%w(programming rails).to_yaml, @book_rails.tags_cache)
      end
    end
    assert_equal(["programming", "rails"], @book_rails.tag_names.sort)
    @book_rails.tagships.each{|tagship|
      assert_equal(@book_rails.id,         tagship.model_id)
      assert_equal(@book_rails.class.name, tagship.model_type)
    }
    @book_rails.reload
    @book_rails.tags.each{|tag|
      assert_equal(1, tag.tagships_count)
      assert_equal(@book_rails.class.name, tag.model_type)
    }
  end
  
  def test_overwrite_tag
    @book_rails.tag("programming, rails")
    assert_equal(2, @book_rails.tagships.count)
    
    @book_rails.tag("agile, rails")
    assert_equal(2, @book_rails.tagships.count)
    assert_equal(["agile", "rails"], @book_rails.tag_names.sort)
  end
  
  def test_delete_tag
    assert_equal([], YAML::load(@book_rails.tags_cache))
    @book_rails.tag("programming, rails")
    assert_equal(%w(programming rails).to_yaml, @book_rails.tags_cache)
    
    assert_difference(Tagship, :count, -2) do   # association is deleted
      assert_difference(Tag, :count, -2) do      # tags are not deleted.
        @book_rails.tag("")
        assert_equal(0, @book_rails.tags.size)
        assert_equal([].to_yaml, @book_rails.tags_cache)
      end
    end
  end
  
  def test_multi_models
    @book_rails.tag("rails")
    @software_rails.tag("rails")
    
    booktag = @book_rails.tagships.first
    softtag = @software_rails.tagships.first
    assert_equal("Store::TestSoftware", softtag.model_type)      
    assert(booktag.id != softtag.id)
    
    tags = Tag.find_all_by_name("rails")
    assert_equal(2, tags.size)
  end
      
  def test_find
    @book_rails.tag("rails")
    @software_rails.tag("rails")
    @dvd_rails.tag("rails, tutorial")
    @dvd_rails2.tag("rails, advanced tutorial")
    
    rails_dvd = TestDvd.find_tagged_with("rails")
    assert_equal(2, rails_dvd.size)
    assert_equal(0, TestDvd.find_tagged_with("xyz").size)
  end
  
  def test_count
    @book_rails.tag("rails")
    @software_rails.tag("rails")
    @dvd_rails.tag("rails, tutorial")
    @dvd_rails2.tag("rails, advanced tutorial")    

    hash = TestDvd.tags_count
    assert_equal(2, hash["rails"])
    assert_equal(1, hash["tutorial"])
    assert_equal(1, hash["advanced tutorial"])
         
    # count of all models tagged "rails"
    assert_equal(4, Tag.sum("tagships_count", :conditions => {:name => "rails"}))
    # count of dvds tagged "rails"
    assert_equal(2, Tag.sum("tagships_count", :conditions => {:name => "rails", :model_type => "TestDvd"}))
    
    # get tag name, count hash
    hash = Tag.sum("tagships_count", :group => :name)
    assert_equal(4, hash["rails"])
    assert_equal(1, hash["tutorial"])
  end
  
  private
  # this method should be in test/test_helper.rb, so you can use it in rest of your test cases.
  def assert_difference(object, method = nil, difference = 1)
    initial_value = object.send(method)
    yield
    assert_equal initial_value + difference, object.send(method), "#{object}##{method}"
  end
end
