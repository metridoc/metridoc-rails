namespace :keyserver do

  desc <<~DESC
    Assign stable opaque aliases to all user_name values in keyserver_events
    and keyserver_sessions that do not yet have an entry in
    keyserver_user_name_maps.

    Aliases are of the form "user_NNNN" where NNNN is a zero-padded integer
    assigned in insertion order.  Once assigned, an alias never changes —
    re-running this task after a fresh import adds only new usernames.

    Run after every import:
      rake import -- --config_folder keyserver
      rake keyserver:seed_user_names
  DESC
  task seed_user_names: :environment do
    # Collect all distinct user_name values from both source tables,
    # excluding NULL / blank entries.
    event_names   = Keyserver::Event.where.not(user_name: [nil, ""])
                                    .distinct
                                    .pluck(:user_name)

    session_names = Keyserver::Session.where.not(user_name: [nil, ""])
                                      .distinct
                                      .pluck(:user_name)

    all_names = (event_names + session_names).uniq.select(&:present?)

    # Find which ones are already mapped.
    existing = Keyserver::UserNameMap.pluck(:original).to_set
    new_names = all_names.reject { |n| existing.include?(n) }

    if new_names.empty?
      puts "keyserver:seed_user_names — no new usernames to map."
      next
    end

    # Determine the next alias sequence number.
    # Aliases look like "user_0001", "user_0042", etc.
    last_alias  = Keyserver::UserNameMap.order(:user_alias).pluck(:user_alias).last
    next_number = if last_alias
                    last_alias.sub(/\Auser_0*/, "").to_i + 1
                  else
                    1
                  end

    inserted = 0
    new_names.each do |name|
      aliased = "user_#{next_number.to_s.rjust(4, '0')}"
      Keyserver::UserNameMap.create!(original: name, user_alias: aliased)
      next_number += 1
      inserted    += 1
    end

    puts "keyserver:seed_user_names — assigned #{inserted} new alias(es). " \
         "Total mapped: #{Keyserver::UserNameMap.count}."
  end

end
