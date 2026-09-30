# -*- coding: utf-8 -*-
import os
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import numpy as np

# Set high-quality styling
plt.rcParams['font.sans-serif'] = 'Arial'
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['axes.edgecolor'] = '#334155'
plt.rcParams['axes.linewidth'] = 1.0

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), '..', 'book', 'images')
os.makedirs(OUTPUT_DIR, exist_ok=True)

# -------------------------------------------------------------
# Reusable Standard IEEE MOSFET Drawing Function
# -------------------------------------------------------------
def draw_mosfet(ax, x, y, mos_type='n_enh', source_at='bottom', gate_dir='left', 
                h=1.2, gap=0.25, lead_len=0.5, label_terminals=False, color='#0f172a', lw=1.8):
    """
    Standard IEEE MOSFET symbol:
    - Channel: single continuous vertical bar (enhancement) or thick solid bar (depletion)
    - Gate: parallel vertical plate separated by gap
    - Inversion bubble for pMOS
    - Substrate/bulk arrow: pointing IN for nMOS, OUT for pMOS
    - Clearly readable D, G, S terminal labels
    """
    # 1. Channel plate
    if mos_type == 'n_dep':
        ax.plot([x, x], [y - h/2, y + h/2], color=color, lw=lw*2.8, solid_capstyle='butt', zorder=4)
    else:
        ax.plot([x, x], [y - h/2, y + h/2], color=color, lw=lw, solid_capstyle='butt', zorder=4)

    # 2. Source and Drain leads
    top_lead_y = y + h/2 + lead_len
    bot_lead_y = y - h/2 - lead_len
    ax.plot([x, x], [y + h/2, top_lead_y], color=color, lw=lw, zorder=4)
    ax.plot([x, x], [y - h/2, bot_lead_y], color=color, lw=lw, zorder=4)

    # 3. Gate plate & lead
    xg = x - gap if gate_dir == 'left' else x + gap
    ax.plot([xg, xg], [y - h/2, y + h/2], color=color, lw=lw, solid_capstyle='butt', zorder=4)

    g_lead_len = 0.45
    if mos_type == 'p_enh':
        rbub = 0.11
        xbub = xg - rbub if gate_dir == 'left' else xg + rbub
        bub = patches.Circle((xbub, y), rbub, facecolor='white', edgecolor=color, lw=lw, zorder=5)
        ax.add_patch(bub)
        x_start = xbub - rbub if gate_dir == 'left' else xbub + rbub
        ax.plot([x_start, x_start - g_lead_len], [y, y], color=color, lw=lw, zorder=4)
        gate_term = (x_start - g_lead_len, y)
    else:
        x_start = xg
        ax.plot([x_start, x_start - g_lead_len], [y, y], color=color, lw=lw, zorder=4)
        gate_term = (x_start - g_lead_len, y)

    # 4. Bulk / Substrate arrow
    arrow_len = 0.22
    if mos_type in ['n_enh', 'n_dep']:
        # Arrow pointing IN to channel
        ax.annotate('', xy=(x, y), xytext=(x - arrow_len, y),
                    arrowprops=dict(arrowstyle='->,head_width=0.22,head_length=0.22', color=color, lw=lw), zorder=5)
    else:
        # Arrow pointing OUT from channel
        ax.annotate('', xy=(x - arrow_len, y), xytext=(x, y),
                    arrowprops=dict(arrowstyle='->,head_width=0.22,head_length=0.22', color=color, lw=lw), zorder=5)

    # 5. Terminal Labels (D, G, S)
    if label_terminals:
        if source_at == 'bottom':
            ax.text(x + 0.16, y + h/2 + 0.15, 'D', fontsize=8.5, fontweight='bold', color='#1e3a8a', va='center')
            ax.text(x + 0.16, y - h/2 - 0.18, 'S', fontsize=8.5, fontweight='bold', color='#15803d', va='center')
        else:
            ax.text(x + 0.16, y + h/2 + 0.15, 'S', fontsize=8.5, fontweight='bold', color='#15803d', va='center')
            ax.text(x + 0.16, y - h/2 - 0.18, 'D', fontsize=8.5, fontweight='bold', color='#1e3a8a', va='center')
        gx = gate_term[0] - 0.12
        ax.text(gx, y + 0.18, 'G', fontsize=8.5, fontweight='bold', color='#7c3aed', ha='right', va='center')

    d_coord = (x, top_lead_y if source_at == 'bottom' else bot_lead_y)
    s_coord = (x, bot_lead_y if source_at == 'bottom' else top_lead_y)
    return {'D': d_coord, 'S': s_coord, 'G': gate_term, 'center': (x, y)}

