require 'test_helper'
require 'minitest/mock'
class PseudonymizableTest < ActiveSupport::TestCase
  # A dummy class for isolated testing
  class DummyModel
    include Pseudonymizable
  end

  test "generates a consistent hex string for the same input" do    
    id = "12345678"

    mock_credentials = { pepper: 'test_pepper_123' }

    Rails.application.stub(:credentials, mock_credentials) do
      result_one = DummyModel.generate_hmac_pseudonym(id)
      result_two = DummyModel.generate_hmac_pseudonym(id)
      
      # Validate the result is repeatable
      assert_equal result_one, result_two
      # Validate the result is a 64-character SHA256 hex string
      assert_match(/\A[a-f0-9]{64}\z/, result_one) 
    end
  end

  test "generates different outputs for different inputs" do
    mock_credentials = { pepper: 'test_pepper_key_123' }

    Rails.application.stub(:credentials, mock_credentials) do
      result_one = DummyModel.generate_hmac_pseudonym("12345678")
      result_two = DummyModel.generate_hmac_pseudonym("87654321")
      
      # Validate two separate inputs create two different outputs
      refute_equal result_one, result_two
    end
  end

  test "handles integer inputs safely by casting to a string" do
    mock_credentials = { pepper: 'test_pepper_key_123' }

    Rails.application.stub(:credentials, mock_credentials) do
      assert_nothing_raised do
        DummyModel.generate_hmac_pseudonym(12345678)
      end
    end
  end

  test "blows up loudly if the HMAC_PEPPER_KEY environment variable is missing" do
    Rails.application.stub(:credentials, {}) do
        assert_raises(KeyError) do
        DummyModel.generate_hmac_pseudonym("12345678")
      end
    end
  end
end