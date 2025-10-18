BLADE_BUCKET_REGION = 'ap-northeast-1'
BLADE_BUCKET_NAME = 'blade.ruby-lang.org'

require 'kconv'

class Message < ApplicationRecord
  # Not really sure we will utlize this configuration,
  # but I don't want to make this column.
  # https://blade.ruby-lang.org/ruby-talk/1 is JST.
  # https://blade.ruby-lang.org/ruby-talk/410000 is not.
  self.skip_time_zone_conversion_for_attributes = [:published_at]

  class << self
    def from_mail(mail, list, list_seq)
      body = Kconv.toutf8 mail.body.raw_source
      if ((list.name == 'ruby-dev') && list_seq.in?([13859, 26229, 39731, 39734])) || ((list.name == 'ruby-core') && list_seq.in?([5231])) || ((list.name == 'ruby-list') && list_seq.in?([29637, 29711, 30148])) || ((list.name == 'ruby-talk') && list_seq.in?([5198, 61316]))
        body.gsub!("\u0000", '')
      end
      if (list.name == 'ruby-list') && list_seq.in?([37565, 38116, 43106])
        mail.header[:subject].value.chop!
      end
      subject = mail.subject
      subject = Kconv.toutf8 subject if subject
      from = Kconv.toutf8 mail.from_address&.raw
      if !from && (list.name == 'ruby-core') && (list_seq == 161)
        from = mail.from.encode Encoding::UTF_8, Encoding::KOI8_R
      end

      # mail.in_reply_to returns strange Array object in some cases (?), so let's use the raw value
      parent_message_id = extract_message_id_from_in_reply_to(mail.header[:in_reply_to]&.value)
      parent_message = Message.find_by message_id_header: parent_message_id if parent_message_id
      if !parent_message && (String === mail.references)
        parent_message = Message.find_by message_id_header: mail.references
      end
      if !parent_message && (Array === mail.references)
        mail.references.compact.each do |ref|
          break if (parent_message = Message.find_by message_id_header: ref)
        end
      end

      new list_id: list.id, list_seq: list_seq, body: body, subject: subject, from: from, published_at: mail.date, message_id_header: mail.message_id, parent_id: parent_message&.id
    end

    private def extract_message_id_from_in_reply_to(header)
      header && header.strip.scan(/<([^>]+)>/).flatten.first
    end

    def from_s3(list_name, list_seq, s3_client = Aws::S3::Client.new(region: BLADE_BUCKET_REGION))
      obj = s3_client.get_object(bucket: BLADE_BUCKET_NAME, key: "#{list_name}/#{list_seq}")

      m = self.from_string(obj.body.read)
      m.list_id = List.find_by_name(list_name).id
      m.list_seq = list_seq
      m
    end

    def from_string(str)
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
        body: Kconv.toutf8(body),
        subject: headers['Subject'],
        from: headers['From'],
        published_at: published_at,
      )
    end
  end

  def reload_from_s3(s3_client = Aws::S3::Client.new(region: BLADE_BUCKET_REGION))
    m = Message.from_s3(List.find_by_id(self.list_id).name, self.list_seq, s3_client)

    self.body = m.body
    self.subject = m.subject
    self.from = from
    self.published_at = m.published_at

    m
  end
end
