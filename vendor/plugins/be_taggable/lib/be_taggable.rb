module BeTaggable
  def self.included(base)  #:nodoc:
    base.extend(ActMethods)
  end

  module ActMethods  #:nodoc:
    def be_taggable
      has_many :tagships, :as => :model,
               :class_name => "Tagship",
               :foreign_key => "model_id",              
               :conditions => ["tagships.model_type=?", name], # model's class name
               :dependent => :destroy
               
      has_many :tags,
               :class_name => "Tag",
               :through => :tagships
      
      extend  ::BeTaggable::ClassMethods
      include ::BeTaggable::InstanceMethods
    end
  end
  
  module ClassMethods     
    def split_tag_names(str)
      return [] if (str.nil? or str.strip.empty?)
      str.downcase.split(",").collect{|x| x.strip if x.strip.size>0 }.uniq.compact.sort
    end
    
    # returns hash of tag names and count for this model, like {"rails" => 5, "ruby" => 3}
    def tags_count(options = {})
      rs = Tag.find_all_by_model_type(name, options)
      Hash[*rs.collect{|r| [r.name, r.tagships_count.to_i]}.flatten]
    end
    
    # find all rows tagged with given string
    def find_tagged_with(tag, options={}) 
      find(:all, 
           {:select => "m.*",
            :joins => %(as m INNER JOIN #{Tagship.table_name} AS ts ON m.id=ts.model_id
                             INNER JOIN #{Tag.table_name} AS t ON ts.tag_id=t.id),
            :conditions =>["ts.model_type=? and t.name=?", name, tag],
            :limit => 20}.merge(options))
    end
  end
  
  module InstanceMethods  
    # create new or overwrite tags, without touching overlapping tags.
    def tag(str)
      old_tags = tag_names
      new_tags = self.class.split_tag_names(str)
      
      (new_tags - old_tags).each{|tag|
        self.tags << Tag.find_or_create_by_name_and_model_type(tag, self.class.name)
      }
      (old_tags - new_tags).each{|tag|  
        tag_obj = Tag.find_by_name_and_model_type(tag, self.class.name)
        self.tags.delete(tag_obj)
        tag_obj.destroy if tag_obj.tagships_count == 1 # cached 1
      } 
      update_attribute(:tags_cache, new_tags.to_yaml) if respond_to? :tags_cache
    end
    
    def tag_names
      self.tags.collect{|tag| tag.name}.sort!
    end
  end
end