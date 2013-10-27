class WelcomeController < ApplicationController
  layout "welcome"

  skip_before_filter :require_sign_in
end
