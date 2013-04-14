hash = {}
links_hash = {}

a = Event.all
puts a

while a.count > 0 do
  Node1 = a.pop()
  Node2 = a.pop()
  hash["nodes"] = Node1
  hash["nodes"] = Node2
  links_hash["source"] = Node2.id
  links_hash["target"] = Node1.id
  hash["links"] = [links_hash]
end
