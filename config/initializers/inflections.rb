# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end

ActiveSupport::Inflector.inflections(:en) do |inflect|

  # IPEDS is uncountable
  # Integrated Postsecondary Education Data System
  inflect.uncountable "Ipeds"

  # IPEDS::DirectorySchema is uncountable
  inflect.uncountable "DirectorySchema"
  inflect.uncountable "directory_schema"
  inflect.uncountable "ipeds_directory_schema"

  # IPEDS::CompletionSchema is uncountable
  inflect.uncountable "CompletionSchema"
  inflect.uncountable "completion_schema"
  inflect.uncountable "ipeds_completion_schema"

  # IPEDS::ProgramSchema is uncountable
  inflect.uncountable "ProgramSchema"
  inflect.uncountable "program_schema"
  inflect.uncountable "ipeds_program_schema"

  # Status is uncountable
  inflect.uncountable "ReshareStatus"
  inflect.uncountable "Status"
  inflect.uncountable "status"
  inflect.uncountable "reshare_status"

  # Ares Item History is uncountable
  inflect.uncountable "ItemHistory"
  inflect.uncountable "item_history"
  inflect.uncountable "ares_item_history"
  inflect.uncountable "cr_ares_item_history"
end
