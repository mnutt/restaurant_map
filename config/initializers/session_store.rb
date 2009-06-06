# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_restaurant_map_session',
  :secret      => 'f2e1da2a542495beed8e122e4df583efd7f9c7a6a585a042f39d5bb7308c606632136765627dee5b09dbe2373d6ed89116cb94a119e4b10205d0cbce230b3a62'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
