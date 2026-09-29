#set page(
  paper: "a4",
  margin: (x: 2.0cm, top: 2.2cm, bottom: 2.2cm),
  header: align(right)[
    #text(size: 8.5pt, fill: rgb("#64748b"))[Thiết kế Vi mạch VLSI từ Bản chất Vật lý | Chương 2: Mạch Logic CMOS & Bố cục Silicon]
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
  "Cảnh báo Lỗi Phổ biến (Common Pitfall)",
  body,
  rgb("#d97706"),
  rgb("#fffbeb"),
  "⚠️"
)

// Tiêu đề sách
#align(center)[
  #text(size: 22pt, weight: "bold", fill: rgb("#0f172a"))[Chương 2: Mạch Logic CMOS & Bố cục Silicon]
  #v(2pt)
  #text(size: 12pt, fill: rgb("#334155"))[Từ Bản chất Bán dẫn đến Nghệ thuật Bố cục Tối ưu trên Tinh thể Silicon]
  #v(1pt)
  #text(size: 9pt, style: "italic", fill: rgb("#64748b"))[
    Tài liệu Chuyên sâu 4 Giờ | Bám sát Slide Bài giảng UIT & Giáo trình CMOS VLSI Design (Weste & Harris)
  ]
  #v(6pt)
  #line(length: 100%, stroke: 1.5pt + rgb("#0284c7"))
]

#v(6pt)
== Lộ trình Học tập 4 Giờ Cốt lõi (4-Hour Study Roadmap)
Tài liệu này được thiết kế theo một *trục logic nhân quả bất biến*: khởi hành từ nguyên lý hút electron của nMOS, suy diễn ra bản chất đối ngẫu của pMOS, giải mã vì sao hai loại transistor này bắt buộc phải kết hợp thành CMOS, và từ đó lý giải toàn bộ cấu trúc mạch số, cổng truyền, phần tử nhớ đến cách sắp đặt tối ưu trên phiến silicon:

#table(
  columns: (1.2fr, 2.3fr, 3.5fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 6.5pt,
  [*Thời gian*], [*Nội dung Trọng tâm*], [*Mục tiêu Bản chất Cần Đạt Được*],
  [Giờ 1 (0h - 1h)], [Bản chất nMOS/pMOS, Nguyên lý CMOS & Ác mộng Sizing NOR], [Hiểu cơ chế điện trường dọc hút hạt mang điện của nMOS và pMOS; lý giải vì sao nMOS truyền mức 1 yếu còn pMOS truyền mức 0 yếu; dẫn xuất cấu trúc PUN/PDN và chứng minh vì sao pMOS trong NOR phải phình to gấp 4 lần do độ linh động lỗ trống kém.],
  [Giờ 2 (1h - 2h)], [Transistor Truyền dẫn & Cổng Truyền (Transmission Gate)], [Phân tích hiện tượng tự ngắt kênh ($V_(g s) arrow.r V_t$) khi dùng nMOS đơn lẻ truyền mức 1; giải mã cấu trúc cổng truyền đối ngẫu TG triệt tiêu sụt áp đạt full rail-to-rail swing và ứng dụng tối ưu mạch dồn kênh 2:1 MUX.],
  [Giờ 3 (2h - 3h)], [Mạch Tuần tự: D-Latch, DFF & Vật lý Setup/Hold], [Hiểu vòng phản hồi ổn định kép bistable; hoạt động 2 pha của D-Latch và Master-Slave DFF; giải mã nguồn gốc thời gian setup ($t_("setup")$) và hold ($t_("hold")$) từ động học nạp điện tích hạt vào tụ nội bộ.],
  [Giờ 4 (3h - 4h)], [Bố cục Silicon, Stick Diagram & Đột phá Euler Path], [Nắm vững các lớp vật lý silicon; vận dụng lý thuyết đồ thị tìm đường đi Euler chung để tạo dải diffusion liền mạch, cắt giảm $50%$ điện dung khuếch tán ký sinh $C_(d b)$ và tăng tốc vi mạch.]
)

#v(10pt)
= Giờ 1: Bản chất nMOS/pMOS, Nguyên lý CMOS & Ác mộng Kích thước NOR
_Tương ứng Slide 13 – 18 | Thời gian mục tiêu: 60 phút_

=== 1.1 Khởi hành từ Trực giác: Cơ chế Vật lý Vi mô của nMOS
Để hiểu sâu sắc toàn bộ chương này, chúng ta xuất phát từ chính bức tranh trực giác cơ bản mà bạn đã biết về transistor nMOS:
- *Cấu tạo vật lý:* Transistor nMOS được chế tạo trên một đế bán dẫn silicon loại p (p-substrate, nơi hạt đa số là lỗ trống tích điện dương, còn electron tự do là hạt thiểu số rất hiếm hoi). Hai bên là hai vùng khuếch tán pha tạp chất loại n nồng độ cao ($n^+$), đóng vai trò là cực Nguồn *(Source)* và cực Máng *(Drain)*. Nằm ngăn cách giữa chúng là lớp cách điện Silicon Dioxide ($"SiO"_2$), trên cùng là bản cực Cổng *(Gate)* bằng Polysilicon.
- *Điện trường thẳng đứng kiến tạo con kênh (Vertical Electric Field $vec(cal(E))_("vert")$):*  
  Khi ta cấp điện áp dương cao vào cực Cổng ($V_g = V_(d d)$), bản cực Cổng tích đầy điện tích dương. Nó tạo ra một điện trường vuông góc hướng thẳng từ cổng xuyên qua lớp oxit cách điện xuống chất nền p.  
  Vì hạt mang điện trái dấu thì hút nhau, điện trường này đẩy lùi các lỗ trống sâu xuống đáy chất nền, đồng thời *hút các hạt electron mang điện tích âm ($e^-$) từ khắp nơi trong đế p kéo dồn lên sát bề mặt tiếp giáp oxide*.  
  Khi hiệu điện thế cổng - nguồn vượt qua ngưỡng kích hoạt ($V_(g s) >= V_(t n)$), mật độ electron kéo lên dày đặc đến mức làm "đảo ngược" tính chất dẫn điện của lớp silicon bề mặt: một "con kênh dẫn n" *(Inversion Layer)* được đục thông, nối liền hai hòn đảo $n^+$ cực Source và cực Drain!
- *Điện trường nằm ngang thúc đẩy dòng chảy (Horizontal Electric Field $vec(cal(E))_("horiz")$):*  
  Khi kênh dẫn đã thông suốt, chỉ cần có chênh lệch điện thế giữa Drain và Source ($V_(d s) > 0$), một điện trường nằm ngang xuất hiện, đẩy các electron từ Source phóng vọt sang Drain. (Quy ước dòng điện $I_(d s)$ chạy ngược chiều electron, tức từ Drain về Source).
