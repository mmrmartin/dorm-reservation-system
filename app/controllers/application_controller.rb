class ApplicationController < ActionController::Base
    before_action :check_app_running

    def unauthorized 
        respond_to do |format|
            format.html { redirect_to "/", alert: "You don't have rights to access this page" }
        end
    end

    def admin_only
        unless(current_user.admin)
            unauthorized
        end
    end

    private 
    def check_app_running
        if !AppSetting.first.is_running && 
            controller_name != "not_running" && 
            controller_name != "app_settings" && 
            controller_name != "sessions" &&
            controller_name != "password"

            redirect_to not_running_index_path 
        end
    end
end
