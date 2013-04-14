class Event < ActiveRecord::Base
  attr_accessible :classname, :event_name, :file, :id, :line

end
