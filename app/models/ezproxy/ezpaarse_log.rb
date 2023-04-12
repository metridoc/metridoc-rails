class Ezproxy::EzpaarseLog < Ezproxy::Base
  self.ignored_columns = [
    :login, :host, :penn_id
  ]
end
