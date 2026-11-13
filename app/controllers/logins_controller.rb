class LoginsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    flash.now[:danger] = "お気に入り登録にはログインが必要です" if params[:require_favorite]
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      flash[:success] = "ログインしました"
      redirect_to root_path
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end
end
