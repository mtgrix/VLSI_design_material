#set page(
  paper: "a4",
  margin: (x: 2.0cm, top: 2.2cm, bottom: 2.2cm),
  header: align(right)[
    #text(size: 8.5pt, fill: rgb("#64748b"))[Thiết kế Vi mạch VLSI từ Bản chất Vật lý | Ch2 - Giờ 2: Các Lớp Cổng Đảo & BSIM]
  ],
  footer: [
    #line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
    #grid(
      columns: (1fr, 1fr),
      align(left)[#text(size: 8pt, fill: rgb("#94a3b8"))[Tài liệu Tự học Chuyên sâu (ĐH CNTT UIT)]],
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
  "Cảnh báo Lỗi Phổ biến & Tử huyệt Mạch (Critical Pitfall)",
  body,
  rgb("#d97706"),
  rgb("#fffbeb"),
  "⚠️"
)

#align(center)[
  #text(size: 19pt, weight: "bold", fill: rgb("#0f172a"))[Chuyên Đề 2 - Giờ 2: Các Lớp Cổng Đảo & Mô Hình Bán Dẫn BSIM]
  #v(2pt)
  #text(size: 11pt, fill: rgb("#334155"))[Tháo Nút Thắt Từng Bước: Các Họ Inverter, Phân Tích VTC, Chuỗi Đệm & Kỷ Nguyên Nanomet]
  #v(1pt)
  #text(size: 8.5pt, style: "italic", fill: rgb("#64748b"))[
    Tài liệu Tự học Chuyên sâu | Khoa Kỹ thuật Máy tính - ĐH Công nghệ Thông tin (UIT)
  ]
  #v(4pt)
  #line(length: 100%, stroke: 1.5pt + rgb("#0284c7"))
]

#v(4pt)
== 0. Bảng thuật ngữ cốt lõi & Phạm vi tài liệu

=== 0.1 Bảng thuật ngữ đối chiếu (Glossary)
#table(
  columns: (1.3fr, 1.2fr, 2.5fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 5pt,
  [*Thuật ngữ Tiếng Anh*], [*Thuật ngữ Tiếng Việt*], [*Ý nghĩa vật lý & mạch điện*],
  [Pull-Up Network (PUN)], [Mạng kéo lên], [Mạch linh kiện nối giữa $V_("DD")$ và ngõ ra, nạp điện tích đưa ngõ ra lên mức 1.],
  [Pull-Down Network (PDN)], [Mạng kéo xuống], [Mạch linh kiện nối giữa ngõ ra và GND, xả điện tích đưa ngõ ra về mức 0.],
  [Rail-to-rail swing], [Dải dao động toàn phần], [Điện áp ngõ ra chạy trọn vẹn từ đúng $0.0"V"$ đến đúng $V_("DD")$, không bị sụt áp ngưỡng.],
  [Static power ($P_("static")$)], [Tiêu tán công suất tĩnh], [Công suất tiêu thụ khi ngõ vào giữ nguyên ở trạng thái logic ổn định (0 hoặc 1).],
  [Voltage Transfer (VTC)], [Đặc tuyến truyền đạt], [Đồ thị hàm truyền biểu diễn $V_("out")$ theo $V_("in")$ khi quét DC từ $0 arrow.r V_("DD")$.],
  [Switching threshold ($V_M$)], [Ngưỡng chuyển mạch], [Điểm trên đặc tuyến VTC mà tại đó $V_("in") = V_("out") = V_M$.],
  [Noise Margin ($N M_L, N M_H$)], [Dải dự trữ nhiễu], [Biên độ nhiễu điện áp tối đa ở ngõ vào mà cổng logic vẫn không bị lật sai trạng thái.],
  [Path Effort ($F$)], [Độ khuếch đại toàn đường], [Tỷ số giữa điện dung tải ngoài cần lái $C_L$ và điện dung ngõ vào $C_("in")$ ($F = C_L / C_("in")$).],
  [Stage Effort ($f$)], [Độ khuếch đại từng tầng], [Tỷ số phóng đại kích thước giữa hai tầng kế tiếp trong chuỗi đệm ($f = F^(1/N)$).],
  [Self-loading ($gamma$)], [Hệ số tự tải ký sinh], [Tỷ số giữa điện dung khuếch tán ngõ ra và điện dung cực cổng ngõ vào.],
  [Short-Channel Effects], [Hiệu ứng kênh ngắn], [Các hiện tượng vật lý phi tuyến xuất hiện khi chiều dài kênh $L <= 0.25 mu"m"$.],
  [Velocity Saturation], [Bão hòa vận tốc], [Vận tốc trôi của hạt dẫn chạm trần tối đa $v_("sat")$ do tán xạ mạng tinh thể dưới điện trường lớn.],
  [DIBL], [Hạ thấp rào thế cực máng], [Điện trường cực máng thâm nhập kênh làm giảm đỉnh rào thế, kéo giảm điện áp ngưỡng $V_t$.],
  [Subthreshold Leakage], [Dòng rò dưới ngưỡng], [Dòng khuếch tán yếu chảy từ nguồn sang máng khi $V_(g s) < V_t$.],
  [Gate Tunneling], [Dòng rò xuyên hầm], [Dòng điện tử lượng tử chui qua lớp điện môi oxit mỏng khi $t_(o x) < 1.5"nm"$.]
)

=== 0.2 Phạm vi tài liệu
Tài liệu này tập trung giải mã 6 họ kiến trúc cổng đảo, phân tích giải tích 5 vùng đặc tuyến VTC, thiết kế chuỗi đệm Inverter với tự tải và hiệu ứng Miller, cơ chế Latch-up, 4 hiệu ứng kênh ngắn phá vỡ Shockley và quy tắc định cỡ nanomet $W_p / W_n approx 1.5 - 1.8:1$.

#v(6pt)
== 1. Cầu nối Giờ 1 $arrow.r$ Các họ Inverter

=== 1.1 Bản chất quy tắc Strong 0 / Weak 1: Cực Source có trôi hay không?
Điểm mấu chốt chi phối khả năng truyền mức logic của transistor nằm ở chỗ: *Cực Source được nối cố định hay bị trôi theo điện áp ngõ ra $V_("out")$?*

