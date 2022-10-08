class PostsController < ApplicationController
  before_action :set_post, only: %i[ show update destroy ]

  # GET /posts
  def index
    @posts = Post.all

    render json: @posts
  end


  # POST /posts
  def create

    image_client = post_params[:image] 

    file_obj = Cloudinary::Uploader.upload(image_client, 
      use_filename:true, 
      unique_filename:false,
      overwrite:true
    )
    

    file_hash = file_obj.to_h
    puts file_hash["public_id"]

    post_hash = { title: post_params[:title], image_path: file_hash["url"], image_public_id: file_hash["public_id"] }
    @post = Post.new(post_hash)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end

  end



  # DELETE /posts/1
  def destroy
    Cloudinary::Uploader.destroy(@post[:image_public_id], :resource_type => 'image')
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :image)
    end
end
