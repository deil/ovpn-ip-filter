#!/usr/bin/ruby

File.open("kusigma_vpn-status.txt", "r") do |f|
 File.open("ovpn-ip-filter.txt", "w") do |w|
  while l = f.gets
   arr = l.split(',')
   if arr.first =~ /client/
    cn = arr[0]
    ip = arr[1].split(':').first
    w.puts "%s %s/32" % [cn, ip]
   end
  end
 end
end

exit 0