1. *nMOS kéo xuống GND (Nhiệm vụ xả tụ - Strong 0):* Cực Source nối cứng vào đất GND ($V_s = 0"V"$). Khi $V_("in") = V_("DD")$, hiệu điện thế $V_(g s) = V_("DD") - 0 = V_("DD")$ giữ nguyên cực đại suốt quá trình xả tụ. Kênh dẫn mở tối đa đưa $V_("out")$ về đúng *$0.0"V"$*.
2. *nMOS kéo lên $V_("DD")$ (Nhiệm vụ nạp tụ - Weak 1):* Nốt ngõ ra đóng vai trò cực Source ($V_s = V_("out")$). Khi nạp điện, $V_("out")$ tăng làm $V_(g s) = V_("DD") - V_("out")$ tụt dần. Khi $V_("out") = V_("DD") - V_(t n)$, hiệu điện thế $V_(g s) = V_(t n)$, kênh dẫn tự đóng sập lại. Ngõ ra bị kẹt cứng tại *$V_("DD") - V_(t n)$*.
3. *pMOS kéo lên $V_("DD")$ (Nhiệm vụ nạp tụ - Strong 1):* Cực Source nối cứng vào $V_("DD")$ ($V_s = V_("DD")$). Khi $V_("in") = 0"V"$, $|V_(g s)| = V_("DD")$ giữ nguyên cực đại. Kênh dẫn nạp căng tràn tụ lên đúng *$V_("DD")$*.
4. *pMOS kéo xuống GND (Nhiệm vụ xả tụ - Weak 0):* Cực Source trôi theo ngõ ra ($V_s = V_("out")$). Kênh dẫn tự ngắt khi $V_("out")$ chạm $|V_(t p)|$. Ngõ ra bị kẹt ở *$|V_(t p)|$*, không về được $0.0"V"$.

=== 1.2 Câu chốt kiến trúc: Vì sao CMOS giành chiến thắng tuyệt đối?
Cấu trúc CMOS (Complementary MOS) thống trị ngành công nghiệp bán dẫn nhờ sự kết hợp đối ngẫu vật lý:
- Mạng kéo lên (PUN) làm bằng *pMOS* (chuyên gia nạp Strong 1).
- Mạng kéo xuống (PDN) làm bằng *nMOS* (chuyên gia xả Strong 0).

*Kết quả:* Ngõ ra đạt dải dao động toàn phần (rail-to-rail: $0.0"V" <-> V_("DD")$) và tuyệt đối không tồn tại đường dẫn tĩnh từ $V_("DD")$ xuống GND. Công suất tĩnh lý tưởng bằng 0 ($P_("static") approx 0$).

#v(6pt)
== 2. Các lớp cổng đảo (Inverter Circuit Families)

=== 2.1 Cổng đảo Tải Điện Trở (Resistive-load Inverter)
- *Tên gọi:* Resistive-load Inverter / Cổng đảo tải điện trở thụ động.
- *PUN:* 1 điện trở thụ động $R_L$ nối lên nguồn $V_("DD")$.
- *PDN:* 1 transistor nMOS logic nối xuống đất GND.
- *Mức logic ngõ ra:* $V_(O H) = V_("DD")$; $V_(O L) = V_("DD") dot frac(R_("on,n"), R_L + R_("on,n")) > 0.0"V"$.
- *Công suất tĩnh:* Khi ngõ ra ở mức thấp, tiêu tốn công suất lớn: $P_("static") approx V_("DD")^2 / R_L$.
- *Số transistor:* $N$ transistor nMOS + 1 điện trở $R_L$.
- *Sơ đồ nguyên lý:*
```text
       VDD
        |
       [R]  Resistor RL (Pull-Up)
        |
        +----o Vout
        |
Vin ---|  nMOS (Pull-Down)
        |
       GND
```
- *Hạn chế & Ứng dụng:* Điện trở $R_L$ chiếm diện tích silicon rất lớn, sườn lên chậm do hằng số thời gian $tau = R_L C_L$ lớn. Từng dùng trong vi mạch sơ khai thập niên 1960; nay không còn dùng.

=== 2.2 Cổng đảo nMOS Tải Giảm Thiểu (Depletion-load nMOS Inverter)
- *Tên gọi:* Depletion-load nMOS Inverter / Cổng đảo nMOS tải suy giảm.
- *PUN:* 1 nMOS loại giảm thiểu ($V_(t,d e p) < 0$) nối ngắn Cổng vào Nguồn ($V_(g s,l o a d) = 0"V"$).
- *PDN:* 1 nMOS tăng cường ($V_(t,e n h) > 0$) thông thường.
- *Mức logic ngõ ra:* $V_(O H) = V_("DD")$; $V_(O L) = V_("DD") dot frac(R_("on,PDN"), R_("on,PUN") + R_("on,PDN")) > 0.0"V"$.
- *Công suất tĩnh:* Rất lớn khi ngõ ra bằng 0 do nguồn dòng tải dẫn liên tục: $P_("static") approx V_("DD") dot I_("sat,load")$.
- *Số transistor:* $N + 1$ transistor nMOS.
- *Sơ đồ nguyên lý:*
```text
       VDD
        |
      --+
     |  |  Depletion nMOS (Vt < 0)
     +--|  Vgs = 0V (Pull-Up)
        |
        +----o Vout
        |
Vin ---|  Enhancement nMOS (Vt > 0)
        |
       GND
```
- *Hạn chế & Ứng dụng:* Tốn công suất tĩnh; cần thêm bước quang khắc cấy ion để tạo $V_t < 0$. Từng dùng trong Intel 8085, Z80; nay bị thay thế hoàn toàn bởi CMOS.

