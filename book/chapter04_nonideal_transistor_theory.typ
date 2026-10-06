#set page(
  paper: "a4",
  margin: (x: 2.0cm, top: 2.2cm, bottom: 2.2cm),
  header: align(right)[
    #text(size: 8.5pt, fill: rgb("#64748b"))[Thiết kế Vi mạch VLSI từ Bản chất Vật lý | Chương 4: Lý thuyết Transistor Phi Lý Tưởng]
  ],
  footer: [
    #line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
    #grid(
      columns: (1fr, 1fr),
      align(left)[#text(size: 8pt, fill: rgb("#94a3b8"))[Tài liệu Tự học Chuyên sâu (Lộ trình 4 Giờ - ĐH CNTT UIT)]],
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

// Hộp ghi chú chuyên dụng
#let callout(title, body, border-color, bg-color, icon) = block(
  breakable: false,
  fill: bg-color,
  stroke: (left: 4pt + border-color),
  inset: (x: 12pt, y: 9pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #grid(
      columns: (auto, 1fr),
      gutter: 6pt,
      text(weight: "bold", size: 10pt, fill: border-color)[#icon #title],
      []
    )
    #v(3pt)
    #text(size: 9.3pt)[#body]
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

// Tiêu đề sách
#align(center)[
  #text(size: 22pt, weight: "bold", fill: rgb("#0f172a"))[Chương 4: Lý thuyết Transistor Phi Lý Tưởng]
  #v(2pt)
  #text(size: 12pt, fill: rgb("#334155"))[Hiệu Ứng Điện Trường Cao, Dòng Rò Nano & Các Góc Mô Phỏng PVT]
  #v(1pt)
  #text(size: 9pt, style: "italic", fill: rgb("#64748b"))[
    Tài liệu Chuyên sâu 4 Giờ | Bám sát Slide Bài giảng UIT (chapter4-nonideal.pdf) & CMOS VLSI Design (Weste & Harris)
  ]
  #v(6pt)
  #line(length: 100%, stroke: 1.5pt + rgb("#0284c7"))
]

#v(6pt)
== Lộ trình Học tập 4 Giờ Cốt lõi (4-Hour Study Roadmap)
Tài liệu này giải mã vì sao mô hình Shockley sụp đổ trong kỷ nguyên nanomet và trang bị phương pháp luận làm chủ transistor thực tế:

#table(
  columns: (1.2fr, 2.4fr, 3.4fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 6.5pt,
  [*Thời gian*], [*Nội dung Trọng tâm*], [*Mục tiêu Bản chất Cần Đạt Được*],
  [Giờ 1 (0h - 1h)], [Sự Sụp Đổ Shockley & Điện Trường Cao], [Phân tích tán xạ mặt oxit ($mu_(e f f)$); trần vận tốc $v_(s a t)$ do phonon quang; quan hệ $I_(d s a t)$ bậc 1; biến điệu kênh $lambda$ (CLM).],
  [Giờ 2 (1h - 2h)], [Biến Thiên Điện Áp Ngưỡng $V_t$], [Hiểu cơ chế Body Effect ($V_(s b) > 0$); cực Drain đâm xuyên hạ rào cản (DIBL); chia sẻ điện tích ($V_t$ Roll-off) và đỉnh bù Halo (RSCE).],
  [Giờ 3 (2h - 3h)], [Dòng Rò Nano & Độ Nhạy Nhiệt], [Làm chủ 3 con đường rò ($I_(s u b), I_(g a t e), I_(j u n c)$); độ dốc $S$; đột phá HKMG; cuộc giằng co giữa $mu(T)$ và $V_t(T)$ và hiện tượng đảo nhiệt ZTC.],
  [Giờ 4 (3h - 4h)], [Biến Thiên Quy Trình & Góc PVT], [Nắm vững 5 góc quy trình (TT, FF, SS, FS, SF) và 4 kịch bản ký duyệt vi mạch then chốt: Max Delay (Setup), Min Delay (Hold), Leakage, Power.]
)

---

== 0. Bảng thuật ngữ cốt lõi (Glossary)

#table(
  columns: (1.8fr, 1.8fr, 3.4fr),
  fill: (x, y) => if y == 0 { rgb("#f1f5f9") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 5.5pt,
  [*Thuật ngữ Tiếng Anh*], [*Thuật ngữ Tiếng Việt*], [*Ý nghĩa Vật lý & Mạch điện*],
  [Mobility Degradation], [Suy giảm độ linh động], [Điện trường dọc ép electron va đập vào mặt $S i - S i O_2$ gồ ghề, làm giảm $mu_(e f f)$.],
  [Velocity Saturation ($v_(s a t)$)], [Bão hòa vận tốc], [Vận tốc hạt dẫn chạm trần tối đa ($10^7" cm/s"$) do phát xạ phonon quang vào mạng tinh thể.],
  [Channel Length Mod. (CLM, $lambda$)], [Biến điệu chiều dài kênh], [Vùng nghèo Drain mở rộng lấn vào kênh, rút ngắn kênh ($L_(e f f) = L - L_d$) và tạo độ dẫn $g_(d s) > 0$.],
  [Body Effect ($gamma$)], [Hiệu ứng phân cực đế], [$V_(s b) > 0$ làm mở rộng vùng nghèo dưới cổng, buộc cực cổng phải tích nhiều áp hơn để bật (tăng $V_t$).],
  [DIBL ($eta$)], [Hạ thấp rào thế do cực Máng], [Điện trường cực Máng đâm xuyên vào kênh, hạ thấp đỉnh rào cản thế ở cực Nguồn ($V_t' = V_(t 0) - eta V_(d s)$).],
  [Short-Channel Effect (SCE)], [Hiệu ứng kênh ngắn / $V_t$ Roll-off], [Vùng nghèo Source/Drain chia sẻ bớt điện tích trong kênh, làm $V_t$ sụt giảm khi $L$ ngắn lại.],
  [Reverse SCE (RSCE)], [Hiệu ứng kênh ngắn ngược], [$V_t$ tăng nhẹ khi $L$ bắt đầu ngắn lại do nồng độ cấy bù Halo ở hai mép kênh chồng lấn nhau.],
  [Subthreshold Swing ($S$)], [Độ dốc dưới ngưỡng], [Số milivolt điện áp cổng cần thiết để dòng rò dưới ngưỡng tăng/giảm $10 times$ (thường $70 - 100" mV/dec"$).],
  [Gate Tunneling ($I_(g a t e)$)], [Dòng rò xuyên hầm cổng], [Electron chui lượng tử qua lớp oxit cổng siêu mỏng khi bề dày $t_(o x) <= 1.5" nm"$.],
  [High-$kappa$ Metal Gate (HKMG)], [Cổng kim loại điện môi $kappa$ cao], [Thay $S i O_2$ bằng $H f O_2$ ($kappa approx 25$), cho phép tăng bề dày vật lý để triệt tiêu dòng rò xuyên hầm.],
  [Temperature Inversion (ZTC)], [Đảo ngược nhiệt độ], [Ở điện áp thấp, sự giảm $V_t$ theo nhiệt lấn át sự giảm độ linh động, khiến chip nóng chạy nhanh hơn chip lạnh.],
  [Process Corners (PVT)], [Các góc quy trình PVT], [Kỹ thuật mô phỏng ở các tổ hợp tham số biên xấu nhất (Fast, Typical, Slow) để ký duyệt chip tin cậy.]
)

---

== Giờ 1: Sự Sụp Đổ Của Shockley & Các Hiệu Ứng Điện Trường Cao

#figure(
  image("images/fig4_1_high_field_effects.png", width: 100%),
  caption: [Hình 4.1: Các hiệu ứng Điện trường cao & Sự sụp đổ của Mô hình Shockley]
)

=== 1.1 Khởi đầu từ thực tế: Shockley lý tưởng vs Dữ liệu 65nm
Trong mô hình Shockley kinh điển, dòng bão hòa phụ thuộc bậc 2 vào điện áp cổng:
$ I_(d s a t) = frac(beta, 2) (V_(g s) - V_t)^2 $
Nhưng trên tiến trình 65nm ($V_(D D) = 1.0"V"$):
1. Dòng bão hòa thực tế chỉ đạt $approx 747 mu"A"/mu"m"$, thấp hơn dự báo Shockley hơn $2 times$.
2. Khi tăng $V_(g s)$ theo các bước đều đặn ($0.4"V" -> 0.6"V" -> 0.8"V" -> 1.0"V"$), khoảng cách giữa các đường cong $I_(d s)$ cách đều nhau tuyến tính (bậc 1) thay vì giãn nở bậc 2.
3. Trong vùng bão hòa, đặc tuyến không nằm ngang mà nghiêng dốc theo $V_(d s)$.

=== 1.2 Bức tranh hai điện trường trong lòng kênh dẫn
Khi kích thước hình học thu nhỏ xuống nanomet, hai điện trường cực mạnh xuất hiện:
- *Điện trường dọc:* $cal(E)_(v e r t) = frac(V_(g s) - V_(d s)/2, t_(o x)) > 10^6" V/cm"$. Điện trường này kéo ép các electron va đập sát vào bề mặt oxit.
- *Điện trường ngang:* $cal(E)_(l a t) = frac(V_(d s), L) > 10^5" V/cm"$. Điện trường này gia tốc hạt mang điện dọc theo chiều dài kênh.

=== 1.3 Suy giảm độ linh động (Mobility Degradation)
Dưới điện trường dọc cực lớn, electron bị ép dính chặt vào giao diện $S i - S i O_2$ gồ ghề ở cấp độ nguyên tử. Sự tán xạ va đập bề mặt liên tục làm giảm độ linh động hiệu dụng:
$ mu_(e f f) = frac(mu_0, 1 + theta (V_(g s) - V_t)) $

=== 1.4 Bão hòa vận tốc (Velocity Saturation)
Khi điện trường ngang vượt ngưỡng tới hạn $cal(E)_c approx 10" kV/cm"$, electron thu nhận động năng lớn và phát xạ liên tục phonon quang vào mạng tinh thể. Vận tốc trôi chạm trần giới hạn $v_(s a t)$:
- Electron: $v_(s a t, n) approx 10^7" cm/s" = 10^5" m/s"$.
- Lỗ trống: $v_(s a t, p) approx 8 times 10^6" cm/s"$.

#math-box[
  *Dẫn xuất dòng bão hòa vận tốc bậc 1:*
  Khi hạt mang điện chạm trần vận tốc $v_(s a t)$, dòng điện chạy qua kênh được xác định bởi mật độ điện tích lớp đảo nhân với $v_(s a t)$:
  $ I_(d s a t) = W C_(o x) (V_(g s) - V_t - V_(d s a t)) v_(s a t) prop (V_(g s) - V_t) $
  Số mũ bình phương bị bẻ gãy hoàn toàn thành hàm bậc 1!  
  Đồng thời, transistor bị bão hòa tại điện áp nhỏ hơn rất nhiều:
  $ V_(d s a t) = (V_(g s) - V_t) parallel (cal(E)_c L) = frac((V_(g s) - V_t) cal(E)_c L, (V_(g s) - V_t) + cal(E)_c L) < V_(g s) - V_t $
]

=== 1.5 Biến điệu chiều dài kênh (Channel Length Modulation - CLM)
Vùng nghèo tiếp giáp Drain phân cực ngược lấn sâu vào kênh dẫn một đoạn $L_d prop sqrt(V_(d s))$. Chiều dài kênh thực tế ngắn lại: $L_(e f f) = L - L_d$. Nội trở kênh giảm khiến dòng $I_(d s)$ tiếp tục tăng trong vùng bão hòa:
$ I_(d s) = I_(d s a t) (1 + lambda V_(d s)) quad "với" quad lambda prop frac(1, L) $
Hệ quả là điện trở ngõ ra $r_o = 1 / g_(d s) approx 1 / (lambda I_(d s a t))$ bị suy giảm, kéo tụt hệ số khuếch đại điện áp của transistor.

---

== Giờ 2: Các Hiệu Ứng Biến Thiên Điện Áp Ngưỡng $V_t$

#figure(
  image("images/fig4_2_threshold_voltage_effects.png", width: 100%),
  caption: [Hình 4.2: Các hiệu ứng Biến thiên Điện áp Ngưỡng $V_t$ (Body Effect, DIBL, Charge Sharing)]
)

