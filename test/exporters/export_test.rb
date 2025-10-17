require 'test_helper'

class Export::ExportTest < ActiveSupport::TestCase
  test "Missing Configuration Folder" do
    options = {
      "config_folder": "unreal_folder_name"
    }

    assert_raises(RuntimeError) {
      Export::Export.new(options)
    }
  end
end

class Export::TaskTest < ActiveSupport::TestCase
  test "Class Exists" do
    expected = Export::Task.new(nil, {})
    assert expected.respond_to?(:csv_file_path)
  end  
end

class Export::Dynamodb::TaskTest < ActiveSupport::TestCase
  test "Class Existance" do
    yaml_file = {
      "aws_region": "us-east-1",
      "aws_profile": "metridoc_read",
      "source_table": "StreamDeck-SPI"
    }
    
    expected = Export::Dynamodb::Task.new(nil, yaml_file)
    assert expected.respond_to?(:scan_items)
    assert expected.respond_to?(:execute)
  end

  test "Save Query Data" do
    data = Aws::DynamoDB::Types::ScanOutput.new(
      :count => 574, 
      :scanned_count => 580, 
      :last_evaluated_key => nil, 
      :consumed_capacity => 
      Aws::DynamoDB::Types::ConsumedCapacity.new(
        :capacity_units => 9.0
      )
    )

    task = Export::Dynamodb::Task.new(nil, {})
    actual = task.save_query_data(data)
    expected = StreamDeck::ServicePoint::Query.create(
      :count => 574,
      :scanned_count => 580,
      :capacity_units => 9.0,
      :downloaded_at => Time.now()
    )

    assert_equal expected.count, actual.count
    assert_equal expected.scanned_count, actual.scanned_count
    assert_equal expected.capacity_units, actual.capacity_units
  end
end
