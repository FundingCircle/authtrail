module AuthTrail
  class GeocodeJob < ApplicationJob
    def perform(login_activity)
      result =
        begin
          Geocoder.search(login_activity.ip).first
        rescue => e
          Rails.logger.info "Geocode failed: #{e.message}"
          nil
        end

      if result
        login_activity.update!(
          city: get(result, :city),
          region: get(result, :state),
          country: get(result, :country)
        )
      end
    end

    def get(result, value)
      return unless result.respond_to?(value)
      result.send(value)
    end
  end
end
