#set page(
  paper: "a4",
  margin: (x: 1.8cm, top: 2.0cm, bottom: 2.0cm),
  header: align(right)[
    #text(size: 8.5pt, fill: rgb("#64748b"))[VLSI Design from First Principles | Chapter 3: CMOS Transistor Theory]
  ],
  footer: [
    #line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
    #grid(
      columns: (1fr, 1fr),
      align(left)[#text(size: 8pt, fill: rgb("#94a3b8"))[4-Hour Fast-Track Study Guide (UIT VLSI)]],
      align(right)[#context text(size: 8.5pt, weight: "bold", fill: rgb("#334155"))[Page #counter(page).display() of 8]]
    )
  ]
)

#set text(
  font: "Segoe UI",
  size: 9.8pt,
  lang: "en"
)

#set par(
  justify: true,
  leading: 0.62em
)

// Callout box styling
#let callout(title, body, border-color, bg-color, icon) = block(
  breakable: false,
  fill: bg-color,
  stroke: (left: 3.5pt + border-color),
  inset: (x: 10pt, y: 7pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #grid(
      columns: (auto, 1fr),
      gutter: 6pt,
      text(weight: "bold", size: 9.5pt, fill: border-color)[#icon #title],
      []
    )
    #v(2pt)
    #text(size: 9.0pt)[#body]
  ]
)

#let physical-box(body) = callout(
  "Physical Mechanism (Cơ chế vật lý cốt lõi)",
  body,
  rgb("#0284c7"),
  rgb("#f0f9ff"),
  "🔬"
)

#let math-box(body) = callout(
  "Mathematical Derivation (Chứng minh toán học)",
  body,
  rgb("#7c3aed"),
  rgb("#f5f3ff"),
  "📐"
)

#let rule-box(body) = callout(
  "VLSI Design Rule of Thumb (Quy tắc thiết kế vi mạch)",
  body,
  rgb("#059669"),
  rgb("#ecfdf5"),
  "⚡"
)

// ==========================================
// PAGE 1: TITLE & ROADMAP & HOUR 1 START
// ==========================================
#align(center)[
  #text(size: 21pt, weight: "bold", fill: rgb("#0f172a"))[Chapter 3: CMOS Transistor Theory]
  #v(1pt)
  #text(size: 11pt, fill: rgb("#334155"))[Understanding VLSI from Physical & Mathematical Mechanisms]
  #v(1pt)
  #text(size: 8.5pt, style: "italic", fill: rgb("#64748b"))[
    4-Hour Fast-Track Study Guide | Lecture Reference: UIT Chapter 3 & Weste-Harris CMOS VLSI
  ]
  #v(4pt)
  #line(length: 100%, stroke: 1.5pt + rgb("#0284c7"))
]

== 4-Hour Time-Boxed Roadmap (Lộ trình học tập 4 giờ)
Follow this exact schedule to achieve complete mastery in 4 hours without wasting time on Chapters 1 & 2:

#table(
  columns: (1.2fr, 2.3fr, 3.5fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 5.5pt,
  [*Time Block*], [*Module Name*], [*Key Mechanism & Outcome*],
  [Hour 1 (0h - 1h)], [The MOS Capacitor & 3 Modes], [Accumulation, Depletion, Inversion, Threshold Voltage $V_t$ origin],
  [Hour 2 (1h - 2h)], [Derivation of $I-V$ Equations], [Transit time, channel charge, Linear/Saturation math, Pinch-off],
  [Hour 3 (2h - 3h)], [pMOS Physics & AMI 0.6$mu$m Math], [Hole mobility penalty ($mu_n / mu_p approx 2$), $W_p = 2W_n$ sizing, slide 15 math],
  [Hour 4 (3h - 4h)], [Parasitic Capacitances & Delay], [Gate capacitance $C_g$, Diffusion capacitance $C_(d b)$, delay formula $Delta t = (C Delta V)/I$]
)

#v(6pt)
= Hour 1: The MOS Capacitor & The 3 Operating Modes
_Reference: Slides 1 – 5 | Target Time: 60 minutes_

