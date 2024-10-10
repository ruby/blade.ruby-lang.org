require 'optparse'

params = {}
OptionParser.new do |opts|
    opts.on('--list LIST')
    opts.on('--from FROM', Integer)
    opts.on('--to TO', Integer)
end.parse!(into: params)

list = params[:list]

(params[:from]..params[:to]).each do |seq|
    begin
        message = Message.from_s3(list, seq)
        message.save
    rescue ActiveRecord::RecordNotUnique
        STDERR.puts("#{list}:#{seq} already exists")
    rescue Aws::S3::Errors::NoSuchKey
        STDERR.puts("#{list}:#{seq} doesn't exist")
    rescue
        STDERR.puts("failed to import #{list}:#{seq}")
    end
end
