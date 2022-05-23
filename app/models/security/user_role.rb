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
                        "UpennEzproxy"
                      ]
  ACCESS_LEVELS = ["read-only", "read-write"]

  # Define the authorization function for all pages here.
  def authorized?(action, subject)
    return true unless Security::UserRole.subject_secured?(subject)

    s = Security::UserRole.translate_subject_to_section(subject)
    access_level = action == :read ? ['read-only', 'read-write'] : 'read-write'

    puts "checking: #{s} - #{access_level} - #{action.to_s}"

    return self.user_role_sections.of_section_access_level(s, access_level).present?
  end

  # Check if the subject is in the list of managed sections of the site
  def self.subject_secured?(subject)
    return translate_subject_to_section(subject).in?(MANAGED_SECTIONS)
  end

  # Turn the subject into an equivalent section name
  def self.translate_subject_to_section(subject)
    # If the subject is type Class, return the subject
    if subject.is_a?(Class)
      s = subject
    # Find the namespace of the subject, if it is defined
    # TODO: Placeholder for reconfiguration of namespaces
    # Currently has no effect.
    elsif subject.respond_to?(:namespace_name)
      s = subject.class
    # If the subjects class isn't a string, return the class name
    elsif subject.class.to_s != "String"
      s = subject.class
    # Otherwise return the subject (a string)
    else
      s = subject
    end

    # Use a regex to get the module name from Module::Class
    if (m = s.to_s.match(/(?<module>[^\:]+)\:\:/))
      s = m[:module]
    end

    s = "Security" if s.to_s == "AdminUser"
    # BUG: At this point GeoData::ZipCode will be processed to GeoData ... feature?
    s = "SupplementalData" if s.to_s.in?(["UpsZone", "GeoData::ZipCode", "Institution"])

    return s.to_s
  end

  def self.section_select_options
    MANAGED_SECTIONS.sort_by{|e| Security::UserRoleSection.section_humanized_name(e).upcase }.map{|e| [Security::UserRoleSection.section_humanized_name(e), e]}
  end

  def user_role_sections_sorted
    self.user_role_sections.sort_by{|a| Security::UserRoleSection.section_humanized_name(a.section)}
  end

end
