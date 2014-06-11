class NotesController < ApplicationController
  skip_before_filter :signin_required,
                      only: [:index, :show]
  before_filter :set_note,
                 only: [:edit, :update, :active, :destroy]

  def index
    @notes = Note.with_users

    case params[:condition]
      when 'actived'
        @notes = @notes.actived
      when 'recent'
        @notes = @notes.recent
      when 'last_changes'
        @notes = @notes.last_changes(current_user.city_id)
                       .limit(params[:n].blank? ? 10 : params[:n])
    end
  end

  def show
    @note = Note.where(id: params[:id])
                .includes(user: { city: { } })
                .first

    render '404' and return if @note.nil?
  end

  def new
    # Значение поля статус по умолчанию, для всех новых записей - pending
    @note = current_user.notes.build(status: 'pending')
  end

  def edit
  end

  def create
    @note = current_user.notes.build(params[:note])

    if @note.save
      redirect_to @note, notice: 'Done'
    else
      render :new
    end
  end

  def update
    if @note.update_attributes(params[:note])
      redirect_to @note, notice: 'Done'
    else
      render :edit
    end
  end

  def active
    @note.update_attribute(:status, 'active')
    redirect_to @note, notice: t("notes.notices.active")
  end

  # При вызове метода destroy, запись не должна удаляться. Вместо этого значение поля статус должно стать равным "deleted".
  # Пользователь может удалить запись и восстановить удаленную запись (в состояние pending)
  def destroy
    # Перевод записи в статус deleted/pending
    @note.destroy
    redirect_to @note, notice: t("notes.notices.#{@note.status}")
  end

  private
    def set_note
      note = Note.where(id: params[:id])

      # Пользователь с ролью администратора может производить любые действия с любыми записями
      note = note.where(user_id: current_user.id) unless current_user.is_admin?

      @note = note.first

      render '404' and return if @note.nil?
    end
end