=== 1.1 Beyond the Ideal Switch (Vượt qua tư duy công tắc lý tưởng)
In basic digital logic, transistors are treated as ideal switches: Gate = 1 (closed, zero resistance) and Gate = 0 (open, zero leakage).
In real silicon, an ON transistor conducts a *finite current* (dòng điện giới hạn), and its terminals possess *capacitance* (điện dung ký sinh).

#rule-box[
  The fundamental law of digital switching speed is:
  $ Delta t = frac(C, I) Delta V $
  To make a chip faster, we must *maximize current $I$* and *minimize capacitance $C$*. Current and capacitance together dictate the maximum clock frequency of the processor.
]

=== 1.2 Physical Structure of the MOS Capacitor
A MOSFET is controlled by a sandwich structure:
1. *Gate (Cực Cổng):* Highly conductive Polysilicon (silicon đa tinh thể dẫn điện tốt).
2. *Dielectric (Lớp điện môi cách điện):* Silicon Dioxide ($"SiO"_2$) with thickness $t_(o x)$ and permittivity $epsilon_(o x) = 3.9 epsilon_0$.
3. *Body / Substrate (Đế bán dẫn):* p-type silicon doped with Acceptor atoms ($N_A$, e.g., Boron).

Gate oxide capacitance per unit area is:
$ C_(o x) = frac(epsilon_(o x), t_(o x)) = frac(3.9 times 8.85 times 10^(-14) " F/cm", t_(o x)) $

#pagebreak()

// ==========================================
// PAGE 2: HOUR 1 (THE 3 MODES DIAGRAM)
// ==========================================
=== 1.3 The 3 Physical Operating Modes (Ba chế độ hoạt động)
Depending on the gate bias voltage relative to the p-substrate ($V_g$), the structure exhibits 3 distinct regimes:

#align(center)[
  #image("images/fig3_1_mos_capacitor_modes.png", height: 5.4cm)
]

#physical-box[
  *1. Accumulation (Chế độ tích lũy - $V_g < 0" V"$):*\
  Negative voltage on the gate pulls positive holes ($h^+$) from the p-substrate directly up to the $"Si"-"SiO"_2$ surface. A dense layer of holes accumulates at the interface. The transistor is strictly OFF.

  *2. Depletion (Chế độ nghèo - $0 < V_g < V_t$):*\
  A small positive gate voltage repels positive mobile holes away from the surface into the substrate bulk. This exposes immobile negative acceptor ions ($N_A^-$), creating an insulating depletion zone of thickness $W_(d e p)$ containing zero free carriers.

  *3. Inversion (Chế độ đảo - Hình thành kênh dẫn - $V_g > V_t$):*\
  When $V_g$ exceeds the *Threshold Voltage* ($V_t$), the electric field becomes strong enough to pull minority electrons ($e^-$) from the substrate to the surface. The surface silicon inverts from p-type to n-type. This conductive electron layer forms the *Inversion Channel*.
]

#rule-box[
  *Why Threshold Voltage $V_t$ Exists Physically:*\
  $V_t$ is the exact gate voltage required to achieve *strong inversion*—where the electron concentration at the surface equals the original hole concentration in the substrate ($n_("surface") = N_A$). Below $V_t$, no conducting channel exists.
]

#pagebreak()

// ==========================================
// PAGE 3: HOUR 2 (I-V DERIVATION & CONDUCTION)
// ==========================================
= Hour 2: Mathematical Derivation of Shockley $I-V$ Equations
_Reference: Slides 6 – 14 | Target Time: 60 minutes_

=== 2.1 Terminal Voltages & Conduction Regimes
With Source and Body grounded ($V_s = 0" V", V_b = 0" V"$):
- $V_(g s) = V_g - V_s$: Controls channel inversion.
- $V_(d s) = V_d - V_s$: Creates lateral electric field to pull electrons from Source to Drain.
- $V_(g d) = V_g - V_d = V_(g s) - V_(d s)$: Controls channel inversion depth at the drain end.

#align(center)[
  #image("images/fig3_2_nmos_conduction_modes.png", height: 6.6cm)
]

=== 2.2 First-Principles Derivation of Current ($I_(d s)$)
Current is charge passing through a cross-section per unit time: $I_(d s) = frac(Q_("channel"), t_("transit"))$.

