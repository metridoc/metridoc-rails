class Alma::Circulation < Alma::Base
  include Pseudonymizable

  before_save :anonymize_patrons

  def carrel_user?
    user_group == "Carrel"
  end

  def anonymize_patrons
    id_str = penn_id_number.to_s

    if penn_id_number.nil?
      self.penn_id_number = "Unknown"
    elsif carrel_user?
      self.penn_id_number = id_str
    else
      # Use the Penn ID Number to generate a pseudonym
      self.penn_id_number = generate_hmac_pseudonym(id_str)
      
      # Delete all non carrel first and last names
      self.first_name = nil
      self.last_name = nil
    end
  end
end
