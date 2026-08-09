require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'database_cleaner/active_record'

Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # トランザクションを無効化
  config.use_transactional_fixtures = false

  config.include FactoryBot::Syntax::Methods
  config.infer_spec_type_from_file_location!

  # Database Cleaner の設定
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Seed データを読み込む
    Rails.application.load_seed
  end

  # ★ 修正: システムテスト以外では transaction を使用
  config.before(:each) do |example|
    if example.metadata[:type] == :system
      # システムテストでは truncation を使用
      DatabaseCleaner.strategy = :truncation
    else
      # その他のテストでは transaction を使用
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  # ★ 修正: システムテスト以外のみ clean を実行
  config.after(:each) do |example|
    unless example.metadata[:type] == :system
      DatabaseCleaner.clean
    end
  end

  # ★ 修正: システムテスト後に truncation してから Seed データを再読み込み
  config.after(:each, type: :system) do
    DatabaseCleaner.clean_with(:truncation)
    Rails.application.load_seed
  end

  config.before(:each, type: :request) do
    host! 'www.example.com'
  end

  config.filter_rails_from_backtrace!

  # システムテスト用の設定
  config.before(:each, type: :system) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 4444
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end
