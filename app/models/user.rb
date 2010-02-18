require 'digest/sha1'

class User < ActiveRecord::Base
  acts_as_authentic

  # Validations
  validates_presence_of :login
  validates_length_of :login, :within => 3..40
  validates_uniqueness_of :login, :case_sensitive => false
  validates_format_of :login, :with => /^[A-Za-z0-9\-\_]*$/, :message => "Sorry, you can only use letters, numbers, dashes and underscores in your login"
  validates_format_of :name, :with => /^[A-Za-z0-9]\-\']*$/, :message => "Sorry, you can only use letters, numbers, dashes, underscores, apostrophes, and spaces in your login", :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_presence_of :email
  validates_length_of :email, :within => 6..100
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /^[A-Za-z0-9\+\_\@\.]*$/, :message => "Sorry, you need to enter a valid email address."
  
  attr_accessor :password, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_in_state :first, :active, :conditions => { :login => login } # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  # Check if a user has a role.
  def has_role?(role)
    true
  end
  
  def password_required?
    new_record? ? (crypted_password.blank? || !password.blank?) : !password.blank?
  end

  def initialize(attributes={})
    user_attributes = {}
    (attributes || {}).each do |k, v|
      user_attributes[k] = attributes[k] if ATTR_ACCESSIBLE.include?(k.to_sym)
    end
    super user_attributes
  end

  protected
    
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end
end
