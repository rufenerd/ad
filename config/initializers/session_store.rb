# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ad_session',
  :secret      => 'dc12f48b3295520e23fb9e72bdca49cb3d3a9d2e47f7b0d7ed1740a49b301b9f7c059121891e4c2fba7f5bcfa19d3e5a2ef58897e00292cc8d4b9e6d6f8cefe7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
