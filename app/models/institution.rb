class Institution < ApplicationRecord

  scope :of_code, -> (code) { where(code: code) }

  def self.get_id_from_code(code)
    i = of_code(code).first
    i.present? ? i.id : nil
  end

  def ups_zone
    (z = UpsZone.of_zip_code(self.zip_code).first).present? ? z.zone : nil
  end

end
