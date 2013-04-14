require 'json'
class JsonWrapper
  def initialize(attribute)
    @attribute = attribute.to_s
  end

  def before_save(record)
    record.send("#{@attribute}=", JsonWrapper.encrypt(record.send("#{@attribute}")))
  end

  def after_save(record)
    record.send("#{@attribute}=", JsonWrapper.decrypt(record.send("#{@attribute}")))
  end

  def self.encrypt(value)
    value.to_json
  end

  def self.decrypt(value)
    JSON.parse(value) rescue value
  end
end