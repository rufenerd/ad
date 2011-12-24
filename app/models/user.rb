class User < ActiveRecord::Base
  has_many :directive_users, :dependent => :destroy
  has_many :directives, :through => :directive_users
  validates_presence_of :password_hash
  validates_presence_of :password_salt
  validates_presence_of :name
  validates_presence_of :role
  validates_uniqueness_of :username

  OCCUPATIONS = {"Art Therapy Student" => "art_therapy_student",
    "Art Therapy Practitioner" => "art_therapy_practitioner",
    "Mental Health Practitioner" => "mental_health_practitioner"}

  def admin?
    role == "admin"
  end
 
  def occupation
    #TODO: refactor
    occ_pair = OCCUPATIONS.to_a.map(&:reverse).find{|x| x[0] == role}
    occupation = occ_pair ? occ_pair[1] : nil
    admin? ? "Admin" : occupation
  end

  # Use this method to verify password on an instance of this class.  Use authenticate if a class method is appropriate.
  def password_is? password
    password_hash == User.hash_password(password_salt, password)
  end

  # Creates a random password salt and hashes the password with SHA256
  def password= pass
      salt = User.generate_salt
      self.password_salt = salt
      self.password_hash = User.hash_password(salt, pass)
  end

  def self.generate_salt
    [Array.new(6) {rand(256).chr}.join].pack("m").chomp
  end

  # Pretty self explanatory
  def self.hash_password(salt, password)
    Digest::SHA256.hexdigest(password + salt)
  end

  # Returns a boolean indicating if the user has entered a valid email and password combination
  def self.authenticate username, password
    user = User.find_by_username username
    user && user.password_is?(password) ? user : nil
  end

  def stars
    directive_users_by_kind("star")
  end

  def flags
    directive_users_by_kind("flag")
  end
  
  def submissions
    #TODO change compact to dependent detroy
    directive_users_by_kind("submission").compact
  end

  def stars
    #TODO change compact to dependent destroy
    directive_users_by_kind("star").compact
  end

private

  def directive_users_by_kind(kind)
     directive_users.select{|d| d.kind == kind}.map(&:directive) 
  end

end