=== 2.1 Hiệu ứng Phân cực Đế (Body Effect)
Khi cực Source có điện thế cao hơn cực Đế ($V_(s b) > 0"V"$, như trong mạch Pass Transistor hoặc tầng trên của NAND stack):
1. Phân cực ngược tiếp giáp Source-Body mở rộng bề dày vùng nghèo $W_(d e p)$ bên dưới kênh dẫn.
2. Lượng ion tạp chất âm cố định $B^-$ cần trung hòa tăng lên đáng kể.
3. Cực Cổng phải cấp điện áp dương lớn hơn trước khi có thể đảo kênh $->$ *$V_t$ tăng cao!*

#math-box[
  *Phương trình hiệu ứng đế:*
  $ V_t = V_(t 0) + gamma (sqrt(phi_s + V_(s b)) - sqrt(phi_s)) $
  Trong đó $phi_s = 2 phi_F approx 0.6 - 0.7"V"$, và hệ số hiệu ứng đế:
  $ gamma = frac(sqrt(2 q epsilon_(s i) N_A), C_(o x)) = frac(t_(o x), epsilon_(o x)) sqrt(2 q epsilon_(s i) N_A) approx 0.4 - 0.6" V"^(1/2) $
]

=== 2.2 Hạ thấp rào thế do cực Máng (DIBL - Drain-Induced Barrier Lowering)
Khi chiều dài kênh $L$ thu nhỏ, khoảng cách hình học giữa Drain và Source rất ngắn:
- Điện trường từ cực Máng $V_(d s)$ đâm xuyên sâu vào lòng kênh, bẻ cong dải dẫn $E_c$ và kéo tụt đỉnh rào cản thế năng tại cực Nguồn.
- Cực Máng đã "hỗ trợ" cực Cổng bật dòng điện sớm hơn:
$ V_t' = V_(t 0) - eta V_(d s) $
Với hệ số DIBL $eta approx 0.05 - 0.15" V/V"$ ở tiến trình nanomet. Khi $V_(d s) = 1.0"V"$, $V_t$ bị kéo sụt tới $50 - 150" mV"$, kích hoạt dòng rò tĩnh bùng nổ!

