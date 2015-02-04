class TagController < ApplicationController

  def index
  	@tag = ActsAsTaggableOn::Tag.all
  end
end
