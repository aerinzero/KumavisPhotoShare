KumavisPhotoShare.ApplicationController = Ember.ArrayController.extend
  # list of images to show
  content: null
  currentImage: null

  download: -> console.log "download"