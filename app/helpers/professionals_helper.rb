module ProfessionalsHelper
    def cancel_all_appointments_path
        "/professionals/#{@professional.id}/cancel_all_appointments"
      end
end
