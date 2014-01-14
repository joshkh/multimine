class MyHelper

	# mediator = _.extend({}, Backbone.Events)

	test: ->
		console.log("test has been called");

	queryAll = (mines, query, timeout) ->
		for mine, value of mines
			Q.timeout(runOne(value, query), timeout).then(->
				console.log "success"
			).fail ->
				mediator.trigger "timeout", "general failure"

	quickSearchAll = (mines, term, timeout) ->
		for mine, value of mines
			Q(quickSearch term, timeout).then( (results) =>
				console.log(results.facets)
			).fail (message) ->
				mediator.trigger "timeout", message

	runOne = (url, query) ->
		mine = new IM.Service root: url
		Q(mine.records query).then( (results) ->
			console.log results.facets)

	logFailure = (message) ->
		console.log "FAILURE", message

	quickSearch = (term) ->
		mine = new IM.Service root: "beta.flymine.org/query"
		mine.search term

	quickSearchSingle: (term) ->
		mine = new intermine.Service root: "www.mousemine.org/mousemine"
		mine.search term

	calcCategories: (json) ->
		map = {}
		someData = []

		console.log "facets", json.facets.Category

		_.each json.facets.Category, (values, key, list) ->
			console.log "key", key
			aMap = {}
			aMap.legendLabel = key
			aMap.magnitude = values
			someData.push aMap

		console.log "someData", someData

		someData

	calcOrganisms: (json) ->
		map = {}
		someData = []
		# values = _.groupBy json.facets.Category, (val, key) ->
		# 	console.log "val", key
		# 	aMap = {}
		# 	aMap.legendLabel = key
		# 	aMap.magnitude = val
		# 	somedata.push aMap
		console.log "facets", json.facets["organism.shortName"]

		_.each json.facets["organism.shortName"], (values, key, list) ->
			console.log "key", key
			aMap = {}
			aMap.legendLabel = key
			aMap.magnitude = values
			someData.push aMap

		console.log "someData", someData

		someData

	buildChart: (myvalues) ->

		console.log "buildingChart", myvalues

		angle = (d) ->
		  a = (d.startAngle + d.endAngle) * 90 / Math.PI - 90
		  (if a > 90 then a - 180 else a)

		canvasWidth = 600
		canvasHeight = 600
		outerRadius = 150
		innerRadius = 75
		w = 300
		h = 300
		r = Math.min(w, h) / 2
		labelr = r
		color = d3.scale.category20()
		dataSet = myvalues
		vis = d3.select("body").append("svg:svg").data([dataSet]).attr("width", canvasWidth).attr("height", canvasHeight).append("svg:g").attr("transform", "translate(" + 1.5 * outerRadius + "," + 1.5 * outerRadius + ")")
		arc = d3.svg.arc().innerRadius(innerRadius).outerRadius(outerRadius)
		pie = d3.layout.pie().value((d) ->
		  d.magnitude
		).sort((d) ->
		  null
		)

		arcs = vis.selectAll("g.slice").data(pie).enter().append("svg:g").attr("class", "slice")

		arcs.append("svg:path").attr("fill", (d, i) ->
		  color i
		).attr "d", arc

		# arcs.append("svg:text").attr("transform", (d) ->
		#   console.log "d", d
		#   d.outerRadius = outerRadius + 750
		#   d.innerRadius = outerRadius + 745
		#   "translate(" + arc.centroid(d) + ")"

		# ).attr("text-anchor", "middle").style("fill", "Purple").style("font", "bold 12px Arial").text (d, i) ->
		#   dataSet[i].legendLabel

		arcs.append("svg:text").attr("transform", (d) ->
		  c = arc.centroid(d)
		  x = c[0]
		  y = c[1]
		  h = Math.sqrt(x * x + y * y)
		  "translate(" + (x / h * labelr) + "," + (y / h * labelr) + ")"
		).attr("dy", ".35em").attr("text-anchor", (d) ->
		  (if (d.endAngle + d.startAngle) / 2 > Math.PI then "end" else "start")
		).text (d, i) ->
		  dataSet[i].legendLabel

		arcs.filter((d) ->
		  d.endAngle - d.startAngle > .2
		).append("svg:text").attr("dy", ".35em").attr("text-anchor", "middle").attr("transform", (d) ->
		  d.outerRadius = outerRadius
		  d.innerRadius = outerRadius / 2
		  "translate(" + arc.centroid(d) + ")rotate(" + angle(d) + ")"
		).style("fill", "White").style("font", "bold 12px Arial").text (d) ->
		  d.data.magnitude



module.exports = MyHelper