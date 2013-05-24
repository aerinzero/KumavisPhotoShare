KumavisPhotoShare.Image = DS.Model.extend

  fileName: DS.attr('string')

  originalUrl: ( ->
    "/images/#{@get('id')}.original"
  ).property("id")

  mediumUrl: ( ->
    "/images/#{@get('id')}.medium"
  ).property("id")

  largeUrl: ( ->
    "/images/#{@get('id')}.large"
  ).property("id")

  thumbnailUrl: ( ->
    "/images/#{@get('id')}.thumbnail"
  ).property("id")