class Node < ActiveRecord::Base
  attr_accessible :source, :target, :serialize_node_data_to_json

  def serialize_node_data_to_json
    hash = {}
    links_hash = {}
    a = Node.all

    while a.count > 0 do
      node1 = a.pop()
      node2 = a.pop()
      hash["nodes"] = node1
      hash["nodes"] = node2
      links_hash["source"] = node2.id
      links_hash["target"] = node1.id
      hash["links"] = [links_hash]
    end

    @nodes_hash = hash
  end

end

