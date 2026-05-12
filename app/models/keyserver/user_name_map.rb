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

  # Assign stable opaque aliases to any user_name values in keyserver_events
  # and keyserver_sessions that do not yet have an entry in this table.
  #
  # Safe to call repeatedly — only ever adds new rows, never modifies existing
  # aliases.  Returns the number of new aliases created.
  def self.seed
    event_names   = Keyserver::Event.where.not(user_name: [nil, ""])
                                    .distinct.pluck(:user_name)
    session_names = Keyserver::Session.where.not(user_name: [nil, ""])
                                      .distinct.pluck(:user_name)

    all_names = (event_names + session_names).uniq.select(&:present?)
    existing  = pluck(:original).to_set
    new_names = all_names.reject { |n| existing.include?(n) }
    return 0 if new_names.empty?

    last_alias  = order(:user_alias).pluck(:user_alias).last
    next_number = last_alias ? last_alias.sub(/\Auser_0*/, "").to_i + 1 : 1

    new_names.each do |name|
      create!(original: name, user_alias: "user_#{next_number.to_s.rjust(4, '0')}")
      next_number += 1
    end

    new_names.size
  end
end
