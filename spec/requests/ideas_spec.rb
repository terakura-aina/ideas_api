require 'rails_helper'

RSpec.describe "Ideas", type: :request do
  before do
    create(:idea)
    create(:idea, :other_idea)
  end

  describe "GET /api/v1/categories/ideas" do
    context 'パラメータを指定しなかったとき' do
      it '200ステータスを返却すること' do
        get api_v1_categories_ideas_path
        expect(response).to have_http_status(200)
      end

      it '全てのカテゴリのデータを返却すること' do
        get api_v1_categories_ideas_path
        json = JSON.parse(response.body)
        expect(json['data'].count).to eq(Category.count)
      end
    end

    context '登録されているカテゴリのパラメータを指定したとき' do
      it '200ステータスを返却すること' do
        get api_v1_categories_ideas_path, params: { category_name: 'category_1' }
        expect(response).to have_http_status(200)
      end

      it '指定したカテゴリのデータを返却すること' do
        get api_v1_categories_ideas_path, params: { category_name: 'category_1' }
        json = JSON.parse(response.body)
        expect(json['data'].count).to eq(1)
        expect(json['data'].first['category']).to eq('category_1')
      end
    end

    context '登録されていないカテゴリのパラメータを指定したとき' do
      it '404ステータスを返却すること' do
        get api_v1_categories_ideas_path, params: { category_name: 'not_registered' }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST /api/v1/categories/ideas" do
    context '登録するカテゴリが既に存在するとき' do
      let(:category) { Category.find_by(name: 'category_1') }
      it '201ステータスを返却すること' do
        post api_v1_categories_ideas_path, params: { category_name: 'category_1', body: 'test' }
        expect(response).to have_http_status(201)
      end

      it 'カテゴリのレコード数は変わらないこと' do
        expect do
          post api_v1_categories_ideas_path, params: { category_name: 'category_1', body: 'test' }
        end.not_to(change { Category.count })
      end

      it '該当カテゴリのアイデアが1つ増えること' do
        expect do
          post api_v1_categories_ideas_path, params: { category_name: 'category_1', body: 'test' }
        end.to change { category.ideas.count }.by(1)
      end
    end

    context '登録するカテゴリが既に存在しないとき' do
      it '201ステータスを返却すること' do
        post api_v1_categories_ideas_path, params: { category_name: 'category_new', body: 'test' }
        expect(response).to have_http_status(201)
      end

      it 'カテゴリのレコード数が1つ増えること' do
        expect do
          post api_v1_categories_ideas_path, params: { category_name: 'category_new', body: 'test' }
        end.to change { Category.count }.by(1)
      end

      it 'アイデアのレコードが1つ増えること' do
        expect do
          post api_v1_categories_ideas_path, params: { category_name: 'category_new', body: 'test' }
        end.to change { Idea.count }.by(1)
      end
    end

    context 'パラメータに category_name が含まれていないとき' do
      it '422ステータスを返却すること' do
        post api_v1_categories_ideas_path, params: { body: 'test' }
        expect(response).to have_http_status(422)
      end

      it 'カテゴリのレコード数は変わらないこと' do
        expect do
          post api_v1_categories_ideas_path, params: { body: 'test' }
        end.not_to(change { Category.count })
      end

      it 'アイデアのレコード数は変わらないこと' do
        expect do
          post api_v1_categories_ideas_path, params: { body: 'test' }
        end.not_to(change { Idea.count })
      end
    end

    context 'パラメータに body が含まれていないとき' do
      it '422ステータスを返却すること' do
        post api_v1_categories_ideas_path, params: { category_name: 'category_new' }
        expect(response).to have_http_status(422)
      end

      it 'カテゴリのレコード数は変わらないこと' do
        expect do
          post api_v1_categories_ideas_path, params: { category_name: 'category_new' }
        end.not_to(change { Category.count })
      end

      it 'アイデアのレコード数は変わらないこと' do
        expect do
          post api_v1_categories_ideas_path, params: { category_name: 'category_new' }
        end.not_to(change { Idea.count })
      end
    end
  end
end
