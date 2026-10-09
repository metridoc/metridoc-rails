# Map the Demographic Groups to a simpler set of groups.
USER_GROUP_MAP = {
  'Alumni' => 'Alumni',
  'Associate' => 'Faculty',
  'Borrow Direct Plus' => 'Faculty',
  'Courtesy Borrower' => 'Other',
  'Drexel Faculty' => 'Other',
  'Faculty' => 'Faculty',
  'Faculty Express' => 'Faculty',
  'Faculty Spouse' => 'Other',
  'GIC textbook users' => 'Undergraduate Student',
  'Grad Student' => 'Graduate Student',
  'Library Staff' => 'Library Staff',
  'Medical Center Staff' => 'Staff',
  'Reciprocal Borrower' => 'Other',
  'Retired Library Staff' => 'Library Staff',
  'Staff' => 'Staff',
  'Undergraduate Student' => 'Undergraduate Student',
  'purge' => 'Unknown',
  'Unknown' => 'Unknown',
  '' => 'Unknown'
}.freeze

# Create a reverse lookup that maps the simplified user group to an array of user groups
REVERSE_USER_GROUP_MAP = USER_GROUP_MAP.each_with_object({}) do | (k, v), h|
  h[v] ||= []
  h[v] << k
end.transform_values(&:freeze.freeze)

SCHOOL_MAP = {
  '' => 'Unknown',
  "Annenberg Center" => "Other",
  "Annenberg School for Communication" => "Annenberg School for Communication",
  "Audit, Compliance and Privacy" => "Other",
  "Business Resources" => "Other",
  "Campus Services" => "Other",
  "College of Arts & Sciences" => "School of Arts & Sciences",
  "Comptroller/Division of Finance" => "Other",
  "DRIA" => "Other",
  "Development" => "Other",
  "EVP" => "Other",
  "FRES" => "Other",
  "General University" => "Other",
  "General University Special" => "Other",
  "Graduate School of Education" => "Graduate School of Education",
  "Human Resources" => "Other",
  "ICA" => "Other",
  "ISC" => "Other",
  "Law School" => "Penn Carey Law",
  "Morris Arboretum" => "Other",
  "Museum" => "Other",
  "PROV Health & Wellness Administration" => "Other",
  "Penn Global" => "Other",
  "Penn Libraries" => "Penn Libraries",
  "Penn Praxis" => "Other",
  "Perelman School of Medicine" => "Perelman School of Medicine",
  "President" => "Other",
  "Provost" => "Other",
  "Public Safety" => "Other",
  "School of Dental Medicine" => "School of Dental Medicine",
  "School of Design" => "Stuart Weitzman School of Design",
  "School of Engineering and Applied Science" => "School of Engineering and Applied Science",
  "School of Nursing" => "School of Nursing",
  "Social Policy & Practice" => "Social Policy & Practice",
  "The Wharton School" => "The Wharton School",
  "VPUL" => "Other",
  "Veterinary Medicine" => "Veterinary Medicine"
}.freeze()

# Create a reverse lookup that maps the simplified affiliations to an array of affiliations
REVERSE_SCHOOL_MAP = SCHOOL_MAP.each_with_object({}) do | (k, v), h|
  h[v] ||= []
  h[v] << k
end.transform_values(&:freeze.freeze)

ABBV_SCHOOL_MAP = {
  '' => 'Unknown',
  "Annenberg Center" => "Other",
  "Annenberg School for Communication" => "ASC",
  "Audit, Compliance and Privacy" => "Other",
  "Business Resources" => "Other",
  "Campus Services" => "Other",
  "College of Arts & Sciences" => "SAS",
  "Comptroller/Division of Finance" => "Other",
  "DRIA" => "Other",
  "Development" => "Other",
  "EVP" => "Other",
  "FRES" => "Other",
  "General University" => "Other",
  "General University Special" => "Other",
  "Graduate School of Education" => "GSE",
  "Human Resources" => "Other",
  "ICA" => "Other",
  "ISC" => "Other",
  "Law School" => "LAW",
  "Morris Arboretum" => "Other",
  "Museum" => "Other",
  "PROV Health & Wellness Administration" => "Other",
  "Penn Global" => "Other",
  "Penn Libraries" => "LIBRARY",
  "Penn Praxis" => "Other",
  "Perelman School of Medicine" => "PSOM",
  "President" => "Other",
  "Provost" => "Other",
  "Public Safety" => "Other",
  "School of Dental Medicine" => "DENTAL",
  "School of Design" => "DESIGN",
  "School of Engineering and Applied Science" => "SEAS",
  "School of Nursing" => "NURSING",
  "Social Policy & Practice" => "SP2",
  "The Wharton School" => "WHARTON",
  "VPUL" => "Other",
  "Veterinary Medicine" => "VET"
}.freeze()

# Create a reverse lookup that maps the simplified affiliations to an array of affiliations
REVERSE_ABBV_SCHOOL_MAP = ABBV_SCHOOL_MAP.each_with_object({}) do | (k, v), h|
  h[v] ||= []
  h[v] << k
end.transform_values(&:freeze.freeze)
