namespace :data do
  desc "本番環境のデータベースをリセット"
  task reset_production: :environment do
    if Rails.env.production?
      puts "本番環境のデータベースをリセットします..."

      # データベースをリセット
      Rake::Task["db:reset"].invoke

      # シードデータを投入
      Rake::Task["db:seed"].invoke

      puts "データベースのリセットが完了しました！"
    else
      puts "このタスクは本番環境でのみ実行できます"
    end
  end
end
