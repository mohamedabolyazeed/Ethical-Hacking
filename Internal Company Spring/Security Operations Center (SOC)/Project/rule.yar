rule Suspicious_PE_Trojan {
    meta:
        description = "Detects Trojan with unique string from invoice_2318362983713_823931342io.pdf.exe.bin"
    strings:
        $a = "fIi[qjvRFuc{F:TR0Qbh/sEloLg0K3LI3IJdqmq5Sg6JdYysBy8mxp0XMoGpt858hfK6HIKM4,g54vjOTZtBlKDeyypFb4msYWVH2nB39eGuCE3o7V1rcwtcvgbyfUGH"
    condition:
        uint16(0) == 0x5A4D and any of them
}

rule Suspicious_PE_Malware {
    meta:
        description = "Detects malware with C2 and persistence strings from sample_mal.exe"
    strings:
        $s1 = "svchost32.exe"
        $s2 = "http://malicious-example.com/c2"
    condition:
        uint16(0) == 0x5A4D and all of them
}
