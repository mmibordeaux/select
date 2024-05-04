class SignaturesController < ApplicationController
  def show
    
    # "https://drive.google.com/file/d/#{signature}/view?usp=drive_link"
    # https://drive.google.com/file/d/1I-ZnWbwYm1DjJcZM82G2pUTj6yaWSlX-/view?usp=drive_link
    # "https://drive.google.com/uc?export=preview&id=1I-ZnWbwYm1DjJcZM82G2pUTj6yaWSlX"
    # "https://drive.google.com/file/d/1I-ZnWbwYm1DjJcZM82G2pUTj6yaWSlX-/preview"
    # "https://www.dropbox.com/scl/fi/8cja9c8bbky4m31fcf2yu/Oscar-Motta.png?rlkey=g8okg26jnqv1k310119x47jot&dl=0"
    # "/signature/#{signature}"
    id = params[:id]
    # url = "https://drive.google.com/file/d/#{id}/view?usp=drive_link"
    # url = "https://drive.google.com/file/d/1I-ZnWbwYm1DjJcZM82G2pUTj6yaWSlX-/preview"
    # url = "https://drive.google.com/file/d/1I-ZnWbwYm1DjJcZM82G2pUTj6yaWSlX-/view?usp=drive_link"
    url = "https://drive.usercontent.google.com/download?id=1wMgCWAsqlw0nXcMhCldTbwSznMdXUmBT"
    url = "https://drive.usercontent.google.com/download?id=#{id}"
    download = open(url)
    send_file(download, type: 'image/jpeg', disposition: 'inline')
  end
end