=== 2.3 Hiệu ứng Kênh ngắn & Chia sẻ điện tích ($V_t$ Roll-off)
Vùng nghèo của Source và Drain đã tự gánh bớt một phần điện tích không gian ion tạp chất ở hai đầu kênh (mô hình hình thang Yau). Cực Cổng chỉ cần hỗ trợ phần diện tích hình thang còn lại. Khi $L$ càng ngắn, tỷ lệ chia sẻ càng lớn, khiến *$V_t$ sụt giảm dần theo chiều dài cổng $L$*.

=== 2.4 Hiệu ứng Kênh ngắn Ngược (RSCE) do cấy bù Halo
Để chặn đứng hiện tượng $V_t$ Roll-off và đấm xuyên (Punchthrough), các nhà máy cấy thêm tạp chất p nồng độ cao cục bộ sát hai mép Source/Drain (Halo implants). Khi $L$ giảm đến vùng trung bình ngắn, hai vùng Halo chồng lấn làm nồng độ tạp chất trung bình trong kênh tăng vọt, tạo ra đỉnh nhô lên *$V_t$ tăng khi $L$ giảm nhẹ* (Reverse Short-Channel Effect) trước khi sụp đổ ở kênh siêu ngắn.

---

== Giờ 3: Cơn Ác Mộng Dòng Rò Nano & Độ Nhạy Nhiệt Độ