# -------------------------------------------------------------
# Figure 1: Silicon Layout Layers & Latch-up Mechanism
# -------------------------------------------------------------
def generate_fig1():
    fig = plt.figure(figsize=(16, 7.2), dpi=300)
    gs = fig.add_gridspec(1, 2, width_ratios=[1.25, 1.0], wspace=0.18)

    # Subplot 1: Microscopic Cross-Section of CMOS Inverter
    ax1 = fig.add_subplot(gs[0])
    ax1.set_xlim(0, 12)
    ax1.set_ylim(0, 8.5)
    ax1.axis('off')
    ax1.set_title('(a) Mặt Cắt Lớp Vật Lý Silicon & Cấu Trúc Bố Cục CMOS Inverter', 
                  fontsize=11.5, fontweight='bold', pad=12, color='#0f172a')

    # Substrate (p-sub)
    sub = patches.Rectangle((0.5, 0.8), 11.0, 4.2, facecolor='#ffedd5', edgecolor='#ea580c', lw=1.5)
    ax1.add_patch(sub)
    ax1.text(1.8, 1.2, r'Đế Silicon loại p (p-substrate / $N_A$)', fontsize=9.5, fontweight='bold', color='#9a3412')

    # N-Well
    nwell = patches.Rectangle((5.8, 1.8), 5.5, 3.2, facecolor='#dbeafe', edgecolor='#2563eb', lw=1.5)
    ax1.add_patch(nwell)
    ax1.text(8.5, 2.2, r'Giếng n (N-well / $N_D$)', fontsize=9.5, fontweight='bold', color='#1d4ed8')

    # STRICT SEQUENCE OF REGIONS (Left to Right):
    # 1. Left Edge STI
    sti_left = patches.Rectangle((0.5, 4.2), 0.8, 0.8, facecolor='#e2e8f0', edgecolor='#64748b', lw=1.0, hatch='//')
    ax1.add_patch(sti_left)
    ax1.text(0.9, 4.6, 'STI', fontsize=7.5, color='#475569', ha='center', va='center')

    # 2. p+ Sub Tap (GND)
    p_tap = patches.Rectangle((1.4, 4.0), 0.7, 1.0, facecolor='#fed7aa', edgecolor='#c2410c', lw=1.2)
    ax1.add_patch(p_tap)
    ax1.text(1.75, 4.5, 'p+', fontsize=8.5, fontweight='bold', color='#9a3412', ha='center', va='center')
    ax1.text(1.75, 3.7, 'Sub Tap', fontsize=7.5, color='#7c2d12', ha='center')

    # Small STI between Tap and Source
    sti_mid1 = patches.Rectangle((2.2, 4.2), 0.5, 0.8, facecolor='#e2e8f0', edgecolor='#64748b', lw=1.0, hatch='//')
    ax1.add_patch(sti_mid1)
    ax1.text(2.45, 4.6, 'STI', fontsize=7.0, color='#475569', ha='center', va='center')

    # 3. nMOS Source (n+)
    n_src = patches.Rectangle((2.8, 4.0), 0.7, 1.0, facecolor='#bbf7d0', edgecolor='#16a34a', lw=1.2)
    ax1.add_patch(n_src)
    ax1.text(3.15, 4.5, 'n+', fontsize=8.5, fontweight='bold', color='#14532d', ha='center', va='center')
    ax1.text(3.15, 3.7, 'Source', fontsize=7.5, color='#14532d', ha='center')

    # 4. nMOS Channel & Gate (NO STI BETWEEN S AND D!)
    ox_n = patches.Rectangle((3.5, 5.0), 1.2, 0.25, facecolor='#fef08a', edgecolor='#ca8a04')
    ax1.add_patch(ox_n)
    chan_n = patches.Rectangle((3.5, 4.6), 1.2, 0.4, facecolor='#dcfce7', edgecolor='#86efac', linestyle=':', lw=1.0)
    ax1.add_patch(chan_n)
    ax1.text(4.1, 4.78, 'Kênh n', fontsize=7.5, color='#15803d', ha='center', va='center')
    poly_n = patches.Rectangle((3.65, 5.25), 0.9, 0.7, facecolor='#fecaca', edgecolor='#dc2626', lw=1.5)
    ax1.add_patch(poly_n)
    ax1.text(4.1, 5.6, 'Gate (n)', fontsize=8, fontweight='bold', color='#991b1b', ha='center', va='center')

    # 5. nMOS Drain (n+)
    n_drn = patches.Rectangle((4.7, 4.0), 0.7, 1.0, facecolor='#bbf7d0', edgecolor='#16a34a', lw=1.2)
    ax1.add_patch(n_drn)
    ax1.text(5.05, 4.5, 'n+', fontsize=8.5, fontweight='bold', color='#14532d', ha='center', va='center')
    ax1.text(5.05, 3.7, 'Drain', fontsize=7.5, color='#14532d', ha='center')

    # 6. STI Phân cách giếng (between nMOS and pMOS, crossing well boundary at x=5.8)
    sti_well = patches.Rectangle((5.5, 4.2), 1.0, 0.8, facecolor='#e2e8f0', edgecolor='#64748b', lw=1.0, hatch='//')
    ax1.add_patch(sti_well)
    ax1.text(6.0, 4.6, 'STI Giếng', fontsize=7.5, color='#475569', ha='center', va='center')

    # 7. pMOS Drain (p+)
    p_drn = patches.Rectangle((6.6, 4.0), 0.7, 1.0, facecolor='#fed7aa', edgecolor='#c2410c', lw=1.2)
    ax1.add_patch(p_drn)
    ax1.text(6.95, 4.5, 'p+', fontsize=8.5, fontweight='bold', color='#9a3412', ha='center', va='center')
    ax1.text(6.95, 3.7, 'Drain', fontsize=7.5, color='#7c2d12', ha='center')

    # 8. pMOS Channel & Gate (NO STI BETWEEN D AND S!)
    ox_p = patches.Rectangle((7.3, 5.0), 1.2, 0.25, facecolor='#fef08a', edgecolor='#ca8a04')
    ax1.add_patch(ox_p)
    chan_p = patches.Rectangle((7.3, 4.6), 1.2, 0.4, facecolor='#fee2e2', edgecolor='#fca5a5', linestyle=':', lw=1.0)
    ax1.add_patch(chan_p)
    ax1.text(7.9, 4.78, 'Kênh p', fontsize=7.5, color='#b91c1c', ha='center', va='center')
    poly_p = patches.Rectangle((7.45, 5.25), 0.9, 0.7, facecolor='#fecaca', edgecolor='#dc2626', lw=1.5)
    ax1.add_patch(poly_p)
    ax1.text(7.9, 5.6, 'Gate (p)', fontsize=8, fontweight='bold', color='#991b1b', ha='center', va='center')

    # 9. pMOS Source (p+)
    p_src = patches.Rectangle((8.5, 4.0), 0.7, 1.0, facecolor='#fed7aa', edgecolor='#c2410c', lw=1.2)
    ax1.add_patch(p_src)
    ax1.text(8.85, 4.5, 'p+', fontsize=8.5, fontweight='bold', color='#9a3412', ha='center', va='center')
    ax1.text(8.85, 3.7, 'Source', fontsize=7.5, color='#7c2d12', ha='center')

    # Small STI between Source and Well Tap
    sti_mid2 = patches.Rectangle((9.3, 4.2), 0.5, 0.8, facecolor='#e2e8f0', edgecolor='#64748b', lw=1.0, hatch='//')
    ax1.add_patch(sti_mid2)
    ax1.text(9.55, 4.6, 'STI', fontsize=7.0, color='#475569', ha='center', va='center')

    # 10. n+ Well Tap (VDD)
    n_tap = patches.Rectangle((9.9, 4.0), 0.7, 1.0, facecolor='#bbf7d0', edgecolor='#16a34a', lw=1.2)
    ax1.add_patch(n_tap)
    ax1.text(10.25, 4.5, 'n+', fontsize=8.5, fontweight='bold', color='#14532d', ha='center', va='center')
    ax1.text(10.25, 3.7, 'Well Tap', fontsize=7.5, color='#14532d', ha='center')

    # 11. Right Edge STI
    sti_right = patches.Rectangle((10.7, 4.2), 0.8, 0.8, facecolor='#e2e8f0', edgecolor='#64748b', lw=1.0, hatch='//')
    ax1.add_patch(sti_right)
    ax1.text(11.1, 4.6, 'STI', fontsize=7.5, color='#475569', ha='center', va='center')

    # Interconnects & Rails
    ax1.plot([1.2, 3.5], [7.3, 7.3], color='#15803d', lw=4)
    ax1.text(2.35, 7.6, 'GND (0V)', fontsize=9.5, fontweight='bold', color='#15803d', ha='center')
    ax1.plot([1.75, 1.75], [5.0, 7.3], color='#15803d', lw=2, linestyle=':')
    ax1.plot([3.15, 3.15], [5.0, 7.3], color='#15803d', lw=2, linestyle=':')

    ax1.plot([8.5, 10.7], [7.3, 7.3], color='#b91c1c', lw=4)
    ax1.text(9.6, 7.6, 'Vdd (+1.0V)', fontsize=9.5, fontweight='bold', color='#b91c1c', ha='center')
    ax1.plot([8.85, 8.85], [5.0, 7.3], color='#b91c1c', lw=2, linestyle=':')
    ax1.plot([10.25, 10.25], [5.0, 7.3], color='#b91c1c', lw=2, linestyle=':')

    ax1.plot([4.1, 4.1, 6.0, 7.9, 7.9], [5.95, 6.7, 6.7, 6.7, 5.95], color='#7c3aed', lw=2.2)
    ax1.plot([6.0, 6.0], [6.7, 7.5], color='#7c3aed', lw=2.5)
    ax1.scatter([6.0], [7.5], s=40, color='#7c3aed', zorder=5)
    ax1.text(6.0, 7.8, 'Vin', fontsize=10, fontweight='bold', color='#6d28d9', ha='center')

    ax1.plot([5.05, 5.05, 6.0, 6.95, 6.95], [5.0, 6.2, 6.2, 6.2, 5.0], color='#0284c7', lw=2.2)
    ax1.plot([6.0, 6.0], [6.2, 5.4], color='#0284c7', lw=2.5)
    ax1.scatter([6.0], [5.4], s=40, color='#0284c7', zorder=5)
    ax1.text(6.0, 5.1, 'Vout', fontsize=10, fontweight='bold', color='#0369a1', ha='center')

    ax1.text(4.1, 3.1, 'Transistor nMOS\n(Kênh n trên đế p-sub)', fontsize=8.5, ha='center', color='#047857', fontweight='bold')
    ax1.text(7.9, 3.1, 'Transistor pMOS\n(Kênh p trong N-well)', fontsize=8.5, ha='center', color='#b91c1c', fontweight='bold')

    # Subplot 2: Parasitic SCR Latch-up Mechanism
    ax2 = fig.add_subplot(gs[1])
    ax2.set_xlim(0, 10)
    ax2.set_ylim(0, 8.5)
    ax2.axis('off')
    ax2.set_title('(b) Cấu Trúc BJT Ký Sinh Latch-up (SCR Thyristor) & Guard Rings', 
                  fontsize=11.5, fontweight='bold', pad=12, color='#0f172a')

    latch_box = patches.FancyBboxPatch((0.5, 0.8), 9.0, 7.0, boxstyle='round,pad=0.2',
                                        facecolor='#fff7ed', edgecolor='#ea580c', lw=1.5)
    ax2.add_patch(latch_box)

    ax2.plot([2.5, 4.5], [7.3, 7.3], color='#b91c1c', lw=3.5)
    ax2.text(3.5, 7.55, 'Vdd', fontsize=10, fontweight='bold', color='#b91c1c', ha='center')

    q1_circ = patches.Circle((3.5, 5.8), 0.7, facecolor='#fee2e2', edgecolor='#dc2626', lw=1.5)
    ax2.add_patch(q1_circ)
    ax2.text(3.5, 5.8, 'Q1\n(PNP)', fontsize=8.5, fontweight='bold', color='#991b1b', ha='center', va='center')

    q2_circ = patches.Circle((6.5, 3.4), 0.7, facecolor='#dbeafe', edgecolor='#2563eb', lw=1.5)
    ax2.add_patch(q2_circ)
    ax2.text(6.5, 3.4, 'Q2\n(NPN)', fontsize=8.5, fontweight='bold', color='#1e40af', ha='center', va='center')

    ax2.plot([3.5, 3.5], [6.5, 7.3], color='#b91c1c', lw=2)

    rwell = patches.Rectangle((1.5, 5.3), 0.8, 1.3, facecolor='#ffedd5', edgecolor='#c2410c')
    ax2.add_patch(rwell)
    ax2.text(1.9, 5.95, 'R_well', fontsize=8, fontweight='bold', color='#9a3412', ha='center', va='center')
    ax2.plot([1.9, 1.9, 3.5], [7.3, 6.8, 6.8], color='#b91c1c', lw=1.8)
    ax2.plot([1.9, 2.8], [5.3, 5.3], color='#b91c1c', lw=1.8)

    ax2.plot([6.5, 6.5, 2.8], [4.1, 5.3, 5.3], color='#dc2626', lw=1.8)
    ax2.annotate('', xy=(3.0, 5.3), xytext=(4.5, 5.3), arrowprops=dict(arrowstyle='->', color='#dc2626', lw=2))

    ax2.plot([3.5, 3.5, 7.2], [5.1, 3.9, 3.9], color='#2563eb', lw=1.8)
    ax2.annotate('', xy=(7.0, 3.9), xytext=(5.5, 3.9), arrowprops=dict(arrowstyle='->', color='#2563eb', lw=2))

    rsub = patches.Rectangle((7.7, 2.4), 0.8, 1.3, facecolor='#ffedd5', edgecolor='#c2410c')
    ax2.add_patch(rsub)
    ax2.text(8.1, 3.05, 'R_sub', fontsize=8, fontweight='bold', color='#9a3412', ha='center', va='center')

    # GND rail at y=2.0 for Q2 emitter and Rsub (keeping lower area clear for notes)
    ax2.plot([5.8, 8.5], [2.1, 2.1], color='#15803d', lw=3.0)
    ax2.text(7.15, 1.85, 'GND (0V)', fontsize=9.5, fontweight='bold', color='#15803d', ha='center')
    ax2.plot([8.1, 8.1], [2.1, 2.4], color='#15803d', lw=1.8)
    ax2.plot([6.5, 6.5], [2.7, 2.1], color='#15803d', lw=2)
    ax2.plot([7.2, 7.7], [3.9, 3.9], color='#15803d', lw=1.8)

    ax2.text(5.0, 4.6, 'Vòng hồi tiếp dương tự kích (SCR Positive Feedback):\n'
                        r'$\Delta V_{sub} > 0.7\text{V} \rightarrow Q_2\text{ BẬT} \rightarrow I_{C2} \uparrow$' + '\n'
                        r'$\rightarrow Q_1\text{ BẬT} \rightarrow I_{C1} \uparrow\uparrow \rightarrow \beta_1 \cdot \beta_2 \geq 1$' + '\n'
                        'Dòng ngắn mạch lớn Vdd sang GND gây sụp nguồn & cháy chip!',
             fontsize=8.0, color='#7f1d1d', ha='center', va='center',
             bbox=dict(boxstyle='round,pad=0.35', facecolor='#fee2e2', edgecolor='#ef4444', lw=1.2))

    ax2.text(5.0, 1.0, '[Giải Pháp] Guard Rings (Vòng Cách Ly Bố Cục):\n'
                        'Cấy vòng tiếp xúc p+ (nối GND) quanh nMOS & n+ (nối Vdd) quanh pMOS\n'
                        r'để thu gom hạt dẫn rò và triệt tiêu $R_{sub}, R_{well} \rightarrow 0$.',
             fontsize=7.8, color='#14532d', ha='center', va='center',
             bbox=dict(boxstyle='round,pad=0.3', facecolor='#dcfce7', edgecolor='#22c55e', lw=1.0))

    fig.subplots_adjust(left=0.04, right=0.96, top=0.92, bottom=0.04, wspace=0.18)
    fig.savefig(os.path.join(OUTPUT_DIR, 'fig_inv_1_silicon_layers_and_latchup.png'), dpi=300)
    plt.close(fig)
    print('Generated: fig_inv_1_silicon_layers_and_latchup.png')


