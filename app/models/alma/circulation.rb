class Alma::Circulation < Alma::Base
  include Pseudonymizable

  before_validation :anonymize_patrons

  def carrel_user?
    user_group == "Carrel"
  end

  def anonymize_patrons
    id_str = penn_id_number.to_s

    if id_str.blank? || id_str.downcase == "none"
      self.penn_id_number = "Unknown"
      self.first_name = nil
      self.last_name = nil
    elsif carrel_user?
      self.penn_id_number = id_str
    else
      # Use the Penn ID Number to generate a pseudonym
      self.penn_id_number = self.class.generate_hmac_pseudonym(id_str)
      self.first_name = nil
      self.last_name = nil
    end
  end
end
