#!/usr/bin/ruby

def inet_aton(ip)
 n = 0
 shiftlen = 24
 ip.scan(/\d+/) do |octet|
  n += (octet.to_i << shiftlen)
  shiftlen -= 8
 end
 
 n
end

def bitsToMask(bits)
 octets = []
 4.times do
   if bits > 8
    octets << 255
   elsif bits <= 0
    octets << 0
   else
    octets << (((2**bits) - 1) << 8 - bits)
   end
   
   bits -= 9
 end
 
 octets.join('.')
end

def match?(ip, mask)
 mask_net, mask_bits = mask.split("/")
 #p mask_net
 #p mask_bits

 return true if ip == mask_net
 
 ipn = inet_aton(ip)
 netn = inet_aton(mask_net)
 maskn = inet_aton(bitsToMask(mask_bits.to_i))
 wildcardn = maskn ^ ((2**32) - 1)
 broadcastn = netn ^ wildcardn
 #puts ipn
 #puts netn
 #puts broadcastn
 
 return true if ipn >= netn && ipn < broadcastn

 #puts "does not match"
 false
end

cn = ENV['common_name']
client_ip = ENV['trusted_ip'] || ENV['untrusted_ip']

File.open("/etc/openvpn/ovpn-ip-filter.txt", "r") do |f|
 while l = f.gets do
  l = l.strip
  v = l.split(" ")
  p_cn = v[0]
  p_mask = v[1]
  
  if p_cn == cn
   #puts "%s: connecting from %s, should be %s" % [p_cn, client_ip, p_mask]
   exit match?(client_ip, p_mask) ? 0 : -1
  end
 end
end

exit -1
