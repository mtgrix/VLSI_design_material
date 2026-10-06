"""
generate_ch4_figures.py
Generates 4 high-resolution, mechanism-grounded educational figures for Chapter 4: Nonideal Transistor Theory:
1. fig4_1_high_field_effects.png:
   - Panel (a): Vertical electric field & surface roughness scattering (Mobility Degradation).
   - Panel (b): Lateral electric field, phonon collisions & velocity saturation ceiling (vsat).
   - Panel (c): Ideal Shockley quadratic vs. 65nm velocity-saturated I-V characteristics & CLM (lambda).
2. fig4_2_threshold_voltage_effects.png:
   - Panel (a): Body effect: reverse body bias (Vsb > 0) widening depletion region and elevating Vt.
   - Panel (b): DIBL: conduction band barrier lowering from drain electrostatic penetration.
   - Panel (c): Short-channel charge sharing (Vt roll-off) vs channel length L & Halo RSCE effect.
3. fig4_3_nanoscale_leakage_mechanisms.png:
   - Panel (a): Silicon cross-section showing 3 primary leakage paths: I_sub, I_gate, and I_junc (BTBT).
   - Panel (b): Subthreshold log(Ids)-Vgs characteristic, subthreshold swing S, and DIBL/Temp shifts.
   - Panel (c): Gate tunneling mechanisms (Direct vs FN) and HKMG thick physical equivalent oxide.
4. fig4_4_pvt_variations_and_corners.png:
   - Panel (a): Process corner map (nMOS vs pMOS speed: TT, FF, SS, FS, SF) with 3-sigma ellipse.
   - Panel (b): Temperature sensitivity & Temperature Inversion (ZTC point).
   - Panel (c): Critical signoff corners matrix (Max Delay / Setup, Min Delay / Hold, Worst-case Leakage).
"""

import os
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np

# Configure matplotlib for crisp rendering and consistent cross-platform fonts
plt.rcParams['font.sans-serif'] = 'Arial'
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['axes.edgecolor'] = '#333333'
plt.rcParams['axes.linewidth'] = 1.0

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), '..', 'book', 'images')
os.makedirs(OUTPUT_DIR, exist_ok=True)


# =============================================================================
# Helper: Standard IEEE MOSFET Symbol
# =============================================================================
def draw_mosfet(ax, x, y, mos_type='n_enh', scale=1.0, label_terminals=False):
    """
    Draws an IEEE standard MOSFET schematic symbol.
    mos_type: 'n_enh', 'p_enh'
    """
    s = scale
    ch_h = 1.6 * s
    gap = 0.28 * s
    lead_len = 0.55 * s

    # 1. Drain & Source leads
    d_top_y = y + ch_h / 2
    s_bot_y = y - ch_h / 2

    ax.plot([x, x], [d_top_y + lead_len, d_top_y], color='#1e293b', lw=1.8 * s)
    ax.plot([x, x], [s_bot_y, s_bot_y - lead_len], color='#1e293b', lw=1.8 * s)

    # 2. Channel bar
    ch_color = '#0284c7' if mos_type.startswith('n') else '#e11d48'
    ax.plot([x, x], [s_bot_y, d_top_y], color=ch_color, lw=3.0 * s, solid_capstyle='butt')

    # 3. Gate plate
    gate_x = x - gap
    ax.plot([gate_x, gate_x], [s_bot_y + 0.1 * s, d_top_y - 0.1 * s], color='#334155', lw=2.2 * s, solid_capstyle='butt')

    # 4. Gate lead & inversion bubble
    if mos_type.startswith('p'):
        bubble_r = 0.14 * s
        bubble = patches.Circle((gate_x - bubble_r, y), bubble_r, facecolor='white', edgecolor='#e11d48', lw=1.6 * s, zorder=4)
        ax.add_patch(bubble)
        ax.plot([gate_x - 2 * bubble_r - lead_len, gate_x - 2 * bubble_r], [y, y], color='#1e293b', lw=1.8 * s)
    else:
        ax.plot([gate_x - lead_len, gate_x], [y, y], color='#1e293b', lw=1.8 * s)

    # 5. Bulk arrow
    arrow_color = '#0284c7' if mos_type.startswith('n') else '#e11d48'
    if mos_type.startswith('n'):
        # Arrow pointing INTO channel
        ax.annotate('', xy=(x, y), xytext=(x - 0.45 * s, y),
                    arrowprops=dict(arrowstyle="-|>", color=arrow_color, lw=1.2 * s, mutation_scale=9 * s))
    else:
        # Arrow pointing OUT OF channel
        ax.annotate('', xy=(x - 0.45 * s, y), xytext=(x, y),
                    arrowprops=dict(arrowstyle="-|>", color=arrow_color, lw=1.2 * s, mutation_scale=9 * s))

    if label_terminals:
        ax.text(x + 0.25 * s, d_top_y + lead_len * 0.7, 'D', fontsize=8 * s, fontweight='bold', color='#1e293b', va='center')
        ax.text(gate_x - lead_len - 0.22 * s, y, 'G', fontsize=8 * s, fontweight='bold', color='#1e293b', ha='right', va='center')
        ax.text(x + 0.25 * s, s_bot_y - lead_len * 0.7, 'S', fontsize=8 * s, fontweight='bold', color='#1e293b', va='center')


