class Api::V1::BatchesController < Api::V1::ApiController
    before_action :set_batch, only: [:show, :produce, :send]
    before_action :require_authorization!, only: [:show, :produce, :send]

    def index
        @batches = current_user.batchs
        render json: {status: :success, data: @batches}
    end

    def create
        @orders = current_user.orders.where("reference = ? AND purchase_channel = ? AND status = ?", params[:reference], params[:purchase_channel], 'ready')

        if @orders.empty?
            render json: {status: :fail, data: {}}, status: :unprocessable_entity
        else
            @batch = Batch.new(batch_params.merge(user: current_user))
            if @batch.save
                @orders.each do |order|
                    order.update(batch: @batch, status: 'production')
                end
                render json: {status: :success, data: @batch.as_json(include: :orders)}, status: :created
            else
                render json: {status: :fail, data: @batch.errors}, status: :unprocessable_entity
            end
        end
    end

    def show
        render json: {status: :success, data: @batch.as_json(include: :orders)}
    end

    def produce
        @orders = @batch.orders.where('status = ?', 'production')

        if @orders.empty?
            render json: {status: :fail, data: {}}, status: :unprocessable_entity
        else
            @orders.each do |order|
                order.update(status: 'closing')
            end
            render json: {status: :success, data: @batch.as_json(include: :orders)}
        end
    end

    # def dispatch        
    #     @orders = @batch.orders.where('status = ? AND delivery_service = ?', 'closing', params[:delivery_service])

    #     if @orders.empty?
    #         render json: {status: :fail, data: {}}, status: :unprocessable_entity
    #     else
    #         @orders.each do |order|
    #             order.update(status: 'sent')
    #         end
    #         render json: {status: :success, data: @batch.as_json(include: :orders)}
    #     end
    # end

    private
        def set_batch
            begin
                @batch = Batch.find(if params[:id] != nil then params[:id] else params[:batch_id] end)
            rescue ActiveRecord::RecordNotFound
                render json: {status: :fail, data: {}}, status: :not_found
            end
        end

        def batch_params
            params.permit(:reference, :purchase_channel)
        end

        def require_authorization!
            unless current_user == @batch.user
                render json: {}, status: :forbidden
            end
        end
end
