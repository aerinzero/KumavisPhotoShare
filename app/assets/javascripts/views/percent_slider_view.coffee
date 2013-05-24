KumavisPhotoShare.PercentSliderView = Ember.View.extend
  templateName: 'percent_slider'

  label: null # binding set on instantiation where implemented

  percentage: null # binding set on instantiation where implemented

  # !!! TODO: Bananas
  styleWidth: (->
    "width: #{@get('percentage')}%;"
  ).property('percentage')

  # shorten to one decimal place
  prettyPercentage: (->
    prettyPercentage = "#{@get('percentage')}"
    index = prettyPercentage.indexOf '.'
    unless index is -1
      prettyPercentage = prettyPercentage.slice(0,index+2)
    return prettyPercentage
  ).property('percentage')
