#set page(
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

#v(8pt)
= Giờ 3: Đặc Tuyến Truyền Đạt DC (VTC), 5 Vùng Hoạt Động & Lề Nhiễu
_Tương ứng Slide Phân tích DC Cổng Đảo CMOS | Thời gian mục tiêu: 60 phút_

=== 3.1 Giải Phẫu Toán Học & Động Học Hạt Dẫn Qua 5 Vùng Hoạt Động
Đặc tuyến truyền đạt điện áp *(Voltage Transfer Characteristics - VTC)* là đồ thị biểu diễn mối quan hệ giữa điện áp ngõ ra $V_("out")$ theo điện áp ngõ vào $V_("in")$ khi biến thiên liên tục từ $0"V"$ đến $V_("dd")$. Khi $V_("in")$ tăng dần, hai transistor nMOS và pMOS lần lượt trải qua 5 trạng thái hoạt động kinh điển:

#table(
  columns: (0.9fr, 1.3fr, 1.2fr, 1.2fr, 2.4fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 5.5pt,
  [*Vùng*], [*Điều kiện Điện Áp*], [*nMOS*], [*pMOS*], [*Trạng Thái Điện Áp Ngõ Ra $V_("out")$*],
  [Vùng A], [$0 <= V_("in") < V_(t n)$], [TẮT (OFF)\ $I_(d s,n) = 0$], [Tuyến tính\ $V_(d s,p) approx 0$], [$V_("out") = V_("dd")$ vững chắc (Pull-up thông tuyệt đối)],
  [Vùng B], [$V_(t n) <= V_("in") < V_(I L)$], [Bão hòa\ $V_(d s,n) >= V_(g s,n) - V_(t n)$], [Tuyến tính\ $|V_(d s,p)| < |V_(g s,p) - V_(t p)|$], [Bắt đầu sụt nhẹ; độ dốc dốc dần tới $d V_("out") / d V_("in") = -1$ tại $V_(I L)$],
  [Vùng C], [$V_("in") approx V_M$], [Bão hòa], [Bão hòa], [Vùng chuyển tiếp nhạy cảm; độ dốc cực đại; độ khuếch đại điện áp rất lớn],
  [Vùng D], [$V_(I H) < V_("in") <= V_("dd") - |V_(t p)|$], [Tuyến tính\ $V_(d s,n) < V_(g s,n) - V_(t n)$], [Bão hòa\ $|V_(d s,p)| >= |V_(g s,p) - V_(t p)|$], [Tiến sát đất; độ dốc thoải dần qua điểm $d V_("out") / d V_("in") = -1$ tại $V_(I H)$],
  [Vùng E], [$V_("in") > V_("dd") - |V_(t p)|$], [Tuyến tính\ $V_(d s,n) approx 0$], [TẮT (OFF)\ $|V_(g s,p)| < |V_(t p)|$], [$V_("out") = 0.0"V"$ hoàn toàn (Pull-down thông tuyệt đối)]
)

#align(center)[
  #image("images/fig_inv_3_dc_transfer_characteristics_and_regions.png", width: 95%)
]

=== 3.2 Dẫn Xuất Điểm Ngưỡng Chuyển Mạch Logic $V_M$ ($V_("inv")$)
Điểm ngưỡng logic $V_M$ là điểm giao giữa đường đặc tuyến VTC với đường thẳng $V_("out") = V_("in")$. Tại điểm này, trạng thái logic ở ngõ ra nhạy cảm nhất và mạch tiêu tán dòng ngắn mạch $I_("short-circuit")$ cực đại:

