KumavisPhotoShare.LoadingModalController = Em.ObjectController.extend
  content: null # the xhr request
  progress: 0
  onprogressCallback: null
  label: "Preparing..."

  progressPercent: (->
    100 * @get('progress')
  ).property('progress')

  attachCallbacks: (->
    xhr = @get('content')
    if xhr?
      @set('onprogressCallback',xhr.upload.onprogress)
      xhr.upload.onprogress = (event) => @onprogress(event)
      xhr.onload = (event) => @onload(event)
  ).observes('content')

  initiateUpload: ->
    xhr = @get('content')
    # Send our request and hope for the best
    @set('label',"Uploading...")
    xhr.send @get('formData')

  # xhr events

  onprogress: (event) ->
    # update the progress value
    progress = Number(event.loaded)/Number(event.total)
    @set('progress',progress)

    # if progress value is (1), then final processing is happening
    #  so update the label
    if progress == 1
      @set('label',"Completing Upload")

    # call the any external callback
    callback = @get('onprogressCallback')
    if callback?
      callback(event)

  onload: (event) ->
    # call the any external callback
    callback = @get('onloadCallback')
    if callback?
      callback(event)


  # actions

  # abort the xhr
  abort: ->
    @get('content').abort()
    @send('closeModal')
  
