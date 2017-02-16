class AddAttachmentPhotoToTestimonials < ActiveRecord::Migration
  def self.up
    change_table :testimonials do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :testimonials, :photo
  end
end
