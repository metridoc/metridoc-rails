class Institution < ApplicationRecord

  scope :of_code, -> (code) { where(code: code).first }

  def self.get_id_from_code(code)
    i = of_code(code)
    i.present? ? i.id : nil
  end

end
