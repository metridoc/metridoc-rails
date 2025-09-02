class Springshare::Libchat::CombinedView < Springshare::Libchat::Base
  #belongs_to :searchable, polymorphic: true

  self.primary_key = :chat_id 

  def readonly?
    true
  end
end
