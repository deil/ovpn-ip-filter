#!/usr/bin/ruby

input_file = ARGV.first
default_mask = ARGV[1] || "32"

puts "Parsing OpenVPN status file: %s" % input_file
puts "Default netmask for incoming connections: %s" % default_mask

File.open(input_file, "r") do |f|
 File.open("ovpn-ip-filter.txt", "w") do |w|
  while l = f.gets
   arr = l.split(',')
   if arr.first =~ /client/
    cn = arr[0]
    ip = arr[1].split(':').first
    w.puts "%s %s/%s" % [cn, ip, default_mask]
   end
  end
 end
end

exit 0
