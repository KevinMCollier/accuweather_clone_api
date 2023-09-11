class Api::V1::LocationsController < Api::V1::BaseController
  def index
    @locations = policy_scope(Location)
  end
end
