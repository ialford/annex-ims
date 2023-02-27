module NotifyError
  def self.call(exception:, parameters: {}, component: nil, action: nil)
    Sentry.capture_message(exception,
                          extra: {
                            component: component,
                            action: action,
                            parameters: parameters
                          })
  end
end
