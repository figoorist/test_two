# myapp.rb
require 'sinatra'

notices = Array.new

Thread.new do
  while true do
     sleep 10
     notices.delete_if {|item| Time.now.to_i - item[:time].to_i > 6}
     print "Cleaning - "+ Time.now.to_s + "\n"
  end
end

post "/" do
  notice = {video_id: params[:v], customer_id: params[:c], time: Time.now.to_i}
  notices.push(notice)
  "OK!"
end

get "/c/:customer_id" do
  "Count of videos: " + notices.select { |item| item[:customer_id] == params[:customer_id] && Time.now.to_i - item[:time].to_i < 6 }.uniq {|item| item[:video_id]}.count.to_s
end

get "/v/:video_id" do
  "Count of customers: " + notices.select { |item| item[:video_id] == params[:video_id] && Time.now.to_i-item[:time].to_i < 6}.uniq {|item| item[:customer_id]}.count.to_s
end
