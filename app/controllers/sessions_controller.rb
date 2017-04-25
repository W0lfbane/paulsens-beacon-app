class SessionsController < Devise::SessionsController
    private
    
    def respond_to_on_destroy
        flash[:notice] = find_message(:signed_out)

        # We actually need to hardcode this as Rails default responder doesn't
        # support returning empty response on GET request
        respond_to do |format|
            format.all { head :no_content }
            format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name), flash: flash.to_hash }
        end
    end
end