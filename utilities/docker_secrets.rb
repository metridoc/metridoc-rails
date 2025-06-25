# frozen_string_literal: true

# Helper for pulling secrets from docker secrets store.
# TODO: It would be great for this code to be "gemified" and shared across our projects. Reading in
#       secrets from Docker secrets will be something we have to do in all of our applications.
class DockerSecrets
  SECRET_STORE_PATH = '/run/secrets'

  class InvalidKeyError < StandardError; end

  # Look up docker secret. Return default if docker secret is not found.
  #
  # @param [Symbol, String] key
  # @param [String, NilClass] default
  # @return [String, NilClass]
  def self.lookup(key, default = nil)
    raise InvalidKeyError, 'Lookup key is blank' if key.blank?

    secret_file_path = File.join SECRET_STORE_PATH, key.to_s

    if File.exist? secret_file_path
      File.read(secret_file_path).strip
    else
      default
    end
  end

  # Look up docker secret. Raise error if key is not found.
  #
  # @param [Symbol, String] key
  def self.lookup!(key)
    secret = lookup(key)
    raise InvalidKeyError, "Docker secret not found for #{key}" if secret.blank?
    secret
  end
end