=== 2.3 Cổng đảo CMOS Tĩnh Bổ Sung (Static Complementary CMOS Inverter)
- *Tên gọi:* Static Complementary CMOS Inverter / Cổng đảo CMOS tĩnh bổ sung chuẩn.
- *PUN:* Transistor pMOS nối lên $V_("DD")$.
- *PDN:* Transistor nMOS nối xuống GND.
- *Mức logic ngõ ra:* Đạt full rail-to-rail: $V_(O H) = V_("DD")$ và $V_(O L) = 0.0"V"$.
- *Công suất tĩnh:* Lý tưởng bằng 0 ($P_("static") approx 0$) ở cả 2 mức tĩnh 0 và 1 (chỉ có dòng rò nano-ampe).
- *Số transistor:* Đúng $2N$ transistor ($N$ pMOS + $N$ nMOS).
- *Sơ đồ nguyên lý:*
```text
       VDD
        |
      --|o pMOS (Pull-Up)
     |  |
Vin -+--+----o Vout
     |  |
      --|  nMOS (Pull-Down)
        |
       GND
```
- *Hạn chế & Ứng dụng:* Khi $N$ ngõ vào lớn, việc mắc nối tiếp nhiều pMOS làm trễ sườn lên rất nặng. Là chuẩn mực vàng cho hơn 99% mạch số hiện nay.

=== 2.4 Cổng đảo Pseudo-nMOS (Pseudo-nMOS Inverter)
- *Tên gọi:* Pseudo-nMOS Inverter / Cổng đảo giả nMOS.
- *PUN:* 1 transistor pMOS duy nhất có cực Cổng nối đất vĩnh viễn ($V_(g s,p) = -V_("DD")$, luôn BẬT).
- *PDN:* Mạng transistor logic nMOS nối xuống GND.
- *Mức logic ngõ ra:* $V_(O H) = V_("DD")$; $V_(O L) > 0.0"V"$.
  - *Vì sao bắt buộc $beta_n / beta_p >= 4$:* Nếu pMOS quá mạnh, nó sẽ giữ ngõ ra ở mức cao ($V_(O L)$ lớn), vô tình kích bật tầng nMOS tiếp theo. Thiết kế $beta_n >= 4 beta_p$ ép nội trở nMOS nhỏ hơn ít nhất 4 lần so với pMOS, dìm $V_(O L) < 0.1 - 0.2"V"$.
- *Công suất tĩnh:* Rất lớn khi ngõ ra bằng 0 ($P_("static") = V_("DD") dot I_("sat,p")$).
- *Số transistor:* Chỉ cần đúng $N + 1$ transistor (1 pMOS + $N$ nMOS).
- *Sơ đồ nguyên lý:*
```text
       VDD
        |
GND ---|o pMOS (Luôn dẫn, Vgs = -VDD)
        |
        +----o Vout
        |
Vin ---|  nMOS (Logic)
        |
       GND
```
- *Hạn chế & Ứng dụng:* Hao điện tĩnh; $N M_L$ hẹp. Dùng cho cổng NOR nhiều ngõ vào ($N >= 4$), bộ giải mã địa chỉ ROM, PLA nhằm tiết kiệm diện tích và giảm điện dung ngõ vào.

=== 2.5 Cổng đảo $C^2"MOS"$ / Ba Trạng Thái (Clocked CMOS / Tri-state Inverter)
- *Tên gọi:* $C^2"MOS"$ / Tri-state Inverter (Cổng đảo ba trạng thái).
- *PUN:* 2 pMOS mắc nối tiếp (1 pMOS nhận dữ liệu $V_("in")$, 1 pMOS nhận xung $overline("CLK")$).
- *PDN:* 2 nMOS mắc nối tiếp (1 nMOS nhận xung $"CLK"$, 1 nMOS nhận dữ liệu $V_("in")$).
- *Mức logic ngõ ra:* Khi kích hoạt ($"CLK"=1$), đạt $V_(O H)=V_("DD"), V_(O L)=0.0"V"$. Khi ngắt kích hoạt ($"CLK"=0$), ngõ ra rơi vào trạng thái trở kháng cao (*Hi-Z*).
- *Công suất tĩnh:* Lý tưởng bằng 0 ở cả 3 trạng thái.
- *Số transistor:* $2N + 2$ transistor (với cổng đảo 1 ngõ vào, cần 4 transistor).
- *Sơ đồ nguyên lý:*
```text
          VDD
           |
         --|o pMOS (Data In: Vin)
        |  |
/CLK ---+--|o pMOS (Clock Enable)
           |
           +----o Vout (0, 1, hoặc Hi-Z)
           |
 CLK ---+--|  nMOS (Clock Enable)
        |  |
         --|  nMOS (Data In: Vin)
           |
          GND
```
- *Hạn chế & Ứng dụng:* Điện trở dẫn tăng gấp đôi; tăng diện tích dây xung nhịp. Dùng để ghép bus dùng chung và làm mạch chốt D-Latch, Flip-Flop chống chạy đua xung nhịp.

=== 2.6 Cổng đảo Logic Động (Dynamic CMOS Inverter)
- *Tên gọi:* Dynamic CMOS Inverter / Cổng đảo logic động (Precharge - Evaluate).
- *PUN:* 1 pMOS nạp trước điều khiển bởi xung nhịp $"CLK"$.
- *PDN:* 1 nMOS logic nhận $V_("in")$ nối tiếp với 1 nMOS đánh giá điều khiển bởi $"CLK"$.
- *Mức logic ngõ ra:* Pha nạp trước ($"CLK"=0$) nạp lên $V_(O H) = V_("DD")$; pha đánh giá ($"CLK"=1$) xả về $V_(O L) = 0.0"V"$ nếu $V_("in") = 1$.
- *Công suất tĩnh:* Không có dòng tĩnh thuần. Nhưng công suất chuyển mạch động lớn vì phải sạc lại ngõ ra mỗi chu kỳ.
- *Số transistor:* $N + 2$ transistor. Tải ngõ vào rất nhẹ do chỉ nối cực cổng nMOS.
- *Sơ đồ nguyên lý:*
```text
          VDD
           |
 CLK -----|o pMOS (Precharge)
           |
           +----o Vout (Nốt lưu điện tích)
           |
 Vin -----|  nMOS (Logic)
           |
 CLK -----|  nMOS (Evaluate)
           |
          GND
```
- *Hạn chế & Ứng dụng:* Nốt ngõ ra ở trạng thái thả nổi dễ mất điện tích do rò rỉ dưới ngưỡng và chia sẻ điện tích; bắt buộc xung nhịp phải chạy liên tục. Dùng cho ALU siêu tốc, thanh ghi Register File.

