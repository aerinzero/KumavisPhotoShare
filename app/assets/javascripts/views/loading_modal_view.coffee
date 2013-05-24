KumavisPhotoShare.LoadingModalView = Em.View.extend
  templateName: 'loading_modal'

  progressDivStyle: (->
    "width: #{100*@get('controller.progressPercent')}px"
  ).property('controller.progressPercent')

  didInsertElement: ->
    @_super()
    # center modal
    @$().offset
      top: ($(window).height())/2
      left: ($(window).width())/2