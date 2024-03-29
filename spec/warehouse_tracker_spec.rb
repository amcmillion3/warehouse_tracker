require 'stringio'
require_relative '../warehouse_tracker'

RSpec.describe WarehouseTracker do
  let(:expected_report) { "Dan: n/a\nKate: hats - $410.00, socks - $34.50 | Average Order Value: $222.25" }

  context "with input via stdin using mock_test_input_1.txt" do
    before do
      input_file = File.join(File.dirname(__FILE__), 'mock_test_data', 'mock_input_1.txt')
      $stdin = File.open(input_file)
      @tracker = WarehouseTracker.new
      @tracker.start_processing
    end

    after do
      $stdin = STDIN
    end

    it "correctly tracks product registrations and inventory for stdin input" do
      expect(@tracker.instance_variable_get(:@products)).to include(
        "hats" => { price: 20.50, stock: 80 },
        "socks" => { price: 3.45, stock: 20 }
      )
    end

    it "correctly processes orders and generates reports for stdin input" do
      expect(@tracker.report).to eq(expected_report)
    end
  end

  context "when ordering a product not in the warehouse or not enough stock" do
    before do
      @tracker = WarehouseTracker.new
      commands = [
        "register socks $3.45",
        "order kate hats 10"
      ]
      @tracker.process_commands(commands)
    end
  
    it "should ignore the order and not add it to the customer's orders" do
      expect(@tracker.instance_variable_get(:@orders)).to have_value({"hats" => [nil]})
    end
  end
end
