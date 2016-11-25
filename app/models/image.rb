class Image < ApplicationRecord

  def self.store prefix, image
    return nil unless image
    file_name = "#{prefix}." << image.original_filename
    directory = "uploads"
    path = File.join(directory, file_name)
    File.open(path, "wb") { |f| f.write(image.read)}
    resp = Cloudinary::Uploader.upload(path)
    return nil unless resp
    return resp
  end

  def self.delete_by_id id
    Cloudinary::Uploader.destroy(id)
  end

  def self.delete_by_ids ids
    ids.each do |id|
      if id.nil?
        next
      end

      Cloudinary::Uploader.destroy(id)
    end
  end

end