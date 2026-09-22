"""
generate_ch3_figures.py
Generates 5 highly visual, dynamic-mechanism diagrams for Chapter 3: CMOS Transistor Theory:
1. fig3_1_mos_capacitor_modes.png: Chronological particle movements and electric field vectors in MOS capacitor.
2. fig3_2_nmos_conduction_modes.png: Battle between vertical (gate) & lateral (drain) electric fields, and slingshot pinch-off.
3. fig3_3_nmos_iv_curves.png: Shockley I-V curves with the DYNAMIC OPERATING TRAJECTORY of capacitor discharge.
4. fig3_4_nmos_vs_pmos.png: Microscopic carrier physics ("Highway" vs "Musical Chairs") and polarity comparison.
5. fig3_5_transistor_capacitances.png: Physical electron loop during inverter node discharge & synchronized waveforms.
"""

import os
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np

plt.rcParams['font.sans-serif'] = 'Arial'
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['axes.edgecolor'] = '#333333'
plt.rcParams['axes.linewidth'] = 1.0

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), '..', 'book', 'images')
os.makedirs(OUTPUT_DIR, exist_ok=True)

# -------------------------------------------------------------
# Figure 1: MOS Capacitor Operating Modes (Dynamic Particle Story)
# -------------------------------------------------------------
def generate_fig1():
    fig, axes = plt.subplots(1, 3, figsize=(15, 5.8), dpi=300)
    titles = [
        "(a) Accumulation (Tích lũy) | $V_g < 0$\nLỗ trống bị hút ngược lên bề mặt",
        "(b) Depletion (Vùng nghèo) | $0 < V_g < V_t$\nLỗ trống bị xua đuổi, lộ ion âm cố định",
        "(c) Inversion (Đảo - Kênh dẫn) | $V_g > V_t$\nĐiện trường mạnh kéo electron tạo kênh"
    ]

    for i, ax in enumerate(axes):
        ax.set_xlim(0, 10)
        ax.set_ylim(0, 8.5)
        ax.axis('off')
        ax.set_title(titles[i], fontsize=11.5, fontweight='bold', pad=12, color='#0f172a')

        # Gate electrode (Polysilicon)
        poly = patches.Rectangle((1.2, 6.2), 7.6, 1.2, facecolor='#c7d2fe', edgecolor='#3730a3', linewidth=1.5)
        ax.add_patch(poly)
        ax.text(5.0, 6.8, "Gate Electrode (Polysilicon)", ha='center', va='center', fontsize=10, fontweight='bold', color='#1e1b4b')

        # Gate oxide (SiO2)
        oxide = patches.Rectangle((1.2, 5.4), 7.6, 0.8, facecolor='#fef08a', edgecolor='#ca8a04', linewidth=1.5)
        ax.add_patch(oxide)
        ax.text(5.0, 5.8, "Gate Oxide ($SiO_2$) - Insulator ($t_{ox}$)", ha='center', va='center', fontsize=9.5, color='#713f12')

        # P-type substrate
        p_sub = patches.Rectangle((1.2, 0.6), 7.6, 4.8, facecolor='#ffedd5', edgecolor='#c2410c', linewidth=1.5)
        ax.add_patch(p_sub)
        ax.text(5.0, 1.0, "p-type Substrate: Majority carriers = Holes ($h^+$)", ha='center', fontsize=9, color='#9a3412')

        if i == 0:  # Accumulation
            # Negative voltage on gate
            ax.text(5.0, 7.8, "Gate Voltage: $V_g < 0\\text{ V}$ (Điện thế âm)", ha='center', fontsize=10.5, color='#b91c1c', fontweight='bold')
            # Gate negative charges
            for x in np.linspace(2.0, 8.0, 7):
                ax.plot(x, 6.4, marker='$–$', markersize=12, color='#b91c1c')

            # Upward Electric Field vectors
            for x in [3.0, 5.0, 7.0]:
                ax.annotate("", xy=(x, 5.3), xytext=(x, 3.8),
                            arrowprops=dict(arrowstyle="->", color="#dc2626", lw=1.8))
            ax.text(8.3, 4.5, "Điện trường $\\vec{\\mathcal{E}}$\nhướng lên", color='#dc2626', fontsize=8.5, fontweight='bold')

            # Upward force on holes
            for x in np.linspace(2.2, 7.8, 7):
                ax.plot(x, 5.0, marker='$+$', markersize=11, color='#15803d', markeredgewidth=2)
                # Motion arrow pushing hole up
                ax.annotate("", xy=(x, 4.8), xytext=(x, 3.8),
                            arrowprops=dict(arrowstyle="->", color="#16a34a", lw=1.2, linestyle=':'))
            ax.text(5.0, 3.2, "Lực hút Coulomb kéo lỗ trống ($h^+$)\ntụ về bề mặt giáp oxit (Accumulation)", ha='center', fontsize=9, color='#14532d', fontweight='bold')

        elif i == 1:  # Depletion
            ax.text(5.0, 7.8, "Small Positive: $0 < V_g < V_t$", ha='center', fontsize=10.5, color='#ca8a04', fontweight='bold')
            # Gate positive charges
            for x in np.linspace(2.0, 8.0, 7):
                ax.plot(x, 6.4, marker='$+$', markersize=11, color='#15803d')

            # Downward Electric Field vectors
            for x in [3.0, 5.0, 7.0]:
                ax.annotate("", xy=(x, 3.8), xytext=(x, 5.3),
                            arrowprops=dict(arrowstyle="->", color="#ca8a04", lw=1.8))

            # Depletion zone (shaded gray)
            dep = patches.Rectangle((1.2, 3.2), 7.6, 2.2, facecolor='#e2e8f0', edgecolor='#64748b', linestyle='--', linewidth=1.2)
            ax.add_patch(dep)

            # Immobile negative acceptor ions (Boron ions)
            for x in np.linspace(2.4, 7.6, 6):
                for y in [4.7, 3.9]:
                    ax.plot(x, y, marker='$–$', markersize=10, color='#64748b')

            # Motion arrow: holes pushed downward
            for x in [3.0, 5.0, 7.0]:
                ax.annotate("Lỗ trống bị đẩy tụt sâu xuống đế", xy=(x, 1.8), xytext=(x, 3.0),
                            arrowprops=dict(arrowstyle="->", color="#c2410c", lw=1.5),
                            fontsize=8, ha='center', color='#9a3412')
            ax.text(5.0, 2.5, "Vùng nghèo ($W_{dep}$): Các ion $B^-$ bị 'đóng băng'\ntrong mạng tinh thể, không còn hạt tự do", ha='center', fontsize=8.5, color='#334155', fontweight='bold')

        elif i == 2:  # Inversion
            ax.text(5.0, 7.8, "Strong Inversion: $V_g > V_t$ (Đủ mạnh đảo lớp mặt)", ha='center', fontsize=10.5, color='#15803d', fontweight='bold')
            # Dense positive charges on gate
            for x in np.linspace(1.8, 8.2, 9):
                ax.plot(x, 6.4, marker='$+$', markersize=11, color='#15803d')

            # Intense downward field
            for x in [3.0, 5.0, 7.0]:
                ax.annotate("", xy=(x, 4.2), xytext=(x, 5.3),
                            arrowprops=dict(arrowstyle="->", color="#15803d", lw=2.2))

            # Inversion layer of electrons (vivid blue)
            inv = patches.Rectangle((1.2, 4.8), 7.6, 0.6, facecolor='#93c5fd', edgecolor='#1d4ed8', linewidth=1.5)
            ax.add_patch(inv)
            for x in np.linspace(1.8, 8.2, 9):
                ax.plot(x, 5.1, marker='$–$', markersize=11, color='#1e3a8a')

            # Electron recruitment arrows from bulk to surface
            ax.annotate("Electrons ($e^-$) bị hút mạnh\nlên sát mặt oxit tạo kênh", xy=(3.5, 5.0), xytext=(2.0, 3.0),
                        arrowprops=dict(arrowstyle="->", color="#1d4ed8", lw=1.6),
                        fontsize=8.5, color='#1e40af', fontweight='bold')

            # Depletion zone below
            dep = patches.Rectangle((1.2, 2.4), 7.6, 2.4, facecolor='#e2e8f0', edgecolor='#64748b', linestyle='--', linewidth=1.2)
            ax.add_patch(dep)
            for x in np.linspace(2.2, 7.8, 6):
                for y in [3.8, 3.0]:
                    ax.plot(x, y, marker='$–$', markersize=9, color='#64748b')
            ax.text(5.0, 1.8, "Kênh dẫn điện electron (Inversion Sheet)\nBề mặt bị 'đảo' tính chất từ p sang n!", ha='center', fontsize=9, color='#1e3a8a', fontweight='bold')

    plt.tight_layout()
    output_path = os.path.join(OUTPUT_DIR, 'fig3_1_mos_capacitor_modes.png')
    plt.savefig(output_path, dpi=300)
    plt.close()
    print(f"Generated Fig 1: {output_path}")

