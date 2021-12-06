require "test_helper"

class AppointmentsExporterControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get appointments_exporter_index_url
    assert_response :success
  end
end
