#set page(
  paper: "a4",
  margin: (x: 1.8cm, top: 1.8cm, bottom: 1.8cm),
  header: align(right)[
    #text(size: 8.5pt, fill: rgb("#64748b"))[VLSI Design from Mechanism | Chapter 3: CMOS Transistor Theory (Storytelling Edition)]
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
  size: 9.6pt,
  lang: "en"
)

#set par(
  justify: true,
  leading: 0.60em
)

// Callout box styling
#let callout(title, body, border-color, bg-color, icon) = block(
  breakable: false,
  fill: bg-color,
  stroke: (left: 3.5pt + border-color),
  inset: (x: 9pt, y: 6.5pt),
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
// PAGE 1: TITLE & ROADMAP & STORY INTRO
// ==========================================
#align(center)[
  #text(size: 20pt, weight: "bold", fill: rgb("#0f172a"))[Chapter 3: CMOS Transistor Theory]
  #v(1pt)
  #text(size: 11pt, fill: rgb("#334155"))[Understanding Transistors via Physical Storytelling & Dynamic Mechanisms]
  #v(1pt)
  #text(size: 8.5pt, style: "italic", fill: rgb("#64748b"))[
    4-Hour Fast-Track Study Guide | Lecture Reference: UIT Chapter 3 & Weste-Harris CMOS VLSI
  ]
  #v(4pt)
  #line(length: 100%, stroke: 1.5pt + rgb("#0284c7"))
]

== 4-Hour Time-Boxed Roadmap (Lộ trình học tập 4 giờ)
Follow this exact schedule to master Chapter 3 in 4 hours without wasting time on Chapters 1 & 2:

#table(
  columns: (1.2fr, 2.2fr, 3.6fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 5pt,
  [*Time Block*], [*Module Name*], [*The Physical Story (Câu chuyện vật lý)*],
  [Hour 1 (0h - 1h)], [The MOS Capacitor & 3 Modes], [The drama of electrostatic forces: How gate voltage drives holes away and creates an electron highway],
  [Hour 2 (1h - 2h)], [Derivation of $I-V$ Equations], [Traffic flow across silicon: Deriving linear current and the slingshot pinch-off saturation mechanism],
  [Hour 3 (2h - 3h)], [pMOS Physics & AMI 0.6$mu$m Math], [The mobility battle ("Highway" vs "Musical Chairs"): Why pMOS is sluggish and requires double width],
  [Hour 4 (3h - 4h)], [Capacitive Parasitics & Speed], [The Capacitor Discharge Odyssey: Step-by-step electron loop from Ground to node $Y$ and speed limits]
)

#v(4pt)
= Hour 1: The MOS Capacitor & The 3 Operating Modes
_Reference: Slides 1 – 5 | Target Time: 60 minutes_

=== 1.1 Beyond the Ideal Switch (Vượt qua tư duy công tắc lý tưởng)
In basic digital logic, a transistor is taught as an ideal switch: Gate = 1 (closed, zero resistance) and Gate = 0 (open, zero current).
In real silicon, a transistor is a *charge-controlled reservoir pipe*:
1. When turned ON, it does not have zero resistance. Current is limited by carrier collisions in the crystal lattice.
2. Every terminal stores electric charge as parasitic capacitance.
3. Every switching transition is a race to drain or fill this stored charge:
$ Delta t = frac(C, I) Delta V $

=== 1.2 Structure of the MOS Capacitor
The heart of every MOSFET is a parallel-plate sandwich:
1. *Gate (Cực Cổng):* Highly conductive Polysilicon (silicon đa tinh thể dẫn điện tốt).
2. *Dielectric (Lớp điện môi cách điện):* Silicon Dioxide ($"SiO"_2$) with thickness $t_(o x)$ and relative permittivity $epsilon_(o x) = 3.9 epsilon_0$.
3. *Body / Substrate (Đế bán dẫn):* p-type silicon doped with Acceptor atoms ($N_A$, e.g., Boron).

The gate oxide capacitance per unit area is:
$ C_(o x) = frac(epsilon_(o x), t_(o x)) = frac(3.9 times 8.85 times 10^(-14) " F/cm", t_(o x)) $

#pagebreak()

// ==========================================
// PAGE 2: HOUR 1 (THE 3 MODES STORY & DIAGRAM)
// ==========================================
=== 1.3 The Chronological Story of the Three Operating Modes
Imagine you are standing inside the silicon crystal beneath the gate oxide. Here is what happens as gate voltage rises:

#align(center)[
  #image("images/fig3_1_mos_capacitor_modes.png", height: 5.5cm)
]

