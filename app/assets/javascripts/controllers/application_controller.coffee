KumavisPhotoShare.ApplicationController = Ember.ArrayController.extend
  needs: ['loadingModal']
  
  # list of images to show
  content: null
  currentImage: null

  # the modal to show (loading modal)
  currentModalTemplate: null

  isModalVisible: (-> @get('currentModalTemplate')? ).property('currentModalTemplate')

  download: -> console.log "download"

  # This is used for actually doing the work to add the images to their appropriate records and committing them to 
  # the backend.  We are using a POST request w/ ajax here since ember-data does not support file attachments as
  # of yet.

  uploadImages: (files) ->
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
      loadingModalController = @controllerFor('loadingModal')
      loadingModalController.set('content',xhr)
      loadingModalController.set('formData',formData)
      @send('openModal','loadingModal')

      # Server response
      loadingModalController.set 'onloadCallback', (event) =>
        # Load our images into the store -- they should not need a .commit() because the server will have already done this
        imagesData = JSON.parse(event.currentTarget.responseText).images
        attachmentIds = imagesData.mapProperty('id')
        @store.loadMany(KumavisPhotoShare.Image, imagesData)

        # We are grabbing the last object that we uploaded and we're setting that as our current image
        displayImage = @get('images.lastObject')
        @set('currentImage', displayImage)

        @store.commit()

        @send('closeModal')

      # This sends the xhr request
      loadingModalController.initiateUpload()