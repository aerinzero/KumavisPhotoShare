KumavisPhotoShare.ApplicationView = Ember.View.extend
  
  # Element heights
  controlPanelHeight: 150
  filmStripWidth: 210
  
  currentImage: (-> 
    retVal = @get('controller.currentImage')
    if retVal? == false
      @selectImage @get('controller.firstObject')
      retVal = @get('controller.firstObject')
    return retVal
  ).property('controller.currentImage','controller.firstObject')

  currentImageUrl: (->
    # trigger reposition after image loads
    Ember.run.next => @$('.left .thumbnail img').on 'load', => $(window).resize()
    
    if @get('showLargeCurrentImage')
      @get('currentImage.largeUrl')
    else
      @get('currentImage.mediumUrl')
  ).property('currentImage','showLargeCurrentImage')

  showLargeCurrentImage: true

  selectImage: (image) -> 
    @set('controller.currentImage',image)
    # trigger reposition after image loads
    Ember.run.next => @$('.left .thumbnail img').on 'load', => $(window).resize()

  didInsertElement: ->
    @_super()
    # Position Elements
    @positionElements()
    
    # Setup reposition on window resize
    $(window).resize => @positionElements()
    
    # Setup file handling
    @_setupFileHandling()

  positionElements: ->
    # set image size
    @set 'showLargeCurrentImage', @$('.left').width()>900

    # Main section, left
    @$('.left').width $(window).width()-@get('filmStripWidth')
    @$('.left').offset
      top: 0
      left: 0
    @$('.left').height $(window).height()

    # Main section - image
    @$('.left .thumbnail').offset
      top: ($(window).height()-@get('controlPanelHeight'))/2-@$('.left .thumbnail img').height()/2
      left: ($(window).width()-@get('filmStripWidth'))/2-@$('.left .thumbnail img').width()/2

    # Main section - control panel
    @$('.left .controlPanel').width $(window).width()-@get('filmStripWidth')
    @$('.left .controlPanel').offset
      top: $(window).height()-@get('controlPanelHeight')
      left: 0
    @$('.left .controlPanel').height @get('controlPanelHeight')

    # Main-section - control panel - buttons
    
    # Download
    @$('.left .controlPanel #downloadBtn').offset
      top: $('.left .controlPanel').position().top+($('.left .controlPanel').height()-50)/2
      left: ($('.left .controlPanel').width()-150)/2+150
    
    # Upload
    @$('.left .controlPanel #uploadBtn').offset
      top: $('.left .controlPanel').position().top+($('.left .controlPanel').height()-50)/2
      left: ($('.left .controlPanel').width()-150)/2-150
    @$('.left .controlPanel #uploader').offset
      top: $('.left .controlPanel #uploadBtn').offset().top
      left: $('.left .controlPanel #uploadBtn').offset().left
    @$('.left .controlPanel #uploader').width 150
    @$('.left .controlPanel #uploader').height $('.left .controlPanel #uploadBtn').height()

    # filmstrip section, right
    @$('.right').width @get('filmStripWidth')
    @$('.right').offset
      top: 0
      left: $(window).width()-@get('filmStripWidth')
    @$('.right').height $(window).height()

    # setup lazy loading for images - class 'lazy' is added when this is setup
    @$(".thumbnail > img:not(.lazy)").lazyload
      container: $(".right")

  showUploadBox: -> $('input#uploader')[0].click()
    
  _setupFileHandling: ->
    self = this

    $(document).on 'dragover.imgGallery', (event) ->
      event.dataTransfer.dropEffect = 'copy'

    $(document).on 'drop.imgGallery', (event) ->
      event.stopPropagation()
      event.preventDefault()
      self._addImages event.dataTransfer.files
      return false

    $(document).on 'change.imgGallery', "input#uploader", (event) ->
      self._addImages @files
      $(this).val(null)
      return false

  _addImages: (files) -> @controller.uploadImages(files)