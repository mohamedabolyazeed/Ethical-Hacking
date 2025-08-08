# Sprint Title: HackTrek: Death & Challenges

## Overall Goal:

This sprint aims to enhance understanding of fundamental networking protocols and develop penetration testing skills through practical CTF challenges.

## Protocol Powerhouse: A Journey Through Protocols (OSI Model)

Understanding the OSI Model is crucial for mastering networking protocols. Here's a detailed look at some important protocols:

| Protocol | Function                                                                    | Layer (OSI) | Protocol (TCP/UDP) | Port(s) | Use Case                                                 |
|----------|-----------------------------------------------------------------------------|-------------|--------------------|---------|-------------------------------------------------------------|
| DNS      | Translates domain names (e.g., www.example.com) to IP addresses.             | Application | UDP/TCP           | 53      | Website browsing, email routing.                           |
| HTTP     | Transfers data on the web.                                                   | Application | TCP               | 80      | Web browsing.                                                 |
| HTTPS    | Transfers data on the web securely.                                           | Application | TCP               | 443     | Secure web browsing, online transactions.                   |
| FTP      | Transfers files between client and server.                                   | Application | TCP               | 21 (Control), 20 (Data)| Transferring large files.                                       |
| SMB      | Provides shared access to files, printers, and other network resources.       | Session     | TCP               | 445     | File sharing on Windows networks.                              |
| SSH      | Enables secure remote connections to servers and systems.                     | Application | TCP               | 22      | Remote server administration, secure file transfers.         |
| Telnet   | Enables insecure remote connections (legacy).                               | Application | TCP               | 23      | Remote access to devices (legacy use).                            |
| SNMP     | Monitors and manages network devices.                                        | Application | UDP               | 161     | Network performance monitoring.                               |
| ARP      | Resolves IP addresses to MAC addresses.                                      | Data Link   | ARP               | N/A     | Communication within local networks.                       |
| ICMP     | Sends control and diagnostic messages (e.g., Ping).                         | Network     | ICMP              | N/A     | Connectivity testing (Ping), route tracing (Traceroute), error reporting. |
| POP3     | Retrieves emails from a mail server.                                        | Application | TCP               | 110     | Email retrieval.                                            |
| IMAP     | Accesses and synchronizes emails across multiple devices.                    | Application | TCP               | 143     | Email synchronization on multiple devices.                   |
| SMTP     | Sends emails.                                                              | Application | TCP               | 25, 465, 587 | Email sending.                                               |


