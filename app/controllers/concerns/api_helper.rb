module ApiHelper
  extend ActiveSupport::Concern

  protected

  def response_as(kind, opts = {})
    case kind
    when :success
      ApiResponse.success opts
    when :error
      ApiResponse.error opts
    when :failure
      ApiResponse.failure opts
    else
      raise "Kind should be one of :succcess, :fail, :error"
    end
  end

  def permit_json
    params.permit(:format)
  end
end
