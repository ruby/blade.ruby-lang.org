BLADE_BUCKET_REGION = 'ap-northeast-1'
BLADE_BUCKET_NAME = 'blade.ruby-lang.org'

require 'kconv'

class Message < ApplicationRecord
    # Not really sure we will utlize this configuration,
    # but I don't want to make this column.
    # https://blade.ruby-lang.org/ruby-talk/1 is JST.
    # https://blade.ruby-lang.org/ruby-talk/410000 is not.
    self.skip_time_zone_conversion_for_attributes = [:published_at]

    def self.from_s3(list_name, list_seq, s3_client = Aws::S3::Client.new(region: BLADE_BUCKET_REGION))
        obj = s3_client.get_object(bucket: BLADE_BUCKET_NAME, key: "#{list_name}/#{list_seq}")

        m = self.from_string(obj.body.read)
        m.list_id = List.find_by_name(list_name).id
        m.list_seq = list_seq
        m
    end

    def self.from_string(str)
        # There are a few hacks to import messages from blade.ruby-lang.org's
        # S3 bucket.

        # Need to call String#b. There are messages that have headers in non-UTF8,
        # but the body is in UTF-8, such as ruby-list:2882.
        headers_str, body = str.b.split(/\n\n/, 2)

        # ruby-list:2840 doesn't have a proper From header.
        headers_str = Kconv.toutf8(headers_str).gsub(/\r\n/, '')

        headers = headers_str.split(/\n/).map { |line|
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

    def reload_from_s3
        m = self.from_s3(List.find_by_id(self.list_id).name, self.list_seq)

        self.body = m.body
        self.subject = m.subject
        self.from = from
        self.published_at = m.published_at
    end
end