#math-box[
  *Step 1: Calculate Total Channel Charge ($Q_("channel")$)*\
  The channel behaves like a parallel-plate capacitor with area $W times L$. The average channel voltage along the length is $V_("channel, avg") = frac(V_s + V_d, 2) = frac(V_(d s), 2)$.\
  The effective gate-to-channel inversion voltage is $V_("eff") = (V_(g s) - frac(V_(d s), 2)) - V_t$.\
  $ Q_("channel") = C_(o x) W L [ (V_(g s) - V_t) - frac(V_(d s), 2) ] $

  *Step 2: Calculate Transit Time ($t_("transit")$)*\
  Lateral electric field is $cal(E) = V_(d s) / L$. Electron drift velocity is $v = mu_n cal(E) = mu_n frac(V_(d s), L)$.\
  $ t_("transit") = frac(L, v) = frac(L^2, mu_n V_(d s)) $

  *Step 3: Combine to Obtain Linear Current*\
  $ I_(d s) = frac(Q_("channel"), t_("transit")) = mu_n C_(o x) frac(W, L) [ (V_(g s) - V_t) V_(d s) - frac(V_(d s)^2, 2) ] $
]

#pagebreak()

// ==========================================
// PAGE 4: HOUR 2 (SATURATION & PINCH-OFF CURVES)
// ==========================================
=== 2.3 Saturation & Pinch-off Mechanism (Vùng bão hòa & Hiện tượng thắt kênh)
When $V_(d s)$ increases such that $V_(g d) = V_(g s) - V_(d s) <= V_t$, the inversion charge at the drain edge drops to zero. This is called *Pinch-off* (thắt kênh).

#physical-box[
  *Why Current Does Not Drop to Zero at Pinch-off:*\
  Electrons enter the channel at the Source and travel toward the Drain. At the pinch-off point, electrons are injected into the high-field depletion gap and are *swept (quét mạnh)* into the Drain $n^+$ diffusion.
  
  Increasing $V_(d s)$ further does not increase channel current because the voltage drop across the active conducting channel remains clamped at $V_("dsat") = V_(g s) - V_t$.
]

Substituting $V_(d s) = V_(g s) - V_t$ into the linear equation gives the constant saturation current:
$ I_(d s, "sat") = beta [ (V_(g s) - V_t)^2 - frac((V_(g s) - V_t)^2, 2) ] = bold(frac(beta, 2) (V_(g s) - V_t)^2) $
where $beta = mu_n C_(o x) frac(W, L)$ is the transistor gain factor.

#align(center)[
  #image("images/fig3_3_nmos_iv_curves.png", height: 6.2cm)
]

#rule-box[
  *Shockley 1st-Order Summary:*\
  - *Cutoff ($V_(g s) < V_t$):* $I_(d s) = 0$
  - *Linear ($V_(g s) >= V_t, V_(d s) < V_(g s) - V_t$):* $I_(d s) = beta [ (V_(g s) - V_t) V_(d s) - frac(V_(d s)^2, 2) ]$
  - *Saturation ($V_(g s) >= V_t, V_(d s) >= V_(g s) - V_t$):* $I_(d s) = frac(beta, 2) (V_(g s) - V_t)^2$
]

#pagebreak()

// ==========================================
// PAGE 5: HOUR 3 (pMOS PHYSICS & SIZING)
// ==========================================
= Hour 3: pMOS Physics & AMI 0.6$mu$m Hand Calculation
_Reference: Slides 15 – 17 | Target Time: 60 minutes_

=== 3.1 pMOS Physics: Polarity Inversion & Mobility Penalty
A pMOS transistor is formed inside an n-well on a p-substrate, using $p^+$ source/drain diffusions. Current conduction is carried by *holes* ($h^+$) instead of electrons:
- All voltages and currents have *negative polarity*: $V_(g s) < 0, V_(d s) < 0, I_(d s) < 0$.
- Cutoff occurs when $V_(g s) > V_(t p)$ (where $V_(t p) approx -0.7" V"$).

#align(center)[
  #image("images/fig3_4_nmos_vs_pmos.png", height: 5.5cm)
]

