class Ezproxy::EzpaarseJob < Ezproxy::Base
  self.ignored_columns = [
    :login, :host, :penn_id
  ]
end