#figure(
  image("images/fig4_3_nanoscale_leakage_mechanisms.png", width: 100%),
  caption: [Hình 4.3: Ba con đường Rò rỉ Bán dẫn Nanomet & Đột phá Công nghệ HKMG]
)

=== 3.1 Dòng rò Dưới ngưỡng (Subthreshold Leakage)
Khi $V_(g s) < V_t$, transistor không ngắt tuyệt đối. Mật độ electron thiểu số bề mặt khuếch tán từ Source sang Drain tạo thành dòng rò dưới ngưỡng:
$ I_(s u b) = I_0 exp(frac(V_(g s) - V_(t 0) + eta V_(d s) - k_gamma V_(s b), n v_T)) (1 - exp(- frac(V_(d s), v_T))) $
- Thế nhiệt: $v_T = frac(k_B T, q) approx 26" mV (ở 300K)"$.
- *Độ dốc dưới ngưỡng (Subthreshold Swing $S$):*
$ S = ln(10) dot n v_T approx 80 - 100" mV/decade" $
- *Giới hạn nhiệt động lực học ($n=1$):* $S_(i d e a l) = ln(10) v_T approx 60" mV/decade"$. Không thể tắt transistor đột ngột như một công tắc cơ học!

=== 3.2 Dòng rò Xuyên hầm qua Cực Cổng (Gate Leakage) & Đột phá HKMG
Khi lớp oxit $S i O_2$ bị mài mỏng xuống $t_(o x) <= 1.2" nm"$ ($approx 4-5$ lớp nguyên tử), hàm sóng lượng tử của electron chui hầm trực tiếp xuyên qua lớp oxit:
$ I_(g a t e) prop exp(-alpha t_(o x)) $
- Cứ mỏng đi $0.2" nm"$, dòng rò cổng tăng gấp 10 lần! nMOS rò nặng hơn pMOS $10 - 100 times$ do rào thế electron thấp hơn ($3.15" eV"$ vs $4.5" eV"$).
- *Giải pháp High-$kappa$ Metal Gate (HKMG):* Thay $S i O_2$ ($kappa = 3.9$) bằng $H f O_2$ ($kappa approx 25$). Nhờ $C_(o x) = frac(kappa epsilon_0, t_(p h y s))$, xưởng đúc có thể tăng bề dày vật lý lên gấp 5 lần ($t_(p h y s) approx 5 - 6" nm"$) mà điện dung không đổi, triệt tiêu dòng xuyên hầm cổng hơn 100 lần!