#physical-box[
  *1. Act 1: Accumulation (Chế độ tích lũy - $V_g < 0" V"$)*\
  - *Electric Field:* Negative voltage on the gate produces an *upward-pointing electric field* ($arrow.t$).
  - *Carrier Motion:* Mobile positive holes ($h^+$) feel an electrostatic pull upward ($vec(F) = q vec(cal(E))$). They rush to the surface, forming a dense sheet of holes directly underneath the oxide.
  - *Transistor State:* Strictly OFF. There are no free electrons to connect Source to Drain.

  *2. Act 2: Depletion (Chế độ nghèo - $0 < V_g < V_t$)*\
  - *Electric Field:* Gate voltage turns slightly positive, flipping the field *downward* ($arrow.b$).
  - *Carrier Motion:* The positive gate repels positive holes, shoving them deep down into the substrate bulk.
  - *Lattice Residue:* As holes retreat, they expose immobile negative Boron acceptor ions ($B^-$) locked in the crystal lattice. This creates an insulating *Depletion Zone* ($W_(d e p)$) free of mobile carriers.

  *3. Act 3: Inversion (Chế độ đảo - Hình thành kênh dẫn - $V_g > V_t$)*\
  - *Electric Field:* When $V_g$ exceeds the *Threshold Voltage* ($V_t$), the downward electric field becomes overwhelming ($> 10^6 " V/cm"$).
  - *Carrier Motion:* The field forcibly pulls minority electrons from the substrate and source/drain diffusions, locking them into a razor-thin 2D sheet ($approx 1-3" nm"$) at the surface.
  - *The Magic:* The surface silicon has inverted from p-type to n-type! A conducting bridge of electrons is born.
]

#rule-box[
  *Physical Meaning of Threshold Voltage $V_t$:*\
  $V_t$ is not an arbitrary number. It is the exact gate voltage needed to bend the energy bands enough so that the surface electron concentration equals the bulk hole concentration ($n_("surface") = N_A$). Below $V_t$, the channel does not exist!
]

#pagebreak()

// ==========================================
// PAGE 3: HOUR 2 (I-V DERIVATION & FIELD BATTLE)
// ==========================================
= Hour 2: Mathematical Derivation of Shockley $I-V$ Equations
_Reference: Slides 6 – 14 | Target Time: 60 minutes_

=== 2.1 The Battle of Two Electric Fields
When a channel forms, current flow is governed by the tug-of-war between two perpendicular electric fields:
1. *Vertical Field ($cal(E)_perp$):* Created by Gate-to-Channel voltage. Controls *how many electrons* are in the channel.
2. *Lateral Field ($cal(E)_parallel$):* Created by Drain-to-Source voltage ($cal(E)_parallel = V_(d s) / L$). Propels electrons *from Source to Drain*.

#align(center)[
  #image("images/fig3_2_nmos_conduction_modes.png", height: 6.8cm)
]

=== 2.2 First-Principles Derivation of Current ($I_(d s)$)
Current is charge passing through a cross-section per unit time: $I_(d s) = frac(Q_("channel"), t_("transit"))$.

#math-box[
  *Step 1: Calculate Total Channel Charge ($Q_("channel")$)*\
  At the Source ($x=0$), channel voltage is $V_s = 0$. Gate-to-channel voltage is $V_(g s)$.\
  At the Drain ($x=L$), channel voltage is $V_d = V_(d s)$. Gate-to-channel voltage is $V_(g d) = V_(g s) - V_(d s)$.\
  The channel tapers into a wedge! The average channel voltage along the length is $V_("channel, avg") = frac(V_s + V_d, 2) = frac(V_(d s), 2)$.\
  Effective inversion voltage: $V_("eff") = (V_(g s) - frac(V_(d s), 2)) - V_t$.\
  $ Q_("channel") = C_(o x) W L [ (V_(g s) - V_t) - frac(V_(d s), 2) ] $

  *Step 2: Calculate Carrier Transit Time ($t_("transit")$)*\
  Lateral electric field is $cal(E)_parallel = V_(d s) / L$. Electron drift velocity is $v = mu_n cal(E)_parallel = mu_n frac(V_(d s), L)$.\
  Transit time across distance $L$: $t_("transit") = frac(L, v) = frac(L^2, mu_n V_(d s))$.

  *Step 3: Combine to Obtain Linear Current*\
  $ I_(d s) = frac(Q_("channel"), t_("transit")) = mu_n C_(o x) frac(W, L) [ (V_(g s) - V_t) V_(d s) - frac(V_(d s)^2, 2) ] $
]

