Short for IP Security, a set of protocols developed by the IETF to support secure exchange of packets at the IP layer. General/IPSec has been deployed widely to implement General/VirtualPrivateNetworks (General/VPNs).

General/IPSec supports two encryption modes: Transport and Tunnel. Transport mode encrypts only the data portion (payload) of each packet, but leaves the header untouched. The more secure Tunnel mode encrypts both the header and the payload. On the receiving side, an General/IPSec-compliant device decrypts each packet.

For General/IPSec to work, the sending and receiving devices must share a public key. This is accomplished through a protocol known as Internet Security Association and Key Management Protocol/Oakley (ISAKMP/Oakley), which allows the receiver to obtain a public key and authenticate the sender using digital certificates.

Source: http://www.webopedia.com