- 👉 *Quy luật nMOS:* Cấp cực Cổng mức *CAO* ($V_(d d)$) $arrow.r$ Hút electron, thông kênh $arrow.r$ *nMOS BẬT (ON)*. Cấp cực Cổng mức *THẤP* ($0" V"$) $arrow.r$ Mất điện trường hút, kênh tan biến $arrow.r$ *nMOS TẮT (OFF)*.

=== 1.2 Mảnh ghép Đối ngẫu Hoàn hảo: Transistor pMOS Hoạt động Như thế nào?
Bây giờ, hãy lật ngược lại toàn bộ bức tranh vật lý (Nguyên lý đối ngẫu - Physical Duality). Nếu nMOS dùng electron làm hạt dẫn thì pMOS hoạt động ra sao?

#physical-box[
  *Bản chất Vi mô của Transistor pMOS:*
  - *Cấu tạo vật lý:* Để tạo pMOS trên cùng một phiến silicon đế p, người ta phải tạo ra một "hồ chứa" silicon loại n gọi là *Giếng n (N-well)*. Trong N-well (nơi electron là hạt đa số), người ta cấy hai vùng khuếch tán loại p nồng độ cao ($p^+$) làm cực Source và Drain. Hạt mang điện tự do trong vùng $p^+$ này chính là các *lỗ trống ($h^+$) mang điện tích DƯƠNG*.
  - *Làm sao để đục thông kênh giữa hai cực $p^+$?*  
    Muốn nối thông hai cực $p^+$, ta cần tạo ra một con kênh chứa toàn các hạt mang điện dương là *lỗ trống ($h^+$)*.  
    Để hút các hạt tích điện dương ($h^+$) trồi lên mặt tiếp xúc oxide, cực Cổng (Gate) bắt buộc phải tích điện *ÂM* so với cực Nguồn:
    $ V_(g s) = V_g - V_s < V_(t p) < 0 $
  - *Cơ chế điều khiển:*  
    Cực Nguồn (Source) của pMOS thường được nối lên điện áp cao nhất mạch là $V_(d d)$ ($V_s = V_(d d)$).  
    - Khi ta đặt cực Cổng ở mức *THẤP* ($V_g = 0" V"$): Hiệu điện thế điều khiển đạt cực đại âm: $V_(g s) = 0 - V_(d d) = -V_(d d) << V_(t p)$. Cực cổng mang điện tích âm cực mạnh, tạo điện trường thẳng đứng đẩy electron trong N-well lặn xuống đáy, đồng thời *hút các hạt lỗ trống ($h^+$) dâng lên bề mặt*, đục thông một con kênh dẫn p *(p-inversion layer)* nối liền Source và Drain.  
      Khi $V_s > V_d$, các lỗ trống tràn từ Source ($V_(d d)$) sang Drain $arrow.r$ *pMOS BẬT (ON)*.
    - Khi ta đặt cực Cổng ở mức *CAO* ($V_g = V_(d d)$): Hiệu điện thế $V_(g s) = V_(d d) - V_(d d) = 0" V"$. Điện trường âm biến mất, kênh dẫn lỗ trống lập tức tan rã $arrow.r$ *pMOS TẮT (OFF)*.
  - 👉 *Kết luận đối xứng cốt lõi:*  
    - *nMOS:* BẬT khi Gate = $1$ ($V_(d d)$), TẮT khi Gate = $0$ ($0" V"$).  
    - *pMOS:* BẬT khi Gate = $0$ ($0" V"$), TẮT khi Gate = $1$ ($V_(d d)$).
]

=== 1.3 Nút thắt Tử huyệt: Tại sao BẮT BUỘC Phải Kết hợp Cả Hai Thành CMOS?
Đến đây, một câu hỏi tự nhiên nảy sinh trong đầu người kỹ sư: *Nếu nMOS đã dẫn được điện, tại sao ta không dùng toàn bộ nMOS để chế tạo mọi cổng logic cho đơn giản, mà phải tốn công cấy thêm N-well và chế tạo pMOS phức tạp?*

Câu trả lời nằm ở bản chất truyền mức logic của từng loại hạt mang điện:

#table(
  columns: (1.5fr, 2.5fr, 3.2fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 6.5pt,
  [*Loại Transistor*], [*Nhiệm vụ Kéo xuống Đất (Pull-Down)*], [*Nhiệm vụ Kéo lên Nguồn (Pull-Up)*],
  [nMOS (Hạt electron)], [*CỰC MẠNH (Strong '0')* \ Cực Source nối GND ($V_s = 0" V"$). Khi $V_g = V_(d d)$, $V_(g s) = V_(d d)$ giữ nguyên cực đại suốt quá trình xả. Tụ xả kiệt về đúng $0.0" V"$.], [*RẤT YẾU (Weak '1')* \ Nốt ra nối Source ($V_s = V_("out")$). Khi tụ nạp điện, $V_("out")$ tăng làm $V_(g s) = V_(d d) - V_("out")$ tụt dần. Khi $V_("out")$ chạm mốc $V_(d d) - V_(t n)$, kênh tự đóng sập! Điện áp kẹt cứng tại $V_(d d) - V_(t n)$.],
  [pMOS (Hạt lỗ trống)], [*RẤT YẾU (Weak '0')* \ Khi kéo xuống đất, kênh pMOS tự ngắt khi ngõ ra chạm $|V_(t p)|$. Ngõ ra không bao giờ xuống được $0.0" V"$.], [*CỰC MẠNH (Strong '1')* \ Cực Source nối $V_(d d)$ ($V_s = V_(d d)$). Khi $V_g = 0" V"$, $|V_(g s)| = V_(d d)$ giữ nguyên cực đại suốt quá trình nạp. Tụ nạp căng tràn lên đúng $V_(d d)$.]
)

#align(center)[
  #image("images/fig2_1_cmos_gate_topology.png", width: 88%)
]

#physical-box[
  *Sự Ra Đời Tất Yếu Của Kiến Trúc CMOS Bổ Sung (Complementary MOS):*
  - Nếu dùng nMOS để kéo ngõ ra lên mức cao, ta bị mất áp ($V_("out") = V_(d d) - V_(t n)$), gây rò điện nghiêm trọng ở tầng sau.
  - Nếu dùng pMOS để kéo ngõ ra xuống đất, ta cũng bị mất áp ($V_("out") = |V_(t p)|$).
  - 👉 *Giải pháp duy nhất hoàn hảo trong tự nhiên:*
    1. Giao toàn bộ nhiệm vụ *kéo nốt ngõ ra lên nguồn $V_(d d)$* cho pMOS $arrow.r$ Gọi là *Mạng Kéo Lên (Pull-Up Network - PUN)*.
    2. Giao toàn bộ nhiệm vụ *kéo nốt ngõ ra xuống đất GND* cho nMOS $arrow.r$ Gọi là *Mạng Kéo Xuống (Pull-Down Network - PDN)*.
  - Khi ngõ ra cần mức $1$: PUN mở (pMOS dẫn), PDN ngắt (nMOS tắt) $arrow.r$ Điện áp đạt chuẩn xác $V_(d d)$ *(Strong '1')*.
  - Khi ngõ ra cần mức $0$: PUN ngắt (pMOS tắt), PDN mở (nMOS dẫn) $arrow.r$ Điện áp đạt chuẩn xác $0.0" V"$ *(Strong '0')*.
  - Tuyệt đối không bao giờ có đường dẫn trực tiếp từ $V_(d d)$ xuống GND ở trạng thái tĩnh. Dòng tiêu thụ tĩnh xấp xỉ bằng $0$ ($I_("static") approx 0$)! Đó chính là lý do công nghệ này có tên là *CMOS (Complementary Metal-Oxide-Semiconductor)* và thống trị toàn bộ ngành công nghiệp bán dẫn toàn cầu!
]