#math-box[
  *Dẫn Xuất Công Thức Tổng Quát Của $V_M$:*
  - Tại $V_("in") = V_("out") = V_M$, cả hai transistor đều hoạt động trong vùng bão hòa Shockley:
    $ I_(d s,n) = frac(1, 2) beta_n (V_M - V_(t n))^2 $
    $ I_(d s,p) = frac(1, 2) beta_p (V_("dd") - V_M - |V_(t p)|)^2 $
  - Cân bằng dòng điện nút ngõ ra $I_(d s,n) = I_(d s,p)$ và đặt $r = sqrt(beta_p / beta_n)$:
    $ V_M - V_(t n) = r (V_("dd") - V_M - |V_(t p)|) $
    $ V_M (1 + r) = V_(t n) + r (V_("dd") - |V_(t p)|) $
    $ V_M = frac(V_(t n) + r (V_("dd") - |V_(t p)|), 1 + r) $
  - Khi thiết kế mạch đối xứng chuẩn ($r = 1$, $V_(t n) = |V_(t p)|$):
    $ V_M = frac(V_("dd"), 2) $
  - Nếu $beta_p > beta_n$ ($r > 1$): Ngưỡng $V_M$ bị kéo lệch sang phải ($V_M > V_("dd")/2$).
  - Nếu $beta_n > beta_p$ ($r < 1$): Ngưỡng $V_M$ bị kéo lệch sang trái ($V_M < V_("dd")/2$).
]

=== 3.3 Phân Tích Lề Dự Trữ Nhiễu (Noise Margins)
Lề dự trữ nhiễu đo lường khả năng miễn nhiễm của cổng logic trước các xung nhiễu điện từ trên đường dây:
- *Lề nhiễu mức thấp:* $N M_L = V_(I L) - V_(O L) = V_(I L) - 0"V" = V_(I L)$
- *Lề nhiễu mức cao:* $N M_H = V_(O H) - V_(I H) = V_("dd") - V_(I H)$
- *Quy luật đối xứng:* Khi $V_M = V_("dd")/2$, cả hai lề nhiễu đạt giá trị cân bằng tối ưu:
  $ N M_L approx N M_H approx 0.4 dot V_("dd") $
  Đem lại sự ổn định tuyệt đối cho toàn bộ hệ thống số.

#v(8pt)
= Giờ 4: Kỷ Nguyên BSIM, Hiệu Ứng Kênh Ngắn & Mô Phỏng SPICE
_Tương ứng Slide Nonideal Transistor Theory & SPICE Simulation | Thời gian mục tiêu: 60 phút_

=== 4.1 Sự Sụp Đổ Của Mô Hình Shockley Truyền Thống
Mô hình Shockley bậc hai ($I_(d s) prop (V_(g s) - V_t)^2$) từng là kim chỉ nam cho thiết kế vi mạch trong nhiều thập kỷ. Tuy nhiên, khi chiều dài kênh thu nhỏ xuống dưới $0.25 mu"m"$, mô hình này sụp đổ hoàn toàn: nó dự đoán dòng dẫn lớn gấp $2 - 3$ lần thực tế và hoàn toàn bỏ qua các cơ chế rò rỉ nhiệt động học. Để giải cứu ngành công nghiệp bán dẫn, nhóm nghiên cứu tại Đại học Berkeley đã phát triển chuẩn mô hình *BSIM (Berkeley Short-channel IGFET Model)*.

#align(center)[
  #image("images/fig_inv_4_bsim_short_channel_and_spice_simulation.png", width: 95%)
]

=== 4.2 Giải Phẫu Các Hiệu Ứng Kênh Ngắn (Short-Channel Effects)
1. *Bão Hòa Vận Tốc (Velocity Saturation):*
   - Dưới điện trường ngang cực mạnh ($E_x = V_(d s) / L > 10^4 "V/cm"$), các electron va chạm liên tục với mạng tinh thể silicon (tán xạ phonon), khiến vận tốc trôi chạm trần tối đa $v_("sat") approx 10^7 "cm/s"$.
   - Dòng điện bão hòa bị dìm từ hàm bậc 2 xuống quan hệ *bậc 1 tuyến tính*:
     $ I_("dsat") approx W C_(o x) v_("sat") (V_(g s) - V_t) $
