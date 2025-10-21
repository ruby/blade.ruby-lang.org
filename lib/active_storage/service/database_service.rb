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

    def service_name
      'Database'
    end
  end
end