#physical-box[
  *Why Are Holes 2 to 3 Times Slower Than Electrons?*\
  Electrons move through the conduction band (dải dẫn) with low effective mass and few collisions. In contrast, holes move through the valence band (dải hóa trị) as electrons jump from one covalent bond to another. This higher scattering results in:
  $ frac(mu_n, mu_p) approx 2 " to " 3 quad (mu_n approx 350 " cm"^2/("V" dot "s"), mu_p approx 120 " cm"^2/("V" dot "s")) $
]

#rule-box[
  *The Inverter Sizing Golden Rule ($W_p / W_n = 2$):*\
  Because holes travel half as fast as electrons, a pMOS transistor must be designed with *twice the channel width* ($W_p approx 2 W_n$) of an nMOS transistor to deliver the same drive current, ensuring symmetric rise and fall propagation delays ($t_(p L H) approx t_(p H L)$).
]

#pagebreak()

// ==========================================
// PAGE 6: HOUR 3 (AMI 0.6um WORKED CALCULATION)
// ==========================================
=== 3.2 Worked Hand Calculation: AMI 0.6$mu$m Process
*(Directly solving Slide 15 from the university lecture)*

*Given Parameters:*
- Process Node: $0.6 mu"m"$, Gate oxide: $t_(o x) = 100 "Å" = 100 times 10^(-8)" cm" = 10" nm"$.
- Electron mobility: $mu_n = 350 " cm"^2 / ("V" dot "s")$.
- Threshold voltage: $V_t = 0.7" V"$. Transistor geometry: $W/L = (4 lambda) / (2 lambda) = 2$.

#math-box[
  *Step 1: Calculate Oxide Capacitance per Area ($C_(o x)$)*\
  $ epsilon_(o x) = 3.9 times epsilon_0 = 3.9 times (8.85 times 10^(-14) " F/cm") = 3.45 times 10^(-13) " F/cm" $
  $ C_(o x) = frac(epsilon_(o x), t_(o x)) = frac(3.45 times 10^(-13) " F/cm", 100 times 10^(-8) " cm") = bold(3.45 times 10^(-7) " F/cm"^2) $

  *Step 2: Calculate Process Transconductance Parameter ($k'_n = mu_n C_(o x)$)*\
  $ k'_n = mu_n C_(o x) = 350 " cm"^2/("V" dot "s") times (3.45 times 10^(-7) " F/cm"^2) = bold(120.8 mu"A/V"^2) $

  *Step 3: Calculate Transistor Gain Factor ($beta$)*\
  $ beta = k'_n frac(W, L) = 120.8 mu"A/V"^2 times 2 = bold(241.6 mu"A/V"^2 = 0.242 " mA/V"^2) $

  *Step 4: Calculate Saturation Current at $V_(g s) = 5" V"$*\
  $ V_("dsat") = V_(g s) - V_t = 5.0" V" - 0.7" V" = 4.3" V" $
  $ I_(d s, "sat") = frac(beta, 2) (V_(g s) - V_t)^2 = frac(0.242 " mA/V"^2, 2) times (4.3" V")^2 = 0.121 times 18.49 = bold(2.24 " mA") $
]

#v(6pt)
=== Comparison: pMOS Equivalent for AMI 0.6$mu$m
For a pMOS in the same process ($mu_p = 120 " cm"^2/("V" dot "s")$, $V_(t p) = -0.7" V"$, $W/L = 2$):
$ beta_p = mu_p C_(o x) frac(W, L) = 120 times (3.45 times 10^(-7)) times 2 approx bold(0.083 " mA/V"^2) $
At $V_(g s) = -5" V"$:
$ I_(d s, "sat") = -frac(beta_p, 2)(abs(V_(g s)) - abs(V_(t p)))^2 = -frac(0.083, 2) times (4.3)^2 approx bold(-0.77 " mA") $
Notice that $I_(d s, n) / abs(I_(d s, p)) = 2.24 / 0.77 approx bold(2.9 times)$, mathematically proving why pMOS must be wider!

#pagebreak()

// ==========================================
// PAGE 7: HOUR 4 (CAPACITANCES & SPEED DELAY)
// ==========================================
= Hour 4: Transistor Parasitic Capacitance & Circuit Speed
_Reference: Slides 18 – 20 | Target Time: 60 minutes_

