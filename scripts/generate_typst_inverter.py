# -*- coding: utf-8 -*-
import os

TYP_PATH = r'book/inverter_classes_and_bsim.typ'

part1 = """#set page(
  paper: "a4",
  margin: (x: 2.0cm, top: 2.2cm, bottom: 2.2cm),
  header: align(right)[
    #text(size: 8.5pt, fill: rgb("#64748b"))[Thiết kế Vi mạch VLSI từ Bản chất Vật lý | Chuyên đề: Các Lớp Cổng Đảo & Mô Hình BSIM]
  ],
  footer: [
    #line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
    #grid(
      columns: (1fr, 1fr),
      align(left)[#text(size: 8pt, fill: rgb("#94a3b8"))[Tài liệu Chuyên sâu 4 Giờ (ĐH CNTT UIT)]],
      align(right)[#context text(size: 8.5pt, weight: "bold", fill: rgb("#334155"))[Trang #counter(page).display()]]
    )
  ]
)

#set text(
  font: "Segoe UI",
  size: 10pt,
  lang: "vi"
)

#set par(
  justify: true,
  leading: 0.72em
)

// Hộp ghi chú chuyên dụng chuẩn hóa SOP
#let callout(title, body, border-color, bg-color, icon) = block(
  breakable: true,
  fill: bg-color,
  stroke: (left: 4pt + border-color),
  inset: (x: 12pt, y: 7pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #grid(
      columns: (auto, 1fr),
      gutter: 6pt,
      text(weight: "bold", size: 9.8pt, fill: border-color)[#icon #title],
      []
    )
    #v(2.5pt)
    #text(size: 9.2pt)[#body]
  ]
)

#let physical-box(body) = callout(
  "Bản chất Vật lý Vi mô (Microscopic Mechanism)",
  body,
  rgb("#0284c7"),
  rgb("#f0f9ff"),
  "🔬"
)

#let math-box(body) = callout(
  "Dẫn xuất Toán học Chi tiết (Step-by-Step Mathematical Derivation)",
  body,
  rgb("#7c3aed"),
  rgb("#f5f3ff"),
  "📐"
)

#let rule-box(body) = callout(
  "Góc nhìn Kỹ sư Thiết kế Vi mạch (Engineering Takeaway)",
  body,
  rgb("#059669"),
  rgb("#ecfdf5"),
  "⚡"
)

#let pitfall-box(body) = callout(
  "Cảnh báo Lỗi Phổ biến & Tử huyệt Kỹ nghệ (Critical Pitfall)",
  body,
  rgb("#d97706"),
  rgb("#fffbeb"),
  "⚠️"
)

#align(center)[
  #text(size: 20pt, weight: "bold", fill: rgb("#0f172a"))[Chuyên Đề: Các Lớp Cổng Đảo & Mô Hình BSIM trong SPICE]
  #v(2pt)
  #text(size: 11pt, fill: rgb("#334155"))[Giải Phẫu Mặt Nạ Silicon, Tử Huyệt Latch-Up, Các Họ Kiến Trúc Inverter, Động Học VTC & Mô Hình Hóa Bán Dẫn Nanomet]
  #v(1pt)
  #text(size: 8.5pt, style: "italic", fill: rgb("#64748b"))[
    Tài liệu Chuyên sâu 4 Giờ | Bám sát Slide Nonideal, DC/Transient & SPICE UIT | Giáo trình CMOS VLSI Design (Weste & Harris)
  ]
  #v(5pt)
  #line(length: 100%, stroke: 1.5pt + rgb("#0284c7"))
]

#v(4pt)
== Lộ trình Học tập 4 Giờ Cốt lõi (4-Hour Study Roadmap)
Tài liệu này được biên soạn theo *trục logic nhân quả bất biến*: Khởi hành từ các lớp vật lý silicon và cơ chế đóng mở kênh của cặp transistor bổ sung, khảo sát sự tiến hóa của các phân lớp kiến trúc Inverter, mổ xẻ chính xác 5 vùng hoạt động truyền đạt DC, và giải mã lý do vì sao mô hình bán dẫn BSIM ra đời để cứu rỗi ngành công nghiệp vi mạch trong kỷ nguyên nanomet:

#table(
  columns: (1.1fr, 2.3fr, 3.6fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 6pt,
  [*Thời gian*], [*Nội dung Trọng tâm*], [*Mục tiêu Bản chất Cần Đạt Được*],
  [Giờ 1 (0h - 1h)], [Các Lớp Vật Lý Silicon, Chế Tạo & Tử Huyệt Latch-Up], [Nắm vững cấu trúc mặt nạ silicon (Well, Active, Poly, Metal); hiểu nguồn gốc cặp BJT ký sinh PNP-NPN kích hoạt hiệu ứng Thyristor (Latch-up) và kỹ thuật bố trí Guard Rings triệt tiêu điện trở đế/giếng.],
  [Giờ 2 (1h - 2h)], [Phân Lớp Kiến Trúc Cổng Đảo (Inverter Circuit Families)], [So sánh bản chất tải điện trở, tải nMOS suy giảm, CMOS tĩnh, Pseudo-nMOS và Dynamic logic; chứng minh tính ưu việt của full rail-to-rail swing và nguyên lý tối ưu chuỗi đệm Inverter kéo tải nặng ($f = e approx 2.72$).],
  [Giờ 3 (2h - 3h)], [Đặc Tuyến DC (VTC), 5 Vùng Hoạt Động & Biên Dự Trữ Nhiễu], [Giải phẫu toán học và động học hạt dẫn qua 5 vùng hoạt động ($A arrow.r E$); dẫn xuất điểm ngưỡng chuyển mạch $V_M$ ($V_("inv")$) và phân tích độ bất đối xứng của dải dự trữ nhiễu ($N M_L, N M_H$) theo tỷ số $beta_p / beta_n$.],
  [Giờ 4 (3h - 4h)], [Kỷ Nguyên BSIM, Hiệu Ứng Kênh Ngắn & Mô Phỏng SPICE], [Giải mã sự sụp đổ của mô hình Shockley; làm chủ các hiệu ứng kênh ngắn (Bão hòa vận tốc, DIBL, Rò dưới ngưỡng, Xuyên hầm oxit); đọc hiểu tham số BSIM và lý giải vì sao tỷ lệ định cỡ tối ưu trễ FO4 giảm từ $2.5:1$ xuống $1.5:1$.]
)

#v(8pt)
= Giờ 1: Các Lớp Vật Lý Silicon, Quy trình Chế tạo & Tử huyệt Latch-Up
_Tương ứng Slide Chế tạo & Bố cục Silicon | Thời gian mục tiêu: 60 phút_

=== 1.1 Khởi hành từ Bề mặt Bán dẫn: Giải phẫu các Lớp Mặt Nạ Silicon
Để cổng logic hoạt động trong thực tế, các phương trình toán học và sơ đồ nguyên lý phải được hiện thực hóa qua quy trình quang khắc *(Photolithography)* gồm nhiều lớp mặt nạ *(Mask Layers)* xếp chồng lên nhau trên phiến silicon:
1. *Đế Silicon loại p (p-substrate):* Nền móng vật lý đơn tinh thể pha tạp Boron nhẹ ($N_A approx 10^(15) "cm"^(-3)$), nơi hạt đa số là lỗ trống ($h^+$). Transistor nMOS được chế tạo trực tiếp ngay trên bề mặt đế này.
2. *Hồ chứa Giếng n (N-well):* Một vùng đảo silicon được cấy các ion nhóm V (như Phosphorus/Arsenic, $N_D approx 10^(16) "cm"^(-3)$) để tạo môi trường bán dẫn loại n (nơi electron là hạt đa số), đóng vai trò cách ly để chế tạo transistor pMOS.
3. *Vùng Khuếch tán Hoạt tính (Active/Diffusion):* Các cửa sổ cấy ion nồng độ cao ($n^+$ cho nMOS và $p^+$ cho pMOS, mật độ $> 10^(20) "cm"^(-3)$) tạo thành cực Nguồn (Source) và cực Máng (Drain).
4. *Cực Cổng Silicon Đa tinh thể (Polysilicon Gate):* Thanh dẫn Poly được lắng đọng trên lớp điện môi oxit cổng mỏng chỉ vài nanomet. Trong quy trình tự định vị *(Self-aligned process)*, Poly đóng vai trò như chiếc ô chắn chặn ion, phân tách tự nhiên vùng Source và Drain.
5. *Lớp Tiếp xúc & Kim loại (Contact & Metal Layers):* Các lỗ tiếp xúc (Contact cuts) được khoan qua lớp oxit cách điện để kết nối vùng khuếch tán và Polysilicon lên các tầng kim loại Metal 1, Metal 2 phân phối nguồn và tín hiệu.

#align(center)[
  #image("images/fig_inv_1_silicon_layers_and_latchup.png", width: 95%)
]

=== 1.2 Hiểm Họa Sinh Tử: Cơ chế Latch-Up & Cặp BJT Ký Sinh
Khi tích hợp nMOS và pMOS sát cạnh nhau trên cùng một phiến silicon nguyên khối, cấu trúc các lớp bán dẫn vô tình tạo thành hai transistor lưỡng cực BJT ký sinh lồng vào nhau:
- *Transistor $Q_1$ (pnp ký sinh):* Vùng phát (Emitter) là $p^+$ source của pMOS nối $V_("dd")$, vùng gốc (Base) là N-well, vùng thu (Collector) là p-substrate.
- *Transistor $Q_2$ (npn ký sinh):* Vùng phát (Emitter) là $n^+$ source của nMOS nối GND, vùng gốc (Base) là p-substrate, vùng thu (Collector) là N-well.

#physical-box[
  *Vòng Lặp Hồi Tiếp Dương và Cấu Trúc SCR Tự Khóa:*
  - Cực thu của $Q_1$ nối vào cực gốc của $Q_2$. Cực thu của $Q_2$ nối vào cực gốc của $Q_1$. Cặp linh kiện này tạo thành một mạch chỉnh lưu có điều khiển bằng silicon (*SCR - Silicon Controlled Rectifier*).
  - Khi có một xung đột biến điện áp ở chân I/O kích phân cực thuận tiếp giáp B-E của một trong hai BJT, dòng điện bắt đầu chảy qua điện trở nền $R_("sub")$ hoặc điện trở giếng $R_("well")$.
  - Sụt áp $I dot R >= 0.7"V"$ kích mở BJT thứ nhất. BJT thứ nhất kéo dòng kích mở BJT thứ hai. BJT thứ hai lại bơm thêm dòng kích cho BJT thứ nhất!
  - Khi tích số hệ số khuếch đại dòng:
    $ A_("loop") = beta_1 dot beta_2 >= 1 $
    vòng hồi tiếp dương trở nên tự duy trì. Một đường dẫn điện trở cực thấp được nối thông trực tiếp từ $V_("dd")$ xuống GND. Dòng điện vọt lên hàng trăm milliampere đến vài ampere, sinh nhiệt Joule thiêu rụi chip silicon!
]

=== 1.3 Kỹ Thuật Thiết Kế Chế Ngự Latch-Up
Để dập tắt vĩnh viễn thảm họa Latch-Up, các kỹ sư thiết kế layout tuân thủ nghiêm ngặt hai chiến lược:
1. *Cắm cọc tiếp xúc liên tục (Well Taps & Substrate Taps):* Đặt các điểm tiếp xúc $n^+$ trong N-well nối về $V_("dd")$ và $p^+$ trong Substrate nối về GND với khoảng cách định kỳ (thường $< 20 - 30 mu"m"$) để dìm điện trở $R_("well")$ và $R_("sub")$ xuống gần bằng $0 Omega$.
2. *Vòng bảo vệ (Guard Rings):* Bao bọc hoàn toàn các khối transistor bằng các đai khuếch tán nồng độ cao nối đất/nguồn. Đai này đóng vai trò hố thu gom triệt để mọi hạt dẫn thiểu số đi lạc, kéo tụt $beta_1 dot beta_2 << 1$.

#v(8pt)
= Giờ 2: Phân Lớp Kiến Trúc Cổng Đảo (Inverter Circuit Families)
_Tương ứng Slide Cấu trúc Cổng Đảo & Logic Hoàn chỉnh | Thời gian mục tiêu: 60 phút_

=== 2.1 Tiến Hóa Lịch Sử: Từ Tải Thụ Động Đến nMOS Depletion
Trước khi CMOS thống trị, các kỹ sư đã thử nghiệm nhiều phương pháp tạo cổng đảo:
- *Inverter Tải Điện Trở ($R_L$):* Dùng một điện trở thụ động kéo lên nguồn. Khi ngõ vào ở mức cao, nMOS bật kéo ngõ ra xuống. Tuy nhiên:
  $ V_(O L) = V_("dd") dot frac(R_("on,n"), R_L + R_("on,n")) > 0"V" $
  Mạch tiêu tốn công suất tĩnh khổng lồ $P_("static") = V_("dd")^2 / R_L$ khi ngõ ra ở mức 0, đồng thời điện trở $R_L$ chiếm diện tích silicon quá lớn.
- *Inverter nMOS Tải Giảm Thiểu (Depletion-Load nMOS):* Thay thế điện trở bằng một transistor nMOS chế tạo đặc biệt có điện áp ngưỡng âm ($V_t < 0$) và nối ngắn cực Cổng vào cực Nguồn ($V_(g s) = 0"V"$). Linh kiện này đóng vai trò một nguồn dòng không đổi kéo lên nguồn, giúp sườn lên nhanh hơn nhưng vẫn không triệt tiêu được công suất tĩnh.

#align(center)[
  #image("images/fig_inv_2_inverter_classes_and_topologies.png", width: 95%)
]

=== 2.2 Đỉnh Cao Kiến Trúc: Cổng Đảo CMOS Tĩnh Bổ Sung
Cổng đảo CMOS tĩnh bổ sung *(Complementary Static CMOS Inverter)* giải quyết triệt để mọi hạn chế lịch sử:
- *Full Rail-to-Rail Swing:* Khi $V_("in") = 0"V"$, pMOS BẬT mạnh, nMOS TẮT kiệt $arrow.r V_(O H) = V_("dd")$. Khi $V_("in") = V_("dd")$, nMOS BẬT mạnh, pMOS TẮT kiệt $arrow.r V_(O L) = 0.0"V"$.
- *Công suất tĩnh lý tưởng bằng 0:* Ở bất kỳ trạng thái ổn định nào (0 hoặc 1), luôn có ít nhất một transistor tắt hoàn toàn, chặn đứng dòng điện từ nguồn xuống đất.

=== 2.3 Họ Cổng Đảo Tỷ Lệ: Pseudo-nMOS
Trong kiến trúc Pseudo-nMOS, mạng kéo lên pMOS được thay bằng một transistor pMOS duy nhất có cực Cổng nối đất vĩnh viễn ($V_(g s,p) = -V_("dd")$):
- *Ưu điểm:* Tiết kiệm diện tích silicon cho các cổng NOR nhiều ngõ vào ($N+1$ transistor thay vì $2N$), điện dung ngõ vào giảm nhẹ.
- *Nhược điểm:* Khi nMOS bật, có dòng ngắn mạch chạy liên tục từ $V_("dd")$ xuống GND. Để $V_(O L)$ đủ nhỏ, ta bắt buộc phải định cỡ $beta_n / beta_p >= 4$.

=== 2.4 Cổng Đảo $C^2"MOS"$ & Tri-State (3 Trạng Thái)
Mạch bổ sung hai transistor truyền dẫn được điều khiển bởi cặp xung nhịp đối ngẫu $"CLK"$ và $overline("CLK")$:
- Cho phép 3 trạng thái ngõ ra: Mức 0, Mức 1, và Trở kháng cao (*Hi-Z*).
- Ứng dụng: Ghép bus dữ liệu dùng chung và xây dựng các khối chốt D-Latch, Master-Slave Flip-Flop miễn nhiễm hoàn toàn với hiện tượng đua tín hiệu *(Race Condition)*.

=== 2.5 Cổng Đảo Logic Động (Dynamic CMOS Logic)
Hoạt động theo 2 pha xung nhịp:
1. *Pha Nạp trước (Precharge - $"CLK" = 0$):* pMOS bật sạc nút ngõ ra lên $V_("dd")$.
2. *Pha Đánh giá (Evaluate - $"CLK" = 1$):* nMOS đánh giá bật mở; nếu ngõ vào ở mức cao, nút ngõ ra được xả về $0"V"$.
- Tốc độ cực nhanh do tải ngõ vào giảm một nửa, nhưng rất nhạy cảm với sụt giảm điện tích do rò rỉ dưới ngưỡng và chia sẻ điện tích *(Charge Sharing)*.

=== 2.6 Tối Ưu Hóa Chuỗi Đệm Inverter Kéo Tải Dung Lớn
Khi cần lái tải điện dung khổng lồ $C_L >> C_("in")$ (như đường bus hoặc chân I/O pad), đặt một cổng đảo duy nhất sẽ gây trễ khổng lồ do dòng kéo không đủ sạc tụ. Giải pháp là chèn một chuỗi gồm $N$ tầng đệm Inverter với kích thước phóng to dần theo cấp số nhân với hệ số phóng đại $f$:

#math-box[
  *Dẫn Xuất Hệ Số Phóng Đại Tối Ưu $f = e approx 2.72$:*
  - Đặt độ phóng đại toàn đường truyền là $F = C_L / C_("in")$. Với $N$ tầng, hệ số phóng đại mỗi tầng là $f = F^(1/N)$.
  - Bỏ qua điện dung tự tải nội tại ($gamma = 0$), tổng thời gian trễ của chuỗi là:
    $ D = N dot f = N dot F^(1/N) $
  - Lấy đạo hàm theo $N$ và cho bằng $0$:
    $ frac(partial D, partial N) = F^(1/N) + N dot F^(1/N) dot (-frac(ln F, N^2)) = f dot (1 - ln f) = 0 $
  - Vì $f > 0$, ta có: $1 - ln f = 0 arrow.r ln f = 1 arrow.r f = e approx 2.718$!
  - Số tầng tối ưu: $N_("opt") = ln(F) = ln(C_L / C_("in"))$.
  - Trong thực tế công nghiệp khi tính đến điện dung tự tải ($gamma approx 1$), cực tiểu độ trễ dịch chuyển về vùng $f approx 3.5 - 4.0$, vừa giảm độ trễ vừa tiết kiệm 50% diện tích silicon!
]
"""

with open(TYP_PATH, 'w', encoding='utf-8') as f:
    f.write(part1)
print("Wrote Part 1")