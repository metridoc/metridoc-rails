module Pseudonymizable
  extend ActiveSupport::Concern

  class_methods do
    # Add generate pseudonym as a class method
    def generate_hmac_pseudonym(id_str)
      
      pepper = Rails.application.credentials.fetch(:pepper)

      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha256'),
        pepper,
        id_str.to_s
      )
    end

  end
end