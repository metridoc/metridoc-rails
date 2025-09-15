class Springshare::Libchat::CombinedView < Springshare::Libchat::Base
  belongs_to :chat, class_name: "Springshare::Libchat::Chat"

  self.primary_key = :chat_id 

  def readonly?
    true
  end
end