=== 1.4 Quy tắc Mắc Nối tiếp / Song song Đối ngẫu (Conduction Complement Rule)
Dựa trên nguyên lý CMOS, ta xây dựng các cổng logic cơ bản:
- *Cổng NAND ($Y = overline(A dot B)$):*  
  Ngõ ra chỉ bằng $0$ khi CẢ $A$ VÀ $B$ cùng bằng $1$.  
  $arrow.r$ Mạng kéo xuống PDN phải gồm 2 nMOS mắc *NỐI TIẾP (Series)*: cần cả $A$ VÀ $B$ cùng có điện trường hút electron thì kênh dẫn từ $Y$ xuống đất mới thông.  
  $arrow.r$ Đối ngẫu lại, mạng kéo lên PUN phải gồm 2 pMOS mắc *SONG SONG (Parallel)*: chỉ cần $A=0$ HOẶC $B=0$ là có một nhánh pMOS mở để bơm lỗ trống nạp tụ lên $V_(d d)$.
- *Cổng NOR ($Y = overline(A + B)$):*  
  Ngõ ra chỉ bằng $1$ khi CẢ $A$ VÀ $B$ cùng bằng $0$.  
  $arrow.r$ Mạng kéo lên PUN phải gồm 2 pMOS mắc *NỐI TIẾP (Series)*: cần cả $A=0$ VÀ $B=0$ thì dòng lỗ trống từ $V_(d d)$ mới chảy qua cả hai transistor để tới $Y$.  
  $arrow.r$ Đối ngẫu lại, mạng kéo xuống PDN gồm 2 nMOS mắc *SONG SONG (Parallel)*: chỉ cần $A=1$ HOẶC $B=1$ là nốt $Y$ lập tức bị xả xuống đất.

=== 1.5 Ác mộng Kích thước Của Cổng NOR: Kết nối với Bản chất Vật lý Chương 3
Bây giờ, hãy nhìn vào *Hình 2.1(b)* và kết nối với kiến thức về độ linh động hạt dẫn mà ta đã chứng minh ở Chương 3:
- Hạt mang điện của nMOS là các electron tự do lướt êm ái trên dải dẫn *(Conduction Band)*: độ linh động cao ($mu_n approx 500 " cm"^2"/V·s"$).
- Hạt mang điện của pMOS là các lỗ trống trong dải hóa trị *(Valence Band)*. Thực chất, lỗ trống không phải là một hạt độc lập, mà là sự nhảy chỗ liên tục của các electron liên kết qua mạng tinh thể silicon (như trò chơi ghế âm nhạc). Sự cản trở và va chạm tán xạ mạng *(lattice phonon scattering)* là cực kỳ khủng khiếp:
  $ mu_p approx 180 - 200 " cm"^2"/V·s" arrow.r frac(mu_n, mu_p) approx 2.5 $
- Vì độ linh động của lỗ trống kém hơn $2.5$ lần, một transistor pMOS cùng kích thước sẽ có điện trở dẫn lớn gấp hơn hai lần nMOS: $R_p approx 2 R_n$!

#math-box[
  *Dẫn xuất Định cỡ Cân bằng (Transistor Sizing Derivation):*\
  Giả sử một nMOS cơ sở ($W_n = 1lambda$) có nội trở $R_n = R$. Để thời gian nạp tụ ($t_r$) cân bằng thời gian xả ($t_f$), một pMOS đơn lẻ phải mở rộng kênh dẫn gấp đôi: $W_p = 2lambda$ để đạt $R_p = R$.
  1. *Cổng NAND2:*  
     - Mạng PDN gồm 2 nMOS nối tiếp: $R_("PDN") = R_n + R_n = 2R_n$. Để tổng trở xả chỉ bằng $R$, ta nhân đôi kích thước cả hai nMOS: $W_n = 2lambda$.
     - Mạng PUN gồm 2 pMOS song song: Trong trường hợp xấu nhất, chỉ có 1 pMOS dẫn: $W_p = 2lambda$.
     - *Tổng bề rộng kênh dẫn:* $W_("total, NAND2") = 2lambda + 2lambda + 2lambda + 2lambda = 8lambda$.
  2. *Cổng NOR2 (Ác mộng thực sự):*  
     - Mạng PDN gồm 2 nMOS song song: Trường hợp xấu nhất 1 nMOS mở: $W_n = 1lambda$.
     - Mạng PUN gồm 2 pMOS NỐI TIẾP: Do 2 pMOS mắc nối tiếp, điện trở bị cộng dồn:
       $ R_("PUN") = R_(p 1) + R_(p 2) = frac(2R, W_p) + frac(2R, W_p) = frac(4R, W_p) $
       Để điện trở kéo lên này bằng $R$, ta bắt buộc phải phình to bề rộng pMOS lên gấp 4 lần:
       $ frac(4R, W_p) = R arrow.r.double W_p = 4lambda ! $
     - *Tổng bề rộng kênh dẫn:* $W_("total, NOR2") = 1lambda + 1lambda + 4lambda + 4lambda = 10lambda$!
]

#rule-box[
  *Quy tắc Vàng Thực chiến: Vì sao Cổng NAND Thống trị Vi mạch?*  
  - Trong cổng NOR, mỗi pMOS bị ép phình to lên $W_p = 4lambda$ (với NOR3 là $W_p = 6lambda$, NOR4 là $W_p = 8lambda$!).  
  - Kích thước kênh dẫn khổng lồ làm cho diện tích cực cổng tăng vọt, kéo theo điện dung ngõ vào $C_("in") = C_(o x) W L$ tăng gấp nhiều lần. Cổng logic ở tầng trước muốn kích mở cổng NOR này sẽ bị quá tải, khiến tốc độ toàn bộ đường truyền tín hiệu bị kéo sập.
  - 👉 *Kết luận kỹ thuật:* Trong công nghiệp vi mạch (Intel, AMD, TSMC), *cổng NAND luôn là lựa chọn số 1*. Các kỹ sư logic luôn vận dụng định lý De Morgan để biến đổi các biểu thức logic thành dạng NAND hoặc cổng phức hợp AOI (And-Or-Invert) thay vì dùng NOR!
]