2. *Hạ Thấp Rào Cản Thế Năng Cực Máng (DIBL):*
   - Vùng suy giảm cực Máng tiến sát cực Source, kéo tụt đỉnh rào thế năng tĩnh điện.
   - Điện áp ngưỡng $V_t$ bị sụt giảm theo $V_(d s)$:
     $ Delta V_t = "ETA0" dot V_(d s) $
3. *Rò Rỉ Dưới Ngưỡng (Subthreshold Leakage):*
   - Ngay cả khi $V_(g s) < V_t$, dòng khuếch tán nhiệt vẫn tồn tại và phụ thuộc hàm mũ:
     $ I_("sub") prop 10^(-V_t / S) $
   - Với hệ số dốc dưới ngưỡng $S = n (k_B T / q) ln(10) approx 70 - 100 "mV/decade"$.
4. *Xuyên Hầm Cơ Học Lượng Tử Qua Oxit Cực Cổng (Gate Tunneling):*
   - Khi độ dày $t_(o x) < 1.5"nm"$, electron xuyên thủng trực tiếp hàng rào điện môi, tạo ra dòng rò cực cổng $I_("gate")$.

=== 4.3 Giải Mã Thẻ Tham Số BSIM4 Trong SPICE
Các tham số then chốt điều khiển các hiệu ứng kênh ngắn trong file thư viện bán dẫn:
- `TOXE`: Độ dày điện môi oxit cổng thực tế (nm).
- `VTH0`: Điện áp ngưỡng danh định tại kênh dài và $V_(d s) approx 0"V"$.
- `VSAT`: Vận tốc bão hòa trôi cực đại của hạt dẫn ($approx 10^5 "m/s"$).
- `ETA0`: Hệ số điều khiển hiệu ứng DIBL hạ thấp rào cản thế năng.
- `DROUT`: Hệ số chiều dài kênh điều khiển sự suy giảm trở kháng ngõ ra.
- `CJ, CJSW`: Điện dung tiếp giáp khuếch tán đáy và chu vi thành bên ($"F/m"^2, "F/m"$).

=== 4.4 Thực Hành Mô Phỏng SPICE & Đột Phá Định Cỡ P/N Trong Nanomet
Mô phỏng chuỗi chuẩn Fan-out of 4 (FO4) trong tiến trình 65nm BSIM cho thấy một kết luận mang tính cách mạng:
- *Lý thuyết Shockley cũ:* Khuyên chọn $W_p / W_n approx 2.5:1$ để bù trừ độ linh động $mu_n / mu_p approx 2.5$.
- *Thực tế BSIM Nanomet:* Do nMOS bị bão hòa vận tốc dìm dòng nặng nề hơn pMOS, tỷ số dòng $I_("on,n") / I_("on,p")$ thực tế co hẹp chỉ còn $1.5 - 1.8$.
- Nếu cố phình to $W_p$ lên $2.5:1$, điện dung tự tải ký sinh ($C_g, C_(d b)$) sẽ bóp nghẹt tốc độ.
- *Tỷ số định cỡ tối ưu trễ trung bình:*
  $ frac(W_p, W_n) approx 1.5:1 quad "đến" quad 1.8:1 ! $
  Vừa đạt tốc độ cao nhất, vừa tiết kiệm 30% diện tích và công suất!

#v(8pt)
=== 4.5 Bảng Tra Cứu Toàn Diện Các Lớp Inverter & Đặc Tính Mô Hình BSIM

