class Skm::Gollum::File
  def initialize(path)
    @path = path
  end
  attr_reader :path
end