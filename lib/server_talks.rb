class ServerTalks
  def self.build_server(&block)
    klass = Class.new
    ???? &block
    klass
  end
end
