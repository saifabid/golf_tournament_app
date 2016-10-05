class Image < ApplicationRecord
  def self.store prefix, image
    return false unless image
    file_name = "#{prefix}." << image.original_filename
    directory = "uploads"
    path = File.join(directory, file_name)
    File.open(path, "wb") { |f| f.write(image.read)}
    return path
  end
end