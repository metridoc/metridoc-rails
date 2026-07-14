namespace :db do
  desc "Retroactively pseudonymize patron information"
  task backfill_pseudonyms: :environment do
    
    raise "PEPPER is not set!" if Rails.application.credentials.pepper.blank?

    counter = 0

    Alma::Circulation.where(pseudonym: nil).find_each(batch_size: 1000) do |event|
      
      id_str = event.penn_id_number.to_s.strip

      # Skip if already anonymized
      next if id_str.empty?

      # Map nil PII directly
      if event.penn_id_number.nil?
        event.update_columns(
          pseudonym: "Unknown"
        )
      # Leave the Carrels untouched
      elsif event.user_group == "Carrel"
        event.update_columns(
          pseudonym: id_str,
          penn_id_number: nil
        )
      else
        # Create irreversible token
        token = Alma::Circulation.generate_hmac_pseudonym(id_str)

        event.update_columns(
          pseudonym: token,
          first_name: nil,
          last_name: nil,
          penn_id_number: nil
        )
      end

      # Visual progress indication
      counter += 1
      print "." if counter % 10000 == 0

    end

    puts "\nFinished retroactively anonymizing #{counter} patron information"
  end
end
