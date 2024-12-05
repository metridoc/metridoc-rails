class Springshare::Inquirymap::Inquirymap < Springshare::Inquirymap::Base
  belongs_to :chat, class_name: "Springshare::Libchat::Chat"
end