class Springshare::Inquirymap::Inquirymap < Springshare::Inquirymap::Base
  belongs_to :chat, class_name: "Springshare::Libchat::Chat"

  # Define the SuperAdmin columns
  def self.superadmin_columns
    [
      "sentiment_score", "sentiment"
    ]
  end

end