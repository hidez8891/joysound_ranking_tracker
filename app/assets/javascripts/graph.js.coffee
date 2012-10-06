url = $("#song_url").val()

if url?
  createChart = (params) ->
    chart = new Highcharts.StockChart(
      chart:
        renderTo: params.id
      rangeSelector:
        selected: 4
      title:
        text: ''
      yAxis:
        title: ''
        reversed: params.reversed
      navigator:
        yAxis:
          reversed: params.reversed
      tooltip:
        shared: false
        pointFormat: '<span style="color:{series.color}">{series.name}</span>: ' +
            '<b>{point.y}'+params.suffix+'</b>'
      series: params.data
    )

  $.getJSON(
    url + '.json' ,
    (data) ->
      rank_data = []
      point_data = []

      for song in data
        rank_data.push(
          name: song.title
          data: ([Date.parse(log.date), parseInt(log.rank)] for log in song.logs)
        )
        point_data.push(
          name: song.title
          data: ([Date.parse(log.date), parseInt(log.point)] for log in song.logs)
        )
        null

      createChart(
        id: 'rank_graph'
        data: rank_data
        reversed: true
        suffix: '位'
      )

      createChart(
        id: 'point_graph'
        data: point_data
        reversed: false
        suffix: '票'
      )
      null
  )

