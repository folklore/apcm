class SessionsController < ApplicationController
  skip_before_filter :signin_required,
                      except: [:destroy]

  def create
    user = User.where(email: params[:email]).first

    if user and user.citizen?(params[:city_id])
      session[:current_user_id] = user.id
      flash[:notice] = "Welcome #{user.name}!"
    end

    redirect_to :root
  end

  def destroy
    session.delete(:current_user_id)
    redirect_to :root, notice: 'Goodbye'
  end
end