=== 3.3 Dòng rò Tiếp giáp P-N & Xuyên hầm Dải-sang-Dải (BTBT)
Xảy ra tại tiếp giáp phân cực ngược Source/Drain sang Substrate. Bên cạnh dòng nhiệt đảo chiều $I_D approx -I_s$, ở nồng độ tạp chất cao (vùng mép Halo), dải hóa trị trong chất nền p chồng lấn với dải dẫn của Drain, kích hoạt dòng *Band-to-Band Tunneling (BTBT)* electron chui trực tiếp xuyên dải cấm $E_g$.

=== 3.4 Độ nhạy Nhiệt độ & Hiện tượng Đảo ngược Nhiệt độ (Temperature Inversion)
Nhiệt độ $T$ tác động hai mặt đối nghịch:
1. Độ linh động giảm mạnh: $mu(T) prop T^(-1.5)$ do tán xạ phonon mạng tinh thể.
2. Điện áp ngưỡng giảm tuyến tính: $frac(d V_t, d T) approx -1.0 " đến " -2.0" mV/°C"$.
- *Ở điện áp danh định ($V_(D D) = 1.0"V"$):* Suy giảm $mu$ áp đảo $->$ *Chip nóng chạy CHẬM HƠN!*
- *Ở chế độ tắt ($V_(g s) = 0"V"$):* $V_t$ giảm và $v_T$ tăng khiến dòng rò tĩnh bùng nổ gấp $20 - 50 times$ ở 125°C.
- *Hiện tượng Đảo ngược Nhiệt độ (ZTC Point):* Ở điện áp siêu thấp ($V_(D D) < V_(Z T C) approx 0.52"V"$), độ sụt $V_t$ lấn át $mu$, khiến *chip nóng lại chạy NHANH HƠN chip lạnh*!

---

== Giờ 4: Biến Thiên Quy Trình & Các Góc Mô Phỏng PVT

