class SignaturesController < ApplicationController
  def show
    id = params[:id]
    url = "https://drive.usercontent.google.com/download?id=#{id}&export=download&authuser=0"
    download = URI.open(url)
    send_file(download, type: 'image/png', disposition: 'inline')
  end
end