=== 1.6 Thiết kế Cổng Phức hợp (Compound Gates: AOI & OAI)
Để thực hiện các hàm logic phức tạp mà không phải ghép nối nhiều cổng AND/OR rời rạc (vốn làm tốn diện tích và tạo ra nhiều tầng trễ lan truyền), kỹ sư gộp chung các biểu thức vào một tầng logic duy nhất:
- *Cổng AOI21 (And-Or-Invert):* Thực hiện hàm $Y = overline(A dot B + C)$. Mạng PDN gồm nhánh $(A, B)$ nối tiếp, mắc song song với nhánh $C$. Mạng PUN đối ngẫu gồm nhánh $(A, B)$ song song, mắc nối tiếp với nhánh $C$.
- *Cổng AOI22:* Thực hiện hàm $Y = overline((A dot B) + (C dot D))$. Chỉ cần duy nhất 8 transistor trong một tầng logic, tiết kiệm $43%$ diện tích so với 14 transistor nếu dùng các cổng rời!

#pagebreak()

= Giờ 2: Transistor Truyền dẫn (Pass Transistor) & Cổng Truyền (Transmission Gate)
_Tương ứng Slide 19 – 24 | Thời gian mục tiêu: 60 phút_

=== 2.1 Bước Chuyển từ Giờ 1: Ảo tưởng Công tắc Đơn Transistor & Hiện tượng Ngắt Kênh
Ở Giờ 1, ta thấy một cổng logic đầy đủ cần ít nhất 4 đến 8 transistor. Trong thiết kế vi mạch, các kỹ sư luôn tìm cách thu nhỏ diện tích silicon. Một ý tưởng táo bạo nảy sinh: *Tại sao không dùng duy nhất MỘT transistor nMOS làm một chiếc công tắc nối tiếp trên đường dây để đóng/ngắt tín hiệu (Pass Transistor)?*

Ý tưởng này lập tức vấp phải bức tường vật lý bán dẫn mà ta đã phân tích ở Mục 1.3. Hãy quan sát tỉ mỉ *Hình 2.2(a) và 2.2(b)*:

#align(center)[
  #image("images/fig2_2_pass_transistor_vt_drop.png", width: 84%)
]

#physical-box[
  *Cơ chế Vi mô Đằng sau Cú sụt áp Ngưỡng ($V_t$ Drop):*
  - *Khi nMOS truyền mức 0 ($V_("in") = 0" V"$, $V_g = V_(d d)$ — Hình 2.2a):*  
    Cực Nguồn (Source) luôn là cực có điện thế thấp hơn giữa hai đầu khuếch tán. Do đó, nốt ngõ vào đóng vai trò là Source ($V_s = 0" V"$).  
    Điện áp điều khiển cổng - nguồn là:
    $ V_(g s) = V_g - V_s = V_(d d) - 0 = V_(d d) $
    Hiệu điện thế điều khiển đạt cực đại tuyệt đối. Điện trường thẳng đứng mở toang con kênh, hút electron từ nguồn xả thẳng nốt ngõ ra xuống đất cho tới khi $V_("out") = 0.0" V"$. nMOS là công tắc hoàn hảo để truyền mức 0 *(Strong '0')*.

  - *Khi nMOS truyền mức 1 ($V_("in") = V_(d d)$, $V_g = V_(d d)$ — Hình 2.2b):*  
    Ban đầu ngõ ra ở $0" V"$, nên nốt ngõ ra đóng vai trò là cực Source ($V_s = V_("out") = 0" V"$). Lúc này $V_(g s) = V_(d d) - 0 = V_(d d) > V_(t n)$, kênh dẫn mở toang, dòng electron bắt đầu tháo chạy ra ngoài, nạp điện tích dương cho tụ $C_L$.  
    *Nhưng bi kịch xảy ra khi tụ nạp điện:* Điện áp $V_("out")$ tăng dần lên $0.5" V", 1.0" V", 1.3" V"...$  
    Vì cực Source chính là nốt ngõ ra, điện áp cổng - nguồn bị bóp nghẹt liên tục theo thời gian:
    $ V_(g s)(t) = V_g - V_s(t) = V_(d d) - V_("out")(t) $
    Khi điện áp ngõ ra vừa nạp tới mức:
    $ V_("out") = V_(d d) - V_(t n) arrow.r V_(g s) = V_(d d) - (V_(d d) - V_(t n)) = V_(t n) $
    Ngay tại thời khắc này, hiệu điện thế điều khiển tụt đúng bằng điện áp ngưỡng $V_(t n)$! Lực tĩnh điện không còn đủ sức giữ các electron ở lại mặt tiếp xúc. *Kênh dẫn tự động sập xuống và biến mất hoàn toàn (Channel Shutoff)!*  
    Dòng nạp bị cắt đứt ($I_(d s) arrow.r 0$). Tụ điện không thể nạp thêm được một electron nào nữa. Điện áp ngõ ra vĩnh viễn bị kẹt cứng ở mức tàn tật:
    $ V_("out, max") = V_(d d) - V_(t n) $
]

#pitfall-box[
  *Hậu quả Chết người của Mức 1 Yếu (Weak '1') trong Vi mạch:*  
  Nếu nguồn $V_(d d) = 1.8" V"$ và điện áp ngưỡng (có xét hiệu ứng đế Body Effect) là $V_(t n) approx 0.5" V"$, ngõ ra chỉ lên được tối đa $1.3" V"$.  
  Khi mức điện áp $1.3" V"$ này đi vào cổng của một Inverter tiếp theo, nó không đủ cao để tắt hoàn toàn pMOS của Inverter đó ($|V_(g s, p)| = 1.8 - 1.3 = 0.5" V" approx |V_(t p)|$).  
  Hậu quả: Cả pMOS và nMOS của tầng sau đều hé mở cùng một lúc, tạo ra một *dòng ngắn mạch tĩnh (Static Crowbar Current)* chạy thẳng từ $V_(d d)$ xuống GND, đốt nóng chip và làm suy sụp hoàn toàn biên độ chống nhiễu *(Noise Margin)*!
]

=== 2.2 Giải pháp Toàn vẹn: Cổng Truyền CMOS (Transmission Gate - TG)
Làm thế nào để vừa có một chiếc van công tắc nhỏ gọn, vừa truyền được tín hiệu nguyên vẹn từ $0" V"$ tới $V_(d d)$ mà không mất đi một milivolt nào?

