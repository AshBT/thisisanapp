# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require_tree .
#= require d3


jQuery ->
  width = 960
  height = 2200

  cluster = d3.layout.cluster().size([height, width - 160])  ##change the layout here
  diagonal = d3.svg.diagonal().projection((d) -> [d.y, d.x]) 
  svg = d3.select('body').append('svg')  #the actual element that it creates on the page
    .attr('width', width)
    .attr('height', height)
    .append('g')
    .attr("transform", 'translate(40,0)')
  d3.json("flare.json", (root, error) ->
    console.log root
    console.log error
    nodes = cluster.nodes(root)
    links = cluster.links(nodes)
    link = svg.selectAll(".link")
      .data(links)
      .enter()
      .append("path")
      .attr("class", "link")
      .attr("d", diagonal)
    node = svg.selectAll(".node")
      .data(nodes)
      .enter()
      .append("g")
      .attr("class", "node")
      .attr("transform", (d) -> "translate(" + d.y + "," + d.x + ")")
    node.append("circle").attr("r", 4.5)
    node.append("text")
      .attr("dx", (d) -> if d.children then -10 else 10)
      .attr("dy", 3)
      .style("text-anchor", (d) -> if d.children then "end" else "start")
      .text((d) -> d.name)
  )
  d3.select(self.frameElement).style("height", height + "px")