#v(6pt)
== 3. Đặc tuyến truyền đạt DC (VTC) & 5 vùng hoạt động

=== 3.1 Năm vùng hoạt động khi quét $V_("in")$ tăng dần
1. *Vùng A ($0 <= V_("in") < V_(t n)$):* nMOS TẮT ($I_(d s,n) = 0$), pMOS Tuyến tính ($|V_(d s,p)| approx 0$). Ngõ ra $V_("out") = V_("DD")$.
2. *Vùng B ($V_(t n) <= V_("in") < V_(I L)$):* nMOS Bão hòa ($V_(d s,n) >= V_(g s,n) - V_(t n)$), pMOS Tuyến tính. $V_("out")$ sụt nhẹ; độ dốc dốc dần tới $-1$ tại $V_(I L)$.
3. *Vùng C ($V_("in") approx V_M$):* Cả nMOS và pMOS đều Bão hòa. Độ dốc khuếch đại cực đại $|d V_("out") / d V_("in")| >> 1$. $V_("out")$ rơi dốc đứng.
4. *Vùng D ($V_(I H) < V_("in") <= V_("DD") - |V_(t p)|$):* nMOS Tuyến tính, pMOS Bão hòa. $V_("out")$ tiến dần về $0"V"$. Điểm bắt đầu có độ dốc $-1$ tại $V_(I H)$.
5. *Vùng E ($V_("in") > V_("DD") - |V_(t p)|$):* nMOS Tuyến tính, pMOS TẮT ($I_(d s,p) = 0$). Ngõ ra $V_("out") = 0.0"V"$.

=== 3.2 Bảng tổng kết 5 vùng hoạt động
#table(
  columns: (0.9fr, 1.3fr, 1.1fr, 1.1fr, 2fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 5pt,
  [*Vùng*], [*Điều kiện ngõ vào*], [*nMOS*], [*pMOS*], [*Trạng thái ngõ ra $V_("out")$*],
  [Vùng A], [$0 <= V_("in") < V_(t n)$], [TẮT ($I_(d s)=0$)], [Tuyến tính], [$V_("out") = V_("DD")$ vững chắc],
  [Vùng B], [$V_(t n) <= V_("in") < V_(I L)$], [Bão hòa], [Tuyến tính], [Bắt đầu sụt; dốc dần tới $-1$ tại $V_(I L)$],
  [Vùng C], [$V_("in") approx V_M$], [Bão hòa], [Bão hòa], [Rơi dốc đứng quanh $V_M$; gain cực đại],
  [Vùng D], [$V_(I H) < V_("in") <= V_("DD") - |V_(t p)|$], [Tuyến tính], [Bão hòa], [Tiến sát $0"V"$; dốc thoải từ $-1$ tại $V_(I H)$],
  [Vùng E], [$V_("in") > V_("DD") - |V_(t p)|$], [Tuyến tính], [TẮT ($I_(d s)=0$)], [$V_("out") = 0.0"V"$ hoàn toàn]
)

=== 3.3 Dẫn xuất ngưỡng chuyển mạch $V_M$ từng bước
Tại điểm ngưỡng logic, định nghĩa: $V_("in") = V_("out") = V_M$.
Ở Vùng C, cả hai transistor đều bão hòa:
$ I_(d s,n) = 1/2 beta_n (V_M - V_(t n))^2 $
$ I_(d s,p) = 1/2 beta_p (V_("DD") - V_M - |V_(t p)|)^2 $

Cân bằng dòng điện Kirchhoff $I_(d s,n) = I_(d s,p)$ và đặt *một định nghĩa chuẩn duy nhất cho biến số $r$*:
$ r = sqrt(frac(beta_p, beta_n)) $

$ V_M - V_(t n) = r dot (V_("DD") - V_M - |V_(t p)|) $
$ V_M (1 + r) = V_(t n) + r (V_("DD") - |V_(t p)|) $
$ V_M = frac(V_(t n) + r (V_("DD") - |V_(t p)|), 1 + r) $

Khi đối xứng chuẩn ($r = 1$ và $V_(t n) = |V_(t p)|$): $V_M = V_("DD") / 2$.

=== 3.4 Dải dự trữ nhiễu & Phân tích góc lệch tiến trình PVT FS
- $N M_L = V_(I L) - V_(O L) = V_(I L) - 0.0"V" = V_(I L)$
- $N M_H = V_(O H) - V_(I H) = V_("DD") - V_(I H)$

#math-box[
  *Phân Tích Bài Toán Góc Lệch Tiến Trình FS (Fast nMOS, Slow pMOS):*
  - Thông số: $V_("DD") = 1.0"V"$, $beta_n' = 1.44 beta_n$, $V_(t n)' = 0.22"V"$, $beta_p' = 0.64 beta_p$, $|V_(t p)'| = 0.38"V"$.
  - Tính $r'$ theo định nghĩa chuẩn:
    $ r' = sqrt(frac(beta_p', beta_n')) = sqrt(frac(0.64, 1.44)) = frac(0.8, 1.2) = frac(2, 3) approx 0.667 $
  - Tính ngưỡng logic mới $V_M'$:
    $ V_M' = frac(0.22 + 0.667 times (1.0 - 0.38), 1 + 0.667) = frac(0.22 + 0.4133, 1.667) approx 0.38"V" $
  - *Hệ quả kỹ thuật:* $V_M'$ sụt giảm từ $0.50"V"$ xuống $0.38"V"$, đặc tuyến VTC bị *trượt lệch sang TRÁI*. Lề nhiễu mức thấp $N M_L approx V_(I L)$ bị bóp nghẹt. Mạch trở nên cực kỳ nhạy cảm và dễ nhảy sai trạng thái logic khi có *Nhiễu nảy đất (Ground Bounce)* trên đường GND!
]

#v(6pt)
== 4. Chuỗi đệm Inverter (Inverter Buffer Chain) & Hiện tượng Miller

=== 4.1 Bài toán kéo tải nặng & Độ khuếch đại đường truyền
Khi cổng logic cơ bản ($C_("in")$) lái tải lớn $C_L$, độ khuếch đại đường truyền là $F = C_L / C_("in")$. Dùng chuỗi $N$ tầng với hệ số phóng đại mỗi tầng $f = F^(1/N)$.