Câu trả lời một lần nữa đến từ *Nguyên lý Đối ngẫu CMOS*: Ghép song song một nMOS và một pMOS với nhau, được điều khiển bởi hai xung đối pha ($C$ và $overline(C)$), tạo thành *Cổng Truyền (Transmission Gate - TG)* như minh họa trên *Hình 2.2(c)*:
- Khi $C = 1$ ($V_(d d)$) và $overline(C) = 0$ ($0" V"$): Cổng truyền BẬT.
  - *Khi truyền mức thấp ($0" V"$):* nMOS có cực cổng nối $V_(d d)$ và cực nguồn nối $0" V"$, duy trì $V_(g s) = V_(d d)$ cực khỏe. nMOS gánh trọn vẹn việc xả nốt về đúng $0.0" V"$ (bù đắp hoàn hảo cho sự yếu ớt của pMOS khi gần đất).
  - *Khi truyền mức cao ($V_(d d)$):* Khi điện áp ngõ ra vượt qua $V_(d d) - V_(t n)$, nMOS bị ngắt kênh. Nhưng lúc này, cực cổng của pMOS đang được nối đất ($overline(C) = 0" V"$)! Hiệu điện thế điều khiển của pMOS là:
    $ |V_(g s, p)| = |V_g - V_s| = |0 - V_(d d)| = V_(d d) >> |V_(t p)| $
    Kênh dẫn của pMOS mở toang tối đa, tiếp tục bơm dòng lỗ trống kéo thẳng điện áp ngõ ra chạm nóc $V_(d d)$!
- 👉 *Kết quả (Hình 2.2d):* Cổng truyền TG đạt *đáp ứng điện áp toàn dải (Full Rail-to-Rail Swing từ $0" V"$ đến $V_(d d)$)*. Hai transistor bù trừ cho nhau, giữ cho nội trở dẫn tương đương $R_("TG") = R_n parallel R_p$ luôn ổn định và bằng phẳng suốt quá trình chuyển mạch.

=== 2.3 Ứng dụng Kinh điển: Mạch Dồn Kênh 2:1 MUX (Multiplexer)
Hãy nhìn vào bảng so sánh trên *Hình 2.3(a)*. Đây là minh chứng hùng hồn cho sức mạnh của cổng truyền TG:
- *Cách thiết kế cổng tĩnh truyền thống (Static CMOS MUX):*  
  Hàm $Y = D_0 dot overline(S) + D_1 dot S$ đòi hỏi: 2 cổng AND (12 transistors) + 1 cổng OR (6 transistors) + 1 cổng đảo (2 transistors) = Tổng cộng cần tới *14 đến 20 transistors*, tín hiệu phải đi qua ít nhất 2 đến 3 tầng trễ!
- *Cách thiết kế bằng Cổng truyền TG (TG-based MUX):*  
  Ta chỉ cần 2 cổng truyền TG mắc chung ngõ ra và 1 cổng đảo để tạo $overline(S)$. Khi $S=0$, TG1 mở thông dòng $D_0$ ra $Y$; khi $S=1$, TG2 mở thông $D_1$ ra $Y$.  
  Tổng số linh kiện: Chỉ vỏn vẹn *6 transistors*!  
  *Hiệu quả:* Tiết kiệm gần $60%$ diện tích silicon, giảm điện dung ký sinh tại nốt $Y$, giúp tốc độ dồn kênh tăng gấp đôi.

#pagebreak()

= Giờ 3: Mạch Tuần tự: D-Latch, DFF & Vật lý Setup/Hold
_Tương ứng Slide 25 – 29 | Thời gian mục tiêu: 60 phút_

=== 3.1 Bước Chuyển từ Mạch Tổ hợp sang Mạch Tuần tự: Phần tử Ổn định Kép (Bistable Loop)
Tất cả các mạch ta đã khảo sát ở Giờ 1 và Giờ 2 đều là *mạch tổ hợp (Combinational Logic)*: ngõ ra tức thời chỉ phụ thuộc vào ngõ vào hiện tại, mạch hoàn toàn không có ký ức.

Để máy tính có thể ghi nhớ được thông tin (1 bit $0$ hoặc $1$), mạch điện bắt buộc phải có *vòng phản hồi (Feedback Loop)*. Cấu trúc nền tảng nhất là hai cổng đảo Inverter mắc nối tiếp vòng tròn khép kín thành một *Phần tử Ổn định Kép (Bistable Element)*:
- Nếu nốt $Q = 1$, cổng đảo thứ nhất kéo nốt $overline(Q) = 0$.
- Nốt $overline(Q) = 0$ quay ngược lại điều khiển cổng đảo thứ hai, ghìm chặt nốt $Q = 1$.
- Vòng phản hồi dương này tự khóa điện tích và lưu giữ trạng thái vĩnh viễn chừng nào nguồn điện $V_(d d)$ còn cấp.

=== 3.2 Mạch Chốt D Điều khiển bằng Xung nhịp (Clocked D-Latch)
Vấn đề là làm sao ta có thể ghi dữ liệu mới từ bên ngoài vào vòng lặp này mà không gây ngắn mạch xung đột? Giải pháp chính là dùng các cổng truyền TG làm những chiếc van đóng/mở có điều khiển, như trên *Hình 2.3(b)*:

#align(center)[
  #image("images/fig2_3_transmission_gate_and_latch.png", width: 84%)
]

Mạch D-Latch hoạt động theo hai pha xung nhịp rõ rệt:
1. *Pha Trong suốt (Transparent Phase — Khi $"CLK" = 1$):*  
   Cổng truyền ngõ vào TG1 mở toang, trong khi cổng truyền phản hồi TG2 bị khóa chặt. Dữ liệu từ ngõ vào $D$ tự do tràn qua TG1, qua cổng đảo và xuất hiện tại nốt ngõ ra. Mọi biến động ở $D$ đều phản ánh tức thì ra $Q$ (mạch "trong suốt").
2. *Pha Giữ / Chốt (Hold/Opaque Phase — Khi $"CLK" = 0$):*  
   TG1 lập tức ngắt lìa ngõ vào $D$, cô lập mạch khỏi thế giới bên ngoài. Đồng thời, TG2 bật sáng, đóng kín vòng lặp giữa hai cổng đảo. Điện tích tại nốt trung gian $Q_M$ được khóa chặt và bảo toàn, dữ liệu được ghi nhớ an toàn.

=== 3.3 Mạch D Flip-Flop Kích khởi Cạnh (Master-Slave Edge-Triggered DFF)
Nhược điểm chí mạng của D-Latch là nó "trong suốt" trong suốt cả nửa chu kỳ xung nhịp ($"CLK"=1$). Nếu tín hiệu ngõ vào bị nhiễu hoặc đổi trạng thái nhiều lần khi xung nhịp đang ở mức cao, dữ liệu sai lệch sẽ tràn ra ngõ ra.

