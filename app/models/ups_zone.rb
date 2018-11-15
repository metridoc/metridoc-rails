class UpsZone < ApplicationRecord

  scope :of_prefix, -> (from_prefix, to_prefix) { where(from_prefix: from_prefix, to_prefix: to_prefix).first }

end
