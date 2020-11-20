require 'test_helper'

class ReportGalleryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get report_gallery_index_url
    assert_response :success
  end

end
