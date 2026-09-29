"""
generate_ch2_figures.py
Generates 4 publication-quality, mechanism-driven diagrams for Chapter 2: CMOS Circuits & Layout:
1. fig2_1_cmos_gate_topology.png: Complementary CMOS Logic Gates & The Sizing Penalty of pMOS Stacks (NAND vs NOR).
2. fig2_2_pass_transistor_vt_drop.png: Pass Transistor Vt Degradation Mechanics & Transmission Gate Full-Swing Solution.
3. fig2_3_transmission_gate_and_latch.png: Transmission Gate 2:1 MUX, Bistable D-Latch, and Master-Slave DFF Timing.
4. fig2_4_stick_diagram_and_euler.png: Standard Cell Layout, Stick Diagrams, and Euler Path Diffusion Sharing Optimization.
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
# Figure 1: CMOS Gate Topology & Sizing Penalty (NAND vs NOR)
# -------------------------------------------------------------
def generate_fig1():
    fig = plt.figure(figsize=(15, 6.8), dpi=300)
    gs = fig.add_gridspec(1, 2, width_ratios=[1.2, 1.0], wspace=0.18)

    # Subplot 1: Microscopic Carrier Physics in Complementary CMOS
    ax1 = fig.add_subplot(gs[0])
    ax1.set_xlim(0, 10)
    ax1.set_ylim(0, 10)
    ax1.axis('off')
    ax1.set_title("(a) Mạng Kéo Lên (PUN) & Mạng Kéo Xuống (PDN) | Dòng Hạt Mang Điện", 
                  fontsize=11.5, fontweight='bold', pad=12, color='#0f172a')

    # Rails
    ax1.plot([0.5, 9.5], [9.3, 9.3], color='#b91c1c', lw=3.5)
    ax1.text(0.8, 9.55, "Vdd (+1.8V / +1.2V)", fontsize=10, fontweight='bold', color='#b91c1c')

    ax1.plot([0.5, 9.5], [0.7, 0.7], color='#15803d', lw=3.5)
    ax1.text(0.8, 0.35, "GND (0V)", fontsize=10, fontweight='bold', color='#15803d')

    # Pull-Up Network (PUN) box
    pun_box = patches.FancyBboxPatch((0.8, 5.5), 8.4, 3.4, boxstyle="round,pad=0.2",
                                      facecolor='#fef2f2', edgecolor='#ef4444', lw=1.5, linestyle='--')
    ax1.add_patch(pun_box)
    ax1.text(1.1, 8.6, "MẠNG KÉO LÊN (PUN - Pull-Up Network) | Gồm các pMOS", 
             fontsize=9.5, fontweight='bold', color='#991b1b', va='top')

    # Carrier in PUN: Holes
    ax1.text(5.0, 7.3, "Kênh pMOS dẫn: Bơm Lỗ Trống ($h^+$) từ Vdd sạc vào tụ ngõ ra $C_L$\n"
                       "Độ linh động lỗ trống kém: $\\mu_p \\approx 0.4 \\mu_n \\rightarrow R_{on,p} \\approx 2 R_{on,n}$",
             fontsize=8.8, color='#7f1d1d', ha='center', va='center',
             bbox=dict(boxstyle='round,pad=0.3', facecolor='#fee2e2', edgecolor='#f87171'))

    # Pull-Down Network (PDN) box
    pdn_box = patches.FancyBboxPatch((0.8, 1.1), 8.4, 3.4, boxstyle="round,pad=0.2",
                                      facecolor='#eff6ff', edgecolor='#3b82f6', lw=1.5, linestyle='--')
    ax1.add_patch(pdn_box)
    ax1.text(1.1, 4.2, "MẠNG KÉO XUỐNG (PDN - Pull-Down Network) | Gồm các nMOS", 
             fontsize=9.5, fontweight='bold', color='#1e40af', va='top')

    # Carrier in PDN: Electrons
    ax1.text(5.0, 2.7, "Kênh nMOS dẫn: Rút Electron ($e^-$) từ cực nguồn GND xả sạch $C_L$\n"
                       "Độ linh động electron cao: $\\mu_n \\approx 2.5 \\mu_p \\rightarrow$ Xả điện nhanh, nội trở thấp",
             fontsize=8.8, color='#1e3a8a', ha='center', va='center',
             bbox=dict(boxstyle='round,pad=0.3', facecolor='#dbeafe', edgecolor='#93c5fd'))

    # Output node and Capacitor
    ax1.plot([5.0, 5.0], [5.5, 4.5], color='#0f172a', lw=2)
    ax1.plot([5.0, 7.2], [5.0, 5.0], color='#0f172a', lw=2)
    ax1.plot(5.0, 5.0, 'o', color='#0f172a', markersize=6)
    ax1.text(7.4, 5.0, "Nốt ngõ ra (Output: Y)", fontsize=9.5, fontweight='bold', va='center', color='#0f172a')

    # Load capacitor CL
    ax1.plot([8.6, 8.6], [5.0, 4.3], color='#0f172a', lw=1.5)
    ax1.plot([8.2, 9.0], [4.3, 4.3], color='#0f172a', lw=2)
    ax1.plot([8.2, 9.0], [3.9, 3.9], color='#0f172a', lw=2)
    ax1.plot([8.6, 8.6], [3.9, 3.2], color='#0f172a', lw=1.5)
    ax1.plot([8.3, 8.9], [3.2, 3.2], color='#64748b', lw=2)
    ax1.plot([8.4, 8.8], [3.0, 3.0], color='#64748b', lw=1.5)
    ax1.text(9.2, 4.1, "$C_L$", fontsize=10, fontweight='bold', color='#0284c7')

    # Direction arrows
    ax1.annotate("", xy=(5.0, 5.1), xytext=(5.0, 6.0),
                 arrowprops=dict(arrowstyle="->", color="#dc2626", lw=2.2))
    ax1.text(3.3, 5.6, "Lỗ trống ($h^+$) kéo lên", fontsize=8, fontweight='bold', color='#dc2626', ha='right')

    ax1.annotate("", xy=(5.0, 4.0), xytext=(5.0, 4.9),
                 arrowprops=dict(arrowstyle="->", color="#2563eb", lw=2.2))
    ax1.text(3.3, 4.4, "Electron ($e^-$) xả xuống", fontsize=8, fontweight='bold', color='#2563eb', ha='right')


    # Subplot 2: Sizing Comparison: NAND vs NOR Sizing Nightmare
    ax2 = fig.add_subplot(gs[1])
    ax2.set_xlim(0, 10)
    ax2.set_ylim(0, 10)
    ax2.axis('off')
    ax2.set_title("(b) Sự 'Thất Sủng' Của Cổng NOR: Ác Mộng Kích Thước pMOS", 
                  fontsize=11.5, fontweight='bold', pad=12, color='#0f172a')

    # Inverter baseline
    inv_box = patches.Rectangle((0.5, 6.8), 9.0, 2.7, facecolor='#f8fafc', edgecolor='#cbd5e1', lw=1.2)
    ax2.add_patch(inv_box)
    ax2.text(0.8, 9.25, "Cổng Đảo Cơ Sở (Inverter Sizing - Chuẩn 1X)", fontsize=9.2, fontweight='bold', color='#0f172a', va='top')
    ax2.text(0.8, 8.6, "• nMOS: Chiều rộng $W_n = 1\\lambda \\rightarrow$ Điện trở kéo xuống $R_n = R$\n"
                       "• pMOS: Chiều rộng $W_p = 2\\lambda \\rightarrow$ Điện trở kéo lên $R_p = 2R/2 = R$\n"
                       "$\\rightarrow$ Thời gian tăng/giảm cân bằng: $t_r \\approx t_f$. Tổng độ rộng = $3\\lambda$",
             fontsize=8.3, color='#334155', va='top')

    # NAND vs NOR comparison cards
    nand_box = patches.Rectangle((0.5, 3.5), 4.3, 3.0, facecolor='#ecfdf5', edgecolor='#10b981', lw=1.5)
    ax2.add_patch(nand_box)
    ax2.text(0.7, 6.25, "Cổng NAND2 (Ưu Tiên Số 1)", fontsize=9, fontweight='bold', color='#065f46', va='top')
    ax2.text(0.7, 5.65, "• 2 nMOS NỐI TIẾP:\n"
                        "  $W_n = 2\\lambda \\rightarrow R_{eq} = R$\n"
                        "• 2 pMOS SONG SONG:\n"
                        "  $W_p = 2\\lambda \\rightarrow R_{worst} = R$\n"
                        "• Tổng độ rộng: $8\\lambda$\n"
                        "$\\rightarrow$ Nhỏ gọn, tốc độ nhanh!",
             fontsize=8.0, color='#047857', va='top')

    nor_box = patches.Rectangle((5.2, 3.5), 4.3, 3.0, facecolor='#fff1f2', edgecolor='#f43f5e', lw=1.5)
    ax2.add_patch(nor_box)
    ax2.text(5.4, 6.25, "Cổng NOR2 (Hạn Chế Dùng)", fontsize=9, fontweight='bold', color='#9f1239', va='top')
    ax2.text(5.4, 5.65, "• 2 nMOS SONG SONG:\n"
                        "  $W_n = 1\\lambda \\rightarrow R_{worst} = R$\n"
                        "• 2 pMOS NỐI TIẾP (Ác mộng!):\n"
                        "  $W_p = 4\\lambda \\rightarrow R_{eq} = R$\n"
                        "• Tổng độ rộng: $10\\lambda$\n"
                        "$\\rightarrow$ pMOS phình to gấp 4 lần!",
             fontsize=8.0, color='#be123c', va='top')

    # Engineering Rule box below
    eng_box = patches.FancyBboxPatch((0.5, 0.4), 9.0, 2.8, boxstyle="round,pad=0.2",
                                     facecolor='#f0fdf4', edgecolor='#16a34a', lw=1.2)
    ax2.add_patch(eng_box)
    ax2.text(0.8, 2.9, "[QUY TẮC VÀNG THIẾT KẾ VI MẠCH - Engineering Rule]:", fontsize=8.8, fontweight='bold', color='#15803d', va='top')
    ax2.text(0.8, 2.3, "1. Chuỗi pMOS nối tiếp rất chậm vì $\\mu_p$ thấp. Nếu ngõ vào $N > 3$, NOR bị nghẽn nặng!\n"
                       "2. Thư viện chuẩn (Standard Cell) luôn ưu tiên NAND và biến đổi biểu thức\n"
                       "   theo định lý De Morgan để dùng NAND/AOI thay vì NOR/OAI.",
             fontsize=8.0, color='#14532d', va='top')

    output_path = os.path.join(OUTPUT_DIR, 'fig2_1_cmos_gate_topology.png')
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close()
    print(f"Generated: {output_path}")

# -------------------------------------------------------------
# Figure 2: Pass Transistor Vt Degradation & Transmission Gate
# -------------------------------------------------------------
def generate_fig2():
    fig = plt.figure(figsize=(15, 6.8), dpi=300)
    gs = fig.add_gridspec(2, 2, width_ratios=[1.1, 0.9], height_ratios=[1.0, 1.0], hspace=0.36, wspace=0.22)

    # Subplot 1: nMOS Passing '0' (Strong 0)
    ax1 = fig.add_subplot(gs[0, 0])
    ax1.set_xlim(0, 10)
    ax1.set_ylim(0, 5)
    ax1.axis('off')
    ax1.set_title("(a) nMOS Truyền Mức 0 (Strong 0) | $V_{in} = 0V, V_g = V_{dd}$", 
                  fontsize=10.5, fontweight='bold', color='#0f172a')

    # Draw nMOS
    # Poly Gate
    ax1.add_patch(patches.Rectangle((4.5, 3.2), 1.0, 0.8, facecolor='#ef4444', edgecolor='#991b1b', lw=1.5))
    ax1.text(5.0, 3.6, "Gate: Vdd", ha='center', va='center', fontsize=8.5, fontweight='bold', color='white')
    # Thin oxide
    ax1.add_patch(patches.Rectangle((4.5, 3.0), 1.0, 0.2, facecolor='#fef08a', edgecolor='#ca8a04'))
    # Channel and diffusions
    ax1.add_patch(patches.Rectangle((2.0, 1.8), 2.5, 1.2, facecolor='#bbf7d0', edgecolor='#16a34a', lw=1.2)) # Source
    ax1.text(3.25, 2.4, "Source: 0V\n($n^+$)", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#14532d')
    ax1.add_patch(patches.Rectangle((4.5, 1.8), 1.0, 1.2, facecolor='#dcfce7', edgecolor='#86efac')) # Channel
    ax1.text(5.0, 2.4, "Kênh mở", ha='center', va='center', fontsize=8, color='#15803d')
    ax1.add_patch(patches.Rectangle((5.5, 1.8), 2.5, 1.2, facecolor='#bbf7d0', edgecolor='#16a34a', lw=1.2)) # Drain
    ax1.text(6.75, 2.4, "Drain ($V_{out}$)\n($n^+$)", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#14532d')

    # Explanatory text & condition
    ax1.text(5.0, 0.6, "Cực nguồn ở 0V $\\rightarrow V_{gs} = V_g - V_s = V_{dd} - 0 = V_{dd} \\gg V_{tn}$\n"
                       "Điện áp điều khiển $V_{gs}$ luôn duy trì ở mức tối đa $\\rightarrow$ Kênh dẫn mở mạnh mẽ cho tới khi $V_{out} = 0V$.\n"
                       "$\\rightarrow$ nMOS là một công tắc tuyệt vời để truyền mức 0 (Strong '0').",
             fontsize=8.5, color='#1e293b', ha='center',
             bbox=dict(boxstyle='round,pad=0.3', facecolor='#f0fdf4', edgecolor='#86efac'))


    # Subplot 2: nMOS Passing '1' (Degraded Weak 1 - The Vt Drop Trap)
    ax2 = fig.add_subplot(gs[1, 0])
    ax2.set_xlim(0, 10)
    ax2.set_ylim(0, 5)
    ax2.axis('off')
    ax2.set_title("(b) nMOS Truyền Mức 1 (Weak 1) | Hiện Tượng Tự Ngắt Kênh Khi $V_{gs} \\rightarrow V_{tn}$", 
                  fontsize=10.5, fontweight='bold', color='#991b1b')

    # Poly Gate
    ax2.add_patch(patches.Rectangle((4.5, 3.2), 1.0, 0.8, facecolor='#ef4444', edgecolor='#991b1b', lw=1.5))
    ax2.text(5.0, 3.6, "Gate: Vdd", ha='center', va='center', fontsize=8.5, fontweight='bold', color='white')
    ax2.add_patch(patches.Rectangle((4.5, 3.0), 1.0, 0.2, facecolor='#fef08a', edgecolor='#ca8a04'))

    # Diffusions
    ax2.add_patch(patches.Rectangle((2.0, 1.8), 2.5, 1.2, facecolor='#fed7aa', edgecolor='#ea580c', lw=1.2)) # Input
    ax2.text(3.25, 2.4, "Drain: Vdd\n(Ngõ vào)", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#9a3412')
    # Vanishing channel
    ax2.add_patch(patches.Polygon([[4.5, 3.0], [5.5, 3.0], [4.5, 2.2]], facecolor='#fecaca', edgecolor='#ef4444', lw=1.2))
    ax2.text(5.0, 2.2, "NGẮT!", ha='center', va='center', fontsize=7.5, fontweight='bold', color='#b91c1c')
    ax2.add_patch(patches.Rectangle((5.5, 1.8), 2.5, 1.2, facecolor='#fed7aa', edgecolor='#ea580c', lw=1.2)) # Output/Source
    ax2.text(6.75, 2.4, "Source: $V_{out}$\n(Kẹp tại $V_{dd}-V_t$!)", ha='center', va='center', fontsize=8.5, fontweight='bold', color='#b91c1c')

    # Explanatory text & condition
    ax2.text(5.0, 0.6, "Khi tụ ngõ ra sạc lên, cực Source bây giờ chính là ngõ ra: $V_s = V_{out}$.\n"
                       "Do đó: $V_{gs} = V_g - V_{out} = V_{dd} - V_{out}$.\n"
                       "Khi $V_{out} = V_{dd} - V_{tn} \\rightarrow V_{gs} = V_{tn} \\rightarrow$ KÊNH TỰ BIẾN MẤT (SHUTOFF)!\n"
                       "Dòng $I_{ds} \\rightarrow 0$, ngõ ra vĩnh viễn bị mắc kẹt tại $V_{dd} - V_{tn}$ (Mất mát biên độ chống nhiễu).",
             fontsize=8.5, color='#991b1b', ha='center',
             bbox=dict(boxstyle='round,pad=0.3', facecolor='#fef2f2', edgecolor='#fca5a5'))


    # Subplot 3: Transmission Gate (TG) Structure & Circuit
    ax3 = fig.add_subplot(gs[0, 1])
    ax3.set_xlim(0, 10)
    ax3.set_ylim(0, 5)
    ax3.axis('off')
    ax3.set_title("(c) Cổng Truyền CMOS (Transmission Gate - TG)", 
                  fontsize=10.5, fontweight='bold', color='#0f172a')

    # Draw TG schematic
    # Input wire
    ax3.plot([0.8, 3.0], [2.5, 2.5], color='#0f172a', lw=2)
    ax3.text(0.6, 2.5, "A", fontsize=11, fontweight='bold', va='center', ha='right', color='#0f172a')

    # Split to pMOS (top) and nMOS (bottom)
    ax3.plot([3.0, 3.0], [1.2, 3.8], color='#0f172a', lw=2)
    ax3.plot([3.0, 4.2], [3.8, 3.8], color='#0f172a', lw=2) # to pMOS
    ax3.plot([3.0, 4.2], [1.2, 1.2], color='#0f172a', lw=2) # to nMOS

    # pMOS symbol (top)
    ax3.plot([4.2, 5.8], [3.8, 3.8], color='#dc2626', lw=2.5) # drain-source
    ax3.plot([4.2, 5.8], [4.3, 4.3], color='#0f172a', lw=2) # gate line
    ax3.plot([5.0, 5.0], [4.3, 4.7], color='#0f172a', lw=2)
    ax3.plot(5.0, 4.5, 'o', color='white', markeredgecolor='#0f172a', markeredgewidth=1.5, markersize=6) # inversion bubble
    ax3.text(5.0, 4.9, "Control: C_b (0V)", ha='center', fontsize=8.5, fontweight='bold', color='#991b1b')
    ax3.text(5.0, 3.4, "pMOS (Truyền '1' trọn vẹn)", ha='center', fontsize=8, color='#dc2626', fontweight='bold')

    # nMOS symbol (bottom)
    ax3.plot([4.2, 5.8], [1.2, 1.2], color='#2563eb', lw=2.5) # drain-source
    ax3.plot([4.2, 5.8], [0.7, 0.7], color='#0f172a', lw=2) # gate line
    ax3.plot([5.0, 5.0], [0.7, 0.3], color='#0f172a', lw=2)
    ax3.text(5.0, 0.1, "Control: C (Vdd)", ha='center', fontsize=8.5, fontweight='bold', color='#1e40af')
    ax3.text(5.0, 1.5, "nMOS (Truyền '0' trọn vẹn)", ha='center', fontsize=8, color='#2563eb', fontweight='bold')

    # Merge to output
    ax3.plot([5.8, 7.0], [3.8, 3.8], color='#0f172a', lw=2)
    ax3.plot([5.8, 7.0], [1.2, 1.2], color='#0f172a', lw=2)
    ax3.plot([7.0, 7.0], [1.2, 3.8], color='#0f172a', lw=2)
    ax3.plot([7.0, 9.2], [2.5, 2.5], color='#0f172a', lw=2)
    ax3.text(9.4, 2.5, "B (Full-Swing)", fontsize=10, fontweight='bold', va='center', color='#059669')


    # Subplot 4: Dynamic Waveform: nMOS alone vs TG Charging CL
    ax4 = fig.add_subplot(gs[1, 1])
    t = np.linspace(0, 5, 200)
    Vdd = 1.8
    Vt = 0.45

    # Single nMOS trajectory: saturates at Vdd - Vt
    v_nmos = (Vdd - Vt) * (1 - np.exp(-t / 0.8))
    # TG trajectory: pulls all the way to Vdd
    v_tg = Vdd * (1 - np.exp(-t / 0.75))

    ax4.plot(t, v_nmos, color='#ef4444', lw=2.5, linestyle='--', label='1 nMOS duy nhất (Kẹt tại $V_{dd}-V_t$)')
    ax4.plot(t, v_tg, color='#059669', lw=2.8, label='Transmission Gate (Full Rail-to-Rail $V_{dd}$)')
    ax4.axhline(Vdd, color='#64748b', linestyle=':', lw=1.2)
    ax4.text(0.2, Vdd + 0.05, "$V_{dd} = 1.8V$", fontsize=8.5, color='#334155', fontweight='bold')

    ax4.axhline(Vdd - Vt, color='#dc2626', linestyle=':', lw=1.2)
    ax4.text(0.2, Vdd - Vt - 0.12, "$V_{dd} - V_t = 1.35V$", fontsize=8.5, color='#dc2626', fontweight='bold')

    ax4.set_title("(d) Quỹ Đạo Điện Áp Sạc Tụ $V_{out}(t)$", fontsize=10.5, fontweight='bold', color='#0f172a')
    ax4.set_xlabel("Thời gian chuẩn hóa ($t / \\tau$)", fontsize=9)
    ax4.set_ylabel("Điện áp ngõ ra $V_{out}$ (V)", fontsize=9)
    ax4.set_ylim(-0.1, 2.1)
    ax4.grid(True, linestyle=':', alpha=0.6)
    ax4.legend(loc='lower right', fontsize=8.2, framealpha=0.9)

    # Operating Trajectory Annotation
    ax4.annotate("Kênh nMOS ngắt hẳn\nDòng I = 0, tụ ngừng nạp!", xy=(3.0, Vdd - Vt), xytext=(2.2, 0.7),
                 arrowprops=dict(arrowstyle="->", color="#dc2626", lw=1.5),
                 fontsize=8, fontweight='bold', color='#dc2626',
                 bbox=dict(boxstyle='round,pad=0.2', facecolor='#fef2f2', edgecolor='#fca5a5'))

    output_path = os.path.join(OUTPUT_DIR, 'fig2_2_pass_transistor_vt_drop.png')
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close()
    print(f"Generated: {output_path}")

# -------------------------------------------------------------
# Figure 3: Transmission Gate Applications: MUX, Latch & DFF
# -------------------------------------------------------------
def generate_fig3():
    fig = plt.figure(figsize=(15, 6.2), dpi=300)
    gs = fig.add_gridspec(1, 2, width_ratios=[0.9, 1.3], wspace=0.18)

    # Subplot 1: 2:1 Multiplexer using TG
    ax1 = fig.add_subplot(gs[0])
    ax1.set_xlim(0, 10)
    ax1.set_ylim(0, 10)
    ax1.axis('off')
    ax1.set_title("(a) Mạch Ghép Kênh 2:1 MUX Bằng Cổng Truyền (TG)", 
                  fontsize=11, fontweight='bold', pad=12, color='#0f172a')

    # TG 1 for Input D0
    ax1.add_patch(patches.FancyBboxPatch((3.5, 6.6), 3.0, 2.0, boxstyle="round,pad=0.2",
                                         facecolor='#eff6ff', edgecolor='#3b82f6', lw=1.5))
    ax1.text(5.0, 7.6, "Cổng Truyền TG 1\nĐiều khiển bởi $S=0$ (BẬT)", ha='center', va='center',
             fontsize=9, fontweight='bold', color='#1e40af')
    ax1.plot([1.0, 3.5], [7.6, 7.6], color='#0f172a', lw=2)
    ax1.text(0.8, 7.6, "D0", fontsize=11, fontweight='bold', va='center', ha='right')

    # TG 2 for Input D1
    ax1.add_patch(patches.FancyBboxPatch((3.5, 2.4), 3.0, 2.0, boxstyle="round,pad=0.2",
                                         facecolor='#f8fafc', edgecolor='#94a3b8', lw=1.5))
    ax1.text(5.0, 3.4, "Cổng Truyền TG 2\nĐiều khiển bởi $S=1$ (TẮT)", ha='center', va='center',
             fontsize=9, fontweight='bold', color='#475569')
    ax1.plot([1.0, 3.5], [3.4, 3.4], color='#0f172a', lw=2)
    ax1.text(0.8, 3.4, "D1", fontsize=11, fontweight='bold', va='center', ha='right')

    # Merge to Output Y
    ax1.plot([6.5, 8.0], [7.6, 7.6], color='#0f172a', lw=2)
    ax1.plot([6.5, 8.0], [3.4, 3.4], color='#0f172a', lw=2)
    ax1.plot([8.0, 8.0], [3.4, 7.6], color='#0f172a', lw=2)
    ax1.plot([8.0, 9.5], [5.5, 5.5], color='#0f172a', lw=2.5)
    ax1.plot(8.0, 5.5, 'o', color='#0f172a', markersize=6)
    ax1.text(9.7, 5.5, "Y", fontsize=12, fontweight='bold', va='center', color='#059669')

    # Active trajectory arrow
    ax1.annotate("D0 thông suốt ra Y khi S=0", xy=(8.2, 5.7), xytext=(4.0, 9.2),
                 arrowprops=dict(arrowstyle="->", color="#2563eb", lw=2, connectionstyle="arc3,rad=-0.2"),
                 fontsize=8.5, fontweight='bold', color='#1d4ed8')

    # Trade-off comparison box
    ax1.text(5.0, 1.0, "[SO SÁNH VỚI MUX DÙNG CỔNG LOGIC TĨNH (Static CMOS)]:\n"
                       "• MUX tĩnh (2 AND + 1 OR + 1 INV): Cần tới 14 transistors, trễ 2 tầng cổng.\n"
                       "• MUX dùng TG (2 TG + 1 INV cho tín hiệu chọn S): Chỉ cần 6 transistors!\n"
                       "$\\rightarrow$ Tiết kiệm 57% diện tích, giảm điện dung ký sinh đáng kể.",
             fontsize=8.3, color='#0f172a', ha='center',
             bbox=dict(boxstyle='round,pad=0.3', facecolor='#f0fdf4', edgecolor='#86efac'))


    # Subplot 2: D-Latch & Master-Slave D Flip-Flop
    ax2 = fig.add_subplot(gs[1])
    ax2.set_xlim(0, 13)
    ax2.set_ylim(0, 10)
    ax2.axis('off')
    ax2.set_title("(b) Mạch Chốt D-Latch & D Flip-Flop Kích Khởi Cạnh (Master-Slave)", 
                  fontsize=11, fontweight='bold', pad=12, color='#0f172a')

    # Master Latch box
    master_box = patches.FancyBboxPatch((0.5, 3.6), 5.8, 5.8, boxstyle="round,pad=0.2",
                                        facecolor='#eff6ff', edgecolor='#3b82f6', lw=1.5)
    ax2.add_patch(master_box)
    ax2.text(3.4, 8.9, "TẦNG MASTER (D-Latch)", ha='center', fontsize=9.5, fontweight='bold', color='#1e40af')

    # Slave Latch box
    slave_box = patches.FancyBboxPatch((6.7, 3.6), 5.8, 5.8, boxstyle="round,pad=0.2",
                                       facecolor='#fef2f2', edgecolor='#ef4444', lw=1.5)
    ax2.add_patch(slave_box)
    ax2.text(9.6, 8.9, "TẦNG SLAVE (D-Latch)", ha='center', fontsize=9.5, fontweight='bold', color='#991b1b')

    # Circuit blocks inside Master
    # TG1 (input)
    ax2.add_patch(patches.Rectangle((1.0, 6.2), 1.4, 1.2, facecolor='#dbeafe', edgecolor='#2563eb'))
    ax2.text(1.7, 6.8, "TG 1\n(CLK=0)", ha='center', va='center', fontsize=8, fontweight='bold', color='#1e3a8a')
    # Inv 1
    ax2.add_patch(patches.Polygon([[2.8, 6.0], [2.8, 7.6], [3.8, 6.8]], facecolor='#e0f2fe', edgecolor='#0284c7'))
    ax2.plot(4.0, 6.8, 'o', color='white', markeredgecolor='#0284c7', markersize=5)
    # Inv 2 (feedback)
    ax2.add_patch(patches.Polygon([[3.8, 4.4], [3.8, 5.6], [2.8, 5.0]], facecolor='#e0f2fe', edgecolor='#0284c7'))
    ax2.plot(2.6, 5.0, 'o', color='white', markeredgecolor='#0284c7', markersize=5)
    # TG2 (feedback switch)
    ax2.add_patch(patches.Rectangle((4.5, 4.4), 1.2, 1.2, facecolor='#dbeafe', edgecolor='#2563eb'))
    ax2.text(5.1, 5.0, "TG 2\n(CLK=1)", ha='center', va='center', fontsize=7.5, fontweight='bold', color='#1e3a8a')

    # Connections Master
    ax2.plot([0.0, 1.0], [6.8, 6.8], color='#0f172a', lw=1.8)
    ax2.text(0.0, 7.1, "D", fontsize=10, fontweight='bold')
    ax2.plot([2.4, 2.8], [6.8, 6.8], color='#0f172a', lw=1.8)
    ax2.plot([4.2, 6.0], [6.8, 6.8], color='#0f172a', lw=1.8) # to internal node Qm
    ax2.plot(4.5, 6.8, 'o', color='#0f172a', markersize=4)
    ax2.plot([4.5, 4.5], [6.8, 5.0], color='#0f172a', lw=1.5)
    ax2.plot([4.5, 4.2], [5.0, 5.0], color='#0f172a', lw=1.5) # into Inv2
    ax2.plot([2.4, 1.5], [5.0, 5.0], color='#0f172a', lw=1.5)
    ax2.plot([1.5, 1.5], [5.0, 4.4], color='#0f172a', lw=1.5)
    ax2.text(5.5, 7.2, "$Q_M$", fontsize=9, fontweight='bold', color='#2563eb')

    # Circuit blocks inside Slave
    # TG3
    ax2.add_patch(patches.Rectangle((7.0, 6.2), 1.4, 1.2, facecolor='#fee2e2', edgecolor='#dc2626'))
    ax2.text(7.7, 6.8, "TG 3\n(CLK=1)", ha='center', va='center', fontsize=8, fontweight='bold', color='#991b1b')
    # Inv 3
    ax2.add_patch(patches.Polygon([[8.8, 6.0], [8.8, 7.6], [9.8, 6.8]], facecolor='#ffe4e6', edgecolor='#e11d48'))
    ax2.plot(10.0, 6.8, 'o', color='white', markeredgecolor='#e11d48', markersize=5)
    # Inv 4 (feedback)
    ax2.add_patch(patches.Polygon([[9.8, 4.4], [9.8, 5.6], [8.8, 5.0]], facecolor='#ffe4e6', edgecolor='#e11d48'))
    ax2.plot(8.6, 5.0, 'o', color='white', markeredgecolor='#e11d48', markersize=5)
    # TG4
    ax2.add_patch(patches.Rectangle((10.5, 4.4), 1.2, 1.2, facecolor='#fee2e2', edgecolor='#dc2626'))
    ax2.text(11.1, 5.0, "TG 4\n(CLK=0)", ha='center', va='center', fontsize=7.5, fontweight='bold', color='#991b1b')

    # Connections Slave & Output
    ax2.plot([6.0, 7.0], [6.8, 6.8], color='#0f172a', lw=1.8)
    ax2.plot([8.4, 8.8], [6.8, 6.8], color='#0f172a', lw=1.8)
    ax2.plot([10.2, 12.5], [6.8, 6.8], color='#0f172a', lw=2)
    ax2.text(12.7, 6.8, "Q", fontsize=11, fontweight='bold', color='#059669', va='center')

    # Timing analysis box at bottom
    timing_box = patches.FancyBboxPatch((0.5, 0.4), 12.0, 2.7, boxstyle="round,pad=0.2",
                                        facecolor='#fffbeb', edgecolor='#f59e0b', lw=1.2)
    ax2.add_patch(timing_box)
    ax2.text(0.8, 2.6, "[BẢN CHẤT VẬT LÝ CỦA THỜI GIAN SETUP (t_setup) VÀ HOLD (t_hold)]:", 
             fontsize=9, fontweight='bold', color='#b45309')
    ax2.text(0.8, 0.8, "• Setup time ($t_{setup}$): Thời gian dữ liệu $D$ phải ổn định TRƯỚC sườn xung nhịp. Về bản chất hạt mang điện,\n"
                       "  đây là thời gian cần thiết để hạt (electron/lỗ trống) nạp/xả đầy đủ tụ ký sinh tại nốt trung gian $Q_M$\n"
                       "  trước khi công tắc TG1 bị ngắt hoàn toàn.\n"
                       "• Hold time ($t_{hold}$): Thời gian dữ liệu $D$ phải giữ nguyên SAU sườn xung nhịp để đảm bảo cổng truyền TG1\n"
                       "  thực sự đóng kín, ngăn chặn điện tích từ dữ liệu mới tràn vào làm hỏng trạng thái vừa chốt.",
             fontsize=8.2, color='#78350f')

    output_path = os.path.join(OUTPUT_DIR, 'fig2_3_transmission_gate_and_latch.png')
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close()
    print(f"Generated: {output_path}")

# -------------------------------------------------------------
# Figure 4: Stick Diagram & Euler Path Diffusion Optimization
# -------------------------------------------------------------
def generate_fig4():
    fig = plt.figure(figsize=(15, 6.6), dpi=300)
    gs = fig.add_gridspec(2, 2, width_ratios=[1.0, 1.2], height_ratios=[1.0, 1.1], hspace=0.32, wspace=0.22)

    # Subplot 1: Standard Cell Layer Convention & Rules
    ax1 = fig.add_subplot(gs[0, 0])
    ax1.set_xlim(0, 10)
    ax1.set_ylim(0, 5)
    ax1.axis('off')
    ax1.set_title("(a) Quy Ước Lớp Bố Cục (Silicon Layout Layers)", 
                  fontsize=10.5, fontweight='bold', color='#0f172a')

    # Color swatches
    layers = [
        ("N-Diffusion (n+ Active)", "#4ade80", "#16a34a", "Kênh nMOS trong p-substrate"),
        ("P-Diffusion (p+ Active)", "#fbbf24", "#d97706", "Kênh pMOS trong N-well"),
        ("Polysilicon (Cực Cổng)", "#ef4444", "#b91c1c", "Chạy dọc cắt ngang qua Diffusion"),
        ("Metal 1 (Dây Kim Loại)", "#3b82f6", "#1d4ed8", "Dây nguồn Vdd, GND & nối nốt"),
        ("Contact Cut (Lỗ Tiếp Xúc)", "#1e293b", "#0f172a", "Nối Metal 1 với Poly / Diffusion (X)")
    ]

    for idx, (name, col, border, desc) in enumerate(layers):
        y = 4.2 - idx * 0.85
        ax1.add_patch(patches.Rectangle((0.5, y - 0.25), 0.7, 0.5, facecolor=col, edgecolor=border, lw=1.2))
        if "Contact" in name:
            ax1.plot([0.5, 1.2], [y-0.25, y+0.25], color='white', lw=1.5)
            ax1.plot([0.5, 1.2], [y+0.25, y-0.25], color='white', lw=1.5)
        ax1.text(1.5, y + 0.05, name, fontsize=8.5, fontweight='bold', color='#0f172a')
        ax1.text(1.5, y - 0.2, desc, fontsize=7.8, color='#475569')


    # Subplot 2: Euler Graph for AOI21: F = (A.B + C)_bar
    ax2 = fig.add_subplot(gs[0, 1])
    ax2.set_xlim(0, 10)
    ax2.set_ylim(0, 5)
    ax2.axis('off')
    ax2.set_title("(b) Đồ Thị Euler Tìm Trình Tự Poly Chia Sẻ Diffusion", 
                  fontsize=10.5, fontweight='bold', color='#0f172a')

    # Graph description
    ax2.text(5.0, 4.4, "Hàm Logic: $Y = \\overline{A \\cdot B + C}$ (Cổng AOI21)", ha='center', fontsize=9.5, fontweight='bold', color='#0f172a')

    # Graph PUN vs PDN
    ax2.text(2.5, 3.6, "Đồ thị Mạng PUN (pMOS)", ha='center', fontsize=8.5, fontweight='bold', color='#b91c1c')
    # Nodes PUN: Vdd, n1, Out
    ax2.plot(1.2, 2.5, 'o', color='#b91c1c', markersize=8)
    ax2.text(1.2, 2.0, "Vdd", ha='center', fontsize=8, color='#b91c1c')
    ax2.plot(3.8, 2.5, 'o', color='#b91c1c', markersize=8)
    ax2.text(3.8, 2.0, "Out", ha='center', fontsize=8, color='#b91c1c')
    # Edges PUN
    ax2.plot([1.2, 3.8], [2.5, 2.5], color='#b91c1c', lw=2)
    ax2.text(2.5, 2.7, "C", ha='center', fontsize=8.5, fontweight='bold', color='#b91c1c')
    # branch A and B in parallel
    ax2.plot([1.2, 2.5], [2.5, 3.2], color='#b91c1c', lw=1.5)
    ax2.plot([2.5, 3.8], [3.2, 2.5], color='#b91c1c', lw=1.5)
    ax2.text(1.7, 3.1, "A", fontsize=8, fontweight='bold', color='#b91c1c')
    ax2.text(3.3, 3.1, "B", fontsize=8, fontweight='bold', color='#b91c1c')

    # PDN Graph
    ax2.text(7.5, 3.6, "Đồ thị Mạng PDN (nMOS)", ha='center', fontsize=8.5, fontweight='bold', color='#1d4ed8')
    ax2.plot(6.2, 2.5, 'o', color='#1d4ed8', markersize=8)
    ax2.text(6.2, 2.0, "GND", ha='center', fontsize=8, color='#1d4ed8')
    ax2.plot(8.8, 2.5, 'o', color='#1d4ed8', markersize=8)
    ax2.text(8.8, 2.0, "Out", ha='center', fontsize=8, color='#1d4ed8')
    ax2.plot([6.2, 8.8], [2.5, 2.5], color='#1d4ed8', lw=2)
    ax2.text(7.5, 2.7, "C", ha='center', fontsize=8.5, fontweight='bold', color='#1d4ed8')
    # branch A series B
    ax2.plot([6.2, 7.5], [2.5, 1.6], color='#1d4ed8', lw=1.5)
    ax2.plot([7.5, 8.8], [1.6, 2.5], color='#1d4ed8', lw=1.5)
    ax2.text(6.7, 1.7, "A", fontsize=8, fontweight='bold', color='#1d4ed8')
    ax2.text(8.3, 1.7, "B", fontsize=8, fontweight='bold', color='#1d4ed8')

    # Common Euler Path text
    ax2.text(5.0, 0.6, "Đường đi Euler chung cho cả PUN và PDN: A — B — C\n"
                       "Quy tắc vàng: Nếu tìm được cùng một chuỗi duyệt qua tất cả các cạnh (cực cổng)\n"
                       "thì có thể đặt các đường Polysilicon liên tiếp mà KHÔNG CẦN CẮT VÙNG DIFFUSION!",
             fontsize=8.3, ha='center', color='#065f46',
             bbox=dict(boxstyle='round,pad=0.3', facecolor='#ecfdf5', edgecolor='#10b981'))


    # Subplot 3: Layout Không Tối Ưu (Rời rạc, nhiều vách ngăn diffusion break)
    ax3 = fig.add_subplot(gs[1, 0])
    ax3.set_xlim(0, 10)
    ax3.set_ylim(0, 6)
    ax3.axis('off')
    ax3.set_title("(c) Bố Cục Ngẫu Nhiên: Bị Ngắt Đoạn Diffusion (Xấu)", 
                  fontsize=10, fontweight='bold', color='#b91c1c')

    # Power rails
    ax3.plot([0.5, 9.5], [5.5, 5.5], color='#3b82f6', lw=3.0) # Vdd metal
    ax3.text(0.7, 5.65, "Vdd", fontsize=8, color='#1d4ed8', fontweight='bold')
    ax3.plot([0.5, 9.5], [0.5, 0.5], color='#3b82f6', lw=3.0) # GND metal
    ax3.text(0.7, 0.65, "GND", fontsize=8, color='#1d4ed8', fontweight='bold')

    # Broken p-diffusion
    ax3.add_patch(patches.Rectangle((1.5, 3.8), 2.5, 1.0, facecolor='#fbbf24', edgecolor='#d97706'))
    ax3.add_patch(patches.Rectangle((5.5, 3.8), 3.0, 1.0, facecolor='#fbbf24', edgecolor='#d97706'))
    # Diffusion break gap
    gap1 = patches.Rectangle((4.0, 3.8), 1.5, 1.0, facecolor='#fee2e2', edgecolor='#ef4444', linestyle=':')
    ax3.add_patch(gap1)
    ax3.text(4.75, 4.3, "Khe hở cách ly\n(Diffusion Break)", ha='center', va='center', fontsize=7, color='#b91c1c', fontweight='bold')

    # Broken n-diffusion
    ax3.add_patch(patches.Rectangle((1.5, 1.2), 2.5, 1.0, facecolor='#4ade80', edgecolor='#16a34a'))
    ax3.add_patch(patches.Rectangle((5.5, 1.2), 3.0, 1.0, facecolor='#4ade80', edgecolor='#16a34a'))
    gap2 = patches.Rectangle((4.0, 1.2), 1.5, 1.0, facecolor='#fee2e2', edgecolor='#ef4444', linestyle=':')
    ax3.add_patch(gap2)

    # Poly gates
    for x, lbl in [(2.7, "B"), (6.5, "A"), (7.8, "C")]:
        ax3.plot([x, x], [1.0, 5.0], color='#ef4444', lw=3.5)
        ax3.text(x, 5.15, lbl, ha='center', fontsize=8, fontweight='bold', color='#b91c1c')

    # Consequences box
    ax3.text(5.0, 2.5, "Hậu Quả Kỹ Thuật:\n"
                       "• Phải chừa khoảng cách cách ly DRC giữa các đảo diffusion -> Tốn diện tích chip.\n"
                       "• Cần 2 tiếp xúc (contacts) riêng biệt cho mỗi cực -> Tăng gấp đôi điện dung ký sinh $C_{db}$!\n"
                       "• Điện dung $C_{db}$ lớn làm chậm thời gian xả tụ $\\Delta t = (C_L \\Delta V)/I_{ds}$.",
             fontsize=7.8, color='#7f1d1d', ha='center',
             bbox=dict(boxstyle='round,pad=0.2', facecolor='#fff1f2', edgecolor='#fca5a5'))


    # Subplot 4: Layout Tối Ưu Bằng Đường Đi Euler (Dải Diffusion Liền Mạch)
    ax4 = fig.add_subplot(gs[1, 1])
    ax4.set_xlim(0, 10)
    ax4.set_ylim(0, 6)
    ax4.axis('off')
    ax4.set_title("(d) Bố Cục Euler Tối Ưu: Chia Sẻ Diffusion Liền Mạch (Tốt)", 
                  fontsize=10, fontweight='bold', color='#15803d')

    # Power rails
    ax4.plot([0.5, 9.5], [5.5, 5.5], color='#3b82f6', lw=3.0)
    ax4.text(0.7, 5.65, "Vdd", fontsize=8, color='#1d4ed8', fontweight='bold')
    ax4.plot([0.5, 9.5], [0.5, 0.5], color='#3b82f6', lw=3.0)
    ax4.text(0.7, 0.65, "GND", fontsize=8, color='#1d4ed8', fontweight='bold')

    # Continuous single p-diffusion strip!
    ax4.add_patch(patches.Rectangle((1.5, 3.8), 7.0, 1.0, facecolor='#fbbf24', edgecolor='#d97706'))
    ax4.text(1.0, 4.3, "p-diff", fontsize=7.5, color='#b45309', fontweight='bold')

    # Continuous single n-diffusion strip!
    ax4.add_patch(patches.Rectangle((1.5, 1.2), 7.0, 1.0, facecolor='#4ade80', edgecolor='#16a34a'))
    ax4.text(1.0, 1.7, "n-diff", fontsize=7.5, color='#15803d', fontweight='bold')

    # Poly gates in strict Euler order: A - B - C
    for x, lbl in [(3.2, "A"), (5.0, "B"), (6.8, "C")]:
        ax4.plot([x, x], [1.0, 5.0], color='#ef4444', lw=3.5)
        ax4.text(x, 5.15, lbl, ha='center', fontsize=8.5, fontweight='bold', color='#b91c1c')

    # Shared contact illustration
    ax4.plot(4.1, 4.3, 'x', color='#0f172a', markersize=7, markeredgewidth=2)
    ax4.plot(4.1, 1.7, 'x', color='#0f172a', markersize=7, markeredgewidth=2)
    ax4.text(4.1, 2.9, "Cực Drain/Source dùng chung\n(Single Shared Contact)", ha='center', fontsize=7.5,
             fontweight='bold', color='#15803d')

    # Engineering victory text
    ax4.text(5.0, 0.2, "Đột Phá Kỹ Thuật (Engineering Triumph):\n"
                       "1. Một dải khuếch tán duy nhất xuyên suốt tế bào chuẩn (Standard Cell).\n"
                       "2. Giảm thiểu diện tích tiếp xúc, triệt tiêu 50% điện dung khuếch tán ký sinh $C_{db}$!\n"
                       "3. Tăng tốc độ đáp ứng của toàn bộ vi mạch lên đến 30% mà không tốn thêm công suất.",
             fontsize=7.8, color='#14532d', ha='center',
             bbox=dict(boxstyle='round,pad=0.2', facecolor='#f0fdf4', edgecolor='#86efac'))

    output_path = os.path.join(OUTPUT_DIR, 'fig2_4_stick_diagram_and_euler.png')
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close()
    print(f"Generated: {output_path}")

if __name__ == '__main__':
    print("Generating Chapter 2 Figures...")
    generate_fig1()
    generate_fig2()
    generate_fig3()
    generate_fig4()
    print("All Chapter 2 Figures generated successfully!")