=== 4.1 Gate Capacitance ($C_g$)
Gate capacitance creates the inversion channel and acts as the capacitive load on the preceding driver:
$ C_g = C_(o x) W L = C_("per_micron") W $
In submicron processes, gate capacitance is approximately:
$ C_("per_micron") = C_(o x) L_("min") approx bold(1.5 " to " 2.0 " fF/"mu"m") $

#align(center)[
  #image("images/fig3_5_transistor_capacitances.png", height: 5.6cm)
]

=== 4.2 Parasitic Diffusion Capacitance ($C_(s b), C_(d b)$)
The $n^+$ source and drain regions form *reverse-biased PN junction diodes* with the p-substrate:
- Diffusion capacitance is *purely parasitic* (wastes dynamic power and increases delay).
- Composed of *Bottom plate capacitance* ($C_("bottom") prop W times L_d$) and *Sidewall capacitance* ($C_("sidewall") prop 2W + 2L_d$).
- Contacted diffusion capacitance is roughly equal to $C_g$. Uncontacted shared diffusion drops to $approx 0.5 C_g$.

=== 4.3 Fundamental Delay Equation
When a gate switches, current charges the load capacitance $C_L = C_("gate") + C_("diff") + C_("wire")$:
$ Delta t = frac(C_L Delta V, I_("avg")) $
To double chip clock frequency, we must either double saturation current $I$ or cut load capacitance $C_L$ in half!

#pagebreak()

// ==========================================
// PAGE 8: HOUR 4 (CHEAT SHEET & SELF-TEST QUIZ)
// ==========================================
=== 4.4 Summary Cheat Sheet (Bảng tóm tắt toàn chương)

#table(
  columns: (1.5fr, 2.5fr, 3fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 5.5pt,
  [*Symbol / Parameter*], [*Physical Meaning*], [*Typical Value / Formula*],
  [$C_(o x)$], [Gate oxide capacitance per area], [$epsilon_(o x) / t_(o x) approx 3.45 times 10^(-7)" F/cm"^2$],
  [$beta$], [Transconductance gain factor], [$mu C_(o x) (W/L)$],
  [Linear Region], [Continuous resistive channel], [$V_(g s) >= V_t$ and $V_(d s) < V_(g s) - V_t$],
  [Saturation Region], [Channel pinched-off at drain], [$V_(g s) >= V_t$ and $V_(d s) >= V_(g s) - V_t$],
  [$I_(d s, "sat")$], [Shockley saturation current], [$frac(beta, 2)(V_(g s) - V_t)^2$],
  [$mu_n / mu_p$], [Mobility ratio (electrons vs holes)], [$approx 2 " to " 3$ ($arrow.r W_p = 2W_n$)],
  [$Delta t$], [Gate propagation delay], [$(C_L Delta V) / I_("avg")$]
)

#v(6pt)
=== 4.5 10-Minute Self-Assessment Quiz (Bài kiểm tra nhanh)

1. *Q1:* An nMOS transistor has $V_(g s) = 3.0" V"$, $V_t = 0.6" V"$, and $V_(d s) = 1.5" V"$. Which operating region is it in?\
   *Answer:* $V_("dsat") = V_(g s) - V_t = 3.0 - 0.6 = 2.4" V"$. Since $V_(d s) = 1.5" V" < 2.4" V"$, the channel is continuous and the transistor is in the *Linear Region*.

2. *Q2:* Why does drain current remain constant in the saturation region even if $V_(d s)$ increases?\
   *Answer:* The channel pinches off at the drain side. The voltage across the active inversion channel is clamped at $V_("dsat") = V_(g s) - V_t$. Extra voltage drops across the pinch-off depletion gap without increasing the channel field.

3. *Q3:* Why is pMOS designed twice as wide as nMOS ($W_p approx 2 W_n$) in standard CMOS cells?\
   *Answer:* Hole mobility in silicon is $2-3 times$ lower than electron mobility ($mu_n / mu_p approx 2-3$). A $2times$ wider pMOS matches nMOS drive current, achieving symmetric rise and fall delays ($t_(p L H) approx t_(p H L)$).

4. *Q4:* Why does sharing diffusion nodes in layout improve circuit speed?\
   *Answer:* Shared diffusion eliminates contact spacing, reducing junction area by $approx 50%$. This reduces parasitic diffusion capacitance $C_(d b)$, decreasing propagation delay $Delta t = (C Delta V)/I$.
