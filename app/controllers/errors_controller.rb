class ErrorsController < ApplicationController
  def error_404
    render '404'
  end

  def error_500
    render '500'
  end

  def error_403
    render '403'
  end
end