#pagebreak()

// ==========================================
// PAGE 4: HOUR 2 (SLINGSHOT PINCH-OFF & TRAJECTORY)
// ==========================================
=== 2.3 The Slingshot Mechanism at Pinch-off (Cơ chế bắn vọt khi thắt kênh)
When $V_(d s)$ increases such that $V_(g d) = V_(g s) - V_(d s) <= V_t$, the vertical field at the drain falls below the threshold needed for inversion. The inversion layer disappears at the drain edge. This is *Pinch-off* (thắt kênh).

#physical-box[
  *Why Current Does NOT Stop at Pinch-off:*\
  Electrons entering from the Source travel through the channel wedge. Upon reaching the pinch-off point, they encounter a fierce, localized electric field across the depletion gap. This field acts like a *slingshot (súng cao su)*, violently sweeping electrons across into the $n^+$ Drain!
  
  Increasing $V_(d s)$ further simply widens this tiny depletion gap slightly. The voltage drop across the active channel remains locked at $V_("dsat") = V_(g s) - V_t$. Therefore, *current completely saturates*!
]

Substituting $V_(d s) = V_(g s) - V_t$ into the linear equation gives the constant saturation current:
$ I_(d s, "sat") = bold(frac(beta, 2) (V_(g s) - V_t)^2) quad "where" quad beta = mu_n C_(o x) frac(W, L) $

=== 2.4 Dynamic Operating Trajectory During Inverter Switching
Notice how an actual circuit moves on the $I-V$ plane when an inverter discharges an output load:

#align(center)[
  #image("images/fig3_3_nmos_iv_curves.png", height: 5.6cm)
]

#rule-box[
  *Reading the Trajectory from Right to Left:*\
  - *Point A ($t = 0$):* $V_("out") = V_(d s) = 5" V"$. Transistor is in *Saturation*. It delivers maximum current ($approx 2.24" mA"$), discharging the load capacitor at maximum speed ($d V / d t = -I_("sat") / C$).
  - *Point B ($t = t_1$):* Output drops to $V_("dsat") = 4.3" V"$. Transistor crosses the pinch-off boundary.
  - *Points C $arrow.r$ D ($t > t_1$):* Transistor enters the *Linear Region*. As $V_("out") arrow.r 0$, the driving electric field collapses, current decays, and the discharge slows down to an exponential tail.
]

#pagebreak()

// ==========================================
// PAGE 5: HOUR 3 (HIGHWAY VS MUSICAL CHAIRS)
// ==========================================
= Hour 3: pMOS Physics & AMI 0.6$mu$m Hand Calculation
_Reference: Slides 15 – 17 | Target Time: 60 minutes_

=== 3.1 The Microscopic Mobility Battle ("Highway" vs "Musical Chairs")
In silicon, an nMOS transistor conducts via *electrons*, while a pMOS transistor conducts via *holes*:

#align(center)[
  #image("images/fig3_4_nmos_vs_pmos.png", height: 5.4cm)
]

#physical-box[
  *Why Are Holes 2.5x Slower Than Electrons?*\
  - *Electrons (The Open Highway):* Free electrons travel in the *Conduction Band* (dải dẫn). They glide through empty energy space with light effective mass ($m^*_e approx 0.26 m_0$) and experience low lattice collisions. Mobility is high: $mu_n approx 350 " cm"^2 / ("V" dot "s")$.
  - *Holes (The Game of Musical Chairs):* Holes do not physically exist as free particles. A hole is an *empty covalent bond* in the *Valence Band* (dải hóa trị). For a hole to move, a bound electron must break its bond and hop into the empty chair. This constant lattice scattering creates high resistance: $mu_p approx 120 " cm"^2 / ("V" dot "s")$.
]

#rule-box[
  *The Inverter Sizing Golden Rule ($W_p / W_n = 2$):*\
  Because holes travel roughly half as fast as electrons ($mu_n / mu_p approx 2-3$), a pMOS transistor must be designed with *twice the channel width* ($W_p approx 2 W_n$) to deliver equal drive current. This ensures equal pull-up and pull-down propagation delays ($t_(p L H) approx t_(p H L)$).
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

