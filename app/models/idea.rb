class Idea < ApplicationRecord
  belongs_to :category

  # belongs_to の presence validator は自動的に追加されるため、明示的な presence: true は不要
  validates :category_id
  validates :body, presence: true
end
