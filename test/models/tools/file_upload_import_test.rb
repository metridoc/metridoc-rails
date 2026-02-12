require 'test_helper'

class Tools::FileUploadImportTest < ActiveSupport::TestCase

  test "Column to Attribute Conversion" do
     # assert Util.column_to_attribute("Outcome (if Known and Applicable)") == "outcome"
     u = tools_file_upload_imports(:misc_consultation_data)
     assert u.get_headers == ["submitted", "consultation_or_instruction", "staff_expertise", "event_date", "mode_of_consultation", "rtg", "outcome", "research_community", "undergraduate_student_type", "graduate_student_type", "school_affiliation"], "Columns are not parsed correctly."
  end

end
