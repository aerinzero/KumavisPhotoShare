# Our top-most route
KumavisPhotoShare.ApplicationRoute = Ember.Route.extend
  
  setupController: (controller, model) -> 
    xhr = KumavisPhotoShare.Image.find()
    controller.set('content', xhr)

    xhr.then (data) => controller.set('currentImage', data.get('firstObject'))

  events:
    # Opens a modal window for the given templateName
    openModal: (templateName) -> 
      @controllerFor('application').set('currentModalTemplate', templateName)
      @controllerFor(templateName).enter() if @controllerFor(templateName).enter
      @render templateName, into: 'application', outlet: 'modal', controller: templateName

    # Closes a modal window for the given templateName
    closeModal: ->
      templateName = @controllerFor('application').get('currentModalTemplate')
      @controllerFor(templateName).exit() if templateName && @controllerFor(templateName).exit
      @controllerFor('application').set('currentModalTemplate', null)

# Our plane jane / index route
KumavisPhotoShare.IndexRoute = Em.Route.extend()