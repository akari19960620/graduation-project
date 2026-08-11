require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# spec/support 配下のファイルを自動読み込み
Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Factory Bot のメソッドを直接使えるようにする
  config.include FactoryBot::Syntax::Methods

  # システムテスト以外はトランザクションを使用
  config.use_transactional_fixtures = true

  # システムテスト用のCapybara設定
  config.before(:each, type: :system) do
    if ENV['CI'] # GitHub Actions環境
      driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
    else # ローカルDocker環境
      driven_by :remote_chrome
      Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
      Capybara.server_port = 4444
      Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
    end
  end

  # リクエストテスト用のホスト設定
  config.before(:each, type: :request) do
    host! 'www.example.com'
  end

  # ファイルの場所からテストタイプを自動判定
  config.infer_spec_type_from_file_location!

  # バックトレースからRailsの内部を除外
  config.filter_rails_from_backtrace!

  # Capybara の設定
  Capybara.default_max_wait_time = 10
  Capybara.disable_animation = true
end