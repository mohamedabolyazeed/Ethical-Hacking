rule Suspicious_PE_Trojan {
    strings:
        $a = "fIi[qjvRFuc{F:TR0Qbh/sEloLg0K3LI3IJdqmq5Sg6JdYysBy8mxp0XMoGpt858hfK6HIKM4,g54vjOTZtBlKDeyypFb4msYWVH2nB39eGuCE3o7V1rcwtcvgbyfUGH"
    condition:
        any of them
}