#table(
  columns: (1fr, 1.2fr, 1.1fr, 1.2fr, 1.3fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 5pt,
  [*Lớp Kiến Trúc*], [*Linh Kiện Kéo Lên / Xuống*], [*Mức Logic Ngõ Ra*], [*Công Suất Tĩnh & Lề Nhiễu*], [*Đặc Trưng Nanomet BSIM & Ứng Dụng*],
  [Tải Điện Trở ($R_L$)], [Điện trở thụ động $R_L$ \ nMOS kéo xuống], [$V_(O H) = V_("dd")$\ $V_(O L) > 0"V"$], [$P_("static")$ rất lớn khi ngõ ra = 0\ $N M_L$ hẹp], [Điện trở chiếm diện tích khổng lồ; lịch sử buổi đầu vi mạch.],
  [nMOS Depletion], [nMOS $V_t < 0$, $V_(g s)=0$\ nMOS kéo xuống], [$V_(O H) = V_("dd")$\ $V_(O L) > 0"V"$], [$P_("static")$ lớn khi ngõ ra = 0\ Sườn lên tốt hơn $R_L$], [Nguồn dòng không đổi; dùng trong Intel 8085 / thập niên 70.],
  [*CMOS Tĩnh Chuẩn*], [*pMOS kéo lên*\ *nMOS kéo xuống*], [*Full Rail-to-Rail*\ $V_(O H)=V_("dd"), V_(O L)=0"V"$], [*$P_("static") approx 0$* (chỉ rò)\ *$N M_L approx N M_H approx 0.4 V_("dd")$*], [*Chuẩn mực vàng VLSI*; chi phối bởi bão hòa vận tốc và DIBL.],
  [Pseudo-nMOS], [1 pMOS nối đất cổng\ nMOS kéo xuống], [$V_(O H) = V_("dd")$\ $V_(O L) > 0"V"$ ($beta_n/beta_p >= 4$)], [$P_("static")$ lớn khi ngõ ra = 0\ $N M_L$ bất đối xứng], [Tiết kiệm diện tích cho cổng nhiều ngõ vào ($N+1$), ROM/PLA decoder.],
  [$C^2"MOS"$ / Tri-State], [Cặp pMOS nối tiếp\ Cặp nMOS nối tiếp], [$V_(O H)=V_("dd"), V_(O L)=0"V"$\ Trạng thái Hi-Z], [Triệt tiêu tĩnh khi ở chế độ dẫn\ Lề nhiễu cao], [Ghép bus dùng chung, chốt D-Latch, triệt tiêu xung đột đua tín hiệu.],
  [Logic Động (Dynamic)], [1 pMOS Precharge\ Khối nMOS Evaluate], [$V_(O H)=V_("dd"), V_(O L)=0"V"$\ (2 pha xung nhịp)], [Tải ngõ vào nhẹ\ Nhạy cảm mất điện tích rò rỉ], [ALU siêu tốc, Register file; đòi hỏi xung nhịp làm tươi liên tục.],
  [BSIM Nanoscale CMOS], [Cặp FinFET pMOS/nMOS\ Đa cổng 3D triệt rò], [Full Rail-to-Rail\ $V_("dd") approx 0.7 - 0.9"V"$], [Rò rỉ dưới ngưỡng và DIBL\ rất nhạy cảm biến thiên PVT], [*$W_p/W_n approx 1.5 - 1.8:1$*; CPU/GPU hiệu năng cao (Apple, Intel, NVIDIA).]
)

#v(8pt)
=== 4.6 5 Câu Hỏi Chẩn Đoán & Tự Đánh Giá Chuyên Sâu (Diagnostic Self-Assessment)

#pitfall-box[
  *Câu hỏi 1 (Cơ chế Vật lý Latch-Up & Kỹ thuật Thiết Kế Guard Rings):*  
  Một vi điều khiển CMOS p-substrate/N-well bị một xung âm $-0.8"V"$ đánh vào chân I/O trong $2"ns"$. Sau đó, dòng tiêu thụ tăng vọt từ $15"mA"$ lên $800"mA"$, chip nóng rực và không phản hồi tín hiệu Reset logic:
  1. Thiết lập biểu thức điều kiện vòng hồi tiếp dương tự duy trì giữa cặp BJT ký sinh $Q_1$ (pnp) và $Q_2$ (npn)?
  2. Tại sao ngắt xung âm và gửi lệnh Reset mềm không tắt được mạch mà bắt buộc phải ngắt hoàn toàn nguồn cung cấp ($V_("dd")$ Power Cycle)?
  3. Phân tích nguyên lý vật lý của các vòng bảo vệ Guard Rings: Làm thế nào chúng triệt tiêu hoàn toàn nguy cơ Latch-up?
]

