Citymagazines::Application.routes.draw do
  resources :notes, except: [:index] do
    collection do
      # /notes                      Все записи
      # /notes/actived              Должна быть возможность получить только активные записи (т.е. те, у которых статус равен "active")
      # /notes/recent               Должна быть возможность получить записи, отсортированные по давности создания - самые свежие должны быть первыми
      # /notes/last_changes?limit=n Должна быть возможность получить N последних измененных записей, принадлежащих пользователям из города текущего пользователя, отсортированных по дате изменения по убыванию
      get '(/:condition)',
           action: :index,
           as: '',
           constraints: { condition: /(actived|recent|last_changes)/ }
    end

    member do
      # Метод переводит запись в разряд активных (опубликованных)
      put 'active'
    end

    # Маршрутный экшен Destroy использован
    # для перевода записи в статус deleted/pending
  end

  # resources :sessions, only: [:create, :destroy]
  post   'signin'  => 'sessions#create'
  delete 'signout' => 'sessions#destroy'

  resources :users, path_names: { new: :signup }
  resources :cities

  root to: 'notes#index'
end