=== 4.2 Tính toán hai trường hợp tách bạch: $gamma = 0$ và $gamma = 1$
1. *Trường hợp 1: Lý tưởng bỏ qua tự tải ($gamma = 0$):*
   - Tổng thời gian trễ: $D = N dot f = N dot F^(1/N)$.
   - Đạo hàm $partial D / partial N = 0 arrow.r f = e approx 2.718$, số tầng $N = ln F$.
   - *Ví dụ với $F = 256$ ($C_L = 512"fF", C_("in") = 2"fF"$):*
     $N = ln(256) approx 5.55 arrow.r$ chọn $N = 6$ tầng.
     Hệ số phóng đại thực tế: $f = 256^(1/6) approx 2.52$.
     Tổng trễ: $D = N dot f = 6 times 2.52 approx 15.1 tau_0$.
2. *Trường hợp 2: Thực tế có tự tải khuếch tán ($gamma approx 1$):*
   - Tổng thời gian trễ: $D = N dot (f + gamma) = N dot (f + 1)$.
   - Kỹ sư công nghiệp chọn $f = 4$:
     Số tầng: $N = log_4(256) = 4$ tầng.
     Tổng trễ: $D = 4 times (4 + 1) = 20 tau_0$.
   - *Đánh đổi diện tích và công suất:*
     - Chuỗi 4 tầng ($f = 4$): Tổng bề rộng $W_("total") = 1 + 4 + 16 + 64 = 85$ đơn vị.
     - Chuỗi 6 tầng ($f = 2.52$): Tổng bề rộng $W_("total") approx 1 + 2.5 + 6.3 + 16 + 40 + 102 approx 168$ đơn vị.
     - Chọn $f = 4$ giúp *tiết kiệm gần 50% diện tích silicon* và giảm 50% năng lượng chuyển mạch động ($C_("total") V_("DD")^2$).

=== 4.3 Hiện tượng quá độ Miller (Miller Undershoot)
Do có tụ ký sinh chồng lấn cực Cổng - Cực Máng $C_(g d)$, khi ngõ vào chuyển dốc đứng từ $1 arrow.r 0$ ($d V_("in")/d t < 0$), dòng điện dịch $I = C_(g d) d(V_("in") - V_("out"))/d t$ kéo giật nốt ngõ ra tụt xuống mức âm ($-0.1"V" arrow.r -0.2"V"$) trước khi pMOS kịp dẫn nạp.
- *Rủi ro vật lý:* Nốt ngõ ra nối với vùng $n^+$ nằm trên $p$-substrate (đang nối đất). Nếu ngõ ra bị kéo âm quá $-0.6"V"$, tiếp giáp $p$-substrate/$n^+$ ngõ ra sẽ phân cực thuận, bơm electron vào chất nền và kích hoạt hiện tượng *Latch-up*!

#v(6pt)
== 5. Cơ chế Latch-up & Biện pháp phòng tránh

=== 5.1 Cặp transistor BJT ký sinh & Vòng lặp hồi tiếp SCR
Trong CMOS bulk, sự xen kẽ giữa các lớp tạo thành 2 BJT ký sinh:
- $Q_1$ (pnp): Emitter là $p^+$ source pMOS nối $V_("DD")$, Base là N-well, Collector là p-substrate.
- $Q_2$ (npn): Emitter là $n^+$ source nMOS nối GND, Base là p-substrate, Collector là N-well.

Cực thu $Q_1$ bơm vào cực gốc $Q_2$, cực thu $Q_2$ kéo dòng từ cực gốc $Q_1$, tạo thành mạch chỉnh lưu có điều khiển (SCR):
- Khi xung quá độ ở I/O kích sụt áp $I dot R_("sub") >= 0.7"V"$ hoặc $I dot R_("well") >= 0.7"V"$, BJT bật mở.
- Vòng hồi tiếp dương tự duy trì khi:
  $ A_("loop") = beta_1 dot beta_2 >= 1 $
- Mạch bị khóa cứng vào đường dẫn điện trở cực thấp từ $V_("DD")$ xuống GND, dòng vọt lên hàng trăm mA gây sụt nguồn và thiêu rụi chip do quá nhiệt.

=== 5.2 Vì sao Reset mềm không thể tắt Latch-up?
Dòng ngắn mạch của SCR chạy trực tiếp qua khối bán dẫn thể tích (bulk silicon), hoàn toàn nằm ngoài sự kiểm soát của cực cổng Poly-Si. Tín hiệu Reset logic ở cực cổng không thể can thiệp. Cách duy nhất để dập tắt là *cắt nguồn điện cung cấp ($V_("DD")$ Power Cycle)* để dòng tụt dưới dòng duy trì ($I < I_H$).

=== 5.3 Biện pháp phòng ngừa trong layout
1. *Substrate & Well Taps:* Cắm tiếp xúc $P^+$ nối GND và $N^+$ nối $V_("DD")$ định kỳ ($< 20 - 30 mu"m"$) để dìm $R_("sub"), R_("well") arrow.r 0 Omega$, ngăn $I dot R$ chạm tới $0.7"V"$.
2. *Guard Rings:* Đai $P^+$ bao quanh nMOS và đai $N^+$ bao quanh pMOS đóng vai trò hố thu gom (sink) hút sạch hạt dẫn thiểu số đi lạc, kéo tụt $beta_1 dot beta_2 << 1$.

#v(6pt)
== 6. Sự sụp đổ của Shockley $arrow.r$ Hiệu ứng kênh ngắn $arrow.r$ BSIM

=== 6.1 Bốn hiệu ứng kênh ngắn (Short-Channel Effects) cốt lõi
1. *Bão hòa vận tốc (Velocity Saturation):* Dưới điện trường dọc lớn ($E_x > 1.5 times 10^4 "V/cm"$), hạt dẫn va chạm liên tục với dao động mạng tinh thể, vận tốc trôi chạm trần tối đa $v_("sat") approx 10^7 "cm/s"$. Dòng bão hòa chuyển sang quan hệ *bậc 1 tuyến tính*:
   $ I_("dsat") approx W C_(o x) v_("sat") (V_(g s) - V_t) $
