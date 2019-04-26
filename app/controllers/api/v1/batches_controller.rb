class Api::V1::BatchesController < Api::V1::ApiController
    before_action :set_batch, only: [:show]
    before_action :require_authorization!, only: [:show]

    def index
        @batches = current_user.batchs
        render json: {status: :success, data: @batches}
    end

    def create
        @orders = current_user.orders.where("reference = ? AND purchase_channel = ?", params[:reference], params[:purchase_channel])

        if @orders.empty?
            render json: {status: :fail, data: {}}, status: :unprocessable_entity
        else
            @batch = Batch.new(batch_params.merge(user: current_user))
            if @batch.save
                @orders.each do |order|
                    order.update(batch: @batch)
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

    private
        def set_batch
            begin
                @batch = Batch.find(params[:id])
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
