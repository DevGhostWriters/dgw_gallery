module DgwGallery
  class Engine < ::Rails::Engine
    initializer "dgw_gallery.assets.precompile" do |app|
        app.config.assets.precompile += %w( no_image.png dgw_logo.png )
    end

  end
end