2. *Hạ thấp rào thế do cực máng (DIBL):* Chiều dài kênh ngắn khiến vùng suy giảm cực Máng tiến sát cực Source, kéo tụt đỉnh rào thế tĩnh điện ở đầu nguồn:
   $ Delta V_t = "ETA0" dot V_(d s) $
   Làm điện áp ngưỡng $V_t$ sụt giảm khi $V_(d s)$ tăng, tăng độ dẫn ngõ ra và tăng vọt dòng rò rỉ.
3. *Dòng rò dưới ngưỡng (Subthreshold Leakage):* Khi $V_(g s) < V_t$, các electron có năng lượng kích thích nhiệt vẫn khuếch tán qua rào thế từ nguồn sang máng:
   $ I_("sub") prop 10^(-frac(V_t - V_(g s), S)), quad S = n (frac(k_B T, q)) ln(10) approx 70 - 100 "mV/decade" $
4. *Dòng rò xuyên hầm oxit cực cổng (Gate Tunneling):* Khi lớp oxit $t_(o x) < 1.5"nm"$, electron lượng tử xuyên qua hàng rào điện môi, tạo dòng rò $I_("gate")$ trực tiếp từ cổng vào kênh/đế.

=== 6.2 Bảy tham số BSIM cốt lõi
- `TOXE`: Độ dày vật lý oxit cổng $arrow.r$ quyết định $C_(o x)$ và dòng rò xuyên hầm $I_("gate")$.
- `VTH0`: Điện áp ngưỡng danh định tại kênh dài khi $V_(d s) approx 0"V"$.
- `VSAT`: Vận tốc bão hòa cực đại của hạt dẫn $arrow.r$ quyết định dòng bão hòa $I_("dsat")$ tuyến tính.
- `ETA0`: Hệ số DIBL $arrow.r$ quyết định mức độ sụt giảm $V_t$ theo $V_(d s)$.
- `DROUT`: Hệ số chiều dài kênh $arrow.r$ quyết định độ dốc dòng điện trong vùng bão hòa.
- `CJ`: Điện dung tiếp giáp đáy khuếch tán ($"F/m"^2$) $arrow.r$ quyết định thành phần đáy của tụ ký sinh $C_(d b), C_(s b)$.
- `CJSW`: Điện dung tiếp giáp thành bên ($"F/m"$) $arrow.r$ quyết định thành phần viền của tụ ký sinh $C_(d b), C_(s b)$.

#v(6pt)
== 7. Định cỡ Transistor trong Kỷ nguyên Nanomet

=== 7.1 Tư duy thời Shockley: Cân bằng thời gian tăng/giảm với $W_p / W_n approx 2.5:1$
Theo Shockley, $I_("dsat") prop mu W$. Do $mu_n / mu_p approx 2.5$, điện trở dẫn nMOS nhỏ hơn pMOS 2.5 lần ($R_n approx R_p / 2.5$). Để cân bằng trễ sườn lên và sườn xuống ($t_(p d r) = t_(p d f)$), kỹ sư chọn $W_p / W_n approx 2.5:1$.

=== 7.2 Thực tế nanomet: Bão hòa vận tốc dìm nMOS xuống $1.5 - 1.8:1$
- Electron có $mu_n$ cao nên đạt điện trường tới hạn $E_c$ rất sớm; nMOS bị bão hòa vận tốc hoàn toàn và dòng bị dìm xuống mức tăng bậc 1.
- Lỗ trống có $mu_p$ nhỏ nên $E_c$ lớn hơn gấp đôi, ít bị bão hòa vận tốc hơn.
- Tỷ số cấp dòng thực tế trong mô hình BSIM co hẹp chỉ còn:
  $ frac(I_("on,n") / W_n, I_("on,p") / W_p) approx 1.5 - 1.8 $

=== 7.3 Tối ưu trễ trung bình: Tránh bẫy tự tải điện dung
Nếu phình to pMOS lên $2.5 - 3.0 W_n$, kích thước lớn sẽ làm phình to tụ cực cổng $C_g$ và tụ khuếch tán $C_(d b)$. Tải dung ký sinh nội tại này tự cản trở tốc độ của chính cổng đảo và tầng phía trước.
- *Quy tắc định cỡ nanomet:* Để đạt thời gian trễ trung bình nhỏ nhất ($t_(p d, a v g) = (t_(p d r) + t_(p d f))/2 = min$), tỷ số bề rộng tối ưu chỉ là:
  $ frac(W_p, W_n) approx 1.5:1 quad "đến" quad 1.8:1 $
  Giúp mạch chạy nhanh nhất, tiết kiệm >30% diện tích và cắt giảm công suất động!

#v(6pt)
== 8. Bảng tra cứu tổng hợp các họ Inverter & BSIM

