module Api
  module V1
    module Categories
      class IdeasController < ApplicationController
        before_action :category_params
        before_action :check_exist_category_name, only: :create
        before_action :check_exist_body, only: :create
        before_action :find_category_name, only: :index

        def index
          if @category.present?
            ideas = format_ideas(@category.ideas, @category)
          else
            ideas = []
            Category.all.each do |category|
              ideas << format_ideas(category.ideas, category)
            end
          end
          render json: { data: ideas }
        rescue => e
          render status: :internal_server_error, json: { status: 500, message: e.message.to_s }
        end

        def create
          @category = Category.create(name: params[:category_name]) if @category.nil?
          Idea.create(category_id: @category.id, body: params[:body])
          render status: :created, json: { status: 201 }
        rescue => e
          render status: :internal_server_error, json: { status: 500, message: e.message.to_s }
        end

        private

        def check_exist_category_name
          return if params[:category_name].present?

          render status: :unprocessable_entity, json: { status: 422, message: 'Unprocessable Entity' }
        end

        def check_exist_body
          return if params[:body].present?

          render status: :unprocessable_entity, json: { status: 422, message: 'Unprocessable Entity' }
        end

        def find_category_name
          return if params[:category_name].nil? || @category.present?

          render status: :not_found, json: { status: 404, message: 'Not Found' }
        end

        def category_params
          @category = Category.find_by(name: params[:category_name]) if params[:category_name]
        end

        def format_ideas(ideas, category)
          result = []
          ideas.each do |idea|
            result << { id: idea.id,
                        category: category.name,
                        body: idea.body,
                        created_at: idea.created_at.to_i }
          end
          result
        end
      end
    end
  end
end
