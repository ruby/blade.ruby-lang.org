require 'optparse'

params = {}
OptionParser.new do |opts|
    opts.on('--list LIST')
    opts.on('--from FROM', Integer)
    opts.on('--to TO', Integer)
end.parse!(into: params)

(params[:from]..params[:to]).each do |seq|
    message = Message.from_s3(params[:list], seq)
    message.save
end
