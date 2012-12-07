class ServerTalks
  def self.build_server(&block)
    Class.new &block
  end
end
