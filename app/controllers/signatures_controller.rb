class SignaturesController < ApplicationController
  def show
    id = params[:id]
    url = "https://drive.usercontent.google.com/download?id=#{id}"
    download = open(url)
    send_file(download, type: 'image/png', disposition: 'inline')
  end
end