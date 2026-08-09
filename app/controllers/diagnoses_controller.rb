class DiagnosesController < ApplicationController
  rescue_from DiagnosisResultNotFoundError, with: :diagnosis_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @questions = DiagnosisQuestion.order(:display_order)
  end

  def create
    puts "\n========================================="
    puts "=== DiagnosesController#create 開始 ==="
    puts "========================================="
    puts "受信したすべてのパラメータ: #{params.inspect}"
    puts "current_session_id: #{current_session_id}"

    puts "\n=== ストロングパラメーター処理 ==="
    puts "diagnosis_params: #{diagnosis_params.inspect}"

    # Form Object でバリデーション
    form = DiagnosisForm.new(diagnosis_params)

    puts "\n=== バリデーション実行 ==="
    puts "form.valid?: #{form.valid?}"
    puts "form.errors: #{form.errors.full_messages.inspect}"

    unless form.valid?
      puts "\n=== バリデーションエラー ==="
      flash[:alert] = form.errors.full_messages.join(", ")
      redirect_to new_diagnosis_path
      return
    end

    puts "\n=== バリデーション成功 ==="
    puts "form.question_answers: #{form.question_answers.inspect}"

    # Service Object で保存
    saver = DiagnosisAnswerSaver.new(current_session_id, form.question_answers)
    result = saver.save

    puts "\n=== 保存処理の結果 ==="
    puts "saver.save の結果: #{result}"
    puts "Diagnosis.count: #{Diagnosis.count}"
    puts "Diagnosis.last: #{Diagnosis.last.inspect}"

    if result
      puts "\n=== 診断データの検索 ==="
      puts "検索する session_id: #{current_session_id}"

      diagnosis = Diagnosis.find_by(session_id: current_session_id)

      puts "診断データ取得結果: #{diagnosis.inspect}"

      if diagnosis
        puts "\n=== リダイレクト実行 ==="
        puts "診断ID: #{diagnosis.id}"
        puts "リダイレクト先パス: #{result_diagnosis_path(diagnosis)}"

        redirect_to result_diagnosis_path(diagnosis), notice: "回答を保存しました"
      else
        puts "\n=== エラー: 診断データが見つかりません ==="
        puts "Diagnosis.all: #{Diagnosis.all.map { |d| { id: d.id, session_id: d.session_id } }}"
        flash[:alert] = "診断データが見つかりませんでした"
        redirect_to new_diagnosis_path
      end
    else
      puts "\n=== 保存失敗 ==="
      puts "エラーメッセージ: #{saver.error_message}"
      flash[:alert] = saver.error_message
      redirect_to new_diagnosis_path
    end

    puts "\n========================================="
    puts "=== DiagnosesController#create 終了 ==="
    puts "=========================================\n"
  end

 def result
  puts "\n========================================="
  puts "=== DiagnosesController#result 開始 ==="
  puts "========================================="
  puts "params[:id]: #{params[:id]}"

  # URLのIDから診断データを取得
  @diagnosis = Diagnosis.find(params[:id])
  puts "診断データ取得: #{@diagnosis.inspect}"
  puts "診断データのID: #{@diagnosis.id}"

  # DiagnosisResultFetcherで診断結果を取得
  puts "\n=== DiagnosisResultFetcher 実行 ==="
  fetcher = DiagnosisResultFetcher.new(@diagnosis.id)
  puts "fetcher 作成完了"

  result_data = fetcher.fetch
  puts "result_data: #{result_data.inspect}"

  # 診断結果が見つからない場合、例外を発生させる
  if result_data.nil?
    puts "\n=== result_data が nil です ==="
    raise DiagnosisResultNotFoundError
  end

  puts "\n=== 診断結果データの代入 ==="
  # 診断結果データをインスタンス変数に代入
  assign_result_data(result_data)

  puts "========================================="
  puts "=== DiagnosesController#result 終了 ==="
  puts "=========================================\n"
end
  private

  def diagnosis_not_found
    flash[:alert] = "診断を受けてください"
    redirect_to new_diagnosis_path
  end

  def record_not_found
    puts "\n=== record_not_found が呼ばれました ==="
    puts "session_id: #{current_session_id}"
    puts "診断データ一覧: #{Diagnosis.all.map { |d| { id: d.id, session_id: d.session_id } }}"

    flash[:alert] = "診断結果が見つかりませんでした"
    redirect_to new_diagnosis_path
  end

  def current_session_id
    session.id.to_s
  end

  def assign_result_data(result_data)
    @answers = result_data[:answers]
    @scores = result_data[:scores]
    @result_category = result_data[:category]
    @diagnosis_result = result_data[:result]
    @recommended_facilities = result_data[:recommended_facilities]
  end

  def diagnosis_params
    puts "\n=== diagnosis_params メソッド ==="
    question_keys = params.keys.select { |key| key.to_s.start_with?("question_") }
    puts "question_ で始まるキー: #{question_keys.inspect}"

    permitted = params.permit(*question_keys)
    puts "許可されたパラメータ: #{permitted.inspect}"
    puts "許可されたパラメータのクラス: #{permitted.class}"

    permitted
  end
end
