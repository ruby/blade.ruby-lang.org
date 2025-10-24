# frozen_string_literal: true

class AttachmentsController < ApplicationController
  skip_forgery_protection

  def show
    if (key = decode_verified_key)
      send_data ActiveStorage::Blob.service.download(key[:key]), content_type: key[:content_type], disposition: key[:disposition]
    else
      head :not_found
    end
  rescue Errno::ENOENT
    head :not_found
  end

  private

  def decode_verified_key
    key = ActiveStorage.verifier.verified(params[:encoded_key], purpose: :blob_key)
    key&.deep_symbolize_keys
  end
end
