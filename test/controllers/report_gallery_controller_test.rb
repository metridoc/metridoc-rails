require 'test_helper'

class ReportGalleryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get report_gallery_url
    assert_response :success
  end

end
