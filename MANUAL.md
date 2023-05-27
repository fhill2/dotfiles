manual os tweaks:
boot options:
- disable SIP protection (yabai) - enabled via csrutil in CLI
- permissive security policy - enable system extensions (ext4fuse)
- reduced security policy (IPMI view)

IPMIView needs reduced security policy, if permissive security policy is enabled the app wont open.