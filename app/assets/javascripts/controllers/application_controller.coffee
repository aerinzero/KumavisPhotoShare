KumavisPhotoShare.ApplicationController = Ember.ArrayController.extend
  # list of images to show
  content: null

  currentImage: null

  selectImage: (image) -> @set('currentImage',image)

  download: ->
    console.log "download"