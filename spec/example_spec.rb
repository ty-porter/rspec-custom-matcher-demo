require "./lib/example"

require "json"
require "securerandom"

RSpec.describe ExampleSender do

  RSpec::Matchers.define :json_message_including do |expected|
    raise ArgumentError.new("Expected values must be a hash!") unless expected.is_a?(Hash)

    match do |actual|
      actual = JSON.parse(actual)
      expected.all? { |key, value| value == actual[key.to_s] }
    end
  end

  describe "#send_message" do

    subject(:sender) { described_class.new }

    let(:receiver) { spy(ExampleReceiver) }
    let(:sample_metadata) do
      {
        object_type: "User",
        object_uuid: SecureRandom.uuid,
        action: "GET",
        controller: "users"
      }
    end

    before { allow(ExampleReceiver).to receive(:new).and_return(receiver) }

    it "succeeds when the correct payload is passed to the receiver" do
      sender.send_message(message: sample_metadata)

      expect(receiver).to have_received(:receive_message).with(sent: json_message_including(sample_metadata))
    end

  end

end