#figure(
  image("images/fig4_4_pvt_variations_and_corners.png", width: 100%),
  caption: [Hình 4.4: Bản đồ Biến thiên Quá trình, Điện áp, Nhiệt độ (PVT Corners)]
)

=== 4.1 Nguồn gốc Biến thiên Tham số Bán dẫn
- *Biến thiên quy trình (Process):* Sai số quang khắc độ dài kênh $Delta L$, sai số bề dày oxit $Delta t_(o x)$, và Thăng giáng tạp chất ngẫu nhiên (RDF - Random Dopant Fluctuation) với sự lệch vài nguyên tử Boron trong kênh nano.
- *Biến thiên môi trường (Voltage, Temp):* Sụt áp đường nguồn kim loại ($V_(D D) plus.minus 10%$) và nhiệt độ vận hành (0°C $->$ 125°C).

=== 4.2 Năm góc quy trình kinh điển (TT, FF, SS, FS, SF)
- *Fast (F):* Kênh ngắn, oxit mỏng, $V_t$ thấp $->$ dòng $I_(o n)$ cực mạnh, rò rỉ cực lớn.
- *Slow (S):* Kênh dài, oxit dày, $V_t$ cao $->$ dòng $I_(o n)$ yếu, trễ dài, rò rỉ rất nhỏ.
- *Lệch góc (FS / SF):* Góc FS có nMOS nhanh, pMOS chậm khiến đặc tuyến VTC lệch trái, bóp hẹp dải dự trữ nhiễu mức thấp $N M_L$, rất sợ nhiễu Ground Bounce! Góc SF thì ngược lại.

=== 4.3 Bốn kịch bản Ký duyệt Vi mạch then chốt (Signoff Corners)
1. *Max Delay / Setup Signoff:* Góc *SS*, $V_(D D, m i n)$ (-10%), $T_(m a x) = 125$°C. Trễ dữ liệu dài nhất, quyết định tần số xung nhịp tối đa $f_(m a x)$.
2. *Min Delay / Hold Signoff:* Góc *FF*, $V_(D D, m a x)$ (+10%), $T_(m i n) = 0$°C. Dữ liệu phóng quá nhanh, có nguy cơ ghi đè hỏng dữ liệu thanh ghi. Vi phạm Hold time làm con chip chết vĩnh viễn ở mọi tần số!
3. *Worst-Case Static Leakage:* Góc *FF*, $V_(D D, m a x)$, $T_(m a x) = 125$°C. Rò rỉ dưới ngưỡng và rò oxit cực đại, ký duyệt thời lượng pin Standby.
4. *Maximum Dynamic Power:* Góc *FF*, $V_(D D, m a x)$, $T_(m a x)$ ở $f_(m a x)$. $P_(d y n) = C V_(D D)^2 f$ đạt đỉnh, định cỡ tản nhiệt và chống ăn mòn dây kim loại (Electromigration).

---

== 5. Bảng So sánh & 5 Câu hỏi Tự kiểm tra Năng lực

=== 5.1 So sánh Tổng hợp: Shockley vs Kênh ngắn Nano