#table(
  columns: (1fr, 1.1fr, 1fr, 1.1fr, 1.8fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 4.5pt,
  [*Họ Cổng Đảo*], [*Mạng PUN / PDN*], [*Mức ngõ ra*], [*Công suất tĩnh*], [*Đặc tính cốt lõi & Ứng dụng*],
  [Resistive-Load], [Điện trở $R_L$ / nMOS], [$V_(O H)=V_("DD")$\ $V_(O L)>0"V"$], [Rất lớn khi $V_("out")=0$], [$R_L$ chiếm diện tích lớn, sườn lên chậm; vi mạch lịch sử 1960.],
  [Depletion nMOS], [nMOS ($V_t<0$) / nMOS], [$V_(O H)=V_("DD")$\ $V_(O L)>0"V"$], [Rất lớn khi $V_("out")=0$], [Sườn lên nhanh hơn $R_L$; cần thêm mặt nạ cấy ion; Intel 8085, Z80.],
  [*Static CMOS*], [*pMOS / nMOS bổ sung*], [*Rail-to-Rail*\ $V_(O H)=V_("DD"), V_(O L)=0"V"$], [*Lý tưởng = 0*\ (chỉ có dòng rò)], [*Chuẩn mực cho >99% mạch số*; dải động cực đại, không hao điện tĩnh.],
  [Pseudo-nMOS], [1 pMOS nối đất / nMOS], [$V_(O H)=V_("DD")$\ $V_(O L)>0"V"$ ($beta_n/beta_p >= 4$)], [Rất lớn khi $V_("out")=0$], [Rất gọn cho cổng nhiều ngõ vào ($N+1$); bộ giải mã địa chỉ ROM, PLA.],
  [$C^2"MOS"$ / Tri-state], [Cặp pMOS / Cặp nMOS nối tiếp], [$V_(O H)=V_("DD"), V_(O L)=0"V"$\ Trạng thái Hi-Z], [Lý tưởng = 0], [Ghép bus dùng chung, chốt D-Latch, triệt tiêu xung đột đua tín hiệu.],
  [Dynamic CMOS], [1 pMOS Precharge / nMOS Evaluate], [$V_(O H)=V_("DD"), V_(O L)=0"V"$\ (2 pha xung nhịp)], [Không có tĩnh thuần, nhạy rò], [Tải ngõ vào nhẹ, tốc độ cực nhanh; nhạy cảm mất điện tích; ALU siêu tốc.],
  [Nanoscale BSIM], [FinFET pMOS / FinFET nMOS], [Full Rail-to-Rail\ ($V_("DD") approx 0.7 - 0.9"V"$)], [Đáng kể do rò rỉ ($I_("sub") + I_("gate")$)], [*$W_p/W_n approx 1.5 - 1.8:1$*; triệt tiêu SCE; CPU/GPU hiện đại.]
)

#v(6pt)
== 9. Năm câu hỏi tự kiểm tra (kèm lời giải đã chuẩn hóa số liệu)

#pitfall-box[
  *Câu 1 (Cơ chế Latch-up & Kỹ thuật Guard Ring):*  
  Một vi điều khiển p-substrate/N-well bị một xung âm $-0.8"V"$ tác động vào chân I/O trong $2"ns"$. Sau đó, dòng tiêu thụ tăng vọt từ $15"mA"$ lên $800"mA"$, chip nóng rực:
  1. Giải thích vòng lặp hồi tiếp dương giữa $Q_1$ (pnp) và $Q_2$ (npn) và điều kiện duy trì?
  2. Vì sao gửi lệnh Reset mềm không tắt được mà bắt buộc phải ngắt hoàn toàn nguồn điện?
  3. Phân tích nguyên lý bảo vệ của Guard Rings?
]

_Lời giải chi tiết:_
1. *Vòng hồi tiếp SCR:* Transistor $Q_1$ (pnp ký sinh từ $p^+$ source pMOS, N-well, p-substrate) và $Q_2$ (npn ký sinh từ $n^+$ source nMOS, p-substrate, N-well) ghép chéo. Khi xung âm $-0.8"V"$ làm sụt áp $I dot R_("sub") >= 0.7"V"$, $Q_2$ bật mở kéo dòng qua $R_("well")$ mở tiếp $Q_1$. $Q_1$ lại bơm dòng kích cho $Q_2$. Điều kiện duy trì:
   $ A_("loop") = beta_1 dot beta_2 >= 1 $
2. *Lý do Reset mềm không hoạt động:* Dòng ngắn mạch chạy qua khối bán dẫn thể tích (bulk substrate), hoàn toàn nằm ngoài sự kiểm soát của cực cổng Poly-Si. Bắt buộc phải ngắt nguồn ($V_("DD")$ Power Cycle) để dòng qua SCR tụt dưới dòng duy trì ($I < I_H$).
3. *Vai trò Guard Rings:* Đai $P^+$ nối GND và $N^+$ nối $V_("DD")$ giảm $R_("sub"), R_("well") arrow.r 0 Omega$, ngăn sụt áp $0.7"V"$. Đồng thời chúng đóng vai trò hố thu gom hút hạt dẫn thiểu số đi lạc, kéo tụt $beta_1 dot beta_2 << 1$.

#rule-box[
  *Câu 2 (Dịch chuyển ngưỡng logic $V_M$ & Biến thiên PVT góc FS):*  
  Cổng đảo CMOS danh định có $V_("DD") = 1.0"V"$, $V_(t n) = 0.3"V"$, $|V_(t p)| = 0.3"V"$, $beta_n = beta_p$.
  1. Dẫn xuất công thức tính $V_M$ và chứng minh $V_M = V_("DD")/2$.
  2. Ở góc lệch tiến trình *FS (Fast nMOS, Slow pMOS)* với $beta_n' = 1.44 beta_n, V_(t n)' = 0.22"V", beta_p' = 0.64 beta_p, |V_(t p)'| = 0.38"V"$, tính giá trị chính xác của $V_M'$?
  3. Đặc tuyến VTC bị lệch về phía nào và mạch nhạy cảm với loại nhiễu nào nhất?
]

_Lời giải chi tiết:_
1. *Dẫn xuất $V_M$:* Cân bằng dòng bão hòa $1/2 beta_n (V_M - V_(t n))^2 = 1/2 beta_p (V_("DD") - V_M - |V_(t p)|)^2$.  
   Đặt một định nghĩa chuẩn duy nhất $r = sqrt(beta_p / beta_n)$:
   $ V_M = frac(V_(t n) + r (V_("DD") - |V_(t p)|), 1 + r) $
   Khi $r = 1$ và $V_(t n) = |V_(t p)| = 0.3"V"$: $V_M = (0.3 + 0.7) / 2 = 0.5"V" = V_("DD")/2$.
2. *Tính toán góc FS:*
   $ r' = sqrt(frac(0.64, 1.44)) = frac(0.8, 1.2) = frac(2, 3) approx 0.667 $
   $ V_M' = frac(0.22 + 0.667 times (1.0 - 0.38), 1 + 0.667) = frac(0.22 + 0.4133, 1.667) approx 0.38"V" $
3. *Kết luận:* $V_M'$ giảm xuống $0.38"V"$, đặc tuyến VTC bị *trượt lệch sang TRÁI*. Lề nhiễu mức thấp $N M_L approx V_(I L)$ bị bóp nghẹt. Mạch trở nên cực kỳ nhạy cảm trước *Nhiễu nảy đất (Ground Bounce)* trên đường GND!

