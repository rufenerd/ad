class Directive < ActiveRecord::Base
  acts_as_taggable
  has_many :directive_users, :dependent => :destroy
  has_many :users, :through => :directive_users

  validates_presence_of :name
  validates_presence_of :description

  POPULATIONS = ["children", "adolescents", "adults", "older adults", "family", "couple"]
  TOPICS = POPULATIONS + ["medical conditions", "substance abuse", "grief"]

  def submitter
    submission ? submission.user : nil
  end

  def submission
    @submission ||= directive_users.find(:first, :conditions => {:kind => "submission"})
  end

  def starred?(user)
    switch_on?("star", user)
  end
  
  def flagged?(user)
    switch_on?("flag", user)
  end

  def switch_on?(kind, user)
    !DirectiveUser.find(:first, :conditions => {:kind => kind, :user_id => user.id, :directive_id => id}).nil?
  end
end
