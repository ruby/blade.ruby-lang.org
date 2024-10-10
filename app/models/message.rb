BLADE_BUCKET_REGION = 'ap-northeast-1'
BLADE_BUCKET_NAME = 'blade.ruby-lang.org'

class Message < ApplicationRecord
    # Not really sure we will utlize this configuration,
    # but I don't want to make this column.
    # https://blade.ruby-lang.org/ruby-talk/1 is JST.
    # https://blade.ruby-lang.org/ruby-talk/410000 is not.
    self.skip_time_zone_conversion_for_attributes = [:published_at]

    def self.from_s3(list_name, list_seq)
        client = Aws::S3::Client.new(region: BLADE_BUCKET_REGION)
        obj = client.get_object(bucket: BLADE_BUCKET_NAME, key: "#{list_name}/#{list_seq}")

        m = self.from_string(obj.body.read)
        m.list_id = List.find_by_name(list_name).id
        m.list_seq = list_seq
        m
    end

    def self.from_string(str)
        hs, body = str.encode('utf-8', invalid: :replace).split(/\n\n/, 2)
        headers = hs.split(/\n/).map { |line|
          line.split(/:\s+/, 2)
        }.to_h

        published_at = DateTime.strptime(headers['Date'], '%Y-%m-%dT%H:%M:%S%:z')

        self.new(
            body: body,
            subject: headers['Subject'],
            from: headers['From'],
            published_at: published_at,
        )
    end
end
