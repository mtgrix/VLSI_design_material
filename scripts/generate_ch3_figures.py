"""
Script to generate high-resolution visual diagrams and plots for Chapter 3: CMOS Transistor Theory.
Generates 5 figures:
1. fig3_1_mos_capacitor_modes.png - Physical cross section of MOS capacitor (Accumulation, Depletion, Inversion)
2. fig3_2_nmos_conduction_modes.png - nMOS transistor cross section (Cutoff, Linear, Saturation & Pinch-off)
3. fig3_3_nmos_iv_curves.png - Exact AMI 0.6um process I-V curves with Linear vs Saturation boundary
4. fig3_4_nmos_vs_pmos.png - Comparison of nMOS and pMOS I-V characteristics and mobility
5. fig3_5_transistor_capacitances.png - Gate & Diffusion parasitic capacitances breakdown & switching delay
"""

import os
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np

# Set styling
plt.rcParams['font.sans-serif'] = 'Arial'
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['axes.edgecolor'] = '#333333'
plt.rcParams['axes.linewidth'] = 1.0

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), '..', 'book', 'images')
os.makedirs(OUTPUT_DIR, exist_ok=True)

# -------------------------------------------------------------
# Figure 1: MOS Capacitor Operating Modes
# -------------------------------------------------------------
def generate_fig1():
    fig, axes = plt.subplots(1, 3, figsize=(15, 5), dpi=300)
    titles = [
        "(a) Accumulation (Tích lũy)\n$V_g < 0$",
        "(b) Depletion (Vùng nghèo)\n$0 < V_g < V_t$",
        "(c) Inversion (Vùng đảo - Kênh dẫn)\n$V_g > V_t$"
    ]

    for i, ax in enumerate(axes):
        ax.set_xlim(0, 10)
        ax.set_ylim(0, 8)
        ax.axis('off')
        ax.set_title(titles[i], fontsize=13, fontweight='bold', pad=15, color='#1a365d')

        # Gate electrode (Polysilicon)
        poly = patches.Rectangle((1.5, 6.0), 7.0, 1.2, facecolor='#c7d2fe', edgecolor='#3730a3', linewidth=1.5)
        ax.add_patch(poly)
        ax.text(5.0, 6.6, "Gate (Polysilicon)", ha='center', va='center', fontsize=11, fontweight='bold', color='#1e1b4b')

        # Gate oxide (SiO2)
        oxide = patches.Rectangle((1.5, 5.2), 7.0, 0.8, facecolor='#fef08a', edgecolor='#ca8a04', linewidth=1.5)
        ax.add_patch(oxide)
        ax.text(5.0, 5.6, "Gate Oxide ($SiO_2$) - Insulator ($t_{ox}$)", ha='center', va='center', fontsize=10, color='#713f12')

        # P-type substrate
        p_sub = patches.Rectangle((1.5, 0.8), 7.0, 4.4, facecolor='#ffedd5', edgecolor='#c2410c', linewidth=1.5)
        ax.add_patch(p_sub)
        ax.text(5.0, 1.3, "p-type Silicon Substrate (Đế bán dẫn loại p)", ha='center', va='center', fontsize=10, color='#9a3412')

        if i == 0:  # Accumulation
            # Negative voltage on gate attracts holes (+) to surface
            ax.text(5.0, 7.5, "Negative Gate Bias: $V_g < 0$", ha='center', fontsize=11, color='red', fontweight='bold')
            # Gate negative charges
            for x in np.linspace(2.2, 7.8, 7):
                ax.plot(x, 6.15, marker='$–$', markersize=10, color='#b91c1c')
            # Oxide/substrate interface accumulated holes (+)
            for x in np.linspace(2.2, 7.8, 7):
                ax.plot(x, 4.9, marker='$+$', markersize=11, color='#15803d', markeredgewidth=2)
            ax.text(5.0, 4.2, "Holes accumulate at surface\n(Lỗ trống tích tụ tại bề mặt)", ha='center', va='center', fontsize=9.5, color='#14532d')

        elif i == 1:  # Depletion
            # Small positive voltage repels holes, exposes fixed negative acceptor ions
            ax.text(5.0, 7.5, "Small Positive Bias: $0 < V_g < V_t$", ha='center', fontsize=11, color='#ca8a04', fontweight='bold')
            # Gate positive charges
            for x in np.linspace(2.2, 7.8, 7):
                ax.plot(x, 6.15, marker='$+$', markersize=10, color='#15803d')
            # Depletion zone (shaded gray)
            dep = patches.Rectangle((1.5, 3.4), 7.0, 1.8, facecolor='#e2e8f0', edgecolor='#64748b', linestyle='--', linewidth=1.2)
            ax.add_patch(dep)
            # Negative acceptor ions in depletion layer
            for x in np.linspace(2.5, 7.5, 6):
                for y in [4.6, 3.9]:
                    ax.plot(x, y, marker='$–$', markersize=10, color='#b91c1c')
            ax.text(5.0, 2.7, "Depletion region: Fixed acceptor ions ($N_A^-$)\n(Vùng nghèo: hạt tải tự do bị đẩy đi hết)", ha='center', va='center', fontsize=9.5, color='#334155')

        elif i == 2:  # Inversion
            # Gate voltage exceeds Vt: pulls free electrons to surface forming an n-channel
            ax.text(5.0, 7.5, "Strong Inversion: $V_g > V_t$", ha='center', fontsize=11, color='#15803d', fontweight='bold')
            # Gate positive charges
            for x in np.linspace(2.2, 7.8, 8):
                ax.plot(x, 6.15, marker='$+$', markersize=11, color='#15803d')
            # Inversion layer of electrons (thin blue layer)
            inv = patches.Rectangle((1.5, 4.7), 7.0, 0.5, facecolor='#93c5fd', edgecolor='#1d4ed8', linewidth=1.2)
            ax.add_patch(inv)
            for x in np.linspace(2.2, 7.8, 8):
                ax.plot(x, 4.95, marker='$–$', markersize=10, color='#1e3a8a')
            ax.text(5.0, 4.35, "Inversion Layer (Kênh dẫn electron)", ha='center', va='center', fontsize=9.5, fontweight='bold', color='#1d4ed8')

            # Depletion zone below inversion layer
            dep = patches.Rectangle((1.5, 2.5), 7.0, 2.2, facecolor='#e2e8f0', edgecolor='#64748b', linestyle='--', linewidth=1.2)
            ax.add_patch(dep)
            for x in np.linspace(2.5, 7.5, 6):
                for y in [3.8, 3.1]:
                    ax.plot(x, y, marker='$–$', markersize=9, color='#b91c1c')
            ax.text(5.0, 2.0, "Depletion region reached maximum width ($W_{dep,max}$)", ha='center', va='center', fontsize=9, color='#475569')

    plt.tight_layout()
    output_path = os.path.join(OUTPUT_DIR, 'fig3_1_mos_capacitor_modes.png')
    plt.savefig(output_path, dpi=300)
    plt.close()
    print(f"Generated: {output_path}")

