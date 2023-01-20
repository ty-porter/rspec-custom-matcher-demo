require "logger"
require "securerandom"

class ExampleSender

  def send_message(message:)
    full_message = message.merge(random_attributes)
    receiver.receive_message(sent: full_message.to_json)
  end

  private
  
  def receiver
    @receiver ||= ExampleReceiver.new
  end

  def random_attributes
    {
      id: rand(10_000),
      uuid: SecureRandom.uuid,
      timestamp: Time.now
    }
  end

end

class ExampleReceiver

  def receive_message(sent:)
    logger.info(sent)
  end

  private

  def logger
    @logger ||= Logger.new(STDOUT)
    @logger.level = Logger::INFO
  end

end
