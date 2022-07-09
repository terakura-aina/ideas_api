class Idea < ApplicationRecord
  belongs_to :category

  # belongs_to の presence validator は自動的に追加されるため、category_id に明示的な presence: true は不要
  validates :body, presence: true
end
