class Note < ActiveRecord::Base

  @@statuses = %w(active deleted pending)

  # Модель записи считается невалидной, если у нее не заполнены поля заголовок и содержимое
  validates :title, :content, :user_id,
             presence: true

  # Длина поля заголовок у записи не может превышать 140 символов
  validates :title,
             length: { maximum: 140 },
             allow_blank: true

  # Модель записи считается невалидной, если в поле статус записано неверное значение (т.е. НЕ active, deleted или pending)
  validates :status,
             inclusion: { in: @@statuses }

  validates :user_id,
             numericality: { only_integer: true,
                             greater_than_or_equal_to: 1 },
             allow_blank: true

  # У одного пользователя не может быть двух записей с одинаковым значением поля заголовок
  validate :unique_titles_for_one_user

  def unique_titles_for_one_user
    if Note.where("title = :title and
                   user_id = :user_id and
                   id != :id",
                  title: title, user_id: user_id, id: self.id || "")
           .exists?
        errors.add(:title, :should_not_have_duplicate)
    end
  end

  belongs_to :user

  scope :with_users, -> { includes(user: :city) }

  # Должна быть возможность получить только активные записи (т.е. те, у которых статус равен "active")
  scope :actived, -> { where(status: 'active') }

  # Должна быть возможность получить записи, отсортированные по давности создания - самые свежие должны быть первыми
  scope :recent, -> { order('created_at DESC') }

  # Должна быть возможность получить N последних измененных записей, принадлежащих пользователям из города текущего пользователя, отсортированных по дате изменения по убыванию
  scope :last_changes, ->(city_id) { where('notes.created_at != notes.updated_at')
                                    .where(users: { city_id: city_id })
                                    .order('notes.updated_at DESC') }

  @@statuses.each do |s|
    define_method("#{s}?") do
      self.status == "#{s}"
    end
  end

  # При вызове метода destroy, запись не должна удаляться. Вместо этого значение поля статус должно стать равным "deleted".
  def destroy
    run_callbacks :destroy do
      # Пользователь может удалить запись и восстановить удаленную запись (в состояние pending)
      self.update_attribute(:status,
                            self.deleted? ? 'pending' : 'deleted')
    end
  end

=begin
  # Значение поля статус по умолчанию, для всех новых записей - pending
  # after_initialize :set_status

  # def set_status
  #   self.status = 'pending'
  # end
=end

end