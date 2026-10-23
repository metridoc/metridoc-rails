# app/models/keyserver/concurrent_session.rb
class Keyserver::ConcurrentSession < Keyserver::Base
  # Non-standard composite primary key setup
  self.primary_key = :division

  def readonly?
    true
  end
end