# -------------------------------------------------------------
# Figure 2: Inverter Classes and Topologies (6 separate panels 2x3)
# -------------------------------------------------------------
def generate_fig2():
    fig, axes = plt.subplots(2, 3, figsize=(18, 12.0), dpi=300)
    axes = axes.flatten()

    titles = [
        '(a) Inverter Tải Điện Trở (Resistive Load)',
        '(b) Inverter nMOS Tải Suy Giảm (Depletion nMOS)',
        '(c) Inverter CMOS Tĩnh Bổ Sung (Static CMOS)',
        '(d) Inverter Giả nMOS (Pseudo-nMOS)',
        r'(e) Inverter $C^2\mathrm{MOS}$ / Tri-state',
        '(f) Inverter Động (Dynamic CMOS Logic)'
    ]

    for i, ax in enumerate(axes):
        ax.set_xlim(0, 10)
        ax.set_ylim(0, 10)
        ax.axis('off')
        ax.set_title(titles[i], fontsize=11, fontweight='bold', pad=10, color='#0f172a')

        # Synchronous VDD (top) and GND (bottom) rails
        ax.plot([1.5, 8.5], [9.3, 9.3], color='#b91c1c', lw=2.5)
        ax.text(5.0, 9.55, 'VDD', fontsize=10, fontweight='bold', color='#b91c1c', ha='center')

        ax.plot([1.5, 8.5], [2.7, 2.7], color='#15803d', lw=2.5)
        ax.text(5.0, 2.40, 'GND', fontsize=10, fontweight='bold', color='#15803d', ha='center')

        if i == 0:
            # (a) Resistive Load
            res = patches.Rectangle((4.5, 6.7), 1.0, 1.8, facecolor='#fef3c7', edgecolor='#d97706', lw=1.5)
            ax.add_patch(res)
            ax.text(5.0, 7.6, '$R_L$', fontsize=10.5, fontweight='bold', color='#b45309', ha='center', va='center')
            ax.plot([5.0, 5.0], [8.5, 9.3], color='#334155', lw=1.8)
            ax.plot([5.0, 5.0], [5.6, 6.7], color='#334155', lw=1.8)

            ax.plot([5.0, 7.8], [5.8, 5.8], color='#0284c7', lw=2.0)
            ax.scatter([7.8], [5.8], color='#0284c7', s=40, zorder=5)
            ax.text(8.0, 5.8, '$V_{out}$', fontsize=10, fontweight='bold', color='#0284c7', va='center')

            t1 = draw_mosfet(ax, 5.0, 4.3, mos_type='n_enh', source_at='bottom', gate_dir='left',
                             h=1.2, label_terminals=True)
            ax.plot([5.0, 5.0], [t1['D'][1], 5.8], color='#334155', lw=1.8)
            ax.plot([5.0, 5.0], [t1['S'][1], 2.7], color='#334155', lw=1.8)

            ax.plot([2.0, t1['G'][0]], [t1['G'][1], t1['G'][1]], color='#7c3aed', lw=2.0)
            ax.scatter([2.0], [t1['G'][1]], color='#7c3aed', s=35, zorder=5)
            ax.text(1.7, t1['G'][1], '$V_{in}$', fontsize=10, fontweight='bold', color='#7c3aed', va='center', ha='right')

            ax.text(5.0, 1.15, '[-] Dòng tĩnh: $I_{static} = V_{DD}/(R_L + R_{on})$ khi $V_{in}=1$\n'
                               '[-] $V_{OL} > 0$ phụ thuộc phân áp $R_L$ và $R_{on}$\n'
                               '[-] Diện tích $R_L$ trên silicon cực lớn ($>100\\times$ MOSFET)',
                    fontsize=8.0, color='#991b1b', ha='center',
                    bbox=dict(boxstyle='round,pad=0.3', facecolor='#fee2e2', edgecolor='#ef4444'))

        elif i == 1:
            # (b) Depletion nMOS Load
            t_load = draw_mosfet(ax, 5.0, 7.4, mos_type='n_dep', source_at='bottom', gate_dir='left',
                                 h=1.2, label_terminals=True)
            ax.plot([5.0, 5.0], [t_load['D'][1], 9.3], color='#334155', lw=1.8)

            ax.plot([t_load['G'][0], 3.6, 3.6, 5.0], [t_load['G'][1], t_load['G'][1], 6.1, 6.1], color='#334155', lw=1.6)
            ax.scatter([5.0], [6.1], color='#334155', s=25, zorder=5)
            ax.text(3.4, 7.4, '$V_{GS}=0$\n($V_t < 0$)', fontsize=7.8, color='#1e3a8a', ha='right', va='center')

            ax.plot([5.0, 7.8], [5.8, 5.8], color='#0284c7', lw=2.0)
            ax.scatter([7.8], [5.8], color='#0284c7', s=40, zorder=5)
            ax.text(8.0, 5.8, '$V_{out}$', fontsize=10, fontweight='bold', color='#0284c7', va='center')

            t_drv = draw_mosfet(ax, 5.0, 4.3, mos_type='n_enh', source_at='bottom', gate_dir='left',
                                h=1.2, label_terminals=True)
            ax.plot([5.0, 5.0], [t_drv['D'][1], 5.8], color='#334155', lw=1.8)
            ax.plot([5.0, 5.0], [t_drv['S'][1], 2.7], color='#334155', lw=1.8)

            ax.plot([2.0, t_drv['G'][0]], [t_drv['G'][1], t_drv['G'][1]], color='#7c3aed', lw=2.0)
            ax.scatter([2.0], [t_drv['G'][1]], color='#7c3aed', s=35, zorder=5)
            ax.text(1.7, t_drv['G'][1], '$V_{in}$', fontsize=10, fontweight='bold', color='#7c3aed', va='center', ha='right')

            ax.text(5.0, 1.15, '[+] Nguồn dòng chủ động kéo lên nhanh hơn $R_L$\n'
                               '[-] Vẫn tốn công suất tĩnh $I_{static}$ khi $V_{in}=1$\n'
                               '[-] Cần thêm bước cấy ion tạo $V_t < 0$ (tăng giá thành)',
                    fontsize=8.0, color='#854d0e', ha='center',
                    bbox=dict(boxstyle='round,pad=0.3', facecolor='#fef9c3', edgecolor='#facc15'))

        elif i == 2:
            # (c) Static Complementary CMOS
            tp = draw_mosfet(ax, 5.0, 7.4, mos_type='p_enh', source_at='top', gate_dir='left',
                             h=1.2, label_terminals=True)
            ax.plot([5.0, 5.0], [tp['S'][1], 9.3], color='#334155', lw=1.8)

            ax.plot([5.0, 7.8], [5.8, 5.8], color='#0284c7', lw=2.0)
            ax.scatter([7.8], [5.8], color='#0284c7', s=40, zorder=5)
            ax.text(8.0, 5.8, '$V_{out}$', fontsize=10, fontweight='bold', color='#0284c7', va='center')

            tn = draw_mosfet(ax, 5.0, 4.3, mos_type='n_enh', source_at='bottom', gate_dir='left',
                             h=1.2, label_terminals=True)
            ax.plot([5.0, 5.0], [tp['D'][1], tn['D'][1]], color='#334155', lw=1.8)
            ax.plot([5.0, 5.0], [tn['S'][1], 2.7], color='#334155', lw=1.8)

            ax.plot([tp['G'][0], 2.8, 2.8, tn['G'][0]], [tp['G'][1], tp['G'][1], tn['G'][1], tn['G'][1]], color='#7c3aed', lw=2.0)
            ax.plot([2.0, 2.8], [5.8, 5.8], color='#7c3aed', lw=2.0)
            ax.scatter([2.0], [5.8], color='#7c3aed', s=35, zorder=5)
            ax.text(1.7, 5.8, '$V_{in}$', fontsize=10, fontweight='bold', color='#7c3aed', va='center', ha='right')

            ax.text(5.0, 1.15, '[+] Biên độ logic toàn phần (Rail-to-Rail: $0\\text{V} - V_{DD}$)\n'
                               '[+] Công suất tĩnh triệt tiêu: $I_{static} \\approx 0$ (chỉ có dòng rò)\n'
                               '[+] Độ dự trữ tạp âm cao ($NM_L, NM_H \\approx 0.4 V_{DD}$)',
                    fontsize=8.0, color='#14532d', ha='center',
                    bbox=dict(boxstyle='round,pad=0.3', facecolor='#dcfce7', edgecolor='#22c55e'))

        elif i == 3:
            # (d) Pseudo-nMOS
            tp = draw_mosfet(ax, 5.0, 7.4, mos_type='p_enh', source_at='top', gate_dir='left',
                             h=1.2, label_terminals=True)
            ax.plot([5.0, 5.0], [tp['S'][1], 9.3], color='#334155', lw=1.8)

            ax.plot([tp['G'][0], 3.2, 3.2], [tp['G'][1], tp['G'][1], 2.9], color='#15803d', lw=1.8)
            ax.plot([3.2, 3.2], [2.9, 2.7], color='#15803d', lw=2.5)
            ax.scatter([3.2], [2.7], color='#15803d', s=30, zorder=5)
            ax.text(3.0, 7.4, '$V_{GS,p}=-V_{DD}$\n(Luôn BẬT)', fontsize=7.8, color='#991b1b', ha='right', va='center')

            ax.plot([5.0, 7.8], [5.8, 5.8], color='#0284c7', lw=2.0)
            ax.scatter([7.8], [5.8], color='#0284c7', s=40, zorder=5)
            ax.text(8.0, 5.8, '$V_{out}$', fontsize=10, fontweight='bold', color='#0284c7', va='center')

            tn = draw_mosfet(ax, 5.0, 4.3, mos_type='n_enh', source_at='bottom', gate_dir='left',
                             h=1.2, label_terminals=True)
            ax.plot([5.0, 5.0], [tp['D'][1], tn['D'][1]], color='#334155', lw=1.8)
            ax.plot([5.0, 5.0], [tn['S'][1], 2.7], color='#334155', lw=1.8)

            ax.plot([2.0, tn['G'][0]], [tn['G'][1], tn['G'][1]], color='#7c3aed', lw=2.0)
            ax.scatter([2.0], [tn['G'][1]], color='#7c3aed', s=35, zorder=5)
            ax.text(1.7, tn['G'][1], '$V_{in}$', fontsize=10, fontweight='bold', color='#7c3aed', va='center', ha='right')

            ax.text(5.0, 1.15, '[+] Giảm tải điện dung ngõ vào (chỉ 1 cổng nMOS)\n'
                               r'[!] Phải định cỡ $\beta_n / \beta_p \geq 4$ để ép $V_{OL} \leq 0.1 V_{DD}$' + '\n'
                               '[-] Dòng tĩnh lớn khi $V_{in}=1$ do pMOS luôn dẫn',
                    fontsize=8.0, color='#854d0e', ha='center',
                    bbox=dict(boxstyle='round,pad=0.3', facecolor='#fef9c3', edgecolor='#facc15'))

        elif i == 4:
            # (e) C2MOS / Tri-state Inverter
            m1 = draw_mosfet(ax, 5.0, 8.0, mos_type='p_enh', source_at='top', gate_dir='left',
                             h=0.85, lead_len=0.30, label_terminals=False)
            ax.plot([5.0, 5.0], [m1['S'][1], 9.3], color='#334155', lw=1.8)
            ax.text(5.8, 8.0, '$M_1$ (pMOS)', fontsize=7.5, color='#991b1b', va='center')

            m2 = draw_mosfet(ax, 5.0, 6.6, mos_type='p_enh', source_at='top', gate_dir='left',
                             h=0.85, lead_len=0.30, label_terminals=False)
            ax.plot([5.0, 5.0], [m1['D'][1], m2['S'][1]], color='#334155', lw=1.8)
            ax.text(5.8, 6.6, '$M_2$ (pMOS)', fontsize=7.5, color='#991b1b', va='center')

            ax.plot([5.0, 7.8], [5.6, 5.6], color='#0284c7', lw=2.0)
            ax.scatter([7.8], [5.6], color='#0284c7', s=40, zorder=5)
            ax.text(8.0, 5.6, '$V_{out}$', fontsize=10, fontweight='bold', color='#0284c7', va='center')

            m3 = draw_mosfet(ax, 5.0, 4.6, mos_type='n_enh', source_at='bottom', gate_dir='left',
                             h=0.85, lead_len=0.30, label_terminals=False)
            ax.plot([5.0, 5.0], [m2['D'][1], m3['D'][1]], color='#334155', lw=1.8)
            ax.text(5.8, 4.6, '$M_3$ (nMOS)', fontsize=7.5, color='#15803d', va='center')

            m4 = draw_mosfet(ax, 5.0, 3.3, mos_type='n_enh', source_at='bottom', gate_dir='left',
                             h=0.85, lead_len=0.25, label_terminals=True)
            ax.plot([5.0, 5.0], [m3['S'][1], m4['D'][1]], color='#334155', lw=1.8)
            ax.plot([5.0, 5.0], [m4['S'][1], 2.7], color='#334155', lw=1.8)
            ax.text(5.8, 3.3, '$M_4$ (nMOS)', fontsize=7.5, color='#15803d', va='center')

            ax.plot([2.5, m2['G'][0]], [m2['G'][1], m2['G'][1]], color='#ea580c', lw=1.8)
            ax.scatter([2.5], [m2['G'][1]], color='#ea580c', s=30, zorder=5)
            ax.text(2.3, m2['G'][1], r'$\overline{\mathrm{CLK}}$', fontsize=9.0, fontweight='bold', color='#ea580c', va='center', ha='right')

            ax.plot([2.5, m3['G'][0]], [m3['G'][1], m3['G'][1]], color='#ea580c', lw=1.8)
            ax.scatter([2.5], [m3['G'][1]], color='#ea580c', s=30, zorder=5)
            ax.text(2.3, m3['G'][1], r'$\mathrm{CLK}$', fontsize=9.0, fontweight='bold', color='#ea580c', va='center', ha='right')

            ax.plot([m1['G'][0], 1.8, 1.8, m4['G'][0]], [m1['G'][1], m1['G'][1], m4['G'][1], m4['G'][1]], color='#7c3aed', lw=1.8)
            ax.plot([1.2, 1.8], [5.6, 5.6], color='#7c3aed', lw=2.0)
            ax.scatter([1.2], [5.6], color='#7c3aed', s=35, zorder=5)
            ax.text(1.0, 5.6, '$V_{in}$', fontsize=9.5, fontweight='bold', color='#7c3aed', va='center', ha='right')

            ax.text(5.0, 1.15, '[+] Khi CLK=1: Đảo trạng thái logic bình thường\n'
                               '[+] Khi CLK=0: Ngõ ra trở kháng cao (High-Z / Treo lơ lửng)\n'
                               '[+] Miễn nhiễm tranh chấp xung (Clock skew immune)',
                    fontsize=7.8, color='#1e3a8a', ha='center',
                    bbox=dict(boxstyle='round,pad=0.3', facecolor='#eff6ff', edgecolor='#93c5fd'))

        elif i == 5:
            # (f) Dynamic CMOS
            tp_dyn = draw_mosfet(ax, 5.0, 7.4, mos_type='p_enh', source_at='top', gate_dir='left',
                                 h=1.1, label_terminals=True)
            ax.plot([5.0, 5.0], [tp_dyn['S'][1], 9.3], color='#334155', lw=1.8)
            ax.text(5.8, 7.4, 'Precharge\n($M_{pre}$)', fontsize=7.8, color='#991b1b', va='center')

            ax.plot([2.5, tp_dyn['G'][0]], [tp_dyn['G'][1], tp_dyn['G'][1]], color='#ea580c', lw=1.8)
            ax.scatter([2.5], [tp_dyn['G'][1]], color='#ea580c', s=30, zorder=5)
            ax.text(2.3, tp_dyn['G'][1], r'$\phi$', fontsize=10, fontweight='bold', color='#ea580c', va='center', ha='right')

            ax.plot([5.0, 7.8], [5.8, 5.8], color='#0284c7', lw=2.0)
            ax.scatter([7.8], [5.8], color='#0284c7', s=40, zorder=5)
            ax.text(8.0, 5.8, '$V_{out}$', fontsize=10, fontweight='bold', color='#0284c7', va='center')

            # Load Capacitor CL
            ax.plot([7.0, 7.0], [5.8, 4.8], color='#0284c7', lw=1.5)
            cap_top = patches.Rectangle((6.7, 4.7), 0.6, 0.1, facecolor='#0284c7')
            cap_bot = patches.Rectangle((6.7, 4.4), 0.6, 0.1, facecolor='#0284c7')
            ax.add_patch(cap_top)
            ax.add_patch(cap_bot)
            ax.plot([7.0, 7.0], [4.4, 3.8], color='#15803d', lw=1.5)
            ax.plot([6.7, 7.3], [3.8, 3.8], color='#15803d', lw=1.5)
            ax.text(7.4, 4.55, '$C_L$', fontsize=8.5, fontweight='bold', color='#0284c7', va='center')

            tn_logic = draw_mosfet(ax, 5.0, 4.6, mos_type='n_enh', source_at='bottom', gate_dir='left',
                                   h=0.95, label_terminals=False)
            ax.plot([5.0, 5.0], [tp_dyn['D'][1], tn_logic['D'][1]], color='#334155', lw=1.8)
            ax.text(5.8, 4.6, 'Logic nMOS\n($M_{in}$)', fontsize=7.8, color='#15803d', va='center')

            ax.plot([2.5, tn_logic['G'][0]], [tn_logic['G'][1], tn_logic['G'][1]], color='#7c3aed', lw=1.8)
            ax.scatter([2.5], [tn_logic['G'][1]], color='#7c3aed', s=30, zorder=5)
            ax.text(2.3, tn_logic['G'][1], '$V_{in}$', fontsize=9.5, fontweight='bold', color='#7c3aed', va='center', ha='right')

            tn_eval = draw_mosfet(ax, 5.0, 3.3, mos_type='n_enh', source_at='bottom', gate_dir='left',
                                  h=0.95, lead_len=0.25, label_terminals=True)
            ax.plot([5.0, 5.0], [tn_logic['S'][1], tn_eval['D'][1]], color='#334155', lw=1.8)
            ax.plot([5.0, 5.0], [tn_eval['S'][1], 2.7], color='#334155', lw=1.8)
            ax.text(5.8, 3.3, 'Evaluate\n($M_{eval}$)', fontsize=7.8, color='#15803d', va='center')

            ax.plot([2.5, tn_eval['G'][0]], [tn_eval['G'][1], tn_eval['G'][1]], color='#ea580c', lw=1.8)
            ax.scatter([2.5], [tn_eval['G'][1]], color='#ea580c', s=30, zorder=5)
            ax.text(2.3, tn_eval['G'][1], r'$\phi$', fontsize=10, fontweight='bold', color='#ea580c', va='center', ha='right')

            ax.text(5.0, 1.15, '[!] Pha 1 ($\\phi=0$): Nạp trước $V_{out} \\rightarrow V_{DD}$ qua $M_{pre}$\n'
                               '[!] Pha 2 ($\\phi=1$): Đánh giá điều kiện xả theo $V_{in}$\n'
                               '[-] Dễ tổn thương bởi chia sẻ điện tích (Charge Sharing) & rò',
                    fontsize=7.8, color='#7f1d1d', ha='center',
                    bbox=dict(boxstyle='round,pad=0.3', facecolor='#fee2e2', edgecolor='#ef4444'))

    fig.subplots_adjust(left=0.04, right=0.96, top=0.93, bottom=0.04, hspace=0.18, wspace=0.14)
    fig.savefig(os.path.join(OUTPUT_DIR, 'fig_inv_2_inverter_classes_and_topologies.png'), dpi=300)
    plt.close(fig)
    print('Generated: fig_inv_2_inverter_classes_and_topologies.png')