_Lời giải chi tiết:_
1. *Vòng hồi tiếp dương SCR:* Transistor $Q_1$ (pnp ký sinh hình thành từ $p^+$ source pMOS, N-well, p-substrate) và $Q_2$ (npn ký sinh từ $n^+$ source nMOS, p-substrate, N-well) ghép chéo cực thu vào cực gốc của nhau. Khi xung âm $-0.8"V"$ kích dòng qua $R_("sub")$, sụt áp $I dot R_("sub") >= 0.7"V"$ mở $Q_2$. $Q_2$ kéo dòng qua $R_("well")$ kích mở $Q_1$. $Q_1$ bơm thêm dòng kích cho $Q_2$. Điều kiện duy trì:
   $ A_("loop") = beta_1 dot beta_2 >= 1 $
   Mạch trở thành một cấu trúc Thyristor (SCR) tự khóa, dẫn dòng không giới hạn.
2. *Không thể tắt bằng Reset mềm:* Dòng điện chạy qua thân khối bán dẫn thể tích (bulk substrate), hoàn toàn nằm ngoài sự kiểm soát của cực cổng Poly-Si. Do đó, muốn dập tắt SCR phải hạ nguồn $V_("dd")$ xuống dưới điện áp giữ ($V_H approx 1.0"V"$) hoặc cắt dòng qua SCR (Power-down).
3. *Cơ chế Guard Rings:* Đai $P^+$ nối GND và $N^+$ nối $V_("dd")$ dìm $R_("sub"), R_("well") arrow.r 0 Omega$, triệt tiêu điều kiện sụt áp $0.7"V"$. Đồng thời, chúng đóng vai trò hố thu gom (sink) hút hết hạt dẫn thiểu số khuếch tán, kéo tụt $beta_1 dot beta_2 << 1$.

#rule-box[
  *Câu hỏi 2 (Dịch Chuyển Ngưỡng Logic $V_M$ & Biến Thiên Tiến Trình PVT):*  
  Cổng đảo CMOS có $V_("dd") = 1.0"V"$, $V_(t n) = 0.3"V"$, $|V_(t p)| = 0.3"V"$.
  1. Dẫn xuất công thức $V_M$ tại điểm bão hòa cân bằng dòng và chứng minh $V_M = V_("dd")/2$ khi đối xứng.
  2. Khi rơi vào góc lệch tiến trình cực đoan *FS (Fast nMOS, Slow pMOS)* với $beta_n' = 1.44 beta_n, V_(t n)' = 0.22"V"$ và $beta_p' = 0.64 beta_p, |V_(t p)'| = 0.38"V"$, tính giá trị chính xác của $V_M'$?
  3. Đường đặc tuyến VTC bị dịch sang hướng nào và mạch trở nên dễ tổn thương trước loại nhiễu nào?
]

_Lời giải chi tiết:_
1. *Dẫn xuất $V_M$:* Cân bằng dòng bão hòa $1/2 beta_n (V_M - V_(t n))^2 = 1/2 beta_p (V_("dd") - V_M - |V_(t p)|)^2$. Đặt $r = sqrt(beta_p / beta_n)$, ta có:
   $ V_M = frac(V_(t n) + r (V_("dd") - |V_(t p)|), 1 + r) $
   Khi $r = 1$ và $V_(t n) = |V_(t p)| = 0.3"V"$, $V_M = 0.5"V" = V_("dd")/2$.
