Tedious::Application.routes.draw do

  resources :reviews, only: [:index, :edit, :update] do
    get :next_pending_for_edit, on: :collection

    get :next_pending_for_bookmarklet,  on: :collection
    get :handle_approve_action,         on: :collection
    get :handle_reject_action,          on: :collection
  end

end
