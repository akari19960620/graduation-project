# 本番環境でのみ実行
if Rails.env.production?
  # シードデータが未投入かチェック（例：Userが0件の場合）
  if User.count.zero?
    Rails.logger.info "シードデータを投入します..."

    begin
      # シードデータを投入
      Rails.application.load_seed
      Rails.logger.info "シードデータの投入が完了しました!"
    rescue => e
      Rails.logger.error "シードデータの投入に失敗しました: #{e.message}"
    end
  else
    Rails.logger.info "シードデータは既に投入済みです"
  end
end
