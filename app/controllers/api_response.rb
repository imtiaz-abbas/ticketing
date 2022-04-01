class ApiResponse
  include ActiveModel::Model
  attr_accessor :status, :data, :message, :code

  def self.success(opts)
    resp = ApiResponse.new
    resp.status = "success"
    resp.data = opts[:data]
    resp
  end

  def self.failure(opts)
    resp = ApiResponse.new
    resp.status = "failure"
    resp.data = opts[:data]
    resp.message = opts[:message]
    resp
  end

  def self.error(opts)
    resp = ApiResponse.new
    resp.status = "error"
    resp.data = opts[:data]
    resp.message = opts[:message]
    resp.code = opts[:code]
    resp
  end
end
