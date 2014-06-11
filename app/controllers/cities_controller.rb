class CitiesController < ApplicationController
  before_filter :admin_required
  before_filter :set_city,
                 only: [:show, :edit, :update, :destroy]

  def index
    @cities = City.all
  end

  def show; end

  def new
    @city = City.new
  end

  def edit; end

  def create
    @city = City.new(params[:city])

    if @city.save
      redirect_to @city, notice: 'Done'
    else
      render :new
    end
  end

  def update
    if @city.update_attributes(params[:city])
      redirect_to @city, notice: 'Done'
    else
      render :edit
    end
  end

  def destroy
    @city.destroy
    redirect_to cities_url
  end

  private
    def set_city
      @city = City.where(id: params[:id]).first
    end
end