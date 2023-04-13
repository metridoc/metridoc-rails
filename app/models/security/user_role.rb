class Security::UserRole < ApplicationRecord
  has_many :admin_users
  has_many :user_role_sections, class_name: "Security::UserRoleSection"

  accepts_nested_attributes_for :user_role_sections, allow_destroy: true, reject_if: proc {|attributes| attributes['section'].blank? }

  MANAGED_SECTIONS = [  "Security",
                        "Ares",
                        "Alma",
                        "Borrowdirect",
                        "Consultation",
                        "EzBorrow",
                        "GateCount",
                        "Illiad",
                        "Keyserver",
                        "Marc",
                        "LibraryProfile",
                        "SupplementalData",
                        "Log",
                        "Bookkeeping",
                        "Tools",
                        "Misc",
                        "Report",
                        "Reshare",
                        "UpennAlma",
                        "Ezproxy",
                        "Ipeds"
                      ]

  ACCESS_LEVELS = ["read-only", "read-write"]

  # Define the authorization function for all pages here.
  def authorized?(action, subject)
    return true unless Security::UserRole.subject_secured?(subject)

    s = Security::UserRole.translate_subject_to_section(subject)
    access_level = action == :read || :statistics ? ['read-only', 'read-write'] : 'read-write'

    puts "checking: #{s} - #{access_level} - #{action.to_s}"

    return self.user_role_sections.of_section_access_level(s, access_level).present?
  end

  # Check if the subject is in the list of managed sections of the site
  def self.subject_secured?(subject)
    section = translate_subject_to_section(subject)
    # Check both the normal sections (for models)
    # and a downcase version (for namespaces)
    return section.in?(MANAGED_SECTIONS.map(&:downcase) + MANAGED_SECTIONS)
  end

  # Turn the subject into an equivalent section name
  def self.translate_subject_to_section(subject)
    # Use a case statement to determine what subject is
    case subject
    when ActiveAdmin::Page
      # Return the namespace of the page
      s = subject.namespace_name
    when Class
      # Return the class
      s = subject
    when String
      # Handle a String input
      s = subject
    else
      # Otherwise return the subject's class
      s = subject.class
    end

    # Use a regex to get the module name from Module::Class
    if (m = s.to_s.match(/(?<module>[^\:]+)\:\:/))
      s = m[:module]
    end

    s = "Security" if s.to_s == "AdminUser"
    s = "SupplementalData" if s.to_s.in?(["GeoData", "Institution"])

    return s.to_s
  end

  def self.section_select_options
    MANAGED_SECTIONS.sort_by{
      |e| Security::UserRoleSection.section_humanized_name(e).upcase
    }.map{|e| [Security::UserRoleSection.section_humanized_name(e), e]}
  end

  def user_role_sections_sorted
    self.user_role_sections.sort_by{
      |a| Security::UserRoleSection.section_humanized_name(a.section)
    }
  end

end
