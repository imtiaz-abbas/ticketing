class Api::BaseController < ApplicationController
  include ApiHelper

  before_action :permit_json
end
