class UpsZone < ApplicationRecord

  scope :of_prefix, -> (from_prefix, to_prefix) { where(from_prefix: from_prefix, to_prefix: to_prefix) }
  scope :of_zip_code, -> (zip_code) { where(" CONCAT(to_prefix, '00') >= ? AND ? >= CONCAT(from_prefix, '00') ", zip_code, zip_code) }

end
