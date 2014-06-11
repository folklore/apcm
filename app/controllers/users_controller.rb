class UsersController < ApplicationController
  before_filter :admin_required,
                 only: [:index]
  skip_before_filter :signin_required,
                      only: [:show, :new, :create]
  before_filter :set_user,
                 only: [:edit, :update, :destroy]

  def index
    @users = User.includes(:city, :notes)
  end

  def show
    @user = User.where(id: params[:id])
                .includes(:city)
                .first
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to @user, notice: 'Done'
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(params[:user],
                               as: current_user.is_admin? ? :admin : :default)
      redirect_to @user, notice: 'Done'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url
  end

  private
    def set_user
      @user = current_user.is_admin? ? User.where(id: params[:id]).first : current_user
    end
end