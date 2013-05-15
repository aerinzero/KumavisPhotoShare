# Our top-most route
KumavisPhotoShare.ApplicationRoute = Ember.Route.extend
  
  setupController: (controller, model) -> 
    xhr = KumavisPhotoShare.Image.find()
    controller.set('content', xhr)

    xhr.then (data) => controller.set('currentImage', data.get('firstObject'))

# Our plane jane / index route
KumavisPhotoShare.IndexRoute = Em.Route.extend()