#physical-box[
  *Câu 3 (Định cỡ nanomet: Bão hòa vận tốc vs Tự tải điện dung):*  
  1. Vì sao lý thuyết Shockley khuyên định cỡ $W_p / W_n approx 2.5:1$ để cân bằng trễ $t_(p d r) = t_(p d f)$?
  2. Trong tiến trình $65"nm"$ BSIM, vì sao bão hòa vận tốc làm tỷ số dòng thực tế $I_("on,n") / I_("on,p")$ co hẹp còn $1.5 - 1.8$?
  3. Vì sao chọn $W_p / W_n approx 1.5 - 1.8:1$ lại cho thời gian trễ trung bình nhỏ hơn chọn $2.5:1$?
]

_Lời giải chi tiết:_
1. *Shockley:* $I_("dsat") prop mu W$. Cần $R_p = R_n arrow.r mu_p W_p = mu_n W_n arrow.r W_p / W_n = mu_n / mu_p approx 2.5:1$.
2. *Bão hòa vận tốc nanomet:* Electron có $mu_n$ cao nên đạt điện trường tới hạn $E_c$ rất sớm; nMOS bị bão hòa vận tốc hoàn toàn, dòng bị dìm xuống quan hệ bậc 1. Lỗ trống có $mu_p$ nhỏ nên $E_c$ lớn hơn gấp đôi, ít bị bão hòa hơn. Tỷ số dòng thực tế co hẹp còn $1.5 - 1.8$.
3. *Bẫy tự tải điện dung:* Nếu làm $W_p = 2.5 W_n$, kích thước lớn làm phình to tụ cực cổng $C_g$ và tụ khuếch tán $C_(d b)$. Tải dung ký sinh nội tại này tự làm chậm chính cổng đảo và tầng phía trước. Định cỡ $W_p / W_n approx 1.5 - 1.8:1$ vừa tận dụng dòng thực tế, vừa tránh tự tải, đạt trễ trung bình $t_(p d, a v g)$ nhỏ nhất.

#math-box[
  *Câu 4 (Đánh giá DIBL & Dòng rò dưới ngưỡng):*  
  nMOS $28"nm"$ chạy ở $V_("DD") = 0.9"V"$. Ở $T = 300"K"$, $S = 80"mV/decade"$, $"ETA0" = 0.075$:
  1. Khi $V_(d s)$ tăng từ $0.05"V"$ lên $0.9"V"$, $V_t$ sụt giảm bao nhiêu millivolt?
  2. Dòng rò dưới ngưỡng $I_("sub")$ tăng lên bao nhiêu lần?
  3. Khi nhiệt độ tăng lên $87^circle.small "C"$ ($360"K"$), hệ số $S$ và dòng rò thay đổi ra sao?
]

_Lời giải chi tiết:_
1. *Độ sụt $V_t$ do DIBL:*
   $ Delta V_t = "ETA0" times (0.9"V" - 0.05"V") = 0.075 times 0.85"V" = 63.75"mV" $
2. *Mức tăng dòng rò:*
   $ frac(I_("sub") prime, I_("sub")) = 10^(frac(Delta V_t, S)) = 10^(frac(63.75, 80)) = 10^(0.7969) approx 6.26 "lần!" $
3. *Ảnh hưởng nhiệt độ:* $S prop T$. Ở $360"K"$: $S_(360"K") = 80 times (360/300) = 96"mV/decade"$. Nhiệt năng $k_B T$ tăng giúp electron vượt rào dễ hơn, làm dòng rò tĩnh tăng từ 10 đến 30 lần so với ở nhiệt độ phòng.

#rule-box[
  *Câu 5 (Thiết kế chuỗi đệm Inverter & Cú nhúng Miller):*  
  Cổng kích thước cơ sở ($C_("in") = 2"fF"$) lái tải bus $C_L = 512"fF"$ ($F = 256$):
  1. Tính số tầng $N$ và tổng trễ $D$ trong trường hợp lý thuyết bỏ qua tự tải ($gamma = 0$)?
  2. Trong thực tế có tự tải ($gamma = 1$), nếu chọn $f = 4$, tính $N, D$ và so sánh diện tích transistor?
  3. Khi ngõ vào nhảy sườn xuống ($1 arrow.r 0$), vì sao ngõ ra xuất hiện cú nhúng âm (Miller undershoot)? Nguy cơ là gì?
]

_Lời giải chi tiết:_
1. *Lý thuyết $gamma = 0$:* $f = e approx 2.718$. $N = ln(256) approx 5.55 arrow.r$ Chọn $N = 6$ tầng.  
   Hệ số phóng đại thực tế: $f = 256^(1/6) approx 2.52$.  
   Tổng trễ: $D = N dot f = 6 times 2.52 approx 15.1 tau_0$.
2. *Thực tế $gamma = 1$ với $f = 4$:*  
   Số tầng: $N = log_4(256) = 4$ tầng.  
   Tổng trễ: $D = 4 times (4 + 1) = 20 tau_0$.  
   *So sánh diện tích:*  
   - Chuỗi 4 tầng ($f = 4$): $W_("total") = 1 + 4 + 16 + 64 = 85$ đơn vị.  
   - Chuỗi 6 tầng ($f = 2.52$): $W_("total") approx 1 + 2.5 + 6.3 + 16 + 40 + 102 approx 168$ đơn vị.  
   - Chọn $f = 4$ giúp *tiết kiệm gần 50% diện tích silicon* và giảm 50% năng lượng nạp xả tụ động.
3. *Cú nhúng âm Miller:* Do tụ chồng lấn $C_(g d)$, khi $V_("in")$ giảm dốc đứng ($1 arrow.r 0$), dòng điện dịch $I = C_(g d) d(V_("in") - V_("out"))/d t$ kéo giật nốt ngõ ra tụt xuống mức âm ($-0.15"V"$) trước khi pMOS kịp mở.  
   *Nguy cơ:* Nếu ngõ ra tụt âm quá $-0.6"V"$, tiếp giáp $p$-substrate/$n^+$ ngõ ra sẽ phân cực thuận, bơm electron vào chất nền và kích hoạt hiện tượng *Latch-up*!
