class Api::V1::Procedures::ProceduresController < ApplicationController

	  #this action is used for confirm account

    def index
      if @procedures = Procedure.all
    		 @procedures = Hospital.find_by_id(params[:id]).procedures if params[:id].present?
         render json: {procedure: @procedures}
      else
        render json: {message: "Unable to load Data properly try after some time."}
      end
    end
end