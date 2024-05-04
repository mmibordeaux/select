# == Schema Information
#
# Table name: baccalaureats
#
#  id               :bigint           not null, primary key
#  evaluation_bonus :float
#  quota            :float
#  selection_bonus  :float
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_id        :bigint           indexed
#
# Indexes
#
#  index_baccalaureats_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_6647df8d93  (parent_id => baccalaureats.id)
#

class Baccalaureat < ApplicationRecord
  TECH = 'Bacheliers technologiques toutes séries'
  GEN = 'Tous les candidats sauf les Bac technologiques'

  belongs_to :parent, class_name: 'Baccalaureat', optional: :true
  has_many :children, class_name: 'Baccalaureat', foreign_key: :parent_id, dependent: :destroy
  has_many :candidates, dependent: :nullify

  scope :root, -> { where(parent: nil) }

  default_scope { order(:title) }

  def self.with_title_and_parent(title, parent)
    return parent if title.blank?
    return parent if title == 'Pas de section linguistique'
    return parent if title == 'MEF NATIONAL'
    where(title: title, parent: parent).first_or_create
  end

  def self.tech
    find_by title: TECH
  end

  def self.gen
    find_by title: GEN
  end

  def inherited_quota
    return quota if quota
    return parent.inherited_quota if parent
  end

  def inherited_evaluation_bonus
    return evaluation_bonus if evaluation_bonus
    return parent.inherited_evaluation_bonus if parent
  end

  def inherited_selection_bonus
    return selection_bonus if selection_bonus
    return parent.inherited_selection_bonus if parent
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