#table(
  columns: (2.0fr, 2.2fr, 2.8fr),
  fill: (x, y) => if y == 0 { rgb("#f1f5f9") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 5.5pt,
  [*Hiện tượng*], [*Shockley Kênh dài*], [*Tiến trình Nano Thực tế (BSIM)*],
  [Quan hệ dòng bão hòa], [$I_(d s a t) prop (V_(g s) - V_t)^2$ (bậc 2)], [$I_(d s a t) prop (V_(g s) - V_t)$ (bậc 1 do bão hòa vận tốc $v_(s a t)$).],
  [Điện áp bão hòa $V_(d s a t)$], [$V_(d s a t) = V_(g s) - V_t$], [$V_(d s a t) = (V_(g s) - V_t) parallel (cal(E)_c L) << V_(g s) - V_t$.],
  [Độ dẫn ra bão hòa $g_(d s)$], [$g_(d s) = 0$ (phẳng lì)], [$g_(d s) > 0$ (nghiêng dốc theo $lambda = 1/L$).],
  [Phân cực ngược đế $V_(s b) > 0$], [Coi như không đổi], [$V_t$ tăng theo $gamma (sqrt(phi_s + V_(s b)) - sqrt(phi_s))$.],
  [Ảnh hưởng cực Máng lên $V_t$], [Không có ảnh hưởng], [$V_t$ giảm theo DIBL: $V_t' = V_(t 0) - eta V_(d s)$.],
  [Dòng điện khi tắt ($V_(g s) = 0$)], [$I_(o f f) = 0$ (ngắt hoàn toàn)], [$I_(o f f) = I_(s u b) + I_(g a t e) + I_(j u n c) > 0$.]
)

=== 5.2 Lời giải 5 Bài toán Tự kiểm tra Năng lực (Tóm tắt cốt lõi)

#rule-box[
  *Bài 1 (Bão hòa vận tốc 65nm):*  
  Với $t_(o x) = 1.2" nm" => C_(o x) = 28.78" fF"/mu"m"^2$.  
  Độ linh động bị suy giảm do tán xạ mặt oxit: $mu_(e f f) = 350 / (1 + 0.25 times 0.7) approx 298" cm"^2/"V"s$.  
  Mô hình Shockley dự đoán sai $I_(s a t) approx 3230 mu"A"$, trong khi bão hòa vận tốc thực tế $I_(d s a t) approx W C_(o x) v_(s a t) (V_(g s) - V_t) approx 2015 mu"A"$ (sai lệch tới $1.6 times$).
]

#rule-box[
  *Bài 2 (Body Effect trên Pass Transistor):*  
  nMOS truyền mức 1 tự khóa khi $V_(o u t) = V_(D D) - V_t(V_(o u t))$.  
  Với $V_(t 0) = 0.35"V", gamma = 0.45, phi_s = 0.65"V", V_(D D) = 1.2"V"$:  
  Giải phương trình lặp ta được $V_(o u t, m a x) approx 0.692"V"$ và $V_t$ thực tế bị đội lên tới $0.508"V"$ (tăng $45%$) do vùng nghèo dưới kênh phình rộng!
]

#rule-box[
  *Bài 3 (DIBL & Bùng nổ Dòng rò):*  
  Với $eta = 80" mV/V"$, khi $V_(d s)$ tăng thêm $0.85"V"$, điện áp ngưỡng bị kéo tụt:  
  $Delta V_t = 0.08 times 0.85 = 68" mV"$.  
  Dòng rò dưới ngưỡng tăng vọt: $10^(68" mV" / 85" mV/dec") = 10^(0.80) approx 6.31" lần"$!
]

#rule-box[
  *Bài 4 (Rò rỉ Xuyên hầm Cổng & HKMG):*  
  Với 500 triệu cổng ở 45nm dùng $S i O_2$, dòng rò xuyên hầm cổng đạt $185.6" mA"$, tiêu tán công suất rò $186" mW"$.  
  Nâng cấp lên HKMG ($H f O_2, kappa approx 25$) cho phép tăng bề dày vật lý lên $5.5" nm"$, dập tắt dòng rò cổng giảm 150 lần xuống chỉ còn $1.24" mW"$ (giảm $99.3%$ công suất rò).
]

#rule-box[
  *Bài 5 (Ký duyệt Hold-Time Race):*  
  Đường truyền có $t_(d a t a, m i n) = t_(p c q, c d) + t_(l o g i c, c d) = 40 + 10 = 50" ps"$ tại góc Fast (FF, $V_(D D, m a x)$, 0°C).  
  Yêu cầu an toàn: $t_(r e q) = t_(h o l d) + t_(s k e w) = 30 + 25 = 55" ps"$.  
  Độ dôi thời gian: $"Slack"_(h o l d) = 50 - 55 = -5" ps" < 0$ $->$ *Vi phạm Hold-time nghiêm trọng!*  
  Khắc phục: Chèn thêm buffer đệm trễ $Delta t >= 10" ps"$ trên đường dữ liệu; đánh đổi thêm diện tích và công suất động.
]
