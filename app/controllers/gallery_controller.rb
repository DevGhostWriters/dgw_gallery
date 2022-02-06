class GalleryController < ApplicationController
  before_action :set_gallery, only: [:manage, :update, :destroy]

  def index
    @page = 'gallery'
    @galleries = Gallery.all
  end

  def manage
    @page = 'add'

  end

  def add_to_gallery
    if !params[:id]
        redirect_back(fallback_location: admin_gallery_path) and return
    end

    ap "adding pfiSet: #{params[:id]} to gallery images"

    gallery = Gallery.first
    ### get pfiSet and copy to giSet
    pfiSet = PortfolioImage.find(params[:id])
    giSet = GalleryImage.where(gallery_id: gallery.id, portfolio_images_id: pfiSet.id).first_or_create
    giSet.before.attach(io: StringIO.new(pfiSet.before.download), filename: pfiSet.before.filename, content_type: pfiSet.before.content_type)
    giSet.after.attach(io: StringIO.new(pfiSet.after.download), filename: pfiSet.after.filename, content_type: pfiSet.after.content_type)
    giSet.caption = pfiSet.portfolio.user.first_name + " " + pfiSet.portfolio.user.last_name + " | " + pfiSet.portfolio.user.city + ", " + pfiSet.portfolio.user.state
    giSet.portfolio_images_id = pfiSet.id
    giSet.save

  end

  def upload_to_gallery
    ### do we have uploaded portfolio images
    if params[:before] && params[:after]
        bImage = params[:before]
        caption = params[:caption]
        gallery = Gallery.first
        giSet = GalleryImage.new
        giSet.gallery_id = gallery.id

        giSet.before.attach(io: File.open(bImage.path), filename: bImage.original_filename, content_type: bImage.content_type)
        giSet.caption = (caption.blank?)? "ARC Expert Work Example" : caption
        giSet.save
    
        flash[:success] = "Image set was successfully added to the gallery"
        redirect_back(fallback_location: gallery_path) and return
    else
        flash[:error] = "Please upload iamges in sets."
        redirect_back(fallback_location: gallery_path) and return

    end



  end


  def remove_from_gallery
    if !params[:id]
        redirect_back(fallback_location: admin_gallery_path) and return
    end

    rmSet = GalleryImage.find(params[:id])
    rmSet.destroy

  end

  

  # GET /gallery/new
  def new
    @gallery = Gallery.new
  end

  # POST /gallery
  def create
    @gallery = Gallery.new(gallery_params)

    if @gallery.save
      redirect_to @gallery, notice: 'Gallery was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /gallery/1
  def update
    if @gallery.update(gallery_params)
      redirect_to @gallery, notice: 'Gallery was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /gallery/1
  def destroy
    @gallery.destroy
    redirect_to gallery_url, notice: 'Gallery was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gallery
      @gallery = Gallery.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gallery_params
      params.fetch(:gallery, {})
    end

end

