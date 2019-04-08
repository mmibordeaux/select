# == Schema Information
#
# Table name: baccalaureats
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  parent_id  :bigint(8)
#  quota      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Baccalaureat < ApplicationRecord
  belongs_to :parent, class_name: 'Baccalaureat', optional: :true
  has_many :children, class_name: 'Baccalaureat', foreign_key: :parent_id, dependent: :destroy
  has_many :candidates, dependent: :nullify

  scope :root, -> { where(parent: nil) }

  default_scope { order(:title) }

  def self.with_title_and_parent(title, parent)
    where(title: title, parent: parent).first_or_create
  end

  def inherited_quota
    return quota if quota
    return parent.inherited_quota if parent
  end

  def inherited_candidates
    Candidate.where(baccalaureat: children_ids)
  end
  def to_s
    s = ''
    s = "#{parent} / " if parent
    s += "#{title}"
    s
  end

  def children_ids
    @children_ids ||= ([id] + children.pluck(:id) + children.collect(&:children_ids)).flatten
  end
end
