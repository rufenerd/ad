class DirectiveUser < ActiveRecord::Base
  belongs_to :directive
  belongs_to :user

private
  def validate
    errors.add_to_base "Bad Kind" unless ["submission", "star", "flag"].include?(kind)
  end
end
