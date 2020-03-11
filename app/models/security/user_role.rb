class Security::UserRole < ApplicationRecord
  has_many :admin_users
  has_many :user_role_access_definitions, -> { order(:element) }, class_name: "Security::UserRoleAccessDefinition"

  accepts_nested_attributes_for :user_role_access_definitions, allow_destroy: true

  MANAGED_ELEMENTS = [  "AdminUser", 
                        "BorrowDirect",
                        "Misc::ConsultationData",
                        "EzBorrow",
                        "GateCount",
                        "Illiad",
                        "Keyserver",
                        "Marc",
                        "LibraryProfile",
                        "Security::UserRole", 
                        "DataSource::Template", 
                        "DataSource::Source",
                        "SupplementalData",
                        "Tools",
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

    s = DataSource::Template if s == DataSource::TemplateStep
    s = DataSource::Source if s == DataSource::SourceStep

    s = "BorrowDirect" if s.to_s.downcase.start_with?("borrowdirect")
    s = "EzBorrow" if s.to_s.downcase.start_with?("ezborrow")
    s = "GateCount" if s.to_s.downcase.start_with?("gatecount")
    s = "Illiad" if s.to_s.downcase.start_with?("illiad")
    s = "Keyserver" if s.to_s.downcase.start_with?("keyserver")
    s = "Marc" if s.to_s.downcase.start_with?("marc")
    s = "Tools" if s.to_s.downcase.start_with?("tools")

    s = "SupplementalData" if s.to_s.in?(["UpsZone", "GeoData::ZipCode", "Institution"])

    return true unless s.in?(MANAGED_ELEMENTS)

    if action == :read
      access_level = ['read-only', 'read-write']
    else
      access_level = 'read-write'
    end

    puts "checking: #{s.to_s} - #{access_level} - #{action.to_s}"

    return self.user_role_access_definitions.of_element_access_level(s.to_s, access_level).present?
  end

  def self.select_options
    MANAGED_ELEMENTS.map{|e| ["#{Object.const_defined?(e) && e.constantize.is_a?(Class) ? e.constantize.model_name.human(count: 2) : I18n.t("phrases.user_role_elements.#{e.downcase}")}", e]}
  end

end
