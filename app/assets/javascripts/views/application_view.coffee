KumavisPhotoShare.ApplicationView = Ember.View.extend
  
  # Element heights
  controlPanelHeight: 150
  filmStripWidth: 200

  currentImage: null
  
  selectImage: (image) -> 
    @set('currentImage',image)

    Ember.run.next =>
      @$('.left .thumbnail img').on 'load', => $(window).resize()
      check = @$('.left .thumbnail img')

  didInsertElement: ->
    @_super()
    # Position Elements
    @positionElements()
    
    # Setup reposition on window resize
    $(window).resize => @positionElements()
    
    # Setup file handling
    @_setupFileHandling()

  positionElements: ->
    console.log "resize"

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

  # This is used for actually doing the work to add the images to their appropriate records and committing them to 
  # the backend.  We are using a POST request w/ ajax here since ember-data does not support file attachments as
  # of yet.

  _addImages: (files) ->
    if files.length > 0

      # We are going to use a HTML5 FormData object to serialize
      formData = new FormData()

      # Loop through the FileList and attach image files to our form
      for file in files
        formData.append "images[files][#{file.name}]", file if file.type.match("image.*")

      # This will open up an ajax request to /images
      xhr = new XMLHttpRequest()
      xhr.open "POST", "/images", true

      # bring up the loading modal
      # loadingModalController = @controllerFor('loadingModal')
      # loadingModalController.set('content',xhr)
      # loadingModalController.set('formData',formData)
      # @send('openModal','loadingModal')

      # Server response
      # loadingModalController.set 'onloadCallback', (event) =>
      xhr.onload = (event) =>
        # Load our images into the store -- they should not need a .commit() because the server will have already done this
        imagesData = JSON.parse(event.currentTarget.responseText).images
        attachmentIds = imagesData.mapProperty('id')
        @controller.store.loadMany(KumavisPhotoShare.Image, imagesData)
        
        # !!!: This exists because when loading data, the associations on the flip-side are not auto-loaded
        images = @get('images')
        # attachmentIds.forEach (id) => 
        #   attachment = KumavisPhotoShare.Image.find(id)
        #   images.pushObject(attachment) if !@get('images').contains(attachment)

        # We are grabbing the last object that we uploaded and we're setting that as our current image
        displayImage = @get('images.lastObject')
        @set('currentImage', displayImage)

        # !!!: This should be done server-side, not client-side
        # We're going to set a coverImage if our current coverImage is nil
        @set('coverImage', displayImage) if !@get('coverImage')?
        @controller.store.commit()

      # This sends the xhr request
      # loadingModalController.initiateUpload()
      xhr.send formData