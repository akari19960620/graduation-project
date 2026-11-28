require 'simplecov'
SimpleCov.start 'rails' do
  skip '/bin/'
  skip '/db/'
  skip '/spec/'
  skip '/test/'
end
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

  # CI用のChromeオプションを明示したドライバの追加
  Capybara.register_driver :headless_chrome_ci do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.binary = ENV['CHROME_BIN'] if ENV['CHROME_BIN'].present?
    options.add_argument('--headless=new')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1400,1400')

    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  # システムテスト用のCapybara設定
  config.before(:each, type: :system) do
    if ENV['CI'] # GitHub Actions環境
      driven_by :headless_chrome_ci
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

  # サーバーエラーを無視する設定を追加
  Capybara.raise_server_errors = false
end
