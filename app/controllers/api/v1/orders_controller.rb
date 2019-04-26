class Api::V1::OrdersController < Api::V1::ApiController
    before_action :set_order, only: [:show, :update,]
    before_action :require_authorization!, only: [:show, :update,]

    def index
        if params[:purchase_channel] != nil
            @orders = current_user.orders.where("purchase_channel = ?", params[:purchase_channel])
            render json: {status: :success, data: @orders}
        else
            @orders = current_user.orders
            render json: {status: :success, data: @orders}
        end
    end
    
    def show
        render json: {status: :success, data: @order}
    end

    def create
        @order = Order.new(order_params.merge(user: current_user))

        if @order.save
            render json: {status: :success, data: @order}, status: :created
        else
            render json: {status: :fail, data: @order.errors}, status: :unprocessable_entity
        end
    end

    def update
        if @order.update(order_params)
            render json: {status: :success, data: @order}
        else
            render json: {status: :fail, data: @order}, status: :unprocessable_entity
        end
    end

    private
        def set_order
            begin
                @order = Order.find(params[:id])
            rescue ActiveRecord::RecordNotFound
                render json: {status: :fail, data: {}}, status: :not_found
            end
        end

        def order_params
            params.permit(:reference, :purchase_channel, :client_name, :address, :delivery_service, :total_value, :line_items, :status)
        end

        def require_authorization!
            unless current_user == @order.user
                render json: {}, status: :forbidden
            end
        end
end