# -------------------------------------------------------------
# Figure 3: DC Transfer Curve & Operating Regions
# -------------------------------------------------------------
def generate_fig3():
    fig = plt.figure(figsize=(16, 7.2), dpi=300)
    gs = fig.add_gridspec(1, 2, width_ratios=[1.15, 1.0], wspace=0.20)

    # Subplot 1: 5 Operating Regions & Noise Margins
    ax1 = fig.add_subplot(gs[0])
    ax1.set_xlim(-0.05, 1.05)
    ax1.set_ylim(-0.05, 1.05)

    vdd = 1.0
    vtn = 0.30
    vtp = -0.30

    vin = np.linspace(0, vdd, 500)
    k = 18.0
    vm_nom = 0.50
    vout = vdd / (1.0 + np.exp(k * (vin - vm_nom)))

    v_a = vtn
    v_b = vm_nom - 0.08
    v_c = vm_nom + 0.08
    v_d = vdd - abs(vtp)

    ax1.axvspan(0, v_a, color='#dbeafe', alpha=0.35, label='A: nMOS Ngắt, pMOS Tuyến tính')
    ax1.axvspan(v_a, v_b, color='#fef3c7', alpha=0.45, label='B: nMOS Bão hòa, pMOS Tuyến tính')
    ax1.axvspan(v_b, v_c, color='#fee2e2', alpha=0.55, label='C: Cả hai Bão hòa (Độ lợi cao)')
    ax1.axvspan(v_c, v_d, color='#fef9c3', alpha=0.45, label='D: nMOS Tuyến tính, pMOS Bão hòa')
    ax1.axvspan(v_d, vdd, color='#e0e7ff', alpha=0.35, label='E: nMOS Tuyến tính, pMOS Ngắt')

    ax1.plot(vin, vout, color='#0f172a', lw=3.0, label='Đặc tuyến DC $V_{out}(V_{in})$', zorder=5)
    ax1.plot([0, vdd], [0, vdd], color='#64748b', linestyle='--', lw=1.5, label='Đường chéo $V_{out} = V_{in}$')

    ax1.scatter([vm_nom], [vm_nom], color='#dc2626', s=70, zorder=6)
    ax1.text(vm_nom + 0.02, vm_nom - 0.06, f'$V_M = {vm_nom:.2f}\\text{{V}}$',
             fontsize=9.5, fontweight='bold', color='#dc2626')

    vil = 0.38
    voh = vdd / (1.0 + np.exp(k * (vil - vm_nom)))
    vih = 0.62
    vol = vdd / (1.0 + np.exp(k * (vih - vm_nom)))

    ax1.scatter([vil], [voh], color='#7c3aed', s=55, zorder=6)
    ax1.scatter([vih], [vol], color='#7c3aed', s=55, zorder=6)
    ax1.text(vil - 0.05, voh + 0.02, '$V_{IL}$ (Slope = -1)', fontsize=8.8, fontweight='bold', color='#6d28d9', ha='right')
    ax1.text(vih + 0.04, vol + 0.03, '$V_{IH}$ (Slope = -1)', fontsize=8.8, fontweight='bold', color='#6d28d9')

    # NM_L at y = 0.25 (well above legend)
    ax1.annotate('', xy=(vil, 0.25), xytext=(0, 0.25),
                 arrowprops=dict(arrowstyle='<->', color='#15803d', lw=2.0))
    ax1.text(vil/2, 0.28, '$NM_L = V_{IL} - V_{OL}$', fontsize=8.5, fontweight='bold', color='#15803d', ha='center')

    # NM_H at y = 0.90
    ax1.annotate('', xy=(vdd, 0.90), xytext=(vih, 0.90),
                 arrowprops=dict(arrowstyle='<->', color='#b91c1c', lw=2.0))
    ax1.text((vdd + vih)/2, 0.93, '$NM_H = V_{OH} - V_{IH}$', fontsize=8.5, fontweight='bold', color='#b91c1c', ha='center')

    ax1.text(0.12, 0.70, 'A', fontsize=14, fontweight='bold', color='#1e40af')
    ax1.text(0.33, 0.60, 'B', fontsize=14, fontweight='bold', color='#b45309')
    ax1.text(0.48, 0.40, 'C', fontsize=14, fontweight='bold', color='#b91c1c')
    ax1.text(0.66, 0.35, 'D', fontsize=14, fontweight='bold', color='#a16207')
    ax1.text(0.85, 0.20, 'E', fontsize=14, fontweight='bold', color='#4338ca')

    ax1.set_xlabel('Điện Áp Ngõ Vào $V_{in}$ (V)', fontsize=10.5, fontweight='bold', color='#0f172a')
    ax1.set_ylabel('Điện Áp Ngõ Ra $V_{out}$ (V)', fontsize=10.5, fontweight='bold', color='#0f172a')
    ax1.set_title('(a) Đường Cong Truyền Đạt DC & Phân Định 5 Vùng Hoạt Động', fontsize=11, fontweight='bold', color='#0f172a')
    ax1.grid(True, linestyle=':', alpha=0.6)
    ax1.legend(loc='lower left', bbox_to_anchor=(0.01, 0.01), fontsize=6.8, framealpha=0.92, ncol=2)

    # Subplot 2: Beta Sizing Shift
    ax2 = fig.add_subplot(gs[1])
    ax2.set_xlim(-0.05, 1.05)
    ax2.set_ylim(-0.05, 1.05)

    test_ratios = [0.25, 1.0, 4.0]
    colors = ['#0284c7', '#16a34a', '#dc2626']

    for r_ratio, c in zip(test_ratios, colors):
        r = np.sqrt(r_ratio)
        v_m_calc = (vtn + r * (vdd - abs(vtp))) / (1.0 + r)
        vout_curve = vdd / (1.0 + np.exp(k * (vin - v_m_calc)))
        ax2.plot(vin, vout_curve, color=c, lw=2.4, 
                 label=r'$\beta_p/\beta_n = ' + f'{r_ratio:.2f}' + r' \rightarrow V_M = ' + f'{v_m_calc:.2f}\\mathrm{{V}}$')
        ax2.scatter([v_m_calc], [v_m_calc], color=c, s=50, zorder=6)

    ax2.plot([0, vdd], [0, vdd], color='#64748b', linestyle='--', lw=1.5, label='Đường chéo $V_{out} = V_{in}$')

    ax2.annotate('Tăng $\\beta_p/\\beta_n$:\n$V_M$ dời sang PHẢI ($V_{DD}$)',
                 xy=(0.58, 0.58), xytext=(0.68, 0.40),
                 arrowprops=dict(arrowstyle='->', color='#dc2626', lw=1.8),
                 fontsize=8.5, fontweight='bold', color='#dc2626')

    ax2.annotate('Giảm $\\beta_p/\\beta_n$:\n$V_M$ dời sang TRÁI (GND)',
                 xy=(0.42, 0.42), xytext=(0.10, 0.55),
                 arrowprops=dict(arrowstyle='->', color='#0284c7', lw=1.8),
                 fontsize=8.5, fontweight='bold', color='#0284c7')

    ax2.set_xlabel('Điện Áp Ngõ Vào $V_{in}$ (V)', fontsize=10.5, fontweight='bold', color='#0f172a')
    ax2.set_ylabel('Điện Áp Ngõ Ra $V_{out}$ (V)', fontsize=10.5, fontweight='bold', color='#0f172a')
    ax2.set_title(r'(b) Biến Thiên Ngưỡng Lật $V_M$ Theo Tỷ Số Định Cỡ $\beta_p / \beta_n$', fontsize=11, fontweight='bold', color='#0f172a')
    ax2.grid(True, linestyle=':', alpha=0.6)
    ax2.legend(loc='lower left', fontsize=8.2, framealpha=0.92)

    ax2.text(0.55, 0.16, '[Quy Luật Vật Lý Định Cỡ]:\n'
                         r'• $\beta_p / \beta_n > 1$ (pMOS mạnh): Kéo $V_M \rightarrow V_{DD}$, tăng $NM_L$, tăng trễ nạp $t_r$.' + '\n'
                         r'• $\beta_p / \beta_n < 1$ (nMOS mạnh): Kéo $V_M \rightarrow \text{GND}$, tăng $NM_H$, tăng tốc xả $t_f$.',
             fontsize=8.0, color='#1e293b',
             bbox=dict(boxstyle='round,pad=0.35', facecolor='#f8fafc', edgecolor='#cbd5e1'))

    fig.subplots_adjust(left=0.06, right=0.96, top=0.92, bottom=0.10, wspace=0.20)
    fig.savefig(os.path.join(OUTPUT_DIR, 'fig_inv_3_dc_transfer_characteristics_and_regions.png'), dpi=300)
    plt.close(fig)
    print('Generated: fig_inv_3_dc_transfer_characteristics_and_regions.png')


