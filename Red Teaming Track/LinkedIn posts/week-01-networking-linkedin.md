# 🔴 Week 1 — Back to Networking Fundamentals

بدأت أول أسبوع في الـ Red Team Roadmap بالرجوع لحاجة ممكن تبان Basic…

لكن من غيرها صعب تفهم فعلًا إيه اللي بيحصل جوه الشبكة.

---

## 📖 مقدمة

بعد فترة كان تركيزي فيها أكتر على Web & API Security، قررت أرجع للأساسيات.

مش علشان أحفظ الـ OSI Layers أو الـ Ports من جديد، لكن علشان أفهم الـ Traffic والـ Connections بشكل أعمق.

السؤال اللي كنت بحاول أجاوب عليه طول الأسبوع:

**إيه اللي بيحصل فعلًا من لحظة ما جهازي يحاول يتصل بسيرفر؟**

---

## 📚 المواضيع التي تمت مراجعتها

خلال الأسبوع راجعت وطبقت على:

- TCP/IP
- OSI Model
- TCP vs UDP
- Common Ports
- DNS
- Wireshark
- TCP 3-Way Handshake

---

## 🔍 العمل العملي مع Wireshark

أهم جزء بالنسبة لي كان إني أحول الكلام النظري لحاجة أشوفها قدامي فعلًا.

فتحت Wireshark وعملت Capture لاتصال HTTPS، وقدرت أشوف بداية الـ TCP Connection:

```
SYN
↓
SYN/ACK
↓
ACK
```

بعد اكتمال الـ 3-Way Handshake ظهر بعدها:

```
TLS Client Hello
```

وهنا بدأت أبص للـ Packet بشكل مختلف.

مش مجرد Row في Wireshark…

لكن مجموعة Layers فوق بعضها:

```
Ethernet Frame
↓
IPv4 Packet
↓
TCP Segment
↓
TLS / Application Data
```

ولما بدأت أحلل الـ Packet، بقيت أركز على حاجات زي:

- Source & Destination IP
- TTL
- Source & Destination Ports
- TCP Flags
- Sequence & Acknowledgment Numbers
- Payload

---

## 🧠 فهم OSI Model بشكل عملي

وده غير طريقة فهمي للـ OSI Model.

بدل ما يكون مجرد 7 Layers لازم أحفظ ترتيبهم، بقيت أستخدمه كـ Mental Model للـ Troubleshooting والـ Security.

لو عندي مشكلة، أبدأ أسأل:

1. هل الـ Physical Connection شغال؟
2. هل الجهاز عنده IP و Gateway صح؟
3. هل فيه Route للهدف؟
4. هل الـ Port مفتوح؟
5. هل الـ TCP Connection اتبنى؟
6. ولا المشكلة في الـ Application نفسه؟

---

## 🔄 الفرق بين TCP و UDP

راجعت كمان الفرق بين TCP و UDP.

والموضوع بالنسبة لي بقى أكتر من:

```
TCP = Reliable
UDP = Fast
```

لأن فهم الفرق بينهم بيأثر على طريقة قراءتك للـ Traffic والـ Scanning والـ Enumeration.

---

## 🎯 أهمية Ports

ونفس الفكرة مع الـ Ports.

- Port 22 مش مجرد SSH.
- Port 80 مش مجرد HTTP.
- Port 445 مش مجرد SMB.

كل Port ممكن يكون بداية للخط ده:

```
Port
↓
Service
↓
Version
↓
Configuration
↓
Attack Surface
```

---

## 🎯 الهدف الأساسي

وده أهم شيء بحاول أركز عليه في المرحلة دي:

مش مجرد استخدام Tools…

لكن فهم النظام والـ Traffic اللي الـ Tools بتعرضهولي.

الهدف من مراجعة الـ Networking مش إني أرجع للبداية.

الهدف إني أبني Foundation أقوى للحاجات اللي جاية:

```
Recon → Enumeration → Network Pentesting → Active Directory → Red Teaming
```

---

## ✅ Week 1 Complete

Week 1 ✅

> Tools can show you the traffic.
>
> Understanding networking tells you what that traffic actually means.

---

## 🏷️ Tags

# CyberSecurity #RedTeam #PenetrationTesting #Networking #TCPIP #Wireshark #NetworkSecurity #Nmap #InfoSec
