class Springshare::Libchat::Inquirymap < Springshare::Libchat::Base
  belongs_to :chat, class_name: "Springshare::Libchat::Chat"
end