Để khắc phục triệt để, ta ghép hai mạch D-Latch nối tiếp nhau nhưng điều khiển bởi *hai pha xung nhịp ngược chiều nhau*, tạo thành cấu trúc *Master-Slave D Flip-Flop (DFF)*:
- Tầng thứ nhất gọi là *Master Latch* (mở khi $"CLK"=0$, chốt khi $"CLK"=1$).
- Tầng thứ hai gọi là *Slave Latch* (chốt khi $"CLK"=0$, mở khi $"CLK"=1$).
- *Khi $"CLK" = 0$:* Tầng Master mở cửa nhận dữ liệu $D$ vào nốt nội bộ $Q_M$, trong khi tầng Slave khóa chặt, bảo vệ ngõ ra $Q$ cũ.
- *Thời khắc $"CLK"$ nhảy từ $0 arrow.r 1$ (Sườn dương - Rising Edge):* Tầng Master lập tức đóng sập cửa lại để cô lập dữ liệu tại $Q_M$, đồng thời tầng Slave mở toang cửa để đẩy điện tích từ $Q_M$ phóng thẳng ra ngõ ra $Q$!
- *Kết quả:* Ngõ ra $Q$ chỉ được cập nhật tại *đúng khoảnh khắc cực ngắn của sườn xung nhịp* (Edge-Triggered).

=== 3.4 Bản chất Vật lý Vi mô của Thời gian Setup ($t_("setup")$) và Hold ($t_("hold")$)
Hầu hết tài liệu chỉ đưa ra định nghĩa thời gian setup và hold một cách khô khan. Nhưng nhìn từ bản chất cơ học hạt mang điện, hai đại lượng này sinh ra từ đâu?

#physical-box[
  *Động học Hạt Mang Điện Đằng sau $t_("setup")$ và $t_("hold")$:*
  - *Thời gian Thiết lập (Setup Time - $t_("setup"$)):*  
    Hãy nhìn vào nốt trung gian $Q_M$ trên Hình 2.3(b). Nốt này có một điện dung ký sinh hữu hạn $C_(Q M)$ (gồm điện dung khuếch tán của TG1, TG2 và điện dung cực cổng của Inverter).  
    Khi dữ liệu $D$ đổi trạng thái, các hạt electron hoặc lỗ trống bắt buộc phải mất một khoảng thời gian hữu hạn chạy qua nội trở kênh dẫn $R_("TG")$ của cổng truyền TG1 để nạp hoặc rút cạn điện tích trên tụ $C_(Q M)$, đưa điện áp tại $Q_M$ vượt qua ngưỡng lật $V_(d d)/2$.  
    $arrow.r$ *Bản chất:* $t_("setup")$ chính là *thời gian nạp điện tích tối thiểu mà dữ liệu $D$ phải đến sớm và đứng yên TRƯỚC sườn xung nhịp*, nhằm đảm bảo hạt mang điện kịp tích tụ đầy đủ trên tụ $C_(Q M)$ trước khi chiếc van TG1 đóng sập lại!  
    Nếu vi phạm, điện áp tại $Q_M$ bị lơ lửng dở dang ở vùng bất định ($approx V_(d d)/2$), đẩy mạch vào trạng thái *Siêu ổn định (Metastability)* khiến vi mạch bị tê liệt!

  - *Thời gian Duy trì (Hold Time - $t_("hold"$)):*  
    Khi xung nhịp $"CLK"$ đổi mức, tín hiệu điều khiển không thể làm chiếc van TG1 đóng kín ngay tức thời trong $0$ giây (do trễ lan truyền của mạch đảo xung nhịp và thời gian để điện trường cực cổng triệt tiêu kênh dẫn). TG1 mất một khoảng thời gian ngắn $Delta t_("turn-off")$ mới thực sự ngắt hoàn toàn.  
    $arrow.r$ *Bản chất:* $t_("hold")$ chính là *khoảng thời gian dữ liệu $D$ bắt buộc phải giữ nguyên SAU sườn xung nhịp*, nhằm ngăn không cho các hạt điện tích của gói dữ liệu mới lọt qua khe cửa chưa kịp đóng kín của TG1 làm vấy bẩn và đảo lộn dữ liệu vừa chốt!
]

#pagebreak()

= Giờ 4: Bố cục Silicon, Stick Diagram & Đột phá Euler Path
_Tương ứng Slide 30 – 46 | Thời gian mục tiêu: 60 phút_

=== 4.1 Bước Chuyển từ Giờ 3: Hiện thực hóa Mạch điện Trên Tinh thể Silicon
Tất cả các sơ đồ nguyên lý ta vẽ ở Giờ 1, 2, 3 cuối cùng đều phải được khắc lên phiến silicon thực tế bằng công nghệ quang khắc mặt nạ *(Photolithography Masks)*.

Như minh họa trên *Hình 2.4(a)*, các lớp vật lý cơ bản trong một tế bào chuẩn (Standard Cell) gồm có:
1. *N-Diffusion (Vùng khuếch tán $n^+$ - Màu xanh lá):* Được tạo ra bằng cách cấy ion Arsenic hoặc Phosphorus nồng độ cao vào đế p, tạo thành cực Source và Drain cho nMOS.
2. *P-Diffusion (Vùng khuếch tán $p^+$ - Màu vàng/nâu):* Được cấy ion Boron vào giếng n (N-well), tạo thành Source và Drain cho pMOS.
3. *Polysilicon (Silicon đa tinh thể - Màu đỏ):* Đóng vai trò là cực Cổng (Gate). *Bất cứ nơi nào một thanh Polysilicon chạy cắt ngang qua một dải Diffusion, một transistor MOSFET sẽ tự động hình thành ngay tại giao điểm đó!*
4. *Metal 1 (Lớp kim loại 1 - Màu xanh dương):* Dùng để dẫn hai đường ray cấp nguồn ($V_(d d)$ ở đỉnh tế bào, GND ở đáy tế bào) và định tuyến tín hiệu nội bộ.
5. *Contact Cut (Lỗ tiếp xúc - Ký hiệu chữ X):* Các lỗ khoan thẳng đứng xuyên qua lớp điện môi cách điện để kết nối dây kim loại Metal 1 với Polysilicon hoặc Diffusion.

#align(center)[
  #image("images/fig2_4_stick_diagram_and_euler.png", width: 84%)
]

=== 4.2 Sơ đồ Que (Stick Diagram) & Kiến trúc Tế bào Chuẩn
Để phác thảo bố cục nhanh trước khi vẽ hình học chi tiết, các kỹ sư sử dụng *Sơ đồ que (Stick Diagram)*:
- Hai đường ray kim loại song song chạy ngang: đường trên là nguồn $V_(d d)$, đường dưới là đất GND.
- Dải khuếch tán pMOS chạy ngang ở nửa trên (nằm trong N-well).
- Dải khuếch tán nMOS chạy ngang ở nửa dưới.
- Các thanh Polysilicon của các ngõ vào ($A, B, C...$) chạy dọc từ trên xuống dưới, cắt ngang qua cả hai dải khuếch tán, điều khiển đồng thời cả cặp pMOS và nMOS tương ứng.

=== 4.3 Đột phá Lý thuyết Đồ thị: Tối ưu Hóa Bằng Đường Đi Euler (Euler Path)
Hãy so sánh hai phương án bố cục layout trên *Hình 2.4(c)* và *Hình 2.4(d)*. Đây là ranh giới phân biệt giữa một kỹ sư nghiệp dư và một chuyên gia thiết kế vi mạch hàng đầu:

1. *Bố cục Ngẫu nhiên (Unoptimized Layout — Hình 2.4c):*  
   Nếu ta xếp thứ tự các thanh Polysilicon ngẫu nhiên (ví dụ: $B - A - C$), mạng pMOS và mạng nMOS sẽ có các cực khuếch tán không tương thích nhau. Ta bắt buộc phải *chặt đứt dải diffusion thành nhiều hòn đảo riêng biệt*.  
   Hậu quả kỹ thuật cực kỳ nặng nề:
   - Theo luật thiết kế (DRC), giữa hai đảo khuếch tán tách rời bắt buộc phải có một khe hở cách ly *(Diffusion Break)* tối thiểu $3lambda$ để chống rò điện. Tế bào bị kéo dài ra, lãng phí diện tích silicon.
   - Mỗi đảo khuếch tán độc lập đều phải khoan các lỗ tiếp xúc riêng biệt *(Contact Cuts)* để nối dây kim loại. Mỗi lỗ tiếp xúc đòi hỏi diện tích kim loại bao quanh, làm tăng kích thước cell.

#math-box[
  *Mối Liên hệ Sống còn với Điện dung Ký sinh Học ở Chương 3:*\
  Trong Chương 3 (Mục 4.2), chúng ta đã chứng minh điện dung khuếch tán ký sinh cực Máng ($C_(d b)$) phụ thuộc trực tiếp vào diện tích đáy ($A$) và chu vi thành bên ($P$) của tiếp giáp P-N:
  $ C_(d b) = C_j A + C_(j s w) P $
  Khi dải khuếch tán bị bẻ gãy thành nhiều khúc riêng biệt, tổng diện tích khuếch tán và chu vi biên tăng vọt lên gấp đôi. Điện dung ký sinh $C_(d b)$ tại nốt ngõ ra tăng hơn $100%$.  
  Thời gian trễ nạp/xả tụ:
  $ Delta t = frac(C_L Delta V, I) = frac((C_("wire") + C_g + C_(d b)) Delta V, I) $
  Điện dung $C_(d b)$ phình to trực tiếp kéo sập tốc độ chuyển mạch của toàn bộ vi mạch!
]

2. *Giải pháp Euler Đột phá (Euler Path Optimization — Hình 2.4d):*  
   Ta chuyển đổi sơ đồ nguyên lý của mạng PUN và PDN thành hai đồ thị có hướng (Graphs) với các đỉnh là các nốt mạch ($V_(d d)$, GND, Output, nốt trung gian) và các cạnh là các cực cổng transistor ($A, B, C...$), như minh họa trên *Hình 2.4(b)*.
   - *Định nghĩa Đường đi Euler:* Là một chuỗi thứ tự đi qua *tất cả các cạnh của đồ thị đúng một lần duy nhất*.
   - *Quy tắc Vàng:* Kỹ sư tìm một chuỗi thứ tự ngõ vào sao cho nó là *Đường đi Euler chung cho cả hai đồ thị PUN và PDN* (Ví dụ: đối với cổng AOI21, chuỗi Euler chung là $A - B - C$).

#rule-box[
  *Chiến thắng Kỹ thuật của Bố cục Euler:*  
  Khi bố trí các thanh Polysilicon theo đúng chuỗi Euler ($A - B - C$):
  1. *Dải khuếch tán liền mạch tuyệt đối:* Cả dải p-diffusion và n-diffusion trải dài liên tục từ đầu đến cuối cell mà không cần bất kỳ một vết cắt nào!
  2. *Chia sẻ cực khuếch tán không cần tiếp xúc (Uncontacted Shared Diffusion):* Cực Drain của transistor $A$ chạm thẳng vào cực Source của transistor $B$ ngay trong lòng khối silicon mà không cần dây nối kim loại, không cần lỗ tiếp xúc contact cut!
  3. *Kết quả:* Triệt tiêu $50%$ điện dung khuếch tán ký sinh $C_(d b)$, giảm diện tích cell chuẩn $25-30%$, tăng tốc độ đáp ứng của chip thêm $20-30%$ mà không tiêu tốn thêm bất kỳ một microwatt công suất nào!
]

---

#v(10pt)
=== 4.4 Bảng Tra cứu Thông số Cốt lõi Toàn chương (Summary Cheat Sheet)

#table(
  columns: (1.5fr, 2.3fr, 3.2fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 6pt,
  [*Khái niệm / Thuật ngữ*], [*Bản chất Vật lý / Nguyên lý*], [*Ý nghĩa Thực tế / Quy tắc Vàng*],
  [nMOS], [Gate cao ($V_(d d)$) hút electron tạo kênh n], [Dẫn mức 0 cực tốt (Strong 0); dẫn mức 1 bị sụt áp $V_t$.],
  [pMOS], [Gate thấp ($0" V"$) hút lỗ trống trong N-well], [Dẫn mức 1 cực tốt (Strong 1); dẫn mức 0 bị ngắt sớm.],
  [CMOS (Bổ sung)], [PUN dùng pMOS kéo lên, PDN dùng nMOS kéo xuống], [Đạt full rail-to-rail swing không suy hao áp, dòng tĩnh $I_("static") approx 0$.],
  [Tỷ lệ Định cỡ Inverter], [$W_p approx 2 W_n$], [Cân bằng thời gian tăng/giảm ($t_r approx t_f$) do $mu_n / mu_p approx 2.5$.],
  [Cổng NAND vs NOR], [NAND có nMOS nối tiếp, NOR có pMOS nối tiếp], [NAND nhỏ hơn ($8lambda$ vs $10lambda$) và nhanh hơn gấp 2 lần so với NOR.],
  [Sụt áp Ngưỡng ($V_t$ Drop)], [Kênh nMOS tự ngắt khi $V_s = V_("out") arrow.r V_(d d) - V_t$], [Không được dùng nMOS đơn lẻ kéo mức cao; gây dòng rò tĩnh tầng sau.],
  [Transmission Gate (TG)], [Ghép song song nMOS và pMOS đối pha], [Đạt full rail-to-rail swing ($0 arrow.r V_(d d)$); giảm 60% diện tích MUX.],
  [Thời gian Setup ($t_("setup"$))], [Thời gian nạp đầy điện tích nốt nội bộ $Q_M$], [Dữ liệu phải ổn định TRƯỚC sườn xung nhịp để chống metastability.],
  [Thời gian Hold ($t_("hold"$))], [Thời gian để công tắc TG1 đóng kín hoàn toàn], [Dữ liệu phải giữ nguyên SAU sườn xung nhịp.],
  [Đường đi Euler (Euler Path)], [Chuỗi duyệt qua mọi cực cổng chung cho PUN/PDN], [Tạo dải diffusion liền mạch, triệt tiêu 50% điện dung ký sinh $C_(d b)$.]
)

#v(8pt)
#pagebreak()
=== 4.5 Bộ Câu hỏi Phản xạ Tư duy Kỹ sư Vi mạch (Diagnostic Self-Assessment)

