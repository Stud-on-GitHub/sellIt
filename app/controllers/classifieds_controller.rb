class ClassifiedsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :find_classified, only: [:show, :update, :destroy]
  before_action :check_authorization, only: [:update, :destroy]

  def index
    render json: Classified.all
  end
  
  def show
    # classified = Classified.find_by(id: params[:id]) # find_by() if not found => no error, with find() => error
    # render json: {}, status: :not_found and return unless classified
    # render json: classified
    render json: @classified
  end

  def create
    classified = current_user.classifieds.create(classified_params)
    if classified.save
      render json: classified, status: :created
    else
      render json: classified.errors.details, status: :bad_request
    end
  end

  def update
    # classified = Classified.find_by(id: params[:id]) # find_by() if not found => no error, with find() => error
    # render json: {}, status: :not_found and return unless classified
    # render json: {}, status: :forbidden and return unless classified.user_id == current_user.id
    # if classified.update(classified_params)
    #   render json: classified
    # else
    #   render json: classified.errors.details, status: :bad_request
    # end
    if @classified.update(classified_params)
      render json: @classified
    else
      render json: @classified.errors.details, status: :bad_request
    end
  end

  def destroy
    # classified = Classified.find_by(id: params[:id])
    # render json: {}, status: :not_found and return unless classified
    # render json: {}, status: :forbidden and return unless classified.user_id == current_user.id
    # if classified.destroy
    #   render json: {}, status: :no_content
    # else
    #   render json: classified.errors.details, status: :bad_request
    # end
    if @classified.destroy
      render json: {}, status: :no_content
    else
      render json: @classified.errors.details, status: :bad_request
    end
  end

  private

  def classified_params
    params.require(:classified).permit(:title, :price, :description)
  end

  def find_classified
    @classified = Classified.find_by(id: params[:id]) # find_by() if not found => no error, with find() => error
    render json: {}, status: :not_found and return unless @classified
  end

  def check_authorization
    render json: {}, status: :forbidden and return unless @classified.user_id == current_user.id
  end
end
