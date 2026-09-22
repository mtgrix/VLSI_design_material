# Chapter 3: CMOS Transistor Theory (Lý thuyết Transistor CMOS)
> **Storytelling & Dynamic Mechanism Edition (Phiên bản Kể chuyện & Cơ chế Động)**  
> **Target Audience:** UIT VLSI Design Student  
> **Study Time Allocation:** 4 Hours Total (4 giờ học tập trung)  
> **Lecture Reference:** `source/source_uit_vn/chapter3-transistors.pdf` (Slides 1 – 20) & Weste & Harris Textbook (`cmos_vlsi.pdf`)  
> **Prerequisites Skipped:** Chapters 1 & 2 are not required. Everything is derived from physical and mathematical first principles *(nguyên lý cơ bản)*.

---

## 4-Hour Time-Boxed Roadmap (Lộ trình học tập 4 giờ)

```
[Hour 1: 0:00 - 1:00] ──> The MOS Capacitor & 3 Operating Modes (Vật lý tụ MOS & 3 chế độ)
[Hour 2: 1:00 - 2:00] ──> Mathematical Derivation of I-V Model (Chứng minh toán học dòng điện)
[Hour 3: 2:00 - 3:00] ──> pMOS Physics & AMI 0.6um Hand Calculation (Vật lý pMOS & Tính toán mẫu)
[Hour 4: 3:00 - 4:00] ──> Parasitic Capacitances & Speed Impact (Điện dung ký sinh & Tốc độ mạch)
```

---

## Hour 1: The MOS Capacitor & The 3 Operating Modes
*(Thời gian dự kiến: 60 phút | Tương ứng Slide 1 – 5)*

### 1.1 Beyond the Ideal Switch (Vượt qua tư duy công tắc lý tưởng)
In basic digital logic, a transistor is taught as an ideal switch:
* When Gate = `1`: switch is closed (zero resistance, instant current).
* When Gate = `0`: switch is open (infinite resistance, zero current).

**The Physical Reality in Silicon (Thực tế vật lý trên chip):**
A real transistor is a **charge-controlled reservoir pipe** *(đường ống dẫn điện tích điều khiển bằng điện áp cổng)*:
1. When turned ON, it passes a **finite current** *(dòng điện giới hạn)* because free carriers constantly collide with vibrating silicon atoms and ionized impurities in the lattice.
2. The gate, source, and drain all store electric charge as **parasitic capacitances** *(điện dung ký sinh)*.
3. Every switching transition in a microprocessor is a physical race between charging and discharging these stored charges:
   $$\Delta t = \frac{C}{I} \Delta V$$
   To make a chip faster, we must **maximize current $I$** and **minimize capacitance $C$**!

---

### 1.2 Structure of the MOS Capacitor
A MOSFET is built around a parallel-plate capacitor sandwich:
1. **Gate (Cực Cổng):** Highly conductive Polysilicon *(silicon đa tinh thể)*.
2. **Dielectric (Lớp điện môi cách điện):** Silicon Dioxide ($SiO_2$) with thickness $t_{ox}$ and relative permittivity $\epsilon_{ox} \approx 3.9$.
3. **Body / Substrate (Đế bán dẫn):** p-type silicon doped with Acceptor atoms *(chất nhận $N_A$, ví dụ Boron)*.

The gate oxide capacitance per unit area is:
$$C_{ox} = \frac{\epsilon_{ox}}{t_{ox}} = \frac{3.9 \times 8.85 \times 10^{-14} \text{ F/cm}}{t_{ox}}$$

---

### 1.3 The Chronological Story of the Three Operating Modes
Imagine standing inside the silicon crystal directly below the gate oxide. Here is the step-by-step physical drama as gate voltage rises:

![Figure 3.1: MOS Capacitor Operating Modes](images/fig3_1_mos_capacitor_modes.png)

#### Act 1: Accumulation (Chế độ tích lũy) — $V_g < 0\text{ V}$
* **Electric Field:** Negative voltage on the gate creates an **upward-pointing electric field** ($\uparrow$).
* **Carrier Motion:** Positively charged mobile holes ($h^+$) feel an electrostatic Coulomb pull upward ($\vec{F} = q\vec{\mathcal{E}}$). They swarm to the surface, accumulating directly under the oxide.
* **Transistor State:** Strictly OFF. There are no free electrons to connect Source to Drain.

#### Act 2: Depletion (Chế độ nghèo) — $0 < V_g < V_t$
* **Electric Field:** As gate voltage turns positive, the electric field flips **downward** ($\downarrow$).
* **Carrier Motion:** The positive gate repels mobile positive holes, driving them deep down into the substrate bulk.
* **Lattice Residue:** As holes retreat, they expose immobile negative Boron acceptor ions ($B^-$) locked permanently into the silicon crystal lattice. This creates a charge-free insulating **Depletion Zone** ($W_{dep}$).

#### Act 3: Inversion (Chế độ đảo — Hình thành kênh dẫn) — $V_g > V_t$
* **Electric Field:** When $V_g$ exceeds the critical **Threshold Voltage ($V_t$)**, the downward electric field becomes intense ($> 10^6\text{ V/cm}$).
* **Carrier Motion:** This electric field forcefully pulls minority electrons ($e^-$) from the substrate bulk and Source/Drain junctions to the surface, locking them into a razor-thin 2D sheet ($1\text{--}3\text{ nm}$ thick).
* **The Inversion Miracle:** The surface silicon inverts its nature from p-type to n-type! A conducting bridge of electrons now connects Source to Drain.

> **Physical Meaning of Threshold Voltage $V_t$:**  
> $V_t$ is the precise gate voltage needed to bend the semiconductor energy bands enough so that surface electron concentration equals the bulk hole concentration ($n_{surface} = N_A$). Below $V_t$, no conducting channel exists!

---

## Hour 2: Mathematical Derivation of Shockley $I-V$ Equations
*(Thời gian dự kiến: 60 phút | Tương ứng Slide 6 – 14)*

### 2.1 The Battle of Two Electric Fields
Once the channel forms, electron flow is governed by the tug-of-war between two perpendicular electric fields:
1. **Vertical Field ($\mathcal{E}_\perp$):** Set by Gate-to-Channel voltage. Controls *how many electrons* are pulled into the channel.
2. **Lateral Field ($\mathcal{E}_\parallel$):** Set by Drain-to-Source voltage ($\mathcal{E}_\parallel = V_{ds} / L$). Propels electrons horizontally *from Source to Drain*.

![Figure 3.2: nMOS Operating Modes & Slingshot Pinch-Off](images/fig3_2_nmos_conduction_modes.png)

---

### 2.2 First-Principles Derivation of Current ($I_{ds}$)
Current is electric charge passing through a cross-section per unit time:
$$I_{ds} = \frac{Q_{channel}}{t_{transit}}$$

#### Step 1: Calculate Total Channel Charge ($Q_{channel}$)
* At the Source ($x=0$), channel voltage is $V_s = 0\text{ V}$. Gate-to-channel voltage is $V_{gs}$.
* At the Drain ($x=L$), channel voltage is $V_d = V_{ds}$. Gate-to-channel voltage is $V_{gd} = V_{gs} - V_{ds}$.
Because the channel voltage rises toward the drain, the channel tapers into a wedge! The average channel voltage along length $L$ is:
$$V_{channel, avg} = \frac{V_s + V_d}{2} = \frac{V_{ds}}{2}$$

The effective gate-to-channel inversion voltage is:
$$V_{eff} = \left(V_{gs} - \frac{V_{ds}}{2}\right) - V_t$$

Since gate capacitance is $C_g = C_{ox} W L$, total mobile inversion charge is:
$$Q_{channel} = C_{ox} W L \left[ (V_{gs} - V_t) - \frac{V_{ds}}{2} \right]$$

#### Step 2: Calculate Carrier Transit Time ($t_{transit}$)
The lateral electric field is $\mathcal{E}_\parallel = \frac{V_{ds}}{L}$. Electron drift velocity is:
$$v = \mu_n \mathcal{E}_\parallel = \mu_n \frac{V_{ds}}{L}$$

The transit time to travel distance $L$ is:
$$t_{transit} = \frac{L}{v} = \frac{L^2}{\mu_n V_{ds}}$$

#### Step 3: Combine to Obtain Linear Current
$$I_{ds} = \frac{Q_{channel}}{t_{transit}} = \mu_n C_{ox} \frac{W}{L} \left[ (V_{gs} - V_t) V_{ds} - \frac{V_{ds}^2}{2} \right]$$

Defining $\beta = \mu_n C_{ox} \frac{W}{L}$, we get the **Linear Region Current**:
$$\boxed{I_{ds} = \beta \left[ (V_{gs} - V_t) V_{ds} - \frac{V_{ds}^2}{2} \right]} \quad (V_{ds} < V_{gs} - V_t)$$

---

### 2.3 The Slingshot Mechanism at Pinch-off (Cơ chế bắn vọt khi thắt kênh)
When $V_{ds}$ increases such that $V_{gd} = V_{gs} - V_{ds} \le V_t$, the vertical field near the drain drops below the inversion threshold. The inversion layer disappears at the drain edge. This is **Pinch-off** *(thắt kênh)*.

#### Why Current Does NOT Stop at Pinch-Off:
Electrons traveling from the Source arrive at the pinch-off boundary at high speed. Across the narrow depletion gap between pinch-off and drain, there is an intense electric field. This field acts like a **slingshot (súng cao su)**, violently sweeping electrons across into the $n^+$ Drain!

Further increasing $V_{ds}$ does not increase channel current because the voltage drop across the active conducting channel remains clamped at $V_{dsat} = V_{gs} - V_t$. Extra voltage merely widens the pinch-off depletion gap.

Substituting $V_{ds} = V_{gs} - V_t$ into the linear equation gives the constant **Saturation Current**:
$$\boxed{I_{ds,sat} = \frac{\beta}{2} (V_{gs} - V_t)^2}$$

---

### 2.4 Dynamic Operating Trajectory on the $I-V$ Plane
Look at how a real circuit moves on the $I-V$ curves when an inverter discharges an output node from $V_{dd} \to 0\text{ V}$:

![Figure 3.3: Dynamic Operating Trajectory on I-V Curves](images/fig3_3_nmos_iv_curves.png)

* **Point A ($t = 0$):** $V_{out} = V_{ds} = 5\text{ V}$. The transistor is in deep **Saturation**. Current is at its maximum ($I_{ds,sat} \approx 2.24\text{ mA}$), discharging the load capacitor at top speed ($dV/dt = -I_{sat}/C_L$).
* **Point B ($t = t_1$):** Output drops to $V_{dsat} = 4.3\text{ V}$. The operating point crosses the pinch-off boundary into the **Linear Region**.
* **Points C $\to$ D ($t > t_1$):** In the Linear region, the channel behaves like a resistor. As capacitor voltage empties, the lateral electric field dies, current drops toward zero, and the discharge slows down to an exponential tail!

---

## Hour 3: pMOS Physics & AMI 0.6 $\mu$m Hand Calculation
*(Thời gian dự kiến: 60 phút | Tương ứng Slide 15 – 17)*

### 3.1 The Microscopic Mobility Battle ("Highway" vs "Musical Chairs")
In silicon, an nMOS conducts via **electrons**, while a pMOS conducts via **holes**:

![Figure 3.4: nMOS vs pMOS Microscopic Mobility](images/fig3_4_nmos_vs_pmos.png)

#### Why Are Holes 2.5x Slower Than Electrons?
* **Electrons (The Open Highway):** Free electrons travel in the **Conduction Band** *(dải dẫn)*. They glide through empty energy space with light effective mass ($m^*_e \approx 0.26 m_0$) and experience low lattice collisions. Mobility is high: $\mu_n \approx 350\text{ cm}^2/(\text{V}\cdot\text{s})$.
* **Holes (The Game of Musical Chairs):** Holes are not physical particles. A hole is an **empty covalent bond** in the **Valence Band** *(dải hóa trị)*. For a hole to move, a bound valence electron must break its bond and hop into the empty chair. This constant lattice scattering causes high resistance: $\mu_p \approx 120\text{ cm}^2/(\text{V}\cdot\text{s})$.

> **The Inverter Sizing Golden Rule ($W_p / W_n = 2$):**  
> Because holes travel roughly half as fast as electrons ($\mu_n / \mu_p \approx 2\text{--}3$), a pMOS transistor must be designed with **twice the channel width** ($W_p \approx 2 W_n$) to deliver equal drive current, ensuring symmetric rise and fall delays ($t_{pLH} \approx t_{pHL}$).

---

### 3.2 Worked Hand Calculation: AMI 0.6 $\mu$m Process (Slide 15)
* **Given Parameters:** $t_{ox} = 100\text{ \AA} = 100 \times 10^{-8}\text{ cm}$, $\mu_n = 350\text{ cm}^2/(\text{V}\cdot\text{s})$, $V_t = 0.7\text{ V}$, $W/L = 4\lambda / 2\lambda = 2$.
1. **Oxide Capacitance per Area:**
   $$C_{ox} = \frac{\epsilon_{ox}}{t_{ox}} = \frac{3.9 \times 8.85 \times 10^{-14}}{100 \times 10^{-8}} = \mathbf{3.45 \times 10^{-7}\text{ F/cm}^2}$$
2. **Process Transconductance Parameter ($k'_n$):**
   $$k'_n = \mu_n C_{ox} = 350 \times (3.45 \times 10^{-7}) = \mathbf{120.8\ \mu\text{A/V}^2}$$
3. **Transistor Gain Factor ($\beta$):**
   $$\beta = k'_n \frac{W}{L} = 120.8 \times 2 = \mathbf{241.6\ \mu\text{A/V}^2 = 0.242\text{ mA/V}^2}$$
4. **Saturation Current at $V_{gs} = 5\text{ V}$:**
   $$V_{dsat} = V_{gs} - V_t = 5.0 - 0.7 = 4.3\text{ V}$$
   $$I_{ds,sat} = \frac{\beta}{2} (V_{gs} - V_t)^2 = \frac{0.242}{2} \times (4.3)^2 = \mathbf{2.24\text{ mA}}$$

---

## Hour 4: Transistor Parasitic Capacitance & Circuit Speed
*(Thời gian dự kiến: 60 phút | Tương ứng Slide 18 – 20)*

### 4.1 The Capacitor Discharge Odyssey (Cuộc hành trình xả tụ ở cấp độ nguyên tử)
What actually happens when an inverter output node switches from $1 \to 0$?

![Figure 3.5: Inverter Capacitor Discharge Anatomy](images/fig3_5_transistor_capacitances.png)

#### The 4 Acts of Node Discharge:
1. **Act 1 (The Stored Charge):** The load capacitor $C_L$ stores positive charge on node $Y$ ($Q = C_L V_{dd}$).
2. **Act 2 (Gate Inversion):** Input $V_{in}$ steps from $0 \to V_{dd}$. In picoseconds, a conductive electron channel bridges Source and Drain.
3. **Act 3 (The Electron Surge from Ground):** Ground is an infinite reservoir of electrons. The positive potential at node $Y$ creates an electric field that **drags electrons from Ground, up through the nMOS channel, onto the capacitor plate** to neutralize the stored charge!
4. **Act 4 (Lattice Collisions & Speed Limit):** Why doesn't it discharge in 0 seconds? As electrons sprint through silicon, they collide with vibrating silicon atoms (phonons). These collisions create **Channel Resistance ($R_{on}$)**, governing the delay:
   $$\Delta t = \frac{C_L \Delta V}{I_{avg}}$$

---

### 4.2 Summary Cheat Sheet (Bảng tóm tắt toàn chương)

| Parameter / Symbol | Physical Meaning *(Ý nghĩa vật lý)* | Typical Value / Formula |
| :--- | :--- | :--- |
| **$C_{ox}$** | Gate oxide capacitance per area | $\epsilon_{ox} / t_{ox} \approx 3.45 \times 10^{-7}\text{ F/cm}^2$ |
| **$\beta$** | Transconductance gain factor | $\mu C_{ox} (W/L)$ |
| **Linear Region** | Continuous resistive channel | $V_{gs} \ge V_t$ and $V_{ds} < V_{gs} - V_t$ |
| **Saturation Region** | Channel pinched-off at drain | $V_{gs} \ge V_t$ and $V_{ds} \ge V_{gs} - V_t$ |
| **$I_{ds,sat}$** | Shockley saturation current | $\frac{\beta}{2}(V_{gs} - V_t)^2$ |
| **$\mu_n / \mu_p$** | Mobility ratio (electrons vs holes) | $\approx 2 \text{ to } 3 \implies W_p = 2W_n$ |
| **$\Delta t$** | Gate propagation delay | $(C_L \Delta V) / I_{avg}$ |

---

### 4.3 10-Minute Self-Assessment Quiz (Bài kiểm tra nhanh)

1. **Q1:** An nMOS transistor has $V_{gs} = 3.0\text{ V}$, $V_t = 0.6\text{ V}$, and $V_{ds} = 1.5\text{ V}$. Which operating region is it in?  
   *Answer:* $V_{dsat} = 3.0 - 0.6 = 2.4\text{ V}$. Since $V_{ds} = 1.5\text{ V} < 2.4\text{ V}$, the channel is continuous and the device is in the **Linear Region**.
2. **Q2:** Why does drain current remain constant in the saturation region even if $V_{ds}$ keeps increasing?  
   *Answer:* The channel pinches off at the drain side. The voltage across the active inversion channel is clamped at $V_{dsat} = V_{gs} - V_t$. Extra voltage drops across the pinch-off depletion gap, acting as a slingshot without increasing the channel field.
3. **Q3:** Why is pMOS designed twice as wide as nMOS in standard CMOS cells?  
   *Answer:* Hole mobility is $2\text{--}3\times$ lower than electron mobility ($\mu_n / \mu_p \approx 2\text{--}3$) due to bond-hopping collisions in the valence band. A $2\times$ wider pMOS matches nMOS drive current for symmetric delays ($t_{pLH} \approx t_{pHL}$).
4. **Q4:** During capacitor discharge, why does discharge speed slow down near the end?  
   *Answer:* In the beginning (Saturation), current is constant at $I_{sat}$ ($V_{out}$ drops linearly). Once $V_{out} < V_{gs} - V_t$, the transistor enters the Linear region. Here, current is proportional to the remaining voltage, decaying exponentially toward zero.
