class Api::V1::SearchController < Api::V1::ApiController

    def search
        if params[:reference] != nil
            @orders = current_user.orders.where("reference = ?", params[:reference])
            render json: {status: :success, data: @orders}
        elsif params[:client_name] != nil
            @orders = current_user.orders.where("client_name = ?", params[:client_name])
            render json: {status: :success, data: @orders}
        else
            @orders = current_user.orders
            render json: {status: :success, data: @orders}
        end
    end
end