#v(4pt)
=== Comparison: pMOS Equivalent for AMI 0.6$mu$m
For a pMOS in the same process ($mu_p = 120 " cm"^2/("V" dot "s")$, $V_(t p) = -0.7" V"$, $W/L = 2$):
$ beta_p = mu_p C_(o x) frac(W, L) = 120 times (3.45 times 10^(-7)) times 2 approx bold(0.083 " mA/V"^2) $
At $V_(g s) = -5" V"$:
$ I_(d s, "sat") = -frac(beta_p, 2)(abs(V_(g s)) - abs(V_(t p)))^2 = -frac(0.083, 2) times (4.3)^2 approx bold(-0.77 " mA") $
Notice that $I_(d s, n) / abs(I_(d s, p)) = 2.24 / 0.77 approx bold(2.9 times)$, mathematically proving why pMOS must be sized wider!

#pagebreak()

// ==========================================
// PAGE 7: HOUR 4 (THE DISCHARGE ODYSSEY)
// ==========================================
= Hour 4: Transistor Parasitic Capacitance & Circuit Speed
_Reference: Slides 18 – 20 | Target Time: 60 minutes_

=== 4.1 The Capacitor Discharge Odyssey (Cuộc hành trình xả tụ ở cấp độ nguyên tử)
What actually happens when an inverter output node switches from $1 arrow.r 0$?

#align(center)[
  #image("images/fig3_5_transistor_capacitances.png", height: 5.4cm)
]

#physical-box[
  *The 4 Acts of Node Discharge:*\
  1. *Act 1 (The Stored Charge):* The load capacitor $C_L$ (sum of gate, diffusion, and wire capacitances) stores positive charge on node $Y$ ($Q = C_L V_(d d)$).
  2. *Act 2 (Gate Inversion):* Input $V_("in")$ steps from $0 arrow.r V_(d d)$. In picoseconds, a conductive electron channel bridges Source and Drain.
  3. *Act 3 (The Electron Surge from Ground):* Ground is an infinite reservoir of electrons. The positive potential at node $Y$ creates an electric field that *drags electrons from Ground, up through the nMOS channel, onto the capacitor plate* to neutralize the charge.
  4. *Act 4 (Lattice Collisions & Speed Limit):* Why doesn't it discharge in 0 seconds? As electrons sprint through silicon, they collide with vibrating silicon atoms (phonons). These collisions create *Channel Resistance ($R_("on")$)*, governing the delay: $Delta t = (C_L Delta V) / I_("avg")$.
]

=== 4.2 Gate vs. Parasitic Diffusion Capacitance
- *Gate Capacitance ($C_g = C_(o x) W L$):* Functional and desirable. It forms the channel and presents $approx 1.5 - 2.0 " fF/"mu"m"$ load to the driver.
- *Diffusion Capacitance ($C_(s b), C_(d b)$):* Purely parasitic. Caused by reverse-biased PN junction diodes between $n^+$ diffusions and the p-body. *Layout tip:* Share diffusion contacts to cut this parasitic capacitance by $50%$.

#pagebreak()

// ==========================================
// PAGE 8: HOUR 4 (CHEAT SHEET & SELF-TEST QUIZ)
// ==========================================
=== 4.3 Summary Cheat Sheet (Bảng tóm tắt toàn chương)

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

#v(4pt)
=== 4.4 10-Minute Self-Assessment Quiz (Bài kiểm tra nhanh)

1. *Q1:* An nMOS transistor has $V_(g s) = 3.0" V"$, $V_t = 0.6" V"$, and $V_(d s) = 1.5" V"$. Which operating region is it in?\
   *Answer:* $V_("dsat") = V_(g s) - V_t = 3.0 - 0.6 = 2.4" V"$. Since $V_(d s) = 1.5" V" < 2.4" V"$, the channel is continuous and the transistor is in the *Linear Region*.

2. *Q2:* Why does drain current remain constant in the saturation region even if $V_(d s)$ increases?\
   *Answer:* The channel pinches off at the drain side. The voltage across the active inversion channel is clamped at $V_("dsat") = V_(g s) - V_t$. Extra voltage drops across the pinch-off depletion gap, acting as a slingshot without increasing channel field.

3. *Q3:* Why is pMOS designed twice as wide as nMOS ($W_p approx 2 W_n$) in standard CMOS cells?\
   *Answer:* Hole mobility in silicon is $2-3 times$ lower than electron mobility ($mu_n / mu_p approx 2-3$) due to bond-hopping collisions in the valence band. A $2times$ wider pMOS matches nMOS drive current for symmetric delays ($t_(p L H) approx t_(p H L)$).

4. *Q4:* During capacitor discharge, why does discharge speed slow down near the end?\
   *Answer:* In the beginning (Saturation), current is constant at $I_("sat")$ ($V_("out")$ drops linearly). Once $V_("out") < V_(g s) - V_t$, the transistor enters the Linear region. Here, current is proportional to the remaining voltage, decaying exponentially toward zero.
