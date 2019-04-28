class Api::V1::UserController < ApplicationController
    def signup
        if not params[:email] != nil
            render json: {status: :fail, data: {email: 'Please enter an email'}}, status: :bad_request
        elsif not params[:password] != nil
            render json: {status: :fail, data: {password: 'Please enter a password'}}, status: :bad_request
        else
            begin
                User.find_by! email: params[:email]
                render json: {status: :fail, data: {email: 'E-mail already registered'}}, status: :unprocessable_entity
            rescue ActiveRecord::RecordNotFound
                @user = User.create(user_params)
                render json: {status: :success, data: {user: @user}}, status: :created
            end
        end
    end

    private
        def user_params
            params.permit(:email, :password, :name)
        end
end
