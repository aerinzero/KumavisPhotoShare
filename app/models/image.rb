class Image < ActiveRecord::Base
  attr_accessible :file_name, :data

  has_attached_file :data,
    path: ":rails_root/../KumavisPhotoShare_assets/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename",
    styles: { thumbnail: ["200x200#", :png], icon: ["460x345#", :png]}

end
