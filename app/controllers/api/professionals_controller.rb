class Api::ProfessionalsController < ApiController

    def list
        params.permit(:name_cont, :page)
        super
    end

end
