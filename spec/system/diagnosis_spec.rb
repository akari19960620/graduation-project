require 'rails_helper'

RSpec.describe '診断機能', type: :system do
  before do
    # 診断結果に表示される施設データを事前に作成
    @facility = create(:facility, name: 'テスト施設')
  end

  it 'トップ画面から診断結果、施設詳細まで正常に遷移できる' do
    # トップ画面にアクセス
    visit root_path
    expect(page).to have_content('診断を始める')

    # 診断開始
    click_on '診断を始める'
    expect(page).to have_content('質問') # 診断質問画面に遷移

    # 質問に回答して送信
    choose 'option_1' # または fill_in, select など、実装に合わせて変更
    click_on '診断する'

    # 診断結果画面に遷移
    expect(page).to have_content('おすすめの施設')
    expect(page).to have_content('テスト施設')

    # 施設詳細画面に遷移
    click_on 'テスト施設'
    expect(page).to have_content('テスト施設') # 施設詳細が表示される
  end

  it '診断をスキップして結果画面にアクセスすると適切に処理される' do
    visit 診断結果画面のパス # 実際のパスに変更
    
    # リダイレクトされるか、エラーメッセージが表示されることを確認
    expect(current_path).to eq(root_path) # または診断質問画面
    # または
    # expect(page).to have_content('診断を実行してください')
  end
end

