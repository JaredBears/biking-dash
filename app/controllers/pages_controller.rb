class PagesController < ApplicationController
  skip_before_action :authenticate_user, only: [:home, :about, :contact, :terms, :privacy]
  
  def home
  end

  def about
  end

  def contact
  end

  def terms
  end

  def privacy
  end
end