# -------------------------------------------------------------
# Figure 2: nMOS Operating Modes & Slingshot Pinch-off
# -------------------------------------------------------------
def generate_fig2():
    fig, axes = plt.subplots(3, 1, figsize=(12, 11.5), dpi=300)
    titles = [
        "1. Cutoff ($V_{gs} < V_t$): Kênh chưa mở | Không có electron tại bề mặt | $I_{ds} \\approx 0$",
        "2. Linear ($V_{gs} > V_t, V_{ds} < V_{gs} - V_t$): Kênh liên tục | Dòng electron chạy đều từ S sang D",
        "3. Saturation & Pinch-off ($V_{gs} > V_t, V_{ds} \\geq V_{gs} - V_t$): Thắt kênh | Cơ chế 'Súng cao su' quét electron"
    ]

    for i, ax in enumerate(axes):
        ax.set_xlim(0, 14)
        ax.set_ylim(0, 6.2)
        ax.axis('off')
        ax.set_title(titles[i], fontsize=11.5, fontweight='bold', pad=8, color='#0f172a', loc='left')

        # Substrate
        p_sub = patches.Rectangle((1, 0.5), 12, 3.7, facecolor='#ffedd5', edgecolor='#c2410c', linewidth=1.5)
        ax.add_patch(p_sub)
        ax.text(7, 0.9, "p-type Substrate (Body b nối đất $V_b = 0\\text{ V}$)", ha='center', fontsize=9.5, color='#9a3412')

        # Source
        src = patches.Rectangle((1.5, 2.4), 2.2, 1.8, facecolor='#bbf7d0', edgecolor='#16a34a', linewidth=1.5)
        ax.add_patch(src)
        ax.text(2.6, 3.3, "Source (n+)\nKho chứa $e^-$", ha='center', va='center', fontsize=9.5, fontweight='bold', color='#14532d')

        # Drain
        drn = patches.Rectangle((10.3, 2.4), 2.2, 1.8, facecolor='#bbf7d0', edgecolor='#16a34a', linewidth=1.5)
        ax.add_patch(drn)
        ax.text(11.4, 3.3, "Drain (n+)\nNơi đón $e^-$", ha='center', va='center', fontsize=9.5, fontweight='bold', color='#14532d')

        # Oxide
        ox = patches.Rectangle((3.7, 4.2), 6.6, 0.4, facecolor='#fef08a', edgecolor='#ca8a04', linewidth=1.5)
        ax.add_patch(ox)

        # Gate
        gate = patches.Rectangle((3.7, 4.6), 6.6, 0.8, facecolor='#c7d2fe', edgecolor='#3730a3', linewidth=1.5)
        ax.add_patch(gate)
        ax.text(7, 5.0, "Polysilicon Gate (Cực Cổng g)", ha='center', va='center', fontsize=10, fontweight='bold', color='#1e1b4b')

        if i == 0:  # Cutoff
            ax.text(7, 3.2, "Barrier chặn: Không có kênh dẫn electron nối S và D\n$I_{ds} = 0\\text{ A}$ (Công tắc mở hoàn toàn)", ha='center', va='center', fontsize=11, color='#dc2626', fontweight='bold')
            ax.annotate("Hàng rào thế năng ngăn electron", xy=(3.8, 3.3), xytext=(5.5, 2.0),
                        arrowprops=dict(arrowstyle="->", color="#dc2626", lw=1.5), fontsize=9, color='#dc2626')

        elif i == 1:  # Linear
            # Channel wedge
            pts = [[3.7, 4.2], [10.3, 4.2], [10.3, 3.6], [3.7, 3.3]]
            ch = patches.Polygon(pts, closed=True, facecolor='#93c5fd', edgecolor='#2563eb', linewidth=1.2)
            ax.add_patch(ch)

            # Two competing fields
            ax.annotate("Điện trường dọc $\\mathcal{E}_\\perp$ lớn\n($V_{gs} - V_s = V_{gs}$)", xy=(4.5, 3.9), xytext=(4.0, 2.0),
                        arrowprops=dict(arrowstyle="->", color="#2563eb", lw=1.4), fontsize=8.5, color='#1d4ed8')
            ax.annotate("Điện trường dọc $\\mathcal{E}_\\perp$ nhỏ hơn\n($V_{gd} = V_{gs} - V_{ds}$)", xy=(9.5, 3.9), xytext=(8.8, 2.0),
                        arrowprops=dict(arrowstyle="->", color="#2563eb", lw=1.4), fontsize=8.5, color='#1d4ed8')

            # Electron stream
            for xp in [5.2, 6.7, 8.2]:
                ax.plot(xp, 3.9, marker='o', markersize=6, color='#1e3a8a')
                ax.annotate("", xy=(xp + 0.6, 3.9), xytext=(xp, 3.9),
                            arrowprops=dict(arrowstyle="->", color="#1e3a8a", lw=2))
            ax.text(7.0, 4.0, "Dòng electron $e^-$ trôi về phía Drain $\\longrightarrow$", ha='center', fontsize=9, fontweight='bold', color='#1e3a8a')
            ax.text(7.0, 2.8, "Điện trường ngang $\\mathcal{E}_\\parallel = V_{ds}/L$ gia tốc electron\nKênh dẫn hoạt động như điện trở điều khiển bởi điện áp $V_{gs}$", ha='center', fontsize=9, color='#334155')

        elif i == 2:  # Saturation & Pinch-off
            # Pinched channel
            pts = [[3.7, 4.2], [8.6, 4.2], [3.7, 3.2]]
            ch = patches.Polygon(pts, closed=True, facecolor='#93c5fd', edgecolor='#2563eb', linewidth=1.2)
            ax.add_patch(ch)

            # Depletion gap near drain
            gap = patches.Rectangle((8.6, 3.0), 1.7, 1.2, facecolor='#fee2e2', edgecolor='#ef4444', linestyle='--', linewidth=1.5)
            ax.add_patch(gap)
            ax.text(9.45, 3.6, "Điểm thắt\nkênh\n($V_{gd} \\leq V_t$)", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#b91c1c')

            # Slingshot arrow
            ax.annotate("", xy=(10.4, 3.6), xytext=(8.5, 3.6),
                        arrowprops=dict(arrowstyle="->", color="#dc2626", lw=3.0))
            ax.text(7.5, 2.2, "Cơ chế 'Súng cao su' (Slingshot):\nElectron tới điểm thắt bị điện trường cực mạnh quét bắn vọt qua vùng nghèo vào Drain!\n$I_{ds}$ đạt bão hòa, không phụ thuộc vào $V_{ds}$ nữa.",
                    fontsize=9.5, fontweight='bold', color='#b91c1c', ha='center', bbox=dict(boxstyle='round,pad=0.4', facecolor='#fef2f2', edgecolor='#f87171'))

    plt.tight_layout()
    output_path = os.path.join(OUTPUT_DIR, 'fig3_2_nmos_conduction_modes.png')
    plt.savefig(output_path, dpi=300)
    plt.close()
    print(f"Generated Fig 2: {output_path}")

# -------------------------------------------------------------
# Figure 3: Dynamic Operating Trajectory on I-V Curves
# -------------------------------------------------------------
def generate_fig3():
    beta = 0.2416  # mA / V^2
    Vt = 0.7       # V
    vds = np.linspace(0, 5, 500)
    vgs_list = [1.0, 2.0, 3.0, 4.0, 5.0]

    plt.figure(figsize=(10, 6.2), dpi=300)

    for vgs in vgs_list:
        ids = []
        vdsat = max(0, vgs - Vt)
        for vd in vds:
            if vgs < Vt:
                i = 0.0
            elif vd < vdsat:
                i = beta * ((vgs - Vt) * vd - 0.5 * (vd ** 2))
            else:
                i = 0.5 * beta * ((vgs - Vt) ** 2)
            ids.append(i)
        
        alpha_val = 0.4 if vgs != 5.0 else 0.95
        lw = 1.5 if vgs != 5.0 else 2.5
        plt.plot(vds, ids, label=f'$V_{{gs}} = {int(vgs)}\\text{{ V}}$' + (' (Đường xả tụ)' if vgs == 5 else ''),
                 linewidth=lw, alpha=alpha_val)

    # Pinch-off boundary parabola
    vd_parabola = np.linspace(0, 5.0 - Vt, 200)
    id_parabola = 0.5 * beta * (vd_parabola ** 2)
    plt.plot(vd_parabola, id_parabola, 'k--', linewidth=1.8, label='Ranh giới thắt kênh: $V_{ds} = V_{gs} - V_t$')

    # ---------------------------------------------------------
    # DYNAMIC TRAJECTORY: Discharge of node Y from Vdd to 0
    # ---------------------------------------------------------
    # Trajectory points on Vgs = 5V curve:
    # Pt A: Vds = 5.0, Ids = 2.24 mA (t = 0+)
    # Pt B: Vds = 4.3, Ids = 2.24 mA (t = t1, boundary)
    # Pt C: Vds = 2.0, Ids = 1.83 mA (t = t2, deep linear)
    # Pt D: Vds = 0.2, Ids = 0.21 mA (t = t3, near completion)

    pts = [(5.0, 2.24), (4.3, 2.24), (2.0, 1.83), (0.4, 0.40)]
    
    # Draw trajectory line with big arrows moving RIGHT TO LEFT
    plt.annotate("", xy=(4.35, 2.24), xytext=(4.95, 2.24),
                 arrowprops=dict(arrowstyle="->", color="#dc2626", lw=3.0))
    plt.annotate("", xy=(2.2, 1.95), xytext=(4.2, 2.24),
                 arrowprops=dict(arrowstyle="->", color="#dc2626", lw=3.0))
    plt.annotate("", xy=(0.5, 0.45), xytext=(1.9, 1.75),
                 arrowprops=dict(arrowstyle="->", color="#dc2626", lw=3.0))

    # Point Markers
    plt.plot(5.0, 2.24, 'ro', markersize=9)
    plt.text(4.85, 2.32, 'Điểm A ($t=0$)\n$V_{out} = 5\\text{V}$\nBão hòa, dòng max\nXả cực nhanh!',
             fontsize=9, fontweight='bold', color='#b91c1c', ha='right')

    plt.plot(4.3, 2.24, 'mo', markersize=8)
    plt.text(4.2, 2.0, 'Điểm B ($t_1$)\nChạm ranh giới thắt kênh\n$V_{ds} = V_{gs} - V_t = 4.3\\text{V}$',
             fontsize=8.5, fontweight='bold', color='#7c3aed', ha='right')

    plt.plot(2.0, 1.83, 'bo', markersize=8)
    plt.text(2.1, 1.45, 'Điểm C ($t_2$)\nVào vùng tuyến tính\nĐiện trường yếu dần\nDòng xả sụt giảm!',
             fontsize=8.5, fontweight='bold', color='#1d4ed8')

    plt.plot(0.2, 0.21, 'go', markersize=8)
    plt.text(0.35, 0.15, 'Điểm D ($t_3 \\to \\infty$)\n$V_{out} \\to 0\\text{V}$\nDòng xả đuôi muộn',
             fontsize=8.5, fontweight='bold', color='#15803d')

    plt.title('Quỹ đạo điểm làm việc khi tụ ngõ ra xả điện: $V_{out} = 5\\text{V} \\longrightarrow 0\\text{V}$\n(Operating Point Trajectory during Inverter Discharge)',
              fontsize=11.5, pad=12, fontweight='bold', color='#0f172a')
    plt.xlabel('Drain Voltage $V_{ds} = V_{out}$ (V)', fontsize=11, fontweight='bold')
    plt.ylabel('Drain Current $I_{ds}$ (mA)', fontsize=11, fontweight='bold')
    plt.grid(True, linestyle=':', alpha=0.6)
    plt.xlim(0, 5.3)
    plt.ylim(0, 2.6)
    plt.legend(loc='lower right', frameon=True, facecolor='white', framealpha=0.9, fontsize=9)

    output_path = os.path.join(OUTPUT_DIR, 'fig3_3_nmos_iv_curves.png')
    plt.tight_layout()
    plt.savefig(output_path, dpi=300)
    plt.close()
    print(f"Generated Fig 3: {output_path}")

# -------------------------------------------------------------
# Figure 4: Microscopic Mobility ("Highway" vs "Musical Chairs")
# -------------------------------------------------------------
def generate_fig4():
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5.6), dpi=300)

    # Subplot 1: Microscopic carrier motion mechanism
    ax1.set_xlim(0, 10)
    ax1.set_ylim(0, 8.5)
    ax1.axis('off')
    ax1.set_title("Vật lý hạt: Tại sao Lỗ trống chậm hơn Electron $2.5\\times$?\n(Conduction Band Highway vs Valence Band Hopping)",
                  fontsize=10.5, fontweight='bold', color='#0f172a')

    # Top: Conduction band for electrons
    box_ec = patches.Rectangle((0.5, 4.6), 9.0, 3.2, facecolor='#eff6ff', edgecolor='#2563eb', linewidth=1.5)
    ax1.add_patch(box_ec)
    ax1.text(0.8, 7.4, "nMOS: Dải dẫn (Conduction Band) = 'ĐƯỜNG CAO TỐC'", fontsize=9.5, fontweight='bold', color='#1e40af')
    ax1.text(0.8, 6.9, "• Electron tự do bay lượn, khối lượng hiệu dụng $m^*_e$ nhẹ, ít va chạm\n• Độ linh động cao: $\\mu_n \\approx 350\\text{ cm}^2/\\text{V}\\cdot\\text{s}$",
             fontsize=8.5, color='#1e3a8a')

    # Free electron gliding smoothly
    for x in [2.5, 4.5, 6.5]:
        ax1.plot(x, 5.3, 'bo', markersize=8)
        ax1.annotate("", xy=(x + 1.2, 5.3), xytext=(x, 5.3),
                     arrowprops=dict(arrowstyle="->", color="#1d4ed8", lw=2.2))
    ax1.text(5.0, 4.8, "Electron lướt êm ái với vận tốc cao", ha='center', fontsize=8.5, fontweight='bold', color='#1e40af')

    # Bottom: Valence band for holes
    box_ev = patches.Rectangle((0.5, 0.6), 9.0, 3.4, facecolor='#fef2f2', edgecolor='#dc2626', linewidth=1.5)
    ax1.add_patch(box_ev)
    ax1.text(0.8, 3.6, "pMOS: Dải hóa trị (Valence Band) = 'TRÒ CHƠI GHẾ ÂM NHẠC'", fontsize=9.5, fontweight='bold', color='#991b1b')
    ax1.text(0.8, 3.1, "• Lỗ trống không tự bay! Nó di chuyển bằng cách đợi electron hóa trị nhảy chỗ\n• Va chạm mạng tinh thể liên tục $\\rightarrow$ Độ linh động kém: $\\mu_p \\approx 120\\text{ cm}^2/\\text{V}\\cdot\\text{s}$",
             fontsize=8.5, color='#7f1d1d')

    # Step-by-step hopping
    for x in [2.5, 4.5, 6.5]:
        ax1.plot(x, 1.7, 'ro', markersize=8)
        ax1.annotate("", xy=(x + 0.8, 1.7), xytext=(x, 1.7),
                     arrowprops=dict(arrowstyle="->", color="#dc2626", lw=1.8, linestyle='--'))
    ax1.text(5.0, 1.0, "Lỗ trống phải 'nhảy từng bước' qua các liên kết bị đứt gãy", ha='center', fontsize=8.5, fontweight='bold', color='#991b1b')

    # Subplot 2: Inverter Sizing Consequence
    ax2.set_xlim(0, 10)
    ax2.set_ylim(0, 8.5)
    ax2.axis('off')
    ax2.set_title("Hệ quả thiết kế: Quy tắc vàng kích thước $W_p = 2 W_n$\n(Compensating Mobility with Silicon Area)",
                  fontsize=10.5, fontweight='bold', color='#0f172a')

    # nMOS cell box
    nmos_box = patches.Rectangle((1.0, 4.8), 3.5, 2.8, facecolor='#dcfce7', edgecolor='#16a34a', linewidth=1.5)
    ax2.add_patch(nmos_box)
    ax2.text(2.75, 6.7, "nMOS Pulldown", ha='center', fontsize=9.5, fontweight='bold', color='#14532d')
    ax2.text(2.75, 5.8, "Chiều rộng: $W_n = 1\\mu\\text{m}$\n$\\mu_n \\approx 350$\n$I_{sat} \\approx 1.12\\text{ mA}$",
             ha='center', fontsize=8.5, color='#14532d')

    # pMOS cell box (Double width!)
    pmos_box = patches.Rectangle((5.5, 4.8), 4.0, 2.8, facecolor='#fee2e2', edgecolor='#dc2626', linewidth=1.5)
    ax2.add_patch(pmos_box)
    ax2.text(7.5, 6.7, "pMOS Pullup (Gấp đôi bề rộng!)", ha='center', fontsize=9.5, fontweight='bold', color='#991b1b')
    ax2.text(7.5, 5.8, "Chiều rộng: $W_p = 2\\mu\\text{m}$\n$\\mu_p \\approx 120$\n$I_{sat} \\approx 1.15\\text{ mA}$",
             ha='center', fontsize=8.5, color='#991b1b')

    # Equal current arrow
    ax2.annotate("Cân bằng dòng xả và nạp:\n$I_{pullup} \\approx I_{pulldown}$",
                 xy=(5.0, 4.2), xytext=(5.0, 2.6),
                 arrowprops=dict(arrowstyle="<->", color="#0f172a", lw=2.0),
                 ha='center', fontsize=9.5, fontweight='bold', color='#0f172a')

    ax2.text(5.0, 1.4, "Kết quả: Thời gian kéo lên ($t_{pLH}$) bằng thời gian kéo xuống ($t_{pHL}$)\nGiúp cổng logic chuyển mạch đối xứng và đạt tốc độ tối ưu!",
             ha='center', fontsize=9, color='#334155', bbox=dict(boxstyle='round,pad=0.5', facecolor='#f8fafc', edgecolor='#cbd5e1'))

    plt.tight_layout()
    output_path = os.path.join(OUTPUT_DIR, 'fig3_4_nmos_vs_pmos.png')
    plt.savefig(output_path, dpi=300)
    plt.close()
    print(f"Generated Fig 4: {output_path}")

