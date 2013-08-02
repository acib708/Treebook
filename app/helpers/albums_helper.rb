module AlbumsHelper
  def album_thumbnail(album)
    if album.pictures.count > 0
      image_tag album.pictures.first.asset.url(:small)
    else
      image_tag 'http://www.beginningiosdev.com/wp-content/uploads/2012/05/screen-shot-2011-10-17-at-2-56-25-am.png'
    end
  end

  def can_edit_album?(album)
    true
  end

end