1. *Câu hỏi 1 (Bản chất nMOS vs pMOS):* Giải thích vì sao nMOS cần điện áp cực cổng ở mức cao ($V_(d d)$) để dẫn điện, trong khi pMOS lại cần điện áp cực cổng ở mức thấp ($0" V"$) để dẫn điện? Nếu đưa điện áp $1.8" V"$ vào cổng của một pMOS có cực Source nối $1.8" V"$, hiện tượng vật lý gì xảy ra bên dưới lớp oxit cổng?\
   *Lời giải:* 
   - Với nMOS: hạt mang điện là electron (tích điện âm), đế bán dẫn là loại p. Muốn hút electron thiểu số từ đế lên bề mặt tạo kênh dẫn, cực cổng phải tích điện dương ($V_g = V_(d d)$) để tạo điện trường thẳng đứng hướng xuống hút điện tích âm.
   - Với pMOS: hạt mang điện là lỗ trống (tích điện dương), đế là N-well. Cực Source nối $1.8" V"$. Muốn hút các hạt tích điện dương lên bề mặt, cực cổng phải tích điện âm so với Source ($V_(g s) < 0$). Khi đưa $V_g = 0" V"$, $V_(g s) = 0 - 1.8 = -1.8" V"$, cực cổng mang điện tích âm mạnh hút các lỗ trống lên tạo kênh dẫn p.
   - Nếu đưa $V_g = 1.8" V"$ vào cổng pMOS: Hiệu điện thế cổng - nguồn là $V_(g s) = 1.8 - 1.8 = 0" V"$. Không có điện trường âm hút lỗ trống. Các electron trong N-well không bị xua đuổi, bề mặt tiếp giáp vẫn giữ nguyên tính chất bán dẫn loại n, không có kênh dẫn nào được hình thành. Transistor hoàn toàn tắt ($I_(d s) = 0$).

2. *Câu hỏi 2 (Cơ chế Sụt áp Ngưỡng):* Tại sao một transistor nMOS duy nhất khi dẫn mức điện áp cao ($V_("in") = 1.8" V"$) chỉ có thể đẩy nốt ngõ ra lên mức tối đa là $1.3" V"$ rồi dừng lại, mặc dù điện áp cực Cổng vẫn được cấp $1.8" V"$ liên tục?\
   *Lời giải:* Vì cực Nguồn (Source) luôn là cực có điện thế thấp hơn giữa hai đầu khuếch tán. Khi tụ sạc lên, nốt ngõ ra đóng vai trò là Source ($V_s = V_("out")$). Điện áp điều khiển thực tế đặt lên lớp oxit cổng là $V_(g s) = V_g - V_s = 1.8" V" - V_("out")$. Khi $V_("out")$ chạm tới mốc $1.8" V" - V_(t n) = 1.3" V"$, hiệu điện thế $V_(g s)$ tụt đúng bằng điện áp ngưỡng $V_(t n) = 0.5" V"$. Điện trường dọc biến mất, lớp đảo electron bị triệt tiêu khiến kênh dẫn tự đóng sập lại. Dòng nạp tắt lịm ($I_(d s) = 0$), điện áp bị kẹp cứng tại $1.3" V"$.

3. *Câu hỏi 3 (Tư duy Đánh đổi Kích thước):* Một kỹ sư mới ra trường muốn cổng NOR2 chạy nhanh bằng cổng NAND2 nên đã tăng kích thước cả 2 pMOS của cổng NOR lên $W_p = 8lambda$. Hãy chỉ ra 2 tác dụng phụ tiêu cực mà sự thay đổi này gây ra cho toàn bộ vi mạch?\
   *Lời giải:* 
   - *Thứ nhất (Quá tải tầng trước):* Khi $W_p$ tăng lên $8lambda$, diện tích cực cổng tăng gấp đôi khiến điện dung ngõ vào $C_("in") = C_(o x) W L$ tăng vọt. Cổng logic ở tầng trước muốn kích mở cổng NOR này sẽ phải mất thời gian nạp điện tích lâu hơn gấp 2-3 lần, làm chậm toàn bộ chuỗi lan truyền tín hiệu.
   - *Thứ hai (Phình to diện tích và dòng rò):* Diện tích giếng N-well và dải p-diffusion phình to đột biến, phá vỡ chiều cao chuẩn hóa của hàng tế bào (standard cell row height), đồng thời làm tăng dòng rò dưới ngưỡng *(subthreshold leakage current)* qua các mối nối P-N khi chip ở chế độ chờ.

4. *Câu hỏi 4 (Chẩn đoán Lỗi Timing):* Trong quá trình kiểm tra vi mạch sau đóng gói, một thanh ghi D Flip-Flop thỉnh thoảng xuất hiện dữ liệu rác không xác định (lúc $0$, lúc $1$) khi nhiệt độ chip tăng cao. Kỹ sư nghi ngờ mạch đã vi phạm thời gian gì? Giải thích từ góc độ điện trở và điện dung ký sinh?\
   *Lời giải:* Mạch đã vi phạm *Thời gian Thiết lập (Setup Time - $t_("setup"$))*. Khi nhiệt độ chip tăng, dao động nhiệt của mạng tinh thể silicon mạnh lên *(lattice phonon scattering)* làm giảm độ linh động hạt dẫn, khiến nội trở $R_("TG")$ của cổng truyền tăng lên. Thời gian nạp tụ ký sinh $tau = R_("TG") C_(Q M)$ bị kéo dài. Dữ liệu $D$ không kịp nạp đủ điện tích làm lật trạng thái nốt $Q_M$ trước khi xung nhịp đóng TG1, đẩy chốt vào trạng thái *Siêu ổn định (Metastability)* khiến ngõ ra dao động bất định giữa 0 và 1.

5. *Câu hỏi 5 (Bản chất Bố cục Silicon):* Tại sao việc áp dụng Đường đi Euler để bố trí một dải khuếch tán liền mạch lại giúp cổng logic chạy nhanh hơn đáng kể so với việc bố trí các transistor ngẫu nhiên, dù tổng số transistor trên sơ đồ nguyên lý là y hệt nhau?\
   *Lời giải:* Bố trí theo đường đi Euler cho phép hai transistor kế tiếp nhau dùng chung một vùng khuếch tán cực Máng/Nguồn mà không cần cắt rời và không cần khoan lỗ tiếp xúc kim loại (Contact cut). Điều này triệt tiêu các khoảng cách cách ly DRC và giảm hơn $50%$ diện tích cũng như chu vi đáy của tiếp giáp P-N. Theo công thức học ở Chương 3, điện dung khuếch tán ký sinh $C_(d b) = C_j A + C_(j s w) P$ giảm một nửa. Do tổng điện dung tải $C_L$ giảm mạnh, thời gian trễ chuyển mạch $Delta t = (C_L Delta V) / I$ giảm tương ứng, giúp vi mạch tăng tốc mà không cần tăng dòng tiêu thụ.