# -------------------------------------------------------------
# Figure 4: BSIM Nanoscale Physics vs Shockley & FO4 Delay
# -------------------------------------------------------------
def generate_fig4():
    fig = plt.figure(figsize=(16, 7.2), dpi=300)
    gs = fig.add_gridspec(1, 2, width_ratios=[1.1, 1.0], wspace=0.20)

    # Subplot 1: Shockley vs BSIM Velocity Saturation & DIBL
    ax1 = fig.add_subplot(gs[0])
    ax1.set_xlim(0, 1.25)
    ax1.set_ylim(0, 1.05)

    vds = np.linspace(0, 1.2, 200)
    vgs = 1.0
    vt = 0.30

    vdsat_shockley = vgs - vt
    ids_shockley = np.where(vds < vdsat_shockley,
                            2.0 * ((vgs - vt)*vds - 0.5*vds**2),
                            (vgs - vt)**2 * (1.0 + 0.02 * vds))
    ids_shockley = ids_shockley / np.max(ids_shockley) * 0.95

    vdsat_bsim = 0.28
    ids_bsim = np.where(vds < vdsat_bsim,
                        2.8 * vds - 2.5 * vds**2,
                        0.60 * (1.0 + 0.14 * (vds - vdsat_bsim)))
    ids_bsim = ids_bsim / np.max(ids_bsim) * 0.72

    ax1.plot(vds, ids_shockley, color='#dc2626', lw=2.5, linestyle='--',
             label=r'Mô hình Shockley (Kênh dài): $I_{ds} \propto (V_{gs}-V_t)^2$')
    ax1.plot(vds, ids_bsim, color='#2563eb', lw=3.0,
             label=r'Mô hình BSIM (Kênh nano): Bão hòa vận tốc $I_{ds} \propto (V_{gs}-V_t)$')

    ax1.axvline(vdsat_bsim, color='#2563eb', linestyle=':', lw=1.5)
    ax1.text(vdsat_bsim + 0.02, 0.48, r'$V_{dsat, BSIM} \ll V_{gs}-V_t$' + '\n(Bão hòa sớm do $\\mathcal{E}_{sat}$)',
             fontsize=8.5, color='#1d4ed8', fontweight='bold')

    ax1.axvline(vdsat_shockley, color='#dc2626', linestyle=':', lw=1.5)
    ax1.text(vdsat_shockley + 0.02, 0.90, r'$V_{dsat, Shockley} = V_{gs}-V_t$',
             fontsize=8.5, color='#991b1b', fontweight='bold')

    # Inset standard MOSFET schematic placed in axes fraction [0.28, 0.06, 0.21, 0.35]
    # which maps to data x in [0.35, 0.61], data y in [0.06, 0.43] - COMPLETELY EMPTY SPACE!
    inset_ax = ax1.inset_axes([0.28, 0.06, 0.21, 0.35], zorder=10)
    inset_ax.set_xlim(0, 4)
    inset_ax.set_ylim(0, 4)
    inset_ax.set_xticks([])
    inset_ax.set_yticks([])
    for spine in inset_ax.spines.values():
        spine.set_color('#cbd5e1')
        spine.set_linewidth(1.2)
    inset_ax.patch.set_facecolor('#ffffff')
    inset_ax.patch.set_alpha(1.0)

    draw_mosfet(inset_ax, 2.0, 1.8, mos_type='n_enh', source_at='bottom', gate_dir='left',
                h=1.3, lead_len=0.45, label_terminals=True, color='#0f172a')
    inset_ax.text(2.0, 3.55, 'Ký Hiệu Chuẩn nMOS\n(Enhancement)', fontsize=7.2, fontweight='bold', ha='center', color='#1e293b')

    # DIBL Annotation: placed in data space x in [0.68, 1.15], y around 0.32
    ax1.annotate('Hiệu ứng DIBL:\nHạ rào thế làm dòng tiếp tục\ntăng dốc trong bão hòa',
                 xy=(1.15, ids_bsim[-5]), xytext=(0.68, 0.32),
                 arrowprops=dict(arrowstyle='->', color='#0f172a', lw=1.6),
                 fontsize=8.2, bbox=dict(boxstyle='round,pad=0.3', facecolor='#eff6ff', edgecolor='#93c5fd'))

    ax1.set_xlabel(r'Điện Áp Cực Máng - Nguồn $V_{ds}$ (V)', fontsize=10.5, fontweight='bold', color='#0f172a')
    ax1.set_ylabel(r'Dòng Điện Dẫn Chuẩn Hóa $I_{ds} / I_{max}$', fontsize=10.5, fontweight='bold', color='#0f172a')
    ax1.set_title('(a) Cơ Chế Bão Hòa Vận Tốc & DIBL: BSIM vs. Shockley', fontsize=11, fontweight='bold', color='#0f172a')
    ax1.grid(True, linestyle=':', alpha=0.6)
    ax1.legend(loc='lower right', bbox_to_anchor=(0.99, 0.03), fontsize=7.8)

    # Subplot 2: FO4 Delay vs P/N Sizing Ratio
    ax2 = fig.add_subplot(gs[1])
    ax2.set_xlim(0.8, 3.8)
    ax2.set_ylim(13.5, 27.5)

    p_n_ratio = np.linspace(0.8, 3.8, 120)
    tpdr = 12.16 + 7.68 / p_n_ratio
    tpdf = 10.0 + 3.0 * p_n_ratio
    tpd_avg = (tpdr + tpdf) / 2.0

    ax2.plot(p_n_ratio, tpdr, color='#dc2626', lw=2.0, linestyle='-.', label=r'Thời gian trễ sườn lên $t_{pdr}$')
    ax2.plot(p_n_ratio, tpdf, color='#15803d', lw=2.0, linestyle='--', label=r'Thời gian trễ sườn xuống $t_{pdf}$')
    ax2.plot(p_n_ratio, tpd_avg, color='#1e3a8a', lw=3.0, label=r'Thời gian trễ trung bình $t_{pd, avg}$')

    min_idx = np.argmin(tpd_avg)
    opt_ratio = p_n_ratio[min_idx]
    opt_tpd = tpd_avg[min_idx]

    ax2.scatter([opt_ratio], [opt_tpd], color='#b91c1c', s=80, zorder=6)
    ax2.plot([opt_ratio, opt_ratio], [13.5, opt_tpd], color='#b91c1c', linestyle=':', lw=1.5)
    ax2.annotate(f'Tối ưu trễ nanoscale:\n$W_p/W_n = {opt_ratio:.1f}:1$ ({opt_tpd:.1f} ps)',
                 xy=(opt_ratio, opt_tpd), xytext=(opt_ratio - 0.40, opt_tpd - 1.8),
                 arrowprops=dict(arrowstyle='->', color='#b91c1c', lw=1.5),
                 fontsize=8.5, fontweight='bold', color='#b91c1c',
                 bbox=dict(boxstyle='round,pad=0.25', facecolor='#ffffff', edgecolor='#b91c1c', alpha=0.92))

    eq_idx = np.argmin(np.abs(tpdr - tpdf))
    eq_ratio = p_n_ratio[eq_idx]
    eq_tpd = tpd_avg[eq_idx]
    ax2.scatter([eq_ratio], [eq_tpd], color='#7c3aed', s=60, zorder=6)
    ax2.annotate(f'Cân bằng $t_{{pdr}} = t_{{pdf}}$:\n$W_p/W_n = {eq_ratio:.1f}:1$ ({eq_tpd:.1f} ps)',
                 xy=(eq_ratio, eq_tpd), xytext=(eq_ratio + 0.20, eq_tpd + 1.2),
                 arrowprops=dict(arrowstyle='->', color='#7c3aed', lw=1.5),
                 fontsize=8.2, fontweight='bold', color='#6d28d9',
                 bbox=dict(boxstyle='round,pad=0.25', facecolor='#ffffff', edgecolor='#7c3aed', alpha=0.92))

    ax2.set_xlabel(r'Tỷ Số Bề Rộng Transistor $W_p / W_n$', fontsize=10.5, fontweight='bold', color='#0f172a')
    ax2.set_ylabel('Thời Gian Trễ Lan Truyền FO4 (ps)', fontsize=10.5, fontweight='bold', color='#0f172a')
    ax2.set_title('(b) Tối Ưu Hóa Tỷ Lệ P/N Trong Chuỗi Trễ FO4 (BSIM 65nm)', fontsize=11, fontweight='bold', color='#0f172a')
    ax2.grid(True, linestyle=':', alpha=0.6)
    ax2.legend(loc='upper right', fontsize=8.0)

    ax2.text(2.3, 24.2, '[Đột Phá Định Cỡ Kênh Nano]:\n'
                        'Do bão hòa vận tốc dìm dòng nMOS mạnh hơn pMOS,\n'
                        'tỷ lệ P/N tối ưu trễ chỉ còn 1.5 - 1.8:1 (đạt đỉnh tại 1.6:1) thay vì 2.5 - 3.0:1!\n'
                        '(Tăng Wp quá mức chỉ làm nặng thêm tải điện dung ký sinh)',
             fontsize=8.0, color='#1e293b', ha='center',
             bbox=dict(boxstyle='round,pad=0.35', facecolor='#f1f5f9', edgecolor='#94a3b8'))

    fig.subplots_adjust(left=0.06, right=0.96, top=0.92, bottom=0.10, wspace=0.20)
    fig.savefig(os.path.join(OUTPUT_DIR, 'fig_inv_4_bsim_short_channel_and_spice_simulation.png'), dpi=300)
    plt.close(fig)
    print('Generated: fig_inv_4_bsim_short_channel_and_spice_simulation.png')


if __name__ == '__main__':
    print('Generating all 4 inverter & BSIM publication figures...')
    generate_fig1()
    generate_fig2()
    generate_fig3()
    generate_fig4()
    print('All figures successfully generated at 300 DPI.')