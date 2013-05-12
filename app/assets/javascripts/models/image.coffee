KumavisPhotoShare.Image = DS.Model.extend

  fileName: DS.attr('string')

  originalUrl: ( ->
    "/images/#{@get('id')}.original"
  ).property("id")

  iconUrl: ( ->
    "/images/#{@get('id')}.icon"
  ).property("id")

  thumbnailUrl: ( ->
    "/images/#{@get('id')}.thumbnail"
  ).property("id")