# -------------------------------------------------------------
# Figure 5: Complete Physical Anatomy of Inverter Node Discharge
# -------------------------------------------------------------
def generate_fig5():
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5.8), dpi=300)

    # Subplot 1: The physical electron loop during discharge
    ax1.set_xlim(0, 10)
    ax1.set_ylim(0, 8.5)
    ax1.axis('off')
    ax1.set_title("Vòng lặp Electron thực tế khi tụ xả\n(Physical Electron Flow during Pulldown)",
                  fontsize=10.5, fontweight='bold', color='#0f172a')

    # Inverter Output Node Y
    node_y = patches.Circle((6.5, 5.2), 0.35, facecolor='#fef08a', edgecolor='#ca8a04', lw=2)
    ax1.add_patch(node_y)
    ax1.text(6.5, 5.2, "Y", ha='center', va='center', fontsize=10, fontweight='bold')
    ax1.text(6.5, 5.8, "Ngõ ra $V_{out}(t)$\n(Ban đầu tích $V_{dd} = 5\\text{V}$)", ha='center', fontsize=8.5, fontweight='bold', color='#854d0e')

    # Load capacitor CL
    ax1.plot([6.5, 6.5], [4.85, 3.8], 'k-', lw=2)
    ax1.plot([5.8, 7.2], [3.8, 3.8], 'k-', lw=3) # top plate
    ax1.plot([5.8, 7.2], [3.4, 3.4], 'k-', lw=3) # bottom plate
    ax1.plot([6.5, 6.5], [3.4, 2.5], 'k-', lw=2)
    ax1.plot([6.1, 6.9], [2.5, 2.5], 'k-', lw=2) # GND
    ax1.plot([6.25, 6.75], [2.35, 2.35], 'k-', lw=1.5)
    ax1.plot([6.4, 6.6], [2.2, 2.2], 'k-', lw=1)
    ax1.text(7.6, 3.6, "Tụ tải $C_L$\n($C_{gate} + C_{diff} + C_{wire}$)", fontsize=8.5, fontweight='bold', color='#1e3a8a')

    # nMOS transistor
    ax1.plot([6.5, 4.0], [5.2, 5.2], 'k-', lw=2)
    nmos_rect = patches.Rectangle((2.8, 4.2), 1.2, 2.0, facecolor='#dcfce7', edgecolor='#16a34a', lw=2)
    ax1.add_patch(nmos_rect)
    ax1.text(3.4, 5.2, "nMOS", ha='center', va='center', fontsize=9.5, fontweight='bold', color='#14532d')

    # Ground connection for nMOS source
    ax1.plot([3.4, 3.4], [4.2, 2.5], 'k-', lw=2)
    ax1.plot([3.0, 3.8], [2.5, 2.5], 'k-', lw=2)
    ax1.plot([3.15, 3.65], [2.35, 2.35], 'k-', lw=1.5)
    ax1.text(3.4, 1.8, "Source GND ($0\\text{V}$)", ha='center', fontsize=8.5, color='#334155')

    # Gate input rising edge
    ax1.plot([1.2, 2.8], [5.2, 5.2], 'k-', lw=2)
    ax1.text(1.0, 5.2, "Input A:\n$0 \\rightarrow V_{dd}$", ha='right', va='center', fontsize=8.5, fontweight='bold', color='#b91c1c')

    # Electron motion arrows (Rushing from GND into capacitor top plate)
    ax1.annotate("", xy=(3.4, 4.6), xytext=(3.4, 2.8),
                 arrowprops=dict(arrowstyle="->", color="#2563eb", lw=3))
    ax1.annotate("", xy=(5.8, 5.2), xytext=(4.2, 5.2),
                 arrowprops=dict(arrowstyle="->", color="#2563eb", lw=3))
    ax1.annotate("", xy=(6.5, 4.0), xytext=(6.5, 4.9),
                 arrowprops=dict(arrowstyle="->", color="#2563eb", lw=3))
    ax1.text(4.8, 6.6, "1. Cổng mở: Electron từ GND tràn qua kênh nMOS\n2. Electron trung hòa điện tích dương trên bản cực tụ\n3. Điện áp $V_{out}$ tụt từ $5\\text{V} \\rightarrow 0\\text{V}$",
             fontsize=8.5, color='#1e3a8a', fontweight='bold', bbox=dict(boxstyle='round,pad=0.4', facecolor='#eff6ff', edgecolor='#bfdbfe'))

    # Subplot 2: Synchronized Waveforms
    t = np.linspace(0, 100, 300) # ps
    # Vin: step at t = 10ps
    vin = np.where(t < 10, 0.0, 5.0)

    # Vout: discharges after 10ps. First saturation (linear drop), then linear (exponential drop)
    vout = np.ones_like(t) * 5.0
    for idx, time in enumerate(t):
        if time >= 10:
            dt = time - 10
            # Phase 1: Saturation (constant current discharge) until Vout = Vdsat = 4.3V
            # I_sat ~ 2.24 mA, say CL = 30 fF -> dV/dt = 2.24mA / 30fF = 74.6 V/ns = 0.075 V/ps
            # Time to drop 0.7V: 0.7 / 0.075 ~ 9.3 ps
            if dt < 10:
                vout[idx] = 5.0 - 0.07 * dt
            else:
                # Phase 2: Linear decay
                v_trans = 5.0 - 0.07 * 10 # 4.3V
                vout[idx] = v_trans * np.exp(-(dt - 10) / 25.0)

    ax2.plot(t, vin, 'r--', label='Ngõ vào $V_{in}(t)$ (Bật lên $5\\text{V}$ lúc $t=10\\text{ps}$)', lw=1.8)
    ax2.plot(t, vout, 'b-', label='Ngõ ra $V_{out}(t)$ (Điện áp trên tụ $C_L$ xả)', lw=2.5)
    ax2.axhline(4.3, color='purple', linestyle=':', label='Ranh giới bão hòa: $V_{dsat} = 4.3\\text{V}$')
    ax2.axhline(2.5, color='gray', linestyle='--', alpha=0.7, label='Ngưỡng chuyển mạch 50% ($V_{dd}/2$)')

    # Shaded saturation vs linear
    ax2.axvspan(10, 20, color='#fee2e2', alpha=0.4, label='Giai đoạn 1: Bão hòa (Xả dốc thẳng, $I_{max}$)')
    ax2.axvspan(20, 100, color='#eff6ff', alpha=0.4, label='Giai đoạn 2: Tuyến tính (Xả đuôi mũ chậm)')

    ax2.set_xlabel('Thời gian $t$ (ps)', fontsize=10.5, fontweight='bold')
    ax2.set_ylabel('Điện áp (V)', fontsize=10.5, fontweight='bold')
    ax2.set_title("Dạng sóng thời gian thực khi tụ $C_L$ xả\n(Saturation Linear Drop $\\rightarrow$ Linear Exponential Tail)",
                  fontsize=10.5, fontweight='bold', color='#0f172a')
    ax2.grid(True, linestyle=':', alpha=0.6)
    ax2.legend(loc='upper right', fontsize=8)
    ax2.set_ylim(-0.5, 5.8)

    plt.tight_layout()
    output_path = os.path.join(OUTPUT_DIR, 'fig3_5_transistor_capacitances.png')
    plt.savefig(output_path, dpi=300)
    plt.close()
    print(f"Generated Fig 5: {output_path}")

if __name__ == '__main__':
    generate_fig1()
    generate_fig2()
    generate_fig3()
    generate_fig4()
    generate_fig5()
    print("All 5 dynamic storytelling figures generated successfully!")
