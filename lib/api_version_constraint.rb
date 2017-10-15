class ApiVersionConstraint

  def initialize(args)
    @version = args[:version]
    @default = args[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.taskmanager.v#{@version}")
  end

end