# Set port
netsh int ipv4 set dynamicport tcp start=3000 num=62000
netsh int ipv6 set dynamicport tcp start=3000 num=62000
# Show current setting
netsh int ipv4 show dynamicport tcp
netsh int ipv6 show dynamicport tcp
