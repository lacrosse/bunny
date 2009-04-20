$:.unshift File.expand_path(File.dirname(__FILE__))

%w[socket thread timeout amqp].each do |file|
	require file
end

%w[ exchange queue header ].each do |file|
  require "bunny/#{file}"
end

class Bunny
	
	attr_reader :client

  class Error < StandardError; end

	def initialize(opts = {})
		@client = AMQP::Client.new(opts)
  end

	def start
		client.start_session
	end

	def status
		client.status
	end
  
  def queue(name, opts = {})
    queues[name] ||= Queue.new(client, name, opts)
  end

  def stop
    client.close
  end

  def queues
    @queues ||= {}
  end

  def direct(name = 'amq.direct', opts = {})
    exchanges[name] ||= Exchange.new(client, :direct, name, opts)
  end

  def topic(name = 'amq.topic', opts = {})
    exchanges[name] ||= Exchange.new(client, :topic, name, opts)
  end

  def headers(name = 'amq.match', opts = {})
    exchanges[name] ||= Exchange.new(client, :headers, name, opts)
  end

  def exchanges
    @exchanges ||= {}
  end

end