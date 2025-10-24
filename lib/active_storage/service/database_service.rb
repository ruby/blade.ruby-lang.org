# frozen_string_literal: true

require 'active_storage/service'

module ActiveStorage
  class Service::DatabaseService < Service
    def upload(key, io, checksum: nil, **)
      instrument :upload, key: key, checksum: checksum do
        ActiveStorage::FileBlob.find_or_initialize_by(key: key) do
          it.data = io.read
          it.save!
        end
      end
    end

    def download(key)
      instrument :download, key: key do
        ActiveStorage::FileBlob.where(key: key).pick(:data)
      end
    end

    def delete(key)
      instrument :delete, key: key do
        ActiveStorage::FileBlob.find_by(key: key)&.destroy
      end
    end

    def exist?(key)
      instrument :exist, key: key do |payload|
        payload[:exist] = ActiveStorage::FileBlob.exists?(key: key)
      end
    end

    private

    def private_url(key, expires_in:, filename:, content_type:, disposition:, **)
      content_disposition = content_disposition_with(type: disposition, filename: filename)
      verified_key_with_expiration = ActiveStorage.verifier.generate(
        {
          key: key,
          disposition: content_disposition,
          content_type: content_type,
          service_name: name
        },
        expires_in: expires_in,
        purpose: :blob_key
      )

      if url_options.blank?
        raise ArgumentError, "Cannot generate URL for #{filename} using Database service, please set ActiveStorage::Current.url_options."
      end

      url_helpers.attachment_url(verified_key_with_expiration, filename: filename, **url_options)
    end

    def url_helpers
      @url_helpers ||= Rails.application.routes.url_helpers
    end

    def url_options
      ActiveStorage::Current.url_options
    end

    def service_name
      'Database'
    end
  end
end
