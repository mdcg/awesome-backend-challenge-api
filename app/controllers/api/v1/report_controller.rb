class Api::V1::ReportController < Api::V1::ApiController
    def index
        if params[:purchase_channel] != nil
            @orders = current_user.orders.where("purchase_channel = ?", params[:purchase_channel])
        else
            @orders = current_user.orders
        end

        total_orders = 0
        total_value = 0
        @orders.each do |order|
            total_orders += 1
            total_value += order.total_value
        end

        render json: {status: :success, data: {total_orders: total_orders, total_value: total_value}}
    end
end
