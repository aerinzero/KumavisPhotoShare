# Our top-most route
KumavisPhotoShare.ApplicationRoute = Ember.Route.extend
  
  setupController: (controller, model) -> 
    @controllerFor('application').set('content',KumavisPhotoShare.Image.find())

# Our plane jane / index route
KumavisPhotoShare.IndexRoute = Em.Route.extend()
