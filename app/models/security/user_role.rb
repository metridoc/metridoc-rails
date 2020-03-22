class Security::UserRole < ApplicationRecord
  has_many :admin_users
  has_many :user_role_access_definitions, class_name: "Security::UserRoleAccessDefinition"

  accepts_nested_attributes_for :user_role_access_definitions, allow_destroy: true, reject_if: proc {|attributes| attributes['element'].blank? }

  MANAGED_ELEMENTS = [  "Security",
                        "Borrowdirect",
                        "EzBorrow",
                        "GateCount",
                        "Illiad",
                        "Keyserver",
                        "Marc",
                        "LibraryProfile",
                        "SupplementalData",
                        "Log",
                        "Bookkeeping"
                      ]
  ACCESS_LEVELS = ["read-only", "read-write"]

  def authorized?(action, subject)
    if subject.is_a?(Class) 
      s = subject
    elsif subject.class.to_s != "String"
      s = subject.class
    else
      s = subject
    end

    if (m = s.to_s.match(/(?<module>[^\:]+)\:\:/))
      s = m[:module]
    end

    s = "Security" if s.to_s == "AdminUser"
    s = "SupplementalData" if s.to_s.in?(["UpsZone", "GeoData::ZipCode", "Institution"])

    return true unless s.to_s.in?(MANAGED_ELEMENTS)

    access_level = action == :read ? ['read-only', 'read-write'] : 'read-write'

    puts "checking: #{s.to_s} - #{access_level} - #{action.to_s}"

    return self.user_role_access_definitions.of_element_access_level(s.to_s, access_level).present?
  end

  def self.select_options
    MANAGED_ELEMENTS.sort_by{|e| Security::UserRoleAccessDefinition.element_humanized_name(e).upcase }.map{|e| [Security::UserRoleAccessDefinition.element_humanized_name(e), e]}
  end

  def user_role_access_definitions_sorted
    self.user_role_access_definitions.sort_by{|a| Security::UserRoleAccessDefinition.element_humanized_name(a.element)}
  end

end
