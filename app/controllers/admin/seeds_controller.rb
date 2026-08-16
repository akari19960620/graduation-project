class Admin::SeedsController < ApplicationController
  # 本番環境でのみ、一時的にseedを実行するためのエンドポイント
  def create
    # セキュリティのため、環境変数でパスワード保護
    if params[:password] == ENV["SEED_PASSWORD"]
      Rails.application.load_seed
      render plain: "Seed completed successfully!"
    else
      render plain: "Unauthorized", status: :unauthorized
    end
  end
end
