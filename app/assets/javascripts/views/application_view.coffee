KumavisPhotoShare.ApplicationView = Ember.View.extend
  
  # Element heights
  controlPanelHeight: 150
  filmStripWidth: 200

  didInsertElement: ->
    @_super()
    
    # Position Elements
    @positionElements()

    # Setup reposition on window resize
    $(window).resize => @positionElements()
    
  positionElements: ->
    console.log "resize"

    # Main section, left
    @$('.left').width $(window).width()-@get('filmStripWidth')
    @$('.left').offset
      top: 0
      left: 0
    @$('.left').height $(window).height()

    # Main section - control panel
    @$('.left .controlPanel').width $(window).width()-@get('filmStripWidth')
    @$('.left .controlPanel').offset
      top: $(window).height()-@get('controlPanelHeight')
      left: 0
    @$('.left .controlPanel').height @get('controlPanelHeight')

    # Main-section - control panel - buttons
    @$('.left .controlPanel .downloadBtn').offset
      top: $('.left .controlPanel').position().top+($('.left .controlPanel').height()-50)/2
      left: ($('.left .controlPanel').width()-150)/2+100
    @$('.left .controlPanel .uploadBtn').offset
      top: $('.left .controlPanel').position().top+($('.left .controlPanel').height()-50)/2
      left: ($('.left .controlPanel').width()-150)/2-100

    # filmstrip section, right
    @$('.right').width @get('filmStripWidth')
    @$('.right').offset
      top: 0
      left: $(window).width()-@get('filmStripWidth')
    @$('.right').height $(window).height()
    