# -------------------------------------------------------------
# Figure 2: nMOS Transistor Conduction Modes & Pinch-Off
# -------------------------------------------------------------
def generate_fig2():
    fig, axes = plt.subplots(3, 1, figsize=(12, 11), dpi=300)
    titles = [
        "1. Cutoff Region ($V_{gs} < V_t$): Không có kênh dẫn, $I_{ds} \\approx 0$",
        "2. Linear Region ($V_{gs} > V_t$, $V_{ds} < V_{gs} - V_t$): Kênh dẫn liên tục, $I_{ds} \\propto V_{ds}$",
        "3. Saturation & Pinch-off ($V_{gs} > V_t$, $V_{ds} \\geq V_{gs} - V_t$): Thắt kênh tại cực máng, $I_{ds} = I_{ds,sat}$"
    ]

    for i, ax in enumerate(axes):
        ax.set_xlim(0, 14)
        ax.set_ylim(0, 6)
        ax.axis('off')
        ax.set_title(titles[i], fontsize=12, fontweight='bold', pad=10, color='#0f172a', loc='left')

        # P-substrate
        p_sub = patches.Rectangle((1, 0.5), 12, 3.5, facecolor='#ffedd5', edgecolor='#c2410c', linewidth=1.5)
        ax.add_patch(p_sub)
        ax.text(7, 1.0, "p-type Substrate (Body b)", ha='center', fontsize=10, color='#9a3412')

        # Source n+ diffusion
        src = patches.Rectangle((1.5, 2.2), 2.2, 1.8, facecolor='#bbf7d0', edgecolor='#16a34a', linewidth=1.5)
        ax.add_patch(src)
        ax.text(2.6, 3.1, "Source\n(n+)", ha='center', va='center', fontsize=10, fontweight='bold', color='#14532d')

        # Drain n+ diffusion
        drn = patches.Rectangle((10.3, 2.2), 2.2, 1.8, facecolor='#bbf7d0', edgecolor='#16a34a', linewidth=1.5)
        ax.add_patch(drn)
        ax.text(11.4, 3.1, "Drain\n(n+)", ha='center', va='center', fontsize=10, fontweight='bold', color='#14532d')

        # Oxide
        ox = patches.Rectangle((3.7, 4.0), 6.6, 0.4, facecolor='#fef08a', edgecolor='#ca8a04', linewidth=1.5)
        ax.add_patch(ox)
        ax.text(7, 4.2, "$SiO_2$ Gate Oxide", ha='center', va='center', fontsize=9, color='#713f12')

        # Gate
        gate = patches.Rectangle((3.7, 4.4), 6.6, 0.8, facecolor='#c7d2fe', edgecolor='#3730a3', linewidth=1.5)
        ax.add_patch(gate)
        ax.text(7, 4.8, "Polysilicon Gate (Cực Cổng g)", ha='center', va='center', fontsize=10, fontweight='bold', color='#1e1b4b')

        if i == 0:  # Cutoff
            ax.text(7, 3.0, "No Inversion Channel (Không có kênh dẫn)\n$I_{ds} = 0$", ha='center', va='center', fontsize=11, color='#dc2626', fontweight='bold')
            ax.text(2.6, 4.5, "$V_s = 0\\text{ V}$", ha='center', fontsize=10, color='#334155')
            ax.text(11.4, 4.5, "$V_d > 0\\text{ V}$", ha='center', fontsize=10, color='#334155')

        elif i == 1:  # Linear
            # Inversion channel: thicker near source, slightly thinner near drain
            pts = [[3.7, 4.0], [10.3, 4.0], [10.3, 3.4], [3.7, 3.2]]
            ch = patches.Polygon(pts, closed=True, facecolor='#93c5fd', edgecolor='#2563eb', linewidth=1.2)
            ax.add_patch(ch)
            ax.text(7, 3.6, "Continuous Inversion Channel (Kênh dẫn liên tục)", ha='center', va='center', fontsize=10, fontweight='bold', color='#1e3a8a')

            # Arrow indicating electron flow from Source to Drain
            ax.annotate("", xy=(9.5, 3.6), xytext=(4.5, 3.6),
                        arrowprops=dict(arrowstyle="->", color="#1d4ed8", lw=2))
            ax.text(7, 2.7, "Electrons flow: Source $\\rightarrow$ Drain\nCurrent flows: Drain $\\rightarrow$ Source ($I_{ds}$)", ha='center', fontsize=9.5, color='#1e40af')

        elif i == 2:  # Saturation & Pinch-off
            # Channel pinches off at drain side
            pts = [[3.7, 4.0], [8.8, 4.0], [3.7, 3.1]]
            ch = patches.Polygon(pts, closed=True, facecolor='#93c5fd', edgecolor='#2563eb', linewidth=1.2)
            ax.add_patch(ch)

            # Pinch-off depletion gap
            gap = patches.Rectangle((8.8, 3.0), 1.5, 1.0, facecolor='#fee2e2', edgecolor='#ef4444', linestyle=':', linewidth=1.5)
            ax.add_patch(gap)
            ax.text(9.55, 3.5, "Pinch-off\nPoint\n($V_{gd} < V_t$)", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#b91c1c')

            # High field sweep arrow
            ax.annotate("High E-field\nsweeps electrons", xy=(10.5, 3.5), xytext=(7.5, 2.4),
                        arrowprops=dict(arrowstyle="->", color="#b91c1c", lw=1.5),
                        fontsize=9, color='#b91c1c', fontweight='bold')
            ax.text(5.5, 3.6, "Inversion Channel", ha='center', va='center', fontsize=9, fontweight='bold', color='#1e3a8a')

    plt.tight_layout()
    output_path = os.path.join(OUTPUT_DIR, 'fig3_2_nmos_conduction_modes.png')
    plt.savefig(output_path, dpi=300)
    plt.close()
    print(f"Generated: {output_path}")

# -------------------------------------------------------------
# Figure 3: Exact AMI 0.6um I-V Characteristics
# -------------------------------------------------------------
def generate_fig3():
    # Parameters from Slide 15:
    # tox = 100 A = 100e-8 cm = 10e-9 m
    # mu_n = 350 cm^2 / V*s = 0.035 m^2 / V*s
    # eps_ox = 3.9 * 8.85e-14 F/cm = 3.4515e-13 F/cm
    # Cox = eps_ox / tox = 3.4515e-7 F/cm^2
    # mu * Cox = 350 * 3.4515e-7 = 1.208e-4 A/V^2 = 120.8 uA/V^2
    # W/L = 4/2 = 2
    # beta = mu * Cox * (W/L) = 241.6 uA/V^2 = 0.2416 mA/V^2
    # Vt = 0.7 V

    beta = 0.2416  # mA / V^2
    Vt = 0.7       # V
    vds = np.linspace(0, 5, 500)
    vgs_list = [1.0, 2.0, 3.0, 4.0, 5.0]

    plt.figure(figsize=(9, 6), dpi=300)

    # Plot saturation locus (Vdsat = Vgs - Vt, Idsat = beta/2 * (Vgs - Vt)^2)
    vdsat_pts = []
    idsat_pts = []

    for vgs in vgs_list:
        ids = []
        vdsat = max(0, vgs - Vt)
        for vd in vds:
            if vgs < Vt:
                i = 0.0
            elif vd < vdsat:
                # Linear region
                i = beta * ((vgs - Vt) * vd - 0.5 * (vd ** 2))
            else:
                # Saturation region
                i = 0.5 * beta * ((vgs - Vt) ** 2)
            ids.append(i)
        
        plt.plot(vds, ids, label=f'$V_{{gs}} = {int(vgs)}\\text{{ V}}$', linewidth=2.2)
        if vdsat > 0 and vdsat <= 5.0:
            vdsat_pts.append(vdsat)
            idsat_pts.append(0.5 * beta * (vdsat ** 2))

    # Plot saturation boundary parabola: Idsat = 0.5 * beta * Vds^2
    vd_parabola = np.linspace(0, 5.0 - Vt, 200)
    id_parabola = 0.5 * beta * (vd_parabola ** 2)
    plt.plot(vd_parabola, id_parabola, 'k--', linewidth=1.8, label='Pinch-off Boundary: $V_{ds} = V_{gs} - V_t$')

    # Shaded regions
    plt.fill_between(vd_parabola, id_parabola, 2.5, color='#dbeafe', alpha=0.3)
    plt.text(1.2, 1.8, 'Vùng tuyến tính\n(Linear Region)\n$V_{ds} < V_{gs} - V_t$', fontsize=11, fontweight='bold', color='#1d4ed8', ha='center')
    plt.text(3.6, 1.0, 'Vùng bão hòa\n(Saturation Region)\n$V_{ds} \\geq V_{gs} - V_t$', fontsize=11, fontweight='bold', color='#b91c1c', ha='center')

    plt.xlabel('Drain-to-Source Voltage $V_{ds}$ (V)', fontsize=12, fontweight='bold')
    plt.ylabel('Drain Current $I_{ds}$ (mA)', fontsize=12, fontweight='bold')
    plt.title('AMI 0.6 $\\mu$m nMOS $I_{ds}-V_{ds}$ Characteristics (Shockley 1st Order Model)\n$t_{ox} = 100\\text{ Å}, \\mu_n = 350\\text{ cm}^2/\\text{V}\\cdot\\text{s}, V_t = 0.7\\text{ V}, W/L = 4/2\\lambda$',
              fontsize=11, pad=12, fontweight='bold', color='#0f172a')
    plt.grid(True, linestyle=':', alpha=0.6)
    plt.xlim(0, 5.0)
    plt.ylim(0, 2.5)
    plt.legend(loc='upper left', frameon=True, facecolor='white', framealpha=0.9, fontsize=9.5)

    output_path = os.path.join(OUTPUT_DIR, 'fig3_3_nmos_iv_curves.png')
    plt.tight_layout()
    plt.savefig(output_path, dpi=300)
    plt.close()
    print(f"Generated: {output_path}")

# -------------------------------------------------------------
# Figure 4: nMOS vs pMOS Comparison (Polarity & Mobility)
# -------------------------------------------------------------
def generate_fig4():
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(13, 5), dpi=300)

    # Left: nMOS
    beta_n = 0.24  # mA/V^2
    Vt_n = 0.7
    vds_n = np.linspace(0, 5, 200)
    for vgs in [2.0, 3.5, 5.0]:
        ids = [beta_n * ((vgs - Vt_n)*v - 0.5*v**2) if v < (vgs - Vt_n) else 0.5*beta_n*(vgs - Vt_n)**2 for v in vds_n]
        ax1.plot(vds_n, ids, label=f'$V_{{gs}} = {vgs}\\text{{ V}}$', linewidth=2)
    ax1.set_title('nMOS: Carriers = Electrons ($e^-$)\nHigh Mobility: $\\mu_n = 350\\text{ cm}^2/\\text{V}\\cdot\\text{s}$', fontsize=11, fontweight='bold', color='#1e3a8a')
    ax1.set_xlabel('$V_{ds}$ (V)', fontsize=11, fontweight='bold')
    ax1.set_ylabel('$I_{ds}$ (mA)', fontsize=11, fontweight='bold')
    ax1.grid(True, linestyle=':', alpha=0.6)
    ax1.legend(loc='upper left')
    ax1.set_ylim(0, 2.5)

    # Right: pMOS (Inverted polarities)
    # mu_p = 120 cm^2/V*s -> beta_p = beta_n * (120/350) ~ 0.082 mA/V^2
    beta_p = 0.082
    Vt_p = -0.7
    vds_p = np.linspace(0, -5, 200)
    for vgs in [-2.0, -3.5, -5.0]:
        vdsat = vgs - Vt_p
        ids = [-(beta_p * ((abs(vgs) - abs(Vt_p))*abs(v) - 0.5*v**2)) if abs(v) < abs(vdsat) else -0.5*beta_p*(abs(vgs) - abs(Vt_p))**2 for v in vds_p]
        ax2.plot(vds_p, ids, label=f'$V_{{gs}} = {vgs}\\text{{ V}}$', linewidth=2)
    ax2.set_title('pMOS: Carriers = Holes ($h^+$)\nLower Mobility: $\\mu_p = 120\\text{ cm}^2/\\text{V}\\cdot\\text{s}$ ($\\sim 2.5\\times$ lower)', fontsize=11, fontweight='bold', color='#991b1b')
    ax2.set_xlabel('$V_{ds}$ (V)', fontsize=11, fontweight='bold')
    ax2.set_ylabel('$I_{ds}$ (mA)', fontsize=11, fontweight='bold')
    ax2.grid(True, linestyle=':', alpha=0.6)
    ax2.legend(loc='lower left')
    ax2.set_ylim(-2.5, 0)

    plt.suptitle("nMOS vs pMOS Comparison: Polarity Inversion and Hole Mobility Penalty\n(Để có cùng dòng điện, pMOS phải có bề rộng $W_p \\approx 2-3 \\times W_n$)",
                 fontsize=12, fontweight='bold', y=1.02)
    plt.tight_layout()
    output_path = os.path.join(OUTPUT_DIR, 'fig3_4_nmos_vs_pmos.png')
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close()
    print(f"Generated: {output_path}")

# -------------------------------------------------------------
# Figure 5: Transistor Parasitic Capacitances & Speed Impact
# -------------------------------------------------------------
def generate_fig5():
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5.5), dpi=300)

    # Subplot 1: Transistor schematic with parasitic capacitors
    ax1.set_xlim(0, 10)
    ax1.set_ylim(0, 8)
    ax1.axis('off')
    ax1.set_title("Physical Breakdown of Transistor Capacitances\n(Phân bố điện dung trên MOSFET)", fontsize=11, fontweight='bold', pad=10)

    # Transistor symbol box
    tx = patches.Rectangle((3.5, 3.0), 3.0, 2.5, facecolor='#f8fafc', edgecolor='#334155', linewidth=2)
    ax1.add_patch(tx)
    ax1.text(5.0, 4.25, "nMOS\nTransistor", ha='center', va='center', fontsize=11, fontweight='bold')

    # Gate connection
    ax1.plot([1.5, 3.5], [4.25, 4.25], 'k-', lw=2)
    ax1.text(1.2, 4.25, "Gate (g)", ha='right', va='center', fontweight='bold')

    # Drain connection
    ax1.plot([5.0, 5.0], [5.5, 7.0], 'k-', lw=2)
    ax1.text(5.0, 7.3, "Drain (d)", ha='center', va='bottom', fontweight='bold')

    # Source connection
    ax1.plot([5.0, 5.0], [3.0, 1.5], 'k-', lw=2)
    ax1.text(5.0, 1.2, "Source (s)", ha='center', va='top', fontweight='bold')

    # Body connection
    ax1.plot([6.5, 8.5], [4.25, 4.25], 'k-', lw=2)
    ax1.text(8.7, 4.25, "Body (b)", ha='left', va='center', fontweight='bold')

    # Parasitic caps drawn as dotted lines with labels
    # Cgs
    ax1.annotate("$C_{gs} \\approx \\frac{1}{2} C_{ox}WL$", xy=(3.6, 3.3), xytext=(2.0, 2.5),
                 arrowprops=dict(arrowstyle="->", color="#2563eb", lw=1.5), fontsize=9.5, fontweight='bold', color='#1d4ed8')
    # Cgd
    ax1.annotate("$C_{gd}$ (Miller cap)", xy=(3.6, 5.2), xytext=(1.8, 6.0),
                 arrowprops=dict(arrowstyle="->", color="#2563eb", lw=1.5), fontsize=9.5, fontweight='bold', color='#1d4ed8')
    # Cdb (diffusion)
    ax1.annotate("Diffusion Cap $C_{db}$\n(Reverse-biased PN diode)", xy=(6.0, 6.0), xytext=(6.5, 6.8),
                 arrowprops=dict(arrowstyle="->", color="#dc2626", lw=1.5), fontsize=9, fontweight='bold', color='#b91c1c')
    # Csb (diffusion)
    ax1.annotate("Diffusion Cap $C_{sb}$", xy=(6.0, 2.5), xytext=(6.5, 1.8),
                 arrowprops=dict(arrowstyle="->", color="#dc2626", lw=1.5), fontsize=9, fontweight='bold', color='#b91c1c')

    # Subplot 2: Transient switching delay Delta_t = (C / I) * Delta_V
    t = np.linspace(0, 100, 200) # ps
    # Two capacitors: C_small and C_large
    v_fast = 5.0 * (1 - np.exp(-t / 15.0))
    v_slow = 5.0 * (1 - np.exp(-t / 35.0))

    ax2.plot(t, v_fast, label='Low Capacitance ($C_{load}$ nhỏ) $\\rightarrow$ Fast Transition', color='#16a34a', lw=2.2)
    ax2.plot(t, v_slow, label='High Capacitance ($C_{load}$ lớn) $\\rightarrow$ Slow Transition', color='#dc2626', lw=2.2)
    ax2.axhline(2.5, color='gray', linestyle='--', alpha=0.7, label='50% $V_{dd}$ Switching Threshold')

    # Delay markers
    t_fast_50 = 15.0 * np.log(2)
    t_slow_50 = 35.0 * np.log(2)
    ax2.plot([t_fast_50, t_fast_50], [0, 2.5], 'g:')
    ax2.plot([t_slow_50, t_slow_50], [0, 2.5], 'r:')
    ax2.annotate(f"$t_{{fast}} \\approx {t_fast_50:.1f}\\text{{ ps}}$", xy=(t_fast_50, 1.0), xytext=(t_fast_50 + 3, 0.8),
                 color='#15803d', fontweight='bold', fontsize=9.5)
    ax2.annotate(f"$t_{{slow}} \\approx {t_slow_50:.1f}\\text{{ ps}}$", xy=(t_slow_50, 1.0), xytext=(t_slow_50 + 3, 0.4),
                 color='#b91c1c', fontweight='bold', fontsize=9.5)

    ax2.set_xlabel('Time $t$ (ps)', fontsize=11, fontweight='bold')
    ax2.set_ylabel('Node Voltage $V(t)$ (V)', fontsize=11, fontweight='bold')
    ax2.set_title("The Fundamental Speed Equation: $\\Delta t = \\frac{C}{I} \\Delta V$\n(Điện dung càng lớn, thời gian nạp xả càng lâu)", fontsize=11, fontweight='bold', pad=10)
    ax2.grid(True, linestyle=':', alpha=0.6)
    ax2.legend(loc='lower right', fontsize=9.5)

    plt.tight_layout()
    output_path = os.path.join(OUTPUT_DIR, 'fig3_5_transistor_capacitances.png')
    plt.savefig(output_path, dpi=300)
    plt.close()
    print(f"Generated: {output_path}")

if __name__ == '__main__':
    generate_fig1()
    generate_fig2()
    generate_fig3()
    generate_fig4()
    generate_fig5()
    print("All 5 Chapter 3 visualization figures generated successfully!")