2. *Tính toán góc FS:*
   $ r' = sqrt(frac(beta_p', beta_n')) = sqrt(frac(0.64, 1.44)) = frac(0.8, 1.2) = frac(2, 3) approx 0.667 $
   $ V_M' = frac(0.22 + 0.667 dot (1.0 - 0.38), 1 + 0.667) = frac(0.22 + 0.4133, 1.667) approx 0.38"V" $
3. *Phân tích nhiễu:* Đặc tuyến VTC bị *trượt mạnh sang bên trái*. Lề nhiễu mức thấp $N M_L = V_(I L) - 0"V"$ bị bóp nghẹt nghiêm trọng. Mạch trở nên cực kỳ nhạy cảm và dễ nhảy sai trạng thái logic khi gặp *Nhiễu nảy đất (Ground Bounce)* trên đường dây GND!

#physical-box[
  *Câu hỏi 3 (Bí Ẩn Định Cỡ P/N Trong Nanomet: Velocity Saturation vs Self-Loading):*  
  1. Vì sao lý thuyết Shockley khuyên chọn $W_p / W_n approx 2.5:1$ để cân bằng trễ $t_(p d r) = t_(p d f)$?
  2. Vì sao trong tiến trình 65nm BSIM, hiện tượng bão hòa vận tốc làm tỷ số dòng thực tế $I_("on,n")/I_("on,p")$ co hẹp chỉ còn $1.5 - 1.8$?
  3. Dẫn xuất toán học chứng minh cực tiểu thời gian trễ trung bình đạt được tại $W_p / W_n = sqrt(mu_n / mu_p) approx 1.5 - 1.7$?
]

_Lời giải chi tiết:_
1. *Lý thuyết Shockley:* $I_("dsat") prop mu W$. Để $R_("on,p") = R_("on,n")$, cần $mu_p W_p = mu_n W_n arrow.r W_p/W_n = mu_n / mu_p approx 2.5 - 3.0$.
2. *Bão hòa vận tốc:* Electron có $mu_n$ cao nên điện trường tới hạn $E_c = 2 v_("sat") / mu_n$ rất nhỏ ($1.5 times 10^4 "V/cm"$). Ngay ở điện áp nhỏ trên kênh $65"nm"$, nMOS đã bị bão hòa vận tốc hoàn toàn, dòng chỉ tăng bậc 1 theo $(V_(g s) - V_t)$. Ngược lại, lỗ trống có $mu_p$ nhỏ nên $E_c$ lớn hơn gấp đôi, ít bị bão hòa hơn. Do đó tỷ số dòng $I_("on,n")/I_("on,p")$ co hẹp còn $1.5 - 1.8$.
3. *Cực tiểu trễ trung bình:* Đặt $k = W_p / W_n$. Trễ trung bình $t_(p d, a v g) = 1/2 (R_n + R_p) C_L prop (1 + mu_r / k) (A + B k)$. Lấy đạo hàm theo $k$ và cho bằng 0: $d/d k = B - mu_r A / k^2 = 0 arrow.r k_("opt") = sqrt(mu_r) = sqrt(mu_n / mu_p) approx sqrt(2.5) approx 1.58$. Định cỡ lớn hơn sẽ làm tụ tự tải $C_(d b)$ phình to ngáng chân tốc độ!

#math-box[
  *Câu hỏi 4 (Hiệu Ứng DIBL & Mô Hình Hóa Dòng Rò Dưới Ngưỡng BSIM):*  
  Một chip $28"nm"$ chạy $V_("dd") = 0.9"V"$. Ở chế độ nghỉ ($V_("in") = 0"V"$, nMOS ngắt, $V_(d s,n) = 0.9"V"$), hệ số $S = 80"mV/decade"$ ở $300"K"$:
  1. Giải thích hiện tượng DIBL dưới góc độ phân bố rào cản thế năng tĩnh điện cực Máng?
  2. Với tham số BSIM $"ETA0" = 0.075$, khi $V_(d s)$ tăng từ $0.05"V"$ lên $0.9"V"$, $V_t$ sụt bao nhiêu millivolt?
  3. Dòng rò dưới ngưỡng $I_("sub")$ tăng vọt bao nhiêu lần? Khi nhiệt độ tăng lên $87^circle.small "C"$ ($360"K"$), dòng rò thay đổi ra sao?
]