# =============================================================================
# FIGURE 1: High-Field Effects (Mobility Degradation, Velocity Saturation & CLM)
# =============================================================================
def generate_fig1():
    fig, axes = plt.subplots(1, 3, figsize=(18, 6.2), dpi=300)
    fig.subplots_adjust(left=0.05, right=0.97, top=0.82, bottom=0.12, wspace=0.24)
    fig.suptitle("Hình 4.1: Các hiệu ứng Điện trường cao & Sự sụp đổ của Mô hình Shockley",
                 fontsize=14, fontweight='bold', color='#0f172a', y=0.97)

    # -------------------------------------------------------------
    # Panel (a): Vertical Field & Mobility Degradation
    # -------------------------------------------------------------
    ax = axes[0]
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 8.5)
    ax.axis('off')
    ax.set_title("(a) Điện trường Dọc & Suy giảm Độ linh động\n(Vertical Field & Surface Scattering)",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)

    # Gate electrode
    ax.add_patch(patches.Rectangle((1.5, 6.4), 7.0, 1.2, facecolor='#c7d2fe', edgecolor='#3730a3', lw=1.5))
    ax.text(5.0, 7.0, "Polysilicon Gate ($V_g \\gg V_t$)", ha='center', va='center', fontsize=9.5, fontweight='bold', color='#1e1b4b')

    # Gate oxide with wavy bottom interface (surface roughness)
    ax.add_patch(patches.Rectangle((1.5, 5.3), 7.0, 1.1, facecolor='#fef08a', edgecolor='#ca8a04', lw=1.5))
    ax.text(5.0, 5.85, "Lớp cách điện Cổng: $SiO_2$ ($t_{ox} \\approx 1.2\\text{ nm}$)",
            ha='center', va='center', fontsize=8.5, color='#713f12', fontweight='bold')

    # Draw jagged interface at bottom of oxide (y = 5.3)
    xs = np.linspace(1.5, 8.5, 36)
    ys = 5.3 + 0.08 * np.sin(xs * 12) + 0.04 * np.cos(xs * 25)
    ax.plot(xs, ys, color='#b45309', lw=2.0)

    # Substrate area
    ax.add_patch(patches.Rectangle((1.5, 0.8), 7.0, 4.5, facecolor='#ffedd5', edgecolor='#ea580c', lw=1.5))
    ax.text(5.0, 1.2, "Đế Silicon loại p (p-substrate)", ha='center', fontsize=9, color='#9a3412', fontweight='bold')

    # Vertical electric field arrows (downward)
    for fx in [2.5, 3.5, 4.5, 5.5, 6.5, 7.5]:
        ax.annotate('', xy=(fx, 4.3), xytext=(fx, 5.2),
                    arrowprops=dict(arrowstyle="->", color='#dc2626', lw=2.0, mutation_scale=12))
    ax.text(7.9, 4.75, "$\\vec{\\mathcal{E}}_{vert} > 10^6\\text{ V/cm}$\n(Cực mạnh)",
            ha='left', va='center', fontsize=8.5, fontweight='bold', color='#dc2626')

    # Electron paths: bouncing violently against jagged interface
    # Electron 1
    e_pts_x = [2.2, 2.7, 3.2, 3.8, 4.4, 5.1, 5.6]
    e_pts_y = [4.2, 5.15, 4.4, 5.20, 4.3, 5.18, 4.5]
    ax.plot(e_pts_x, e_pts_y, color='#0284c7', lw=1.8, linestyle='--', marker='o', markersize=4)
    ax.text(3.9, 3.85, "Electron bị ép va đập liên tục\nvào giao diện $Si-SiO_2$ gồ ghề",
            ha='center', fontsize=8.2, color='#0369a1', fontweight='bold',
            bbox=dict(boxstyle='round,pad=0.2', facecolor='#e0f2fe', edgecolor='#38bdf8', lw=1.0))

    # Formula callout badge
    ax.text(5.0, 2.3, "$\\mu_{eff} = \\frac{\\mu_0}{1 + \\theta(V_{gs} - V_t)}$\n$\\vec{\\mathcal{E}}_{vert} = \\frac{V_{gs} - V_{ds}/2}{t_{ox}}$",
            ha='center', va='center', fontsize=9.2, color='#1e293b', fontweight='bold',
            bbox=dict(boxstyle='round,pad=0.35', facecolor='#ffffff', edgecolor='#cbd5e1', lw=1.5))

    # -------------------------------------------------------------
    # Panel (b): Lateral Field & Velocity Saturation
    # -------------------------------------------------------------
    ax = axes[1]
    ax.set_title("(b) Điện trường Ngang & Bão hòa Vận tốc\n(Carrier Velocity Roll-off & Ceiling)",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)

    E_lat = np.linspace(0, 50, 200)  # kV/cm
    # Carrier velocity models (cm/s)
    # Electrons: mu0 ~ 400 cm2/Vs at high field, vsat = 1e7
    E_c_n = 10.0  # critical field for electrons ~ 10 kV/cm
    v_electron = 1e7 * (E_lat / E_c_n) / (1 + (E_lat / E_c_n)**2)**0.5
    # Holes: mu0 ~ 150 cm2/Vs, vsat = 8e6, Ec_p ~ 30 kV/cm
    E_c_p = 25.0
    v_hole = 8e6 * (E_lat / E_c_p) / (1 + (E_lat / E_c_p))

    ax.plot(E_lat, v_electron / 1e7, color='#0284c7', lw=2.4, label='Electrons: $v_{sat} = 10^7\\text{ cm/s}$')
    ax.plot(E_lat, v_hole / 1e7, color='#e11d48', lw=2.4, label='Holes: $v_{sat} = 0.8 \\times 10^7\\text{ cm/s}$')

    # Ideal linear continuation
    ax.plot([0, 12], [0, 1.2], color='#0284c7', lw=1.2, linestyle=':', label='Kênh dài lý tưởng ($v = \\mu \\mathcal{E}$)')

    # Ceiling line
    ax.axhline(1.0, color='#64748b', lw=1.2, linestyle='--')
    ax.text(32, 1.03, "Trần vận tốc cực đại ($v_{sat}$)", fontsize=8.5, color='#475569', fontweight='bold')

    ax.axvline(E_c_n, color='#0284c7', lw=1.0, linestyle='--')
    ax.text(E_c_n + 1, 0.45, "$\\mathcal{E}_c \\approx 10\\text{ kV/cm}$\n(Bắt đầu bão hòa)", fontsize=8.0, color='#0369a1')

    ax.set_xlabel("Điện trường nằm ngang $\\mathcal{E}_{lat} = V_{ds} / L$ (kV/cm)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_ylabel("Vận tốc trôi $v$ ($10^7\\text{ cm/s}$)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_xlim(0, 50)
    ax.set_ylim(0, 1.3)
    ax.grid(True, linestyle=':', alpha=0.6)
    ax.legend(loc='lower right', fontsize=8.2, framealpha=0.95)

    # Phonon scattering callout
    ax.text(25, 0.25, "[Vật Lý] Tán xạ va chạm liên tục với phonon quang\n(Optical phonon emission) hãm phanh hạt mang điện!",
            ha='center', fontsize=8.0, color='#991b1b', fontweight='bold',
            bbox=dict(boxstyle='square,pad=0.3', facecolor='#fef2f2', edgecolor='#fca5a5', lw=1.0))

    # -------------------------------------------------------------
    # Panel (c): Ideal Shockley vs. 65nm Velocity-Saturated I-V
    # -------------------------------------------------------------
    ax = axes[2]
    ax.set_title("(c) Đặc tuyến I-V: Shockley vs. Tiến trình 65nm\n(Quadratic vs. Linear Scaling & CLM $\\lambda$)",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)

    vds = np.linspace(0, 1.0, 150)

    # 65nm saturated curves (linear with Vgs, tilted with lambda)
    vgs_list = [0.4, 0.6, 0.8, 1.0]
    colors = ['#94a3b8', '#38bdf8', '#0284c7', '#0f172a']

    lam = 0.15  # CLM
    for vgs, col in zip(vgs_list, colors):
        vt = 0.3
        vgt = max(0, vgs - vt)
        vdsat_eff = 0.3 * vgt / (0.3 + vgt) * 2.0  # short-channel lower Vdsat
        ids_sat = 900 * vgt * 1.15  # almost linear with Vgt
        # Smooth transition to saturation
        curve = ids_sat * np.minimum(vds / max(vdsat_eff, 0.05), 1.0) * (1 + lam * vds)
        ax.plot(vds, curve, color=col, lw=2.0, label=f'65nm: $V_{{gs}} = {vgs:.1f}\\text{{V}}$')

    # Ideal Shockley curve at Vgs = 1.0V (quadratic, flat saturation)
    vgt_id = 0.7
    vdsat_id = vgt_id
    ids_id = 1500 * (2 * vgt_id * vds - vds**2) / (vgt_id**2) * 0.5
    ids_id[vds > vdsat_id] = 1500 * 0.5
    ax.plot(vds, ids_id, color='#ef4444', lw=2.0, linestyle='--', label='Shockley lý tưởng ($V_{gs} = 1.0\\text{V}$)')

    ax.set_xlabel("Điện áp Máng - Nguồn $V_{ds}$ (V)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_ylabel("Dòng máng $I_{ds}$ ($\\mu\\text{A}$)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_xlim(0, 1.0)
    ax.set_ylim(0, 1100)
    ax.grid(True, linestyle=':', alpha=0.6)
    ax.legend(loc='upper left', fontsize=7.8, framealpha=0.95)

    # CLM tilt annotation
    ax.annotate('Độ dốc CLM ($\\lambda > 0$)\n$g_{ds} = \\frac{\\partial I_{ds}}{\\partial V_{ds}} > 0$',
                xy=(0.85, 750), xytext=(0.45, 860),
                arrowprops=dict(arrowstyle="->", color='#0f172a', lw=1.4),
                fontsize=8.0, fontweight='bold', color='#0f172a',
                bbox=dict(boxstyle='round,pad=0.2', facecolor='#f1f5f9', edgecolor='#94a3b8'))

    # Linear spacing annotation
    ax.text(0.98, 280, "Khoảng cách giữa các đường cong\nđều đặn (bậc 1 thay vì bậc 2)!",
            ha='right', fontsize=8.0, color='#0369a1', fontweight='bold',
            bbox=dict(boxstyle='square,pad=0.25', facecolor='#e0f2fe', edgecolor='#7dd3fc'))

    out_path = os.path.join(OUTPUT_DIR, 'fig4_1_high_field_effects.png')
    plt.savefig(out_path, dpi=300)
    plt.close()
    print(f"Generated: {out_path}")


# =============================================================================
# FIGURE 2: Threshold Voltage Effects (Body Effect, DIBL & Charge Sharing)
# =============================================================================
def generate_fig2():
    fig, axes = plt.subplots(1, 3, figsize=(18, 6.2), dpi=300)
    fig.subplots_adjust(left=0.05, right=0.97, top=0.82, bottom=0.12, wspace=0.24)
    fig.suptitle("Hình 4.2: Các hiệu ứng Biến thiên Điện áp Ngưỡng $V_t$ (Threshold Voltage Nonidealities)",
                 fontsize=14, fontweight='bold', color='#0f172a', y=0.97)

    # -------------------------------------------------------------
    # Panel (a): Body Effect Mechanism
    # -------------------------------------------------------------
    ax = axes[0]
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 8.5)
    ax.axis('off')
    ax.set_title("(a) Hiệu ứng Phân cực Đế (Body Effect)\n$V_{sb} > 0 \\rightarrow$ Mở rộng Vùng nghèo & Tăng $V_t$",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)

    # Gate, Source, Drain cross section
    # Substrate
    ax.add_patch(patches.Rectangle((1.0, 1.0), 8.0, 4.5, facecolor='#ffedd5', edgecolor='#ea580c', lw=1.5))
    ax.text(5.0, 1.3, "p-Substrate ($V_b = 0\\text{V}$)", ha='center', fontsize=9, color='#9a3412', fontweight='bold')

    # Source n+ (Vsb > 0)
    ax.add_patch(patches.Rectangle((1.5, 3.8), 1.6, 1.7, facecolor='#bae6fd', edgecolor='#0284c7', lw=1.5))
    ax.text(2.3, 4.65, "$n^+$\nSource\n($V_s > 0$)", ha='center', va='center', fontsize=8.0, fontweight='bold', color='#0369a1')

    # Drain n+
    ax.add_patch(patches.Rectangle((6.9, 3.8), 1.6, 1.7, facecolor='#bae6fd', edgecolor='#0284c7', lw=1.5))
    ax.text(7.7, 4.65, "$n^+$\nDrain\n($V_d$)", ha='center', va='center', fontsize=8.0, fontweight='bold', color='#0369a1')

    # Gate & Oxide
    ax.add_patch(patches.Rectangle((3.3, 5.5), 3.4, 0.4, facecolor='#fef08a', edgecolor='#ca8a04', lw=1.2))
    ax.add_patch(patches.Rectangle((3.3, 5.9), 3.4, 0.8, facecolor='#c7d2fe', edgecolor='#3730a3', lw=1.5))
    ax.text(5.0, 6.3, "Gate ($V_g$)", ha='center', va='center', fontsize=9.0, fontweight='bold', color='#1e1b4b')

    # Expanded Depletion Region under gate when Vsb > 0
    dep_patch = patches.Polygon([[3.1, 5.5], [6.9, 5.5], [7.3, 2.3], [2.7, 2.3]],
                                closed=True, facecolor='#f1f5f9', edgecolor='#94a3b8', linestyle='--', lw=1.5)
    ax.add_patch(dep_patch)
    ax.text(5.0, 3.1, "Vùng nghèo phình rộng ($W_{dep} \\uparrow$)\nChứa ion tạp chất âm cố định $B^-$",
            ha='center', va='center', fontsize=8.2, color='#475569', fontweight='bold')

    # Formula Box
    ax.text(5.0, 7.5, "$V_t = V_{t0} + \\gamma (\\sqrt{\\phi_s + V_{sb}} - \\sqrt{\\phi_s})$\n$\\gamma = \\frac{\\sqrt{2q\\epsilon_{si}N_A}}{C_{ox}} \\approx 0.4 - 0.6\\text{ V}^{1/2}$",
            ha='center', va='center', fontsize=8.8, fontweight='bold', color='#0f172a',
            bbox=dict(boxstyle='round,pad=0.3', facecolor='#ffffff', edgecolor='#cbd5e1', lw=1.2))

    # -------------------------------------------------------------
    # Panel (b): DIBL Conduction Band Energy Diagram
    # -------------------------------------------------------------
    ax = axes[1]
    ax.set_title("(b) Hạ thấp Rào thế do Cực Máng (DIBL)\n(Conduction Band Energy along Channel)",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)

    x_ch = np.linspace(0, 1.0, 150)
    # Energy barrier profile: high at low Vds, lowered at high Vds
    # Low Vds curve
    E_low = 0.8 * np.sin(np.pi * x_ch)**0.6 + 0.1
    # High Vds curve (barrier pulled down by drain potential penetration)
    E_high = 0.8 * np.sin(np.pi * x_ch)**0.6 * (1.0 - 0.42 * x_ch) + 0.1 - 0.25 * x_ch

    ax.plot(x_ch, E_low, color='#0284c7', lw=2.5, label='Thấp: $V_{ds} = 0.05\\text{V}$ (Rào thế cao)')
    ax.plot(x_ch, E_high, color='#dc2626', lw=2.5, linestyle='-', label='Cao: $V_{ds} = 1.0\\text{V}$ (Rào thế bị kéo sụt)')

    # Peak points
    ax.plot(0.35, np.max(E_low), 'o', color='#0369a1', markersize=6)
    ax.plot(0.28, np.max(E_high), 'o', color='#b91c1c', markersize=6)

    # Barrier difference arrow
    ax.annotate('', xy=(0.32, np.max(E_high)), xytext=(0.32, np.max(E_low)),
                arrowprops=dict(arrowstyle="<->", color='#b91c1c', lw=1.8))
    ax.text(0.35, (np.max(E_low) + np.max(E_high)) / 2, "$\\Delta V_t = \\eta V_{ds}$\n(Hạ thấp rào cản)",
            fontsize=8.5, fontweight='bold', color='#b91c1c')

    ax.set_xlabel("Vị trí dọc theo kênh dẫn: Source (0) $\\to$ Drain (L)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_ylabel("Năng lượng dải dẫn $E_c$ (eV)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_xlim(0, 1.0)
    ax.set_ylim(-0.25, 1.1)
    ax.grid(True, linestyle=':', alpha=0.6)
    ax.legend(loc='lower left', fontsize=8.2, framealpha=0.95)

    ax.text(0.70, 0.75, "Điện trường cực Máng đâm xuyên\nvào kênh, ăn cắp quyền kiểm soát\ncủa cực Cổng!\n$V_t' = V_{t0} - \\eta V_{ds}$",
            ha='center', fontsize=8.2, fontweight='bold', color='#1e293b',
            bbox=dict(boxstyle='square,pad=0.3', facecolor='#f8fafc', edgecolor='#cbd5e1', lw=1.2))

    # -------------------------------------------------------------
    # Panel (c): Short-Channel Vt Roll-Off & Halo RSCE
    # -------------------------------------------------------------
    ax = axes[2]
    ax.set_title("(c) Biến thiên $V_t$ theo Chiều dài Kênh ($L$)\n($V_t$ Roll-Off & Reverse Short-Channel Effect)",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)

    L = np.linspace(0.04, 0.5, 200)  # um

    # Classic Vt roll-off (charge sharing)
    vt_long = 0.40
    vt_rolloff = vt_long - 0.25 * np.exp(-L / 0.08)

    # With Halo / Pocket implantation (RSCE: bump at medium-short L)
    halo_bump = 0.08 * (L / 0.12) * np.exp(- (L - 0.12)**2 / 0.008)
    vt_halo = vt_rolloff + halo_bump

    ax.plot(L * 1000, vt_rolloff, color='#64748b', lw=2.0, linestyle='--', label='Kênh ngắn cổ điển ($V_t$ Roll-off)')
    ax.plot(L * 1000, vt_halo, color='#0284c7', lw=2.5, label='Có cấy bù Halo/Pocket (RSCE)')

    ax.axhline(vt_long, color='#94a3b8', lw=1.0, linestyle=':')
    ax.text(420, vt_long + 0.01, "$V_{t0}$ (Kênh dài)", fontsize=8.0, color='#64748b')

    # Roll-off arrow
    ax.annotate('Sụp đổ $V_t$ khi $L$ quá ngắn\n(Khó đóng kênh, rò rỉ tăng vọt)',
                xy=(60, 0.24), xytext=(120, 0.18),
                arrowprops=dict(arrowstyle="->", color='#dc2626', lw=1.5),
                fontsize=8.0, fontweight='bold', color='#dc2626')

    # RSCE bump annotation
    ax.annotate('Đỉnh RSCE (Halo)\n(Pha tạp tăng cường ở 2 mép)',
                xy=(130, 0.46), xytext=(220, 0.48),
                arrowprops=dict(arrowstyle="->", color='#0369a1', lw=1.5),
                fontsize=8.0, fontweight='bold', color='#0369a1')

    ax.set_xlabel("Chiều dài kênh $L$ (nm)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_ylabel("Điện áp ngưỡng $V_t$ (V)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_xlim(40, 500)
    ax.set_ylim(0.12, 0.54)
    ax.grid(True, linestyle=':', alpha=0.6)
    ax.legend(loc='lower right', fontsize=8.2, framealpha=0.95)

    out_path = os.path.join(OUTPUT_DIR, 'fig4_2_threshold_voltage_effects.png')
    plt.savefig(out_path, dpi=300)
    plt.close()
    print(f"Generated: {out_path}")


# =============================================================================
# FIGURE 3: Nanoscale Leakage Mechanisms (Subthreshold, Gate & Junction)
# =============================================================================
def generate_fig3():
    fig, axes = plt.subplots(1, 3, figsize=(18, 6.2), dpi=300)
    fig.subplots_adjust(left=0.05, right=0.97, top=0.82, bottom=0.12, wspace=0.24)
    fig.suptitle("Hình 4.3: Các cơ chế Dòng rò Bán dẫn Nanomet (Nanoscale Leakage Mechanisms)",
                 fontsize=14, fontweight='bold', color='#0f172a', y=0.97)

    # -------------------------------------------------------------
    # Panel (a): Silicon Cross-Section with 3 Leakage Paths
    # -------------------------------------------------------------
    ax = axes[0]
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 8.5)
    ax.axis('off')
    ax.set_title("(a) Ba con đường Rò rỉ Chủ yếu trên Silicon\n(Subthreshold, Gate Tunneling & Junction Leakage)",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)

    # Substrate
    ax.add_patch(patches.Rectangle((1.0, 1.0), 8.0, 4.5, facecolor='#ffedd5', edgecolor='#ea580c', lw=1.5))
    ax.text(5.0, 1.3, "p-Substrate ($V_b = 0\\text{V}$)", ha='center', fontsize=9, color='#9a3412', fontweight='bold')

    # Source & Drain diffusions
    ax.add_patch(patches.Rectangle((1.5, 3.8), 1.6, 1.7, facecolor='#bae6fd', edgecolor='#0284c7', lw=1.5))
    ax.text(2.3, 4.65, "$n^+$\nSource", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#0369a1')

    ax.add_patch(patches.Rectangle((6.9, 3.8), 1.6, 1.7, facecolor='#bae6fd', edgecolor='#0284c7', lw=1.5))
    ax.text(7.7, 4.65, "$n^+$\nDrain\n($V_{DD}$)", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#0369a1')

    # Gate & Ultra-thin oxide
    ax.add_patch(patches.Rectangle((3.3, 5.5), 3.4, 0.25, facecolor='#fef08a', edgecolor='#ca8a04', lw=1.2))
    ax.add_patch(patches.Rectangle((3.3, 5.75), 3.4, 0.9, facecolor='#c7d2fe', edgecolor='#3730a3', lw=1.5))
    ax.text(5.0, 6.2, "Gate Poly", ha='center', va='center', fontsize=9.0, fontweight='bold', color='#1e1b4b')
    ax.text(5.0, 5.62, "Ultra-thin $t_{ox} \\approx 1\\text{ nm}$", ha='center', va='center', fontsize=7.2, color='#713f12')

    # Leakage Path 1: Subthreshold (Channel)
    ax.annotate('', xy=(3.3, 4.8), xytext=(6.7, 4.8),
                arrowprops=dict(arrowstyle="->", color='#dc2626', lw=2.5, mutation_scale=14))
    ax.text(5.0, 4.3, "[1] $I_{sub}$ (Rò dưới ngưỡng)\nKhuếch tán khi $V_{gs} < V_t$",
            ha='center', fontsize=8.0, fontweight='bold', color='#dc2626',
            bbox=dict(boxstyle='round,pad=0.2', facecolor='#fef2f2', edgecolor='#fca5a5'))

    # Leakage Path 2: Gate Tunneling
    for gx in [4.2, 5.8]:
        ax.annotate('', xy=(gx, 5.4), xytext=(gx, 6.0),
                    arrowprops=dict(arrowstyle="->", color='#7c3aed', lw=2.0, mutation_scale=10))
    ax.text(5.0, 7.3, "[2] $I_{gate}$ (Xuyên hầm oxit)\nChui lượng tử qua lớp oxit mỏng",
            ha='center', fontsize=8.0, fontweight='bold', color='#6d28d9',
            bbox=dict(boxstyle='round,pad=0.2', facecolor='#f5f3ff', edgecolor='#ddd6fe'))

    # Leakage Path 3: Junction / BTBT
    ax.annotate('', xy=(7.7, 2.5), xytext=(7.7, 3.7),
                arrowprops=dict(arrowstyle="->", color='#059669', lw=2.0, mutation_scale=10))
    ax.text(7.7, 2.0, "[3] $I_{junc}$ (Tiếp giáp PN / BTBT)\nPhân cực ngược Drain-Substrate",
            ha='center', fontsize=7.8, fontweight='bold', color='#047857',
            bbox=dict(boxstyle='round,pad=0.2', facecolor='#ecfdf5', edgecolor='#a7f3d0'))

    # -------------------------------------------------------------
    # Panel (b): Subthreshold Log(Ids) vs Vgs & Subthreshold Swing S
    # -------------------------------------------------------------
    ax = axes[1]
    ax.set_title("(b) Đặc tuyến Dưới ngưỡng $\\log(I_{ds}) - V_{gs}$\n(Subthreshold Swing $S$ & Tỷ lệ $I_{on}/I_{off}$)",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)

    vgs = np.linspace(-0.2, 1.0, 200)
    vt0 = 0.35

    # Nominal curve (Room Temp 300K, S ~ 80 mV/dec)
    S_nom = 0.080  # V/dec
    log_i_off = -10.0  # 10^-10 A
    # Below Vt: exponential. Above Vt: velocity saturated
    log_i_nom = np.where(vgs < vt0,
                         log_i_off + (vgs - (-0.2)) / S_nom,
                         log_i_off + (vt0 - (-0.2)) / S_nom + np.log10(np.maximum(1 + 3.0 * (vgs - vt0), 1e-6)))

    # Hot Temp curve (T = 125C, S degrades to ~ 105 mV/dec, Vt drops)
    S_hot = 0.105
    vt_hot = 0.25
    log_i_hot = np.where(vgs < vt_hot,
                         -8.2 + (vgs - (-0.2)) / S_hot,
                         -8.2 + (vt_hot - (-0.2)) / S_hot + np.log10(np.maximum(1 + 2.2 * (vgs - vt_hot), 1e-6)))

    ax.plot(vgs, log_i_nom, color='#0284c7', lw=2.5, label='Nhiệt độ phòng ($25^\\circ\\text{C}$): $S \\approx 80\\text{ mV/dec}$')
    ax.plot(vgs, log_i_hot, color='#ef4444', lw=2.2, linestyle='--', label='Nhiệt độ cao ($125^\\circ\\text{C}$): $S \\approx 105\\text{ mV/dec}$')

    ax.axvline(vt0, color='#64748b', lw=1.0, linestyle=':')
    ax.text(vt0 + 0.02, -8.5, "Ngưỡng $V_t$", fontsize=8.0, color='#64748b', fontweight='bold')

    # Subthreshold slope S triangle
    ax.plot([0.0, 0.08], [-7.5, -7.5], color='#1e293b', lw=1.5)
    ax.plot([0.08, 0.08], [-7.5, -6.5], color='#1e293b', lw=1.5)
    ax.text(0.12, -7.2, "$S = n v_T \\ln(10)$\n$(\\Delta V_{gs}$ cho 1 thập kỷ $I)$", fontsize=8.0, color='#1e293b', fontweight='bold')

    ax.set_xlabel("Điện áp Cổng - Nguồn $V_{gs}$ (V)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_ylabel("$\\log_{10}(I_{ds})$ (Amperes)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_xlim(-0.2, 1.0)
    ax.set_ylim(-11, -3)
    ax.grid(True, linestyle=':', alpha=0.6)
    ax.legend(loc='lower right', fontsize=8.0, framealpha=0.95)

    # Ion and Ioff callouts
    ax.plot(0.0, log_i_nom[np.argmin(np.abs(vgs - 0.0))], 'ro', markersize=5)
    ax.text(0.02, -8.3, "$I_{off} (V_{gs}=0)$", fontsize=8.0, color='#dc2626', fontweight='bold')
    ax.plot(1.0, log_i_nom[-1], 'go', markersize=5)
    ax.text(0.78, -3.6, "$I_{on} (V_{gs}=V_{DD})$", fontsize=8.0, color='#15803d', fontweight='bold')

    # -------------------------------------------------------------
    # Panel (c): Gate Tunneling & HKMG Solution
    # -------------------------------------------------------------
    ax = axes[2]
    ax.set_title("(c) Xuyên hầm Lượng tử & Đột phá HKMG\n(Direct Tunneling vs. High-$\\kappa$ Metal Gate)",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)

    # Compare SiO2 thin vs HfO2 thick
    # Subpanel top: SiO2
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 8.5)
    ax.axis('off')

    # Card 1: Standard SiO2
    c1 = patches.Rectangle((0.8, 4.4), 8.4, 3.6, facecolor='#fff1f2', edgecolor='#fda4af', lw=1.5)
    ax.add_patch(c1)
    ax.text(1.2, 7.5, "[!] $SiO_2$ Truyền thống: Quá mỏng ($t_{ox} \\approx 1.2\\text{ nm}$)",
            fontsize=9.0, fontweight='bold', color='#9f1239')

    # Barrier diagram for SiO2
    ax.plot([2.5, 4.2, 4.2, 6.2, 6.2, 8.0], [5.2, 5.2, 7.0, 6.2, 5.2, 5.2], color='#e11d48', lw=2.0)
    ax.annotate('', xy=(6.8, 5.6), xytext=(3.5, 5.6),
                arrowprops=dict(arrowstyle="->", color='#e11d48', lw=2.2))
    ax.text(5.2, 5.8, "Electron xuyên thẳng (Direct Tunneling)\n$I_{gate} \\propto \\exp(-\\alpha t_{ox})$ tăng bùng nổ!",
            ha='center', fontsize=8.0, color='#9f1239', fontweight='bold')

    # Card 2: HKMG (HfO2)
    c2 = patches.Rectangle((0.8, 0.4), 8.4, 3.6, facecolor='#f0fdf4', edgecolor='#86efac', lw=1.5)
    ax.add_patch(c2)
    ax.text(1.2, 3.5, "[+] Đột phá High-$\\kappa$ Metal Gate (HKMG: $\\text{HfO}_2, \\kappa \\approx 25$)",
            fontsize=9.0, fontweight='bold', color='#166534')

    # Thick barrier for HfO2
    ax.plot([2.0, 3.5, 3.5, 7.5, 7.5, 8.5], [0.7, 0.7, 1.9, 1.5, 0.7, 0.7], color='#15803d', lw=2.0)
    ax.text(5.5, 1.3, "Rào cản rộng gấp 5 lần ($t_{phys} \\approx 5 t_{ox}$)",
            ha='center', va='center', fontsize=7.8, color='#14532d', fontweight='bold')
    ax.text(5.0, 2.5, "Chặn đứng dòng xuyên hầm ($I_{gate} \\downarrow 100\\times$)\nMà $C_{ox} = \\frac{\\kappa \\epsilon_0}{t_{phys}}$ không đổi ($\\kappa \\approx 25$)!",
            ha='center', va='center', fontsize=8.0, color='#14532d', fontweight='bold')

    out_path = os.path.join(OUTPUT_DIR, 'fig4_3_nanoscale_leakage_mechanisms.png')
    plt.savefig(out_path, dpi=300)
    plt.close()
    print(f"Generated: {out_path}")


# =============================================================================
# FIGURE 4: Process, Voltage, Temperature (PVT) Variations & Corners
# =============================================================================
def generate_fig4():
    fig, axes = plt.subplots(1, 3, figsize=(18, 6.2), dpi=300)
    fig.subplots_adjust(left=0.05, right=0.97, top=0.82, bottom=0.12, wspace=0.24)
    fig.suptitle("Hình 4.4: Bản đồ Biến thiên Quá trình, Điện áp, Nhiệt độ (PVT Corners)",
                 fontsize=14, fontweight='bold', color='#0f172a', y=0.97)

    # -------------------------------------------------------------
    # Panel (a): 2D Process Corner Map (nMOS vs pMOS)
    # -------------------------------------------------------------
    ax = axes[0]
    ax.set_title("(a) Bản đồ Góc Quy trình (Process Corners)\n(Statistical $\\pm 3\\sigma$ Dispersion Ellipse)",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)

    # Grid lines for TT, FF, SS, FS, SF
    ax.axhline(1.0, color='#94a3b8', lw=1.2, linestyle=':')
    ax.axvline(1.0, color='#94a3b8', lw=1.2, linestyle=':')

    # Draw 3-sigma tilted ellipse (positive correlation between nMOS and pMOS)
    theta = np.linspace(0, 2 * np.pi, 200)
    # Principal axes
    a, b = 0.35, 0.15
    rot = np.pi / 4  # 45 degrees
    x_ell = 1.0 + a * np.cos(theta) * np.cos(rot) - b * np.sin(theta) * np.sin(rot)
    y_ell = 1.0 + a * np.cos(theta) * np.sin(rot) + b * np.sin(theta) * np.cos(rot)
    ax.fill(x_ell, y_ell, facecolor='#e0f2fe', edgecolor='#0284c7', lw=1.5, alpha=0.5, label='Vùng chế tạo thực tế ($3\\sigma$)')

    # Mark Corners
    corners = {
        'TT': (1.0, 1.0, '#0f172a', 'Typical-Typical\n(Danh định)'),
        'FF': (1.30, 1.25, '#16a34a', 'Fast-Fast\n(Dòng cực đại, rò rỉ lớn)'),
        'SS': (0.70, 0.75, '#dc2626', 'Slow-Slow\n(Trễ lớn nhất, kiểm tra Setup)'),
        'FS': (1.25, 0.75, '#d97706', 'Fast nMOS, Slow pMOS\n(VTC lệch trái)'),
        'SF': (0.75, 1.25, '#7c3aed', 'Slow nMOS, Fast pMOS\n(VTC lệch phải)')
    }

    for name, (px, py, col, desc) in corners.items():
        ax.plot(px, py, 'o', color=col, markersize=8)
        offset_y = 0.05 if py >= 1.0 else -0.09
        offset_x = 0.0 if name == 'TT' else (0.04 if px >= 1.0 else -0.04)
        ha_align = 'center' if name == 'TT' else ('left' if px >= 1.0 else 'right')
        ax.text(px + offset_x, py + offset_y, f"{name}\n({desc.splitlines()[0]})",
                ha=ha_align, va='center', fontsize=8.0, fontweight='bold', color=col)

    ax.set_xlabel("Tốc độ / Dòng nMOS chuẩn hóa ($I_{on,n}$)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_ylabel("Tốc độ / Dòng pMOS chuẩn hóa ($I_{on,p}$)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_xlim(0.5, 1.5)
    ax.set_ylim(0.5, 1.5)
    ax.grid(True, linestyle=':', alpha=0.5)

    # -------------------------------------------------------------
    # Panel (b): Temperature Sensitivity & Temperature Inversion
    # -------------------------------------------------------------
    ax = axes[1]
    ax.set_title("(b) Độ nhạy Nhiệt & Điểm Đảo ngược Nhiệt\n(Temperature Inversion & ZTC Point)",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)

    vgs_sweep = np.linspace(0.1, 1.0, 150)
    # Cold curve (0C)
    vt_cold = 0.38
    mu_cold = 1.3
    i_cold = mu_cold * np.maximum(0, vgs_sweep - vt_cold)**1.2

    # Hot curve (125C)
    vt_hot = 0.22  # Vt drops
    mu_hot = 0.75  # Mobility drops heavily
    i_hot = mu_hot * np.maximum(0, vgs_sweep - vt_hot)**1.2

    ax.plot(vgs_sweep, i_cold, color='#0284c7', lw=2.4, label='Lạnh: $T = 0^\\circ\\text{C}$ ($\\mu$ cao, $V_t$ cao)')
    ax.plot(vgs_sweep, i_hot, color='#dc2626', lw=2.4, label='Nóng: $T = 125^\\circ\\text{C}$ ($\\mu$ thấp, $V_t$ thấp)')

    # ZTC Intersection Point
    ztc_vgs = 0.52
    ztc_ids = 0.165
    ax.plot(ztc_vgs, ztc_ids, 'ko', markersize=7)
    ax.annotate('Điểm ZTC (Zero Temp Coeff)\n$V_{gs} = V_{ZTC} \\approx 0.52\\text{V}$',
                xy=(ztc_vgs, ztc_ids), xytext=(0.20, 0.38),
                arrowprops=dict(arrowstyle="->", color='#0f172a', lw=1.5),
                fontsize=8.2, fontweight='bold', color='#0f172a',
                bbox=dict(boxstyle='round,pad=0.2', facecolor='#f8fafc', edgecolor='#94a3b8'))

    # Regime 1: High VDD (Normal): Hot is Slower
    ax.text(0.85, 0.45, "Vùng điện áp cao ($V_{DD} > V_{ZTC}$):\n$\\mu$ giảm áp đảo $\\rightarrow$\nNhiệt độ cao chạy CHẬM HƠN!",
            ha='center', fontsize=7.8, fontweight='bold', color='#1e293b',
            bbox=dict(boxstyle='square,pad=0.25', facecolor='#f1f5f9', edgecolor='#cbd5e1'))

    # Regime 2: Low VDD (Ultra-low power): Hot is FASTER (Temperature Inversion)
    ax.text(0.28, 0.06, "Vùng đảo nhiệt:\nNóng chạy NHANH HƠN!",
            ha='center', fontsize=7.5, fontweight='bold', color='#b91c1c')

    ax.set_xlabel("Điện áp điều khiển $V_{gs}$ (V)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_ylabel("Dòng dẫn bão hòa $I_{ds}$ (đơn vị tùy đối)", fontsize=9.5, fontweight='bold', color='#1e293b')
    ax.set_xlim(0.1, 1.0)
    ax.set_ylim(0, 0.8)
    ax.grid(True, linestyle=':', alpha=0.6)
    ax.legend(loc='upper left', fontsize=8.0, framealpha=0.95)

    # -------------------------------------------------------------
    # Panel (c): Critical Simulation Corners Matrix
    # -------------------------------------------------------------
    ax = axes[2]
    ax.set_title("(c) Bốn Góc Mô phỏng Ký duyệt Vi mạch\n(Critical Signoff Simulation Corners)",
                 fontsize=11, fontweight='bold', color='#0f172a', pad=10)
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 8.5)
    ax.axis('off')

    cards = [
        ("1. Max Delay / Setup Signoff (Trễ lớn nhất)",
         "Góc: SS | $V_{DD,min}$ (-10%) | $T_{max} = 125^\\circ\\text{C}$\n"
         "- Tốc độ chậm nhất toàn mạch.\n"
         "- Dùng để ký duyệt tần số xung nhịp ($f_{max}$) & Setup time.",
         '#fef2f2', '#f87171', '#991b1b', 6.4),

        ("2. Min Delay / Hold Signoff (Đua đường truyền)",
         "Góc: FF | $V_{DD,max}$ (+10%) | $T_{min} = 0^\\circ\\text{C}$\n"
         "- Tốc độ nhanh nhất, dữ liệu phóng vọt qua logic.\n"
         "- Nguy cơ vi phạm Hold time làm hỏng thanh ghi!",
         '#f0fdf4', '#4ade80', '#166534', 4.4),

        ("3. Worst-Case Static Leakage (Rò rỉ lớn nhất)",
         "Góc: FF | $V_{DD,max}$ (+10%) | $T_{max} = 125^\\circ\\text{C}$\n"
         "- Dòng rò dưới ngưỡng & rò oxit cực đại.\n"
         "- Kiểm tra công suất tĩnh chế độ Standby / Sleep.",
         '#fffbeb', '#fcd34d', '#92400e', 2.4),

        ("4. Dynamic Power (Công suất động cực đại)",
         "Góc: FF | $V_{DD,max}$ (+10%) | $T_{max} = 125^\\circ\\text{C}$ @ $f_{max}$\n"
         "- $P_{dyn} = C V_{DD}^2 f$ đạt đỉnh tuyệt đối.\n"
         "- Ký duyệt hệ thống tản nhiệt và sụt áp IR Drop.",
         '#f5f3ff', '#c084fc', '#6b21a8', 0.4)
    ]

    for title, body, bg_col, edge_col, txt_col, y_pos in cards:
        card = patches.Rectangle((0.3, y_pos), 9.4, 1.7, facecolor=bg_col, edgecolor=edge_col, lw=1.4)
        ax.add_patch(card)
        ax.text(0.6, y_pos + 1.35, title, fontsize=8.6, fontweight='bold', color=txt_col)
        ax.text(0.6, y_pos + 0.65, body, fontsize=7.6, color='#1e293b', va='center')

    out_path = os.path.join(OUTPUT_DIR, 'fig4_4_pvt_variations_and_corners.png')
    plt.savefig(out_path, dpi=300)
    plt.close()
    print(f"Generated: {out_path}")


if __name__ == '__main__':
    print("Generating Chapter 4 figures...")
    generate_fig1()
    generate_fig2()
    generate_fig3()
    generate_fig4()
    print("All Chapter 4 figures generated successfully!")
