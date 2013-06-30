

Apple's protocol. I don't know much about General/AppleTalk...I didn't learn networks till I was using OS X and IP heavily. Can anybody fill this in a wee bit more? -- General/RobRix

General/AppleTalk was originally the local area network architecture developed for the Macintosh by Gursharan Sidhu and his buds. It was a complete network architecture including cabling standards, a protocol suite, and applications. 

The General/AppleTalk protocol suite follows the OSI/ISO 7 layer model. At the bottom are electrical, link access, and media access protocols. Above these, the stack consists of the Appletalk Datagram Delivery Protocol (DDP), the Appletalk Transaction Protocol (ATP), the General/AppleTalk Session Protocol (ASP), the General/AppleTalk Address Resolution Protocol (AARP), General/AppleTalk Name Binding Protocol (NBP), the General/AppleTalk General/DataStream Protocol (ADSP), the Zone Information Protocol, and a routing protocol. Services including file and printer sharing use the General/AppleTalk Filing Protocol (AFP) and the Printer Access Protocol (PAP).

The original cabling standard and MAC came to be known as General/LocalTalk when General/EtherNet (dubbed General/EtherTalk) and General/TokenRing (General/TokenTalk) implementations became available. 

General/AppleTalk's greatest strength was simplicity of configuration and use. Its major problems were a restrictive packet size, chattiness (real or perceived), and a difficult (Device Manager-based) API. General/AppleTalk's ease of use is due to elegant design: simple cabling, dynamic configuration, dynamic name resolution. 

General/AppleTalk's kiler apps were file sharing and printer sharing (productized as General/AppleShare, General/AppleShare Pro, and Personal File Sharing). Later developments included a "groupware" environment (AOCE) and a standards-based implementation (General/OpenTransport) of the stack. Open Appletalk---Apple's first open source product!--was a source and binary implementation of General/AppleTalk for UNIX and VMS.

Sidhu's book "Inside Appletalk" is the definitive protocol reference through v56. In addition, it is a great pre-Internet-Era introduction to networking in general. The original General/AppleTalk driver interface is described in "Inside Macintosh IV/V/VI".  "Inside Macintosh: Networking" describes the updated .-style driver API. "Inside Macintosh: Networking with General/OpenTransport" describes the OT architecture and (its multitude of) General/APIs. AOCE has its own IM volume.

Apple has moved away from General/AppleTalk and embraced TCP/IP---even AFP prefers IP to DDP, anymore. But the ideas live on, in particular in the General/ZeroConf/Rendevous network configuration and service discovery system which directly leverages the ideas pioneered by AARP and NBP.