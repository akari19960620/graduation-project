# moduleでメソッドをひとまとめにして、各テストファイルに取り込むための準備をする
module SignInSupport
  # request spec用: HTTPリクエストを直接送ってログインする
  def sign_in_as(user, password: "password1")
    # ログイン処理を模倣：Sorceryの仕様により、save後の user.password は常に nil になる
    # →セキュリティ上、平文パスワードをメモリ上に保持しない設計のため
    # →ログイン時は Factory で設定した平文パスワードを明示的に渡す必要がある
    post login_path, params: { email: user.email, password: password }
  end

  # system spec用: ブラウザ操作をシミュレートしてログインする
  def login_as(user, password: "password1")
    visit new_login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: password
    click_button "ログイン"
    expect(page).to have_content "ログアウト"  # ログインの完了を待つ
  end
end

# RSpec.configure は「RSpec全体の設定」を行う場所
RSpec.configure do |config|
  # SignInSupport モジュールを取り込んで、上記メソッドを使えるようにする
  config.include SignInSupport, type: :request
  config.include SignInSupport, type: :system
end
