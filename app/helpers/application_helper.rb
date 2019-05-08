module ApplicationHelper

  def self.mac_address
    platform = RUBY_PLATFORM.downcase
    output = `#{(platform =~ /win32/) ? 'ipconfig /all' : 'ifconfig'}`
    case platform
      when /darwin/
        $1 if output =~ /en1.*?(([A-F0-9]{2}:){5}[A-F0-9]{2})/im
      when /win32/
        $1 if output =~ /Physical Address.*?(([A-F0-9]{2}-){5}[A-F0-9]{2})/im
      when /linux/
        $1 if output =~ /ether\s+(([A-F0-9]{2}:){5}[A-F0-9]{2})/im
      # Cases for other platforms...
      else nil
    end
  end

end
