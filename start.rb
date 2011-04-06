require "hsms_server"

EM.run {
  host, port = "0.0.0.0", 5000
  EM.start_server(host, port, HSMSServer)
  puts "Now accepting connections on address #{host}, port #{port}"
}
