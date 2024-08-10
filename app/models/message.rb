BLADE_BUCKET_REGION = 'ap-northeast-1'
BLADE_BUCKET_NAME = 'blade.ruby-lang.org'

class Message < ApplicationRecord
    def self.from_s3(list_name, list_seq)
        client = Aws::S3::Client.new(region: BLADE_BUCKET_REGION)
        obj = client.get_object(bucket: BLADE_BUCKET_NAME, key: "#{list_name}/#{list_seq}")
        hs, body = obj.body.read.split(/\n\n/, 2)
        headers = hs.split(/\n/).map { |line|
          line.split(/:\s+/, 2)
        }.to_h

        self.new(
          body: body,
          subject: headers['Subject'],
          from: headers['From'],
        )
    end

    def self.from_string(list_name, list_seq, s)
        hs, body = s.split(/\n\n/, 2)
        headers = hs.split(/\n/).map { |line|
          line.split(/:\s+/, 2)
        }.to_h

        self.new(body: body, subject: headers['Subject'], from: headers['From'])
    end
end
