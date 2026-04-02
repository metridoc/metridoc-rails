class Keyserver::UserNameMap < Keyserver::Base
  # Maps raw Keyserver user_name values to stable opaque aliases.
  #
  # original  — the raw username as it appears in events and sessions
  # user_alias — a stable alias assigned by rake keyserver:seed_user_names
  #
  # Aliases are permanent: once assigned, a given username always maps to
  # the same alias across imports and across tables.  This is enforced by
  # the rake task, which only ever adds new rows, never removes or changes
  # existing ones.
  #
  # The column is named user_alias (rather than alias) to avoid collision
  # with Ruby's reserved word.

  validates :original,   presence: true, uniqueness: true
  validates :user_alias, presence: true, uniqueness: true

  has_many :events,
           class_name:  'Keyserver::Event',
           foreign_key: :user_name,
           primary_key: :original

  has_many :sessions,
           class_name:  'Keyserver::Session',
           foreign_key: :user_name,
           primary_key: :original
end