_Lời giải chi tiết:_
1. *Cơ chế DIBL:* Khi kênh co ngắn, vùng suy giảm cực Máng tiến sát cực Source. Điện thế dương lớn tại cực Máng thâm nhập vào kênh, kéo tụt đỉnh rào thế năng tĩnh điện ngăn cách electron, làm hạt dẫn dễ dàng tràn sang Máng, tương đương với việc $V_t$ sụt giảm.
2. *Độ sụt $V_t$:* $Delta V_t = "ETA0" dot (0.9"V" - 0.05"V") = 0.075 times 0.85"V" = 63.75"mV"$.
3. *Bùng nổ dòng rò:* $I_("sub")' / I_("sub") = 10^(Delta V_t / S) = 10^(63.75 / 80) = 10^(0.7969) approx 6.26$ lần! Ở $360"K"$, $S$ tăng lên $96"mV/decade"$ và năng lượng kích thích nhiệt $k_B T$ tăng làm dòng rò nhiệt tăng gấp $10 - 30$ lần so với nhiệt độ phòng!

#rule-box[
  *Câu hỏi 5 (Tối Ưu Chuỗi Đệm Inverter & Quá Độ Miller Ngược Chiều):*  
  Mạch cần lái tải dung $C_L = 512"fF"$ từ cổng kích thước tối thiểu $C_("in") = 2"fF"$:
  1. Tính số tầng $N$ tối ưu, hệ số phóng đại $f$ và tổng độ trễ chuẩn hóa?
  2. Vì sao trong thực tế thiết kế, kỹ sư thường chọn $f approx 3.5 - 4.0$ thay vì $e approx 2.718$?
  3. Khi $V_("in")$ nhảy từ $1 arrow.r 0$, vì sao $V_("out")$ bị nhúng âm (Undershoot bump) trong vài pico-giây đầu? Nguy cơ vật lý là gì?
]

_Lời giải chi tiết:_
1. *Tối ưu hóa Logical Effort:* $F = C_L / C_("in") = 256$. Khi $gamma = 0$, $f = e approx 2.72 arrow.r N = ln(256) approx 5.54 arrow.r N = 6$ tầng, $f = 256^(1/6) = 2.52$, $D = 6 times (2.52 + 1) = 21.12 tau_0$.
2. *Thực tế $f = 4$:* Chọn $f = 4$ thì $N = log_4(256) = 4$ tầng, $D = 4 times (4 + 1) = 20 tau_0$. Chuỗi 4 tầng tiết kiệm gần 50% diện tích silicon ($W_("total") = 85$ so với $168$ đơn vị) và giảm 50% công suất sạc xả tụ động!
3. *Miller Undershoot Bump:* Tụ điện ký sinh chồng lấn cực Cổng - Cực Máng $C_(g d)$ bắc cầu trực tiếp giữa ngõ vào và ngõ ra. Khi $V_("in")$ rơi dốc đứng ($d V_("in") / d t < 0$), dòng điện dịch $I = C_(g d) (d V_("in")/d t)$ kéo giật nút ngõ ra tụt xuống mức âm ($-0.15"V"$) trước khi pMOS kịp cấp dòng. Nếu nút ngõ ra tụt sâu quá $-0.6"V"$, tiếp giáp $p$-substrate/$n^+$ ngõ ra sẽ phân cực thuận, bơm electron vào nền silicon và kích hoạt thảm họa *Latch-Up*!
