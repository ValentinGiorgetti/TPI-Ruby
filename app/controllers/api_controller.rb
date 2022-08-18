class ApiController < ActionController::Base

    include ApiHelper

    ActionController::Parameters.action_on_unpermitted_parameters  = :raise

    before_action :set_class

    def set_class
        @class = controller_name.classify.constantize
    end

    def not_found
        { json: { "description": "Not found" }, status: 404 }
    end

    def bad_parameters
        { json: { "description": "Bad parameters" }, status: 400 }
    end

    def show
        render bad_parameters and return if !check_positive_integer(params[:id])
        result = @class.find_by(id: params[:id])
        render not_found and return if !result
        render json: result
    end

    def list
        render bad_parameters and return if params[:page] && (!check_positive_integer(params[:page]))
        result = @class.ransack(params).result.page(params[:page])
        render not_found and return if result.empty? 
        render json: add_pagination_info(result)
    end

    rescue_from ArgumentError, ActionController::ParameterMissing, ActionController::UnpermittedParameters do |error|
        render bad_parameters
    end

end