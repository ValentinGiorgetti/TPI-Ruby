module ApplicationHelper
    def route(string)
        professional = request.params[:professional_id]
        if professional
            "/professionals/#{professional}#{string}"
        else
            string
        end
    end
  
    def filter_route(string)
        route(string) + "_filtered"
    end

    def button_options(button_class='success', method=:get)
        { class: "btn btn-#{button_class} btn-sm", method: method, form: {style: 'position:relative; display:inline-block;'} }
    end

    def generate_back_button
        button_to 'Back', :back, button_options('info')
    end

    def generate_edit_button
        path = {  "appointments" => @appointment ? route(edit_appointment_path) : nil,
                  "professionals" => @professional ? edit_professional_path(@professional) : nil,
                  "users" => @user && current_user.role == "administrator" ? edit_user_path(@user) : "/user/edit"  }

        button_to 'Edit', path[controller_name], button_options
    end

    def generate_show_button
        path = {  "appointments" => @appointment? route(appointment_path) : nil,
                  "professionals" => @professional ? @professional : nil,
                  "users" => @user && current_user.role == "administrator" ? user_path(@user) : "/my_profile"  }        

        button_to 'Show', path[controller_name], button_options
    end
end
