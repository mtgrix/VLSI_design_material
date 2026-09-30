# Chuyên Đề 2 - Giờ 2: Các Lớp Cổng Đảo (Inverter Circuit Families) & Mô Hình Bán Dẫn BSIM

> **Mục tiêu học tập:** Hiểu rõ bản chất vật lý và cấu trúc mạch của các họ cổng đảo, làm chủ đặc tuyến truyền đạt DC (VTC), nguyên lý chuỗi đệm và lý do mô hình BSIM thay thế mô hình Shockley trong kỷ nguyên nanomet.  
> **Phong cách tiếp cận:** Tháo nút thắt từng bước từ bản chất hạt mang điện đến hành vi mạch thực tế; câu văn ngắn gọn, trực diện, không dùng từ ngữ khoa trương; thuật ngữ chuẩn English / tiếng Việt song song.

---

## 0. Bảng thuật ngữ cốt lõi & Phạm vi tài liệu

### 0.1 Bảng thuật ngữ đối chiếu (Glossary)

| Thuật ngữ Tiếng Anh | Thuật ngữ Tiếng Việt | Ý nghĩa vật lý & mạch điện |
| :--- | :--- | :--- |
| **Pull-Up Network (PUN)** | Mạng kéo lên | Mạch linh kiện nối giữa nguồn $V_{DD}$ và ngõ ra, nạp điện tích để đưa ngõ ra lên mức 1. |
| **Pull-Down Network (PDN)** | Mạng kéo xuống | Mạch linh kiện nối giữa ngõ ra và đất GND, xả điện tích để đưa ngõ ra về mức 0. |
| **Rail-to-rail swing** | Dải dao động toàn phần | Điện áp ngõ ra chạy trọn vẹn từ đúng $0.0\text{V}$ đến đúng $V_{DD}$, không bị sụt áp ngưỡng. |
| **Static power dissipation ($P_{static}$)** | Tiêu tán công suất tĩnh | Công suất điện tiêu thụ khi ngõ vào giữ nguyên ở trạng thái logic ổn định (0 hoặc 1). |
| **Voltage Transfer Characteristic (VTC)** | Đặc tuyến truyền đạt điện áp | Đồ thị hàm truyền biểu diễn điện áp ngõ ra $V_{out}$ theo điện áp ngõ vào $V_{in}$ khi quét DC từ $0 \to V_{DD}$. |
| **Switching threshold ($V_M$)** | Ngưỡng chuyển mạch logic | Điểm trên đặc tuyến VTC mà tại đó điện áp ngõ vào bằng điện áp ngõ ra ($V_{in} = V_{out} = V_M$). |
| **Noise Margin ($NM_L, NM_H$)** | Dải dự trữ nhiễu (mức thấp / cao) | Biên độ nhiễu điện áp tối đa ở ngõ vào mà cổng logic vẫn không diễn giải sai trạng thái logic. |
| **Path Effort ($F$)** | Độ khuếch đại tải toàn đường | Tỷ số giữa điện dung tải ngoài cần lái $C_L$ và điện dung ngõ vào tầng đầu $C_{in}$ ($F = C_L / C_{in}$). |
| **Stage Effort ($f$)** | Độ khuếch đại từng tầng | Tỷ số phóng đại kích thước giữa hai tầng kế tiếp nhau trong chuỗi đệm ($f = F^{1/N}$). |
| **Self-loading ($\gamma$)** | Hệ số tự tải ký sinh | Tỷ số giữa điện dung khuếch tán ký sinh nội tại của chính transistor ngõ ra và điện dung cực cổng ngõ vào. |
| **Short-Channel Effects (SCE)** | Hiệu ứng kênh ngắn | Các hiện tượng vật lý phi tuyến tính xuất hiện khi chiều dài kênh $L \le 0.25\,\mu\text{m}$. |
| **Velocity Saturation** | Bão hòa vận tốc | Vận tốc trôi của hạt dẫn chạm trần tối đa $v_{sat}$ do tán xạ liên tục với mạng tinh thể dưới điện trường dọc lớn. |
| **Drain-Induced Barrier Lowering (DIBL)** | Hạ thấp rào thế do cực máng | Điện trường cực máng thâm nhập sâu vào kênh làm giảm đỉnh rào cản thế năng, kéo giảm điện áp ngưỡng $V_t$. |
| **Subthreshold Leakage ($I_{sub}$)** | Dòng rò dưới ngưỡng | Dòng khuếch tán yếu chảy từ nguồn sang máng khi điện áp điều khiển cực cổng nhỏ hơn ngưỡng ($V_{gs} < V_t$). |
| **Gate Tunneling ($I_{gate}$)** | Dòng rò xuyên hầm oxit cổng | Dòng điện tử lượng tử chui qua lớp cách điện oxit cực mỏng khi độ dày $t_{ox} < 1.5\,\text{nm}$. |

### 0.2 Phạm vi tài liệu
- **Kiến thức tiên quyết đã biết từ Giờ 1:** Bản chất transistor nMOS (hạt electron), pMOS (hạt lỗ trống), quy tắc dẫn điện Strong 0 / Weak 1, cấu tạo cổng CMOS cơ bản và bài toán định cỡ NOR.
- **Trọng tâm Giờ 2:**
  1. Phân tích 6 họ kiến trúc cổng đảo (Inverter circuit families) theo khung so sánh cố định.
  2. Giải tích chi tiết 5 vùng hoạt động của đặc tuyến VTC, dẫn xuất điểm ngưỡng logic $V_M$ và dải dự trữ nhiễu.
  3. Lý thuyết chuỗi đệm Inverter (Inverter buffer chain) và phân tích hiện tượng quá độ Miller.
  4. Cơ chế tích tụ Latch-up ký sinh và biện pháp bố trí layout phòng tránh.
  5. Sự phá vỡ của mô hình Shockley kênh dài và sự ra đời của mô hình chuẩn công nghiệp BSIM.
  6. Thay đổi cốt lõi trong định cỡ tỷ lệ $W_p / W_n$ từ công nghệ micro sang công nghệ nanomet.

---

## 1. Cầu nối Giờ 1 → Các họ Inverter

### 1.1 Bản chất quy tắc Strong 0 / Weak 1: Cực Source có trôi hay không?
Ở Giờ 1, chúng ta đã kết luận nMOS truyền mức 0 mạnh (Strong 0) nhưng truyền mức 1 yếu (Weak 1), còn pMOS ngược lại. Gốc rễ vật lý của hiện tượng này nằm ở câu hỏi: **Cực Source của transistor được nối cố định hay bị trôi theo điện áp ngõ ra $V_{out}$?**

1. **nMOS kéo xuống đất GND (Nhiệm vụ xả tụ - Strong 0):**
   - Cực Source được nối trực tiếp vào nguồn đất GND cố định ($V_s = 0\text{V}$).
   - Khi ngõ vào ở mức cao ($V_{in} = V_{DD}$), điện áp đặt lên lớp oxit cổng là $V_{gs} = V_g - V_s = V_{DD} - 0\text{V} = V_{DD}$.
   - Hiệu điện thế $V_{gs}$ này giữ nguyên giá trị cực đại trong suốt quá trình xả điện tích từ ngõ ra xuống đất. Do đó, kênh dẫn duy trì độ mở tối đa cho đến khi $V_{out}$ được kéo cạn kiệt về đúng **$0.0\text{V}$**.
2. **nMOS kéo lên nguồn $V_{DD}$ (Nhiệm vụ nạp tụ - Weak 1):**
   - Cực Drain nối vào $V_{DD}$. Cực Source đóng vai trò là nốt ngõ ra nối với tụ tải ($V_s = V_{out}$).
   - Ban đầu khi $V_{out} = 0\text{V}$, $V_{gs} = V_{DD} - 0\text{V} = V_{DD}$ nên transistor dẫn mạnh.
   - Nhưng khi dòng điện nạp vào tụ làm $V_{out}$ tăng lên, điện thế cực Source tăng theo. Hiệu điện thế điều khiển thực tế bị thu hẹp dần:
     $$V_{gs} = V_{DD} - V_{out}$$
   - Khi ngõ ra tăng tới mốc $V_{out} = V_{DD} - V_{tn}$, hiệu điện thế $V_{gs}$ chạm đúng ngưỡng bật $V_{tn}$. Điện trường dọc biến mất, kênh dẫn tự động đóng sập lại ($I_{ds} = 0$).
   - Điện tích không thể nạp thêm được nữa. Ngõ ra bị kẹt cứng tại mức **$V_{DD} - V_{tn}$**, gây mất áp ngưỡng nghiêm trọng.
3. **pMOS kéo lên nguồn $V_{DD}$ (Nhiệm vụ nạp tụ - Strong 1):**
   - Cực Source được nối cố định vào $V_{DD}$ ($V_s = V_{DD}$).
   - Khi ngõ vào ở mức thấp ($V_{in} = 0\text{V}$), hiệu điện thế điều khiển là $|V_{gs}| = V_s - V_g = V_{DD} - 0\text{V} = V_{DD}$.
   - Trị số $|V_{gs}|$ giữ nguyên cực đại trong toàn bộ quá trình nạp. Tụ ngõ ra được nạp căng tràn lên đúng mức **$V_{DD}$**.
4. **pMOS kéo xuống đất GND (Nhiệm vụ xả tụ - Weak 0):**
   - Cực Source đóng vai trò là nốt ngõ ra ($V_s = V_{out}$).
   - Khi $V_{out}$ xả điện áp tụt dần về đất, trị số $|V_{gs}| = V_{out} - 0\text{V} = V_{out}$ giảm dần. Khi $V_{out}$ chạm tới $|V_{tp}|$, kênh pMOS tự khóa lại. Điện áp ngõ ra bị kẹt ở mức **$|V_{tp}|$**, không bao giờ về được $0.0\text{V}$.

### 1.2 Câu chốt kiến trúc: Vì sao CMOS giành chiến thắng tuyệt đối?
Cấu trúc CMOS (Complementary MOS) trở thành chuẩn mực thống trị toàn bộ nền công nghiệp bán dẫn không phải vì một trào lưu nhất thời, mà vì tính đối ngẫu vật lý hoàn hảo:
- Mạng kéo lên (Pull-Up Network - PUN) được giao trọn vẹn cho **pMOS** (chuyên gia nạp mức 1 mạnh, Strong 1).
- Mạng kéo xuống (Pull-Down Network - PDN) được giao trọn vẹn cho **nMOS** (chuyên gia xả mức 0 mạnh, Strong 0).

**Kết quả:** Ngõ ra đạt dải dao động toàn phần (rail-to-rail: $0.0\text{V} \leftrightarrow V_{DD}$) và tuyệt đối không bao giờ tồn tại đường dẫn dẫn thông trực tiếp từ $V_{DD}$ xuống GND ở trạng thái tĩnh. Tiêu tán công suất tĩnh lý tưởng bằng 0 ($P_{static} \approx 0$).

---

## 2. Các lớp cổng đảo (Inverter Circuit Families)

Dưới đây là 6 họ kiến trúc cổng đảo được phân tích theo một khung tiêu chuẩn thống nhất.

### 2.1 Cổng đảo Tải Điện Trở (Resistive-load Inverter)
- **Tên gọi:** Resistive-load Inverter / Cổng đảo tải điện trở thụ động.
- **PUN:** Một điện trở thụ động $R_L$ (chế tạo bằng Polysilicon không pha tạp hoặc lớp khuếch tán) nối lên nguồn $V_{DD}$.
- **PDN:** Một transistor nMOS logic nối xuống đất GND.
- **Mức logic ngõ ra ($V_{OH}, V_{OL}$):**
  - Khi $V_{in} = 0\text{V}$: nMOS tắt. Điện trở kéo ngõ ra lên mức cao: $V_{OH} = V_{DD}$.
  - Khi $V_{in} = V_{DD}$: nMOS bật, có điện trở dẫn nội tại $R_{on,n}$. Mạch tạo thành một cầu phân áp:
    $$V_{OL} = V_{DD} \cdot \frac{R_{on,n}}{R_L + R_{on,n}} > 0.0\text{V}$$
- **Công suất tĩnh ($P_{static}$):**
  - Khi ngõ ra ở mức cao ($V_{out} = V_{OH}$): nMOS tắt, dòng điện bằng 0, $P_{static} \approx 0$.
  - Khi ngõ ra ở mức thấp ($V_{out} = V_{OL}$): nMOS bật, dòng điện chạy liên tục từ nguồn xuống đất. Công suất tiêu tán rất lớn:
    $$P_{static} = \frac{V_{DD}^2}{R_L + R_{on,n}} \approx \frac{V_{DD}^2}{R_L}$$
- **Số lượng transistor theo $N$ ngõ vào:** Cần $N$ transistor nMOS + 1 điện trở tải $R_L$.
- **Sơ đồ nguyên lý ASCII:**
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
- **Hạn chế và ứng dụng:**
  - *Hạn chế (Chết ở đâu):* Tiêu tốn công suất tĩnh lớn khi ngõ ra ở mức 0; điện trở $R_L$ có giá trị lớn ($k\Omega \to M\Omega$) chiếm diện tích silicon gấp hàng chục lần một transistor; sườn lên chậm do hằng số thời gian $\tau = R_L C_L$ lớn.
  - *Ứng dụng (Dùng khi nào):* Chỉ dùng trong các mạch tích hợp sơ khai thập niên 1960. Hiện nay không còn sử dụng trong vi mạch số tiêu chuẩn.

### 2.2 Cổng đảo nMOS Tải Giảm Thiểu (Depletion-load nMOS Inverter)
- **Tên gọi:** Depletion-load nMOS Inverter / Cổng đảo nMOS tải suy giảm.
- **PUN:** Một transistor nMOS loại giảm thiểu (Depletion nMOS) được chế tạo đặc biệt với điện áp ngưỡng âm ($V_{t,dep} < 0$). Cực Cổng được nối ngắn trực tiếp vào cực Nguồn của chính nó ($V_{gs,load} = 0\text{V}$).
- **PDN:** Một transistor nMOS tăng cường (Enhancement nMOS) thông thường có điện áp ngưỡng dương ($V_{t,enh} > 0$).
- **Mức logic ngõ ra ($V_{OH}, V_{OL}$):**
  - Khi $V_{in} = 0\text{V}$: Transistor PDN tắt. Transistor tải có $V_{gs,load} = 0\text{V} > V_{t,dep}$ nên luôn duy trì kênh dẫn, nạp điện áp ngõ ra lên trọn vẹn: $V_{OH} = V_{DD}$.
  - Khi $V_{in} = V_{DD}$: Transistor PDN bật. Hai transistor cạnh tranh dẫn dòng, tạo ra mức áp thấp phụ thuộc vào tỷ số kích thước:
    $$V_{OL} = V_{DD} \cdot \frac{R_{on,PDN}}{R_{on,PUN} + R_{on,PDN}} > 0.0\text{V}$$
- **Công suất tĩnh ($P_{static}$):**
  - Rất lớn khi ngõ ra ở mức thấp ($V_{out} = V_{OL}$) do transistor tải hoạt động như một nguồn dòng không đổi bơm điện trực tiếp xuống đất qua transistor PDN: $P_{static} \approx V_{DD} \cdot I_{sat,load}$.
- **Số lượng transistor theo $N$ ngõ vào:** Cần $N + 1$ transistor (tất cả đều là nMOS).
- **Sơ đồ nguyên lý ASCII:**
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
- **Hạn chế và ứng dụng:**
  - *Hạn chế (Chết ở đâu):* Vẫn tiêu tốn công suất tĩnh lớn khi ngõ ra bằng 0; quy trình sản xuất tốn kém vì cần thêm bước quang khắc và cấy ion riêng biệt để tạo ra transistor có $V_t < 0$.
  - *Ứng dụng (Dùng khi nào):* Từng là nền tảng của các vi xử lý kinh điển thập niên 1970 - 1980 (như Intel 8085, Z80, MOS 6502). Ngày nay đã hoàn toàn bị CMOS thay thế.

### 2.3 Cổng đảo CMOS Tĩnh Bổ Sung (Static Complementary CMOS Inverter)
- **Tên gọi:** Static Complementary CMOS Inverter / Cổng đảo CMOS tĩnh bổ sung chuẩn.
- **PUN:** Một transistor pMOS nối lên nguồn $V_{DD}$.
- **PDN:** Một transistor nMOS nối xuống đất GND.
- **Mức logic ngõ ra ($V_{OH}, V_{OL}$):**
  - Khi $V_{in} = 0\text{V}$: pMOS bật dẫn mạnh, nMOS ngắt hoàn toàn $\implies V_{OH} = V_{DD}$.
  - Khi $V_{in} = V_{DD}$: nMOS bật dẫn mạnh, pMOS ngắt hoàn toàn $\implies V_{OL} = 0.0\text{V}$.
  - Đạt dải dao động toàn phần (Full Rail-to-Rail Swing).
- **Công suất tĩnh ($P_{static}$):**
  - Lý tưởng bằng 0 ($P_{static} \approx 0$) ở cả hai trạng thái logic 0 và 1, vì luôn có ít nhất một transistor ngắt hoàn toàn chặn đường dòng từ nguồn xuống đất (chỉ tồn tại dòng rò rỉ rất nhỏ ở quy mô nano-ampe).
- **Số lượng transistor theo $N$ ngõ vào:** Cần đúng $2N$ transistor (gồm $N$ pMOS ở PUN và $N$ nMOS ở PDN).
- **Sơ đồ nguyên lý ASCII:**
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
- **Hạn chế và ứng dụng:**
  - *Hạn chế (Chết ở đâu):* Khi số lượng ngõ vào $N$ lớn (như cổng NOR 4, 8 ngõ vào), số transistor $2N$ tăng nhiều và việc mắc nối tiếp nhiều pMOS làm trễ sườn lên rất nặng và tốn diện tích silicon do độ linh động lỗ trống thấp.
  - *Ứng dụng (Dùng khi nào):* Là khối kiến trúc nền móng chiếm hơn 99% mạch logic trong mọi vi xử lý, vi điều khiển, SoC và chip nhớ hiện đại.

### 2.4 Cổng đảo Pseudo-nMOS (Pseudo-nMOS Inverter)
- **Tên gọi:** Pseudo-nMOS Inverter / Cổng đảo giả nMOS.
- **PUN:** Một transistor pMOS duy nhất có cực Cổng nối đất vĩnh viễn ($V_{g,p} = 0\text{V} \implies V_{gs,p} = -V_{DD}$, luôn luôn ở trạng thái BẬT).
- **PDN:** Mạng transistor logic nMOS nối xuống GND.
- **Mức logic ngõ ra ($V_{OH}, V_{OL}$):**
  - Khi $V_{in} = 0\text{V}$: nMOS tắt, pMOS kéo ngõ ra lên mức cao: $V_{OH} = V_{DD}$.
  - Khi $V_{in} = V_{DD}$: nMOS bật. Mạch trở thành một cấu trúc tỷ lệ (ratioed circuit) cạnh tranh giữa pMOS kéo lên và nMOS kéo xuống:
    $$V_{OL} > 0.0\text{V}$$
  - **Vì sao bắt buộc cần $\beta_n / \beta_p \ge 4$:**  
    Nếu transistor pMOS quá mạnh ($\beta_p$ lớn), dòng điện qua pMOS sẽ giữ nốt ngõ ra ở mức điện áp cao (ví dụ $V_{OL} = 0.6\text{V}$). Mức điện áp này sẽ vô tình kích mở transistor nMOS ở cổng logic tiếp theo, gây sai lệch trạng thái toàn mạch. Để bảo đảm mức $V_{OL}$ đủ nhỏ (thường $< 0.1 - 0.2\text{V}$), ta bắt buộc phải thiết kế độ dẫn của nMOS lớn hơn ít nhất 4 lần so với pMOS:
    $$\frac{\beta_n}{\beta_p} \ge 4$$
- **Công suất tĩnh ($P_{static}$):**
  - Rất lớn khi ngõ ra ở mức thấp ($V_{out} = V_{OL}$): Có dòng ngắn mạch chạy liên tục từ nguồn $V_{DD}$ qua pMOS và nMOS xuống GND ($P_{static} = V_{DD} \cdot I_{sat,p}$).
  - Khi ngõ ra ở mức cao ($V_{out} = V_{OH}$): nMOS tắt nên $P_{static} \approx 0$.
- **Số lượng transistor theo $N$ ngõ vào:** Chỉ cần đúng $N + 1$ transistor (gồm 1 pMOS duy nhất kéo lên và $N$ nMOS logic kéo xuống).
- **Sơ đồ nguyên lý ASCII:**
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
- **Hạn chế và ứng dụng:**
  - *Hạn chế (Chết ở đâu):* Tiêu tốn công suất tĩnh liên tục khi ngõ ra bằng 0; dải dự trữ nhiễu mức thấp $NM_L$ bị thu hẹp đáng kể do $V_{OL} > 0\text{V}$.
  - *Ứng dụng (Dùng khi nào):* Dùng cho các cổng NOR có nhiều ngõ vào ($N \ge 4$), bộ giải mã địa chỉ (address decoder) trong bộ nhớ ROM hoặc mảng logic lập trình được (PLA) nhằm giảm diện tích silicon và giảm điện dung tải ngõ vào.

### 2.5 Cổng đảo $C^2\text{MOS}$ / Ba Trạng Thái (Clocked CMOS / Tri-state Inverter)
- **Tên gọi:** $C^2\text{MOS}$ (Clocked CMOS) / Tri-state Inverter (Cổng đảo ba trạng thái).
- **PUN:** Hai transistor pMOS mắc nối tiếp (một pMOS nhận dữ liệu $V_{in}$, một pMOS nhận tín hiệu điều khiển xung nhịp $\overline{\text{CLK}}$ hoặc $\text{EN}$).
- **PDN:** Hai transistor nMOS mắc nối tiếp (một nMOS nhận tín hiệu xung nhịp $\text{CLK}$ hoặc $\text{EN}$, một nMOS nhận dữ liệu $V_{in}$).
- **Mức logic ngõ ra ($V_{OH}, V_{OL}$):**
  - Khi được kích hoạt ($\text{CLK} = 1, \overline{\text{CLK}} = 0$): Cổng hoạt động như cổng đảo thông thường với $V_{OH} = V_{DD}$ và $V_{OL} = 0.0\text{V}$.
  - Khi bị vô hiệu hóa ($\text{CLK} = 0, \overline{\text{CLK}} = 1$): Cả nhánh kéo lên và nhánh kéo xuống đều bị ngắt hoàn toàn. Ngõ ra bị cô lập ở trạng thái trở kháng cao (**Hi-Z** - High Impedance).
- **Công suất tĩnh ($P_{static}$):**
  - Lý tưởng bằng 0 ở cả 3 trạng thái tĩnh (0, 1 và Hi-Z).
- **Số lượng transistor theo $N$ ngõ vào:** Cần $2N + 2$ transistor (với cổng đảo 1 ngõ vào, cần đúng 4 transistor).
- **Sơ đồ nguyên lý ASCII:**
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
- **Hạn chế và ứng dụng:**
  - *Hạn chế (Chết ở đâu):* Điện trở dẫn tương đương tăng gấp đôi do có 2 transistor mắc nối tiếp ở mỗi nhánh; diện tích dây dẫn tăng lên do phải phân phối cặp đường xung nhịp đối ngẫu ($\text{CLK} / \overline{\text{CLK}}$).
  - *Ứng dụng (Dùng khi nào):* Ghép nối nhiều khối truyền thông vào chung một đường bus dữ liệu nội bộ (Multiplexed Bus); xây dựng mạch chốt (D-Latch) và thanh ghi (Flip-Flop) loại trừ hoàn toàn lỗi chạy đua xung nhịp (Clock Race Condition).

### 2.6 Cổng đảo Logic Động (Dynamic CMOS Inverter)
- **Tên gọi:** Dynamic CMOS Inverter / Cổng đảo logic động (Precharge - Evaluate).
- **PUN:** Một transistor pMOS nạp trước (Precharge transistor) được điều khiển bởi xung nhịp $\text{CLK}$.
- **PDN:** Một transistor nMOS logic nhận dữ liệu $V_{in}$ mắc nối tiếp với một transistor nMOS đánh giá (Evaluate transistor) điều khiển bởi xung nhịp $\text{CLK}$.
- **Mức logic ngõ ra ($V_{OH}, V_{OL}$):**
  - Hoạt động chia làm 2 pha xung nhịp:
    1. *Pha nạp trước (Precharge phase - $\text{CLK} = 0$):* pMOS bật, nMOS đánh giá tắt. Ngõ ra được nạp lên chắc chắn: $V_{OH} = V_{DD}$.
    2. *Pha đánh giá (Evaluate phase - $\text{CLK} = 1$):* pMOS tắt, nMOS đánh giá bật. Nếu $V_{in} = 1$, nhánh nMOS xả điện tích ngõ ra về $V_{OL} = 0.0\text{V}$. Nếu $V_{in} = 0$, ngõ ra giữ nguyên mức $V_{DD}$ nhờ điện dung ký sinh lưu trữ điện tích.
- **Công suất tĩnh ($P_{static}$):**
  - Không có đường dẫn tĩnh từ nguồn xuống đất. Nhưng công suất chuyển mạch động ($P_{dynamic} = \alpha C_L V_{DD}^2 f$) rất lớn vì nốt ngõ ra phải nạp trước lại sau mỗi chu kỳ xung nhịp.
- **Số lượng transistor theo $N$ ngõ vào:** Cần $N + 2$ transistor (1 pMOS nạp trước + $N$ nMOS logic + 1 nMOS đánh giá). Tải ngõ vào rất nhẹ vì dữ liệu chỉ nối vào cực cổng nMOS.
- **Sơ đồ nguyên lý ASCII:**
  ```text
            VDD
             |
   CLK -----|o pMOS (Precharge)
             |
             +----o Vout (Nốt lưu trữ điện tích)
             |
   Vin -----|  nMOS (Logic)
             |
   CLK -----|  nMOS (Evaluate)
             |
            GND
  ```
- **Hạn chế và ứng dụng:**
  - *Hạn chế (Chết ở đâu):* Trong pha đánh giá khi $V_{in} = 0$, nốt ngõ ra rơi vào trạng thái thả nổi (floating). Nốt này rất dễ bị sụt áp do dòng rò dưới ngưỡng (subthreshold leakage) hoặc hiện tượng chia sẻ điện tích (charge sharing) với các nốt bên trong; xung nhịp bắt buộc phải chạy liên tục với tần số đủ cao, không thể dừng xung nhịp để tiết kiệm năng lượng.
  - *Ứng dụng (Dùng khi nào):* Mạch số học tốc độ siêu cao (ALU 64-bit, bộ so sánh, thanh ghi tập tin Register File) trong các CPU hiệu năng cao.

---

## 3. Đặc tuyến truyền đạt DC (VTC) & 5 vùng hoạt động

Đặc tuyến truyền đạt điện áp (Voltage Transfer Characteristic - VTC) là đồ thị biểu diễn điện áp ngõ ra $V_{out}$ theo điện áp ngõ vào $V_{in}$ khi quét liên tục từ $0.0\text{V}$ đến $V_{DD}$.

### 3.1 Giải thích 5 vùng hoạt động A → E khi quét $V_{in}$ tăng dần
Khi $V_{in}$ tăng từ $0\text{V}$ lên $V_{DD}$, hai transistor nMOS và pMOS lần lượt chuyển đổi qua 5 trạng thái hoạt động:

1. **Vùng A ($0 \le V_{in} < V_{tn}$):**
   - nMOS: Có điện áp cổng - nguồn $V_{gs,n} = V_{in} < V_{tn} \implies$ nMOS TẮT hoàn toàn ($I_{ds,n} = 0$).
   - pMOS: Có điện áp $|V_{gs,p}| = V_{DD} - V_{in} > V_{DD} - V_{tn} > |V_{tp}| \implies$ pMOS BẬT mạnh. Vì không có dòng điện chạy qua, hiệu điện thế $|V_{ds,p}| = 0\text{V} \implies$ pMOS ở vùng Tuyến tính (Linear).
   - Ngõ ra: $V_{out} = V_{DD}$ ổn định tuyệt đối.
2. **Vùng B ($V_{tn} \le V_{in} < V_{IL}$):**
   - nMOS: $V_{gs,n} \ge V_{tn}$ nên nMOS bắt đầu mở. Do $V_{out}$ còn rất cao gần $V_{DD}$, điều kiện $V_{ds,n} = V_{out} \ge V_{gs,n} - V_{tn}$ thỏa mãn $\implies$ nMOS ở vùng Bão hòa (Saturation).
   - pMOS: Vẫn có $|V_{ds,p}| = V_{DD} - V_{out} < |V_{gs,p}| - |V_{tp}| \implies$ pMOS ở vùng Tuyến tính (Linear).
   - Ngõ ra: nMOS bắt đầu kéo dòng xả bớt điện tích trên tụ tải, làm $V_{out}$ giảm nhẹ. Độ dốc âm tăng dần tới khi đạt giá trị $-1$ tại điểm $V_{in} = V_{IL}$.
3. **Vùng C ($V_{in} \approx V_M$):**
   - nMOS: Đang dẫn và có $V_{ds,n} = V_M \ge V_M - V_{tn} \implies$ nMOS Bão hòa (Saturation).
   - pMOS: Đang dẫn và có $|V_{ds,p}| = V_{DD} - V_M \ge V_{DD} - V_M - |V_{tp}| \implies$ pMOS Bão hòa (Saturation).
   - Ngõ ra: Cả hai transistor đồng thời hoạt động ở vùng bão hòa (tương đương hai nguồn dòng đối đầu nhau). Tại đây, độ dốc khuếch đại điện áp đạt cực đại: $|dV_{out} / dV_{in}| \gg 1$. Điện áp ngõ ra rơi dốc đứng từ mức cao xuống mức thấp.
4. **Vùng D ($V_{IH} < V_{in} \le V_{DD} - |V_{tp}|$):**
   - nMOS: Ngõ ra $V_{out}$ đã giảm xuống rất thấp, làm cho $V_{ds,n} = V_{out} < V_{gs,n} - V_{tn} \implies$ nMOS chuyển sang vùng Tuyến tính (Linear).
   - pMOS: Có $|V_{ds,p}| = V_{DD} - V_{out} \ge |V_{gs,p}| - |V_{tp}| \implies$ pMOS chuyển sang vùng Bão hòa (Saturation).
   - Ngõ ra: $V_{out}$ giảm dần về sát $0\text{V}$. Điểm bắt đầu vùng D là điểm có độ dốc bằng $-1$ tại $V_{in} = V_{IH}$.
5. **Vùng E ($V_{in} > V_{DD} - |V_{tp}|$):**
   - nMOS: $V_{gs,n} \approx V_{DD}$ dẫn rất mạnh, ở vùng Tuyến tính (Linear) với $V_{ds,n} \approx 0\text{V}$.
   - pMOS: Hiệu điện thế $|V_{gs,p}| = V_{DD} - V_{in} < |V_{tp}| \implies$ pMOS TẮT hoàn toàn ($I_{ds,p} = 0$).
   - Ngõ ra: $V_{out} = 0.0\text{V}$ ổn định tuyệt đối.

### 3.2 Bảng tổng kết 5 vùng hoạt động

| Vùng | Điều kiện điện áp ngõ vào | Trạng thái nMOS | Trạng thái pMOS | Điện áp ngõ ra $V_{out}$ | Độ dốc hàm truyền |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Vùng A** | $0 \le V_{in} < V_{tn}$ | **TẮT** ($I_{ds}=0$) | **Tuyến tính** | $V_{out} = V_{DD}$ | $dV_{out}/dV_{in} = 0$ |
| **Vùng B** | $V_{tn} \le V_{in} < V_{IL}$ | **Bão hòa** | **Tuyến tính** | Bắt đầu sụt nhẹ từ $V_{DD}$ | Thoải dần tới $-1$ tại $V_{IL}$ |
| **Vùng C** | $V_{in} \approx V_M$ | **Bão hòa** | **Bão hòa** | Rơi dốc đứng quanh $V_M$ | Cực đại ($|dV_{out}/dV_{in}| \gg 1$) |
| **Vùng D** | $V_{IH} < V_{in} \le V_{DD} - |V_{tp}|$ | **Tuyến tính** | **Bão hòa** | Tiến sát về $0\text{V}$ | Thoải dần từ $-1$ tại $V_{IH}$ |
| **Vùng E** | $V_{in} > V_{DD} - |V_{tp}|$ | **Tuyến tính** | **TẮT** ($I_{ds}=0$) | $V_{out} = 0.0\text{V}$ | $dV_{out}/dV_{in} = 0$ |

### 3.3 Dẫn xuất ngưỡng chuyển mạch logic $V_M$ từng bước
Ngưỡng chuyển mạch logic $V_M$ (hay $V_{inv}$) là điểm giao nhau giữa đường đặc tuyến VTC và đường thẳng $V_{out} = V_{in}$. Tại điểm này:
$$V_{in} = V_{out} = V_M$$

Ở Vùng C, cả hai transistor đều hoạt động trong vùng bão hòa. Áp dụng phương trình dòng Shockley:
$$I_{ds,n} = \frac{1}{2} \beta_n (V_{gs,n} - V_{tn})^2 = \frac{1}{2} \beta_n (V_M - V_{tn})^2$$
$$I_{ds,p} = \frac{1}{2} \beta_p (|V_{gs,p}| - |V_{tp}|)^2 = \frac{1}{2} \beta_p (V_{DD} - V_M - |V_{tp}|)^2$$

Theo định luật dòng Kirchhoff tại nốt ngõ ra, dòng qua pMOS bằng dòng qua nMOS ($I_{ds,n} = I_{ds,p}$):
$$\frac{1}{2} \beta_n (V_M - V_{tn})^2 = \frac{1}{2} \beta_p (V_{DD} - V_M - |V_{tp}|)^2$$

Triệt tiêu thừa số $1/2$ và lấy căn bậc hai hai vế:
$$\sqrt{\beta_n} (V_M - V_{tn}) = \sqrt{\beta_p} (V_{DD} - V_M - |V_{tp}|)$$

Chia cả hai vế cho $\sqrt{\beta_n}$ và **chốt một định nghĩa duy nhất cho biến số $r$ dùng xuyên suốt tài liệu**:
$$r = \sqrt{\frac{\beta_p}{\beta_n}}$$

Khi đó phương trình trở thành:
$$V_M - V_{tn} = r \cdot (V_{DD} - V_M - |V_{tp}|)$$
$$V_M + r V_M = V_{tn} + r (V_{DD} - |V_{tp}|)$$
$$V_M (1 + r) = V_{tn} + r (V_{DD} - |V_{tp}|)$$

$$\implies V_M = \frac{V_{tn} + r(V_{DD} - |V_{tp}|)}{1 + r}$$

- **Trường hợp mạch đối xứng lý tưởng:**  
  Nếu chọn kích thước sao cho $\beta_p = \beta_n \implies r = 1$, và điện áp ngưỡng đối xứng $V_{tn} = |V_{tp}|$, ta có:
  $$V_M = \frac{V_{tn} + 1 \cdot (V_{DD} - V_{tn})}{1 + 1} = \frac{V_{DD}}{2}$$

### 3.4 Dải dự trữ nhiễu (Noise Margin) & Phân tích góc lệch tiến trình PVT FS
Dải dự trữ nhiễu thể hiện khả năng chống chịu xung nhiễu điện áp ở ngõ vào:
- **Ngưỡng điện áp quy ước:** $V_{IL}$ và $V_{IH}$ là hai điểm trên đặc tuyến VTC có độ dốc đạo hàm đúng bằng $-1$:
  $$\left. \frac{dV_{out}}{dV_{in}} \right|_{V_{in} = V_{IL}} = -1, \quad \left. \frac{dV_{out}}{dV_{in}} \right|_{V_{in} = V_{IH}} = -1$$
- **Lề nhiễu mức thấp:**
  $$NM_L = V_{IL} - V_{OL} = V_{IL} - 0.0\text{V} = V_{IL}$$
- **Lề nhiễu mức cao:**
  $$NM_H = V_{OH} - V_{IH} = V_{DD} - V_{IH}$$

#### Phân tích bài toán góc lệch tiến trình FS (Fast nMOS, Slow pMOS)
Giả sử do sai lệch trong chế tạo, chip rơi vào góc tiến trình lệch FS: nMOS dẫn rất khỏe trong khi pMOS bị yếu:
- Thông số: $V_{DD} = 1.0\text{V}$, $\beta_n' = 1.44 \beta_n$, $V_{tn}' = 0.22\text{V}$, $\beta_p' = 0.64 \beta_p$, $|V_{tp}'| = 0.38\text{V}$.
- Áp dụng định nghĩa chuẩn $r'$:
  $$r' = \sqrt{\frac{\beta_p'}{\beta_n'}} = \sqrt{\frac{0.64 \beta_p}{1.44 \beta_n}} = \frac{0.8}{1.2} = \frac{2}{3} \approx 0.667$$
- Tính điểm ngưỡng chuyển mạch logic mới $V_M'$:
  $$V_M' = \frac{0.22 + 0.667 \times (1.0 - 0.38)}{1 + 0.667} = \frac{0.22 + 0.667 \times 0.62}{1.667} = \frac{0.22 + 0.4133}{1.667} \approx 0.38\text{V}$$

**Hệ quả kỹ thuật:**
1. Ngưỡng logic $V_M'$ sụt giảm từ $0.50\text{V}$ xuống còn **$0.38\text{V}$**.
2. Toàn bộ đường đặc tuyến VTC bị **trượt lệch sang TRÁI (Shift Left)**.
3. Điểm $V_{IL}$ bị kéo tụt xuống rất gần $0\text{V}$, làm cho **dải dự trữ nhiễu mức thấp $NM_L$ bị bóp nghẹt nghiêm trọng**.
4. Mạch trở nên cực kỳ dễ tổn thương trước hiện tượng **Nhiễu nảy đất (Ground Bounce)** trên đường dây GND. Chỉ cần một xung nhiễu dương nhỏ vượt quá $0.22\text{V}$ trên đường đất cũng đủ để nMOS kích hoạt lật sai trạng thái ngõ ra từ mức 1 xuống mức 0.

---

## 4. Chuỗi đệm Inverter (Inverter Buffer Chain) & Hiện tượng Miller

### 4.1 Bài toán kéo tải nặng và mô hình độ khuếch đại Logical Effort
Khi một cổng logic kích thước tối thiểu (điện dung ngõ vào $C_{in}$) cần điều khiển một đường dây bus dài hoặc chân I/O pad có điện dung tải rất lớn $C_L$, độ khuếch đại đường truyền (Path Effort) là:
$$F = \frac{C_L}{C_{in}} \gg 1$$
Nếu dùng trực tiếp một cổng đảo duy nhất để lái tải, dòng điện nhỏ không kịp sạc nạp điện tích, gây ra thời gian trễ khổng lồ $t_{pd} \propto F \cdot \tau_0$. Giải pháp là chèn một chuỗi gồm $N$ tầng đệm Inverter với kích thước phóng to dần theo cấp số nhân với hệ số phóng đại từng tầng:
$$f = F^{1/N}$$

### 4.2 Tính toán hai trường hợp tách bạch: $\gamma = 0$ và $\gamma = 1$

#### Trường hợp 1: Lý tưởng khi bỏ qua điện dung tự tải ($\gamma = 0$)
- Giả định: Không tính điện dung khuếch tán ký sinh ở ngõ ra mỗi tầng.
- Thời gian trễ chuẩn hóa của toàn chuỗi:
  $$D = N \cdot f = N \cdot F^{1/N}$$
- Tìm số tầng $N$ để trễ $D$ đạt cực tiểu bằng cách lấy đạo hàm theo $N$ và cho bằng 0:
  $$\frac{\partial D}{\partial N} = F^{1/N} + N \cdot F^{1/N} \cdot \left(-\frac{\ln F}{N^2}\right) = f (1 - \ln f) = 0$$
  $$\implies 1 - \ln f = 0 \implies f = e \approx 2.718$$
  Số tầng đệm tối ưu lý thuyết là: $N = \ln F$.
- **Ví dụ tính toán với $C_L = 512\text{fF}, C_{in} = 2\text{fF} \implies F = 256$:**
  $$N = \ln(256) \approx 5.55 \implies \text{chọn số nguyên } N = 6 \text{ tầng}$$
  Hệ số phóng đại thực tế mỗi tầng:
  $$f = 256^{1/6} \approx 2.52$$
  Tổng thời gian trễ chuẩn hóa:
  $$D = N \cdot f = 6 \times 2.52 \approx 15.1\,\tau_0$$

#### Trường hợp 2: Thực tế có điện dung tự tải khuếch tán ($\gamma \approx 1$)
- Giả định thực tế: Mỗi tầng đều gánh thêm điện dung khuếch tán ký sinh của chính nó với hệ số $\gamma \approx 1$.
- Thời gian trễ chuẩn hóa toàn chuỗi trở thành:
  $$D = N \cdot (f + \gamma) = N \cdot (f + 1)$$
- Phương trình vi phân tối ưu trở thành: $f + 1 - f \ln f = 0 \implies f \approx 3.59$.
- Trong công nghiệp, các kỹ sư thiết kế thư viện chuẩn luôn ưu tiên chọn **$f = 4$**:
  - Số tầng cần thiết:
    $$N = \log_4(256) = 4 \text{ tầng}$$
  - Tổng thời gian trễ chuẩn hóa:
    $$D = 4 \times (4 + 1) = 20\,\tau_0$$
- **Đánh đổi quan trọng về diện tích và công suất:**
  - Chuỗi 4 tầng ($N = 4, f = 4$): Kích thước tương đối của các tầng là $1, 4, 16, 64 \implies$ Tổng bề rộng transistor:
    $$W_{total} = 1 + 4 + 16 + 64 = 85 \text{ đơn vị}$$
  - Chuỗi 6 tầng ($N = 6, f = 2.52$): Kích thước tương đối là $1, 2.5, 6.3, 16, 40, 102 \implies$ Tổng bề rộng transistor:
    $$W_{total} \approx 168 \text{ đơn vị}$$
  - **Kết luận kỹ nghệ:** Chọn $f = 4$ giúp **tiết kiệm gần 50% diện tích silicon** và giảm 50% năng lượng nạp xả tụ động ($E = C_{total} V_{DD}^2$), trong khi thời gian trễ chỉ tăng rất ít so với mức cực tiểu toán học.

### 4.3 Hiện tượng quá độ Miller (Miller Undershoot)
Giữa cực Cổng và cực Máng của transistor luôn tồn tại tụ điện ký sinh chồng lấn $C_{gd}$. Tụ điện này bắc cầu trực tiếp giữa ngõ vào và ngõ ra.
- Khi ngõ vào chuyển mức dốc đứng từ $1 \to 0$ ($dV_{in}/dt < 0$), dòng điện dịch $I = C_{gd} \frac{d(V_{in} - V_{out})}{dt}$ chạy qua tụ.
- Dòng điện dịch này kéo giật điện áp ngõ ra tụt xuống dưới mức đất (Undershoot tới $-0.1\text{V} \to -0.2\text{V}$) trong vài pico-giây đầu tiên trước khi pMOS kịp dẫn dòng để kéo ngõ ra lên.
- **Rủi ro vật lý:** Nốt ngõ ra được nối với vùng khuếch tán $n^+$ của nMOS nằm trên chất nền p-substrate (đang nối đất $0\text{V}$). Nếu ngõ ra bị kéo âm quá $-0.6\text{V}$, tiếp giáp P-N giữa p-substrate và vùng $n^+$ sẽ bị phân cực thuận, phun electron vào chất nền và có thể kích hoạt hiện tượng Latch-up.

---

## 5. Cơ chế Latch-up & Biện pháp phòng tránh

### 5.1 Cặp transistor lưỡng cực BJT ký sinh & Vòng lặp hồi tiếp SCR
Trong cấu trúc CMOS đồng khối (Bulk CMOS), sự sắp đặt xen kẽ giữa các lớp bán dẫn p-substrate, N-well, vùng khuếch tán $p^+$ và $n^+$ vô tình tạo thành hai transistor lưỡng cực ký sinh:
- Transistor $Q_1$ (pnp ký sinh): Cực phát (Emitter) là $p^+$ source của pMOS nối $V_{DD}$, cực gốc (Base) là N-well, cực thu (Collector) là p-substrate.
- Transistor $Q_2$ (npn ký sinh): Cực phát (Emitter) là $n^+$ source của nMOS nối GND, cực gốc (Base) là p-substrate, cực thu (Collector) là N-well.

Hai transistor này mắc ghép chéo: cực thu của $Q_1$ bơm vào cực gốc của $Q_2$, và cực thu của $Q_2$ kéo dòng từ cực gốc của $Q_1$, tạo thành một cấu trúc chỉnh lưu điều khiển silicon (SCR):
- Khi có xung đột biến điện áp ở ngõ I/O làm sụt áp trên điện trở đế $I \cdot R_{sub} \ge 0.7\text{V}$ hoặc trên điện trở giếng $I \cdot R_{well} \ge 0.7\text{V}$, một BJT sẽ bật mở.
- BJT này kích mở tiếp BJT kia, thiết lập vòng hồi tiếp dương tự duy trì khi:
  $$A_{loop} = \beta_1 \cdot \beta_2 \ge 1$$
- Mạch bị khóa cứng vào một đường dẫn trở kháng cực thấp từ $V_{DD}$ thẳng xuống GND. Dòng điện vọt lên hàng trăm milliampere, gây sụt nguồn và làm hỏng chip do quá nhiệt.

### 5.2 Vì sao tín hiệu Reset mềm không thể dập tắt Latch-up?
Khi SCR đã dẫn thông, dòng điện chạy trực tiếp xuyên qua khối bán dẫn thể tích (bulk substrate và N-well). Đường dòng này hoàn toàn nằm ngoài sự kiểm soát của điện trường cực cổng Poly-Si. 
- Do đó, việc đổi mức logic ngõ vào hay gửi lệnh Reset logic hoàn toàn vô tác dụng.
- Cách duy nhất để dập tắt Latch-up là **cắt nguồn điện cung cấp ($V_{DD}$ Power Cycle)** hoặc hạ điện áp nguồn xuống dưới điện áp duy trì (Holding Voltage $V_H \approx 1.0\text{V}$).

### 5.3 Biện pháp phòng ngừa trong thiết kế layout
Để triệt tiêu hoàn toàn điều kiện $\beta_1 \cdot \beta_2 \ge 1$, kỹ sư layout áp dụng hai nguyên tắc bắt buộc:
1. **Cắm tiếp xúc đế và giếng liên tục (Substrate & Well Taps):** Đặt các lỗ tiếp xúc $P^+$ nối GND và $N^+$ nối $V_{DD}$ định kỳ với khoảng cách ngắn ($< 20 - 30\,\mu\text{m}$) để giảm triệt để giá trị điện trở $R_{sub}$ và $R_{well}$, khiến tích số $I \cdot R$ không bao giờ chạm tới $0.7\text{V}$.
2. **Vòng bảo vệ (Guard Rings):** Đặt các đai khuếch tán nồng độ cao bao quanh transistor (đai $P^+$ nối đất quanh nMOS, đai $N^+$ nối nguồn quanh pMOS). Các đai này đóng vai trò hố thu gom (sink) hút sạch các hạt dẫn thiểu số khuếch tán đi lạc trước khi chúng tới được cực gốc của BJT ký sinh, kéo tụt hệ số truyền hạt dẫn $\beta_1 \cdot \beta_2 \ll 1$.

---

## 6. Sự sụp đổ của Shockley → Hiệu ứng kênh ngắn (SCE) → Mô hình BSIM

### 6.1 Bốn hiệu ứng kênh ngắn (Short-Channel Effects) cốt lõi
Khi chiều dài kênh dẫn thu nhỏ xuống dưới $0.25\,\mu\text{m}$, mô hình Shockley bậc hai ($I_{dsat} \propto (V_{gs} - V_t)^2$) sụp đổ vì bỏ qua 4 hiệu ứng vật lý sau:

#### 1. Bão hòa vận tốc (Velocity Saturation)
- **Bản chất:** Dưới điện trường dọc lớn ($E_x = V_{ds}/L > 1.5 \times 10^4\text{V/cm}$), các electron va chạm liên tục với các dao động mạng tinh thể silicon (tán xạ phonon quang học), khiến vận tốc trôi không thể tăng mãi mà chạm trần giới hạn tối đa: $v_{sat} \approx 10^7\text{cm/s}$.
- **Phương trình tối thiểu:**
  $$I_{dsat} \approx W C_{ox} v_{sat} (V_{gs} - V_t)$$
- **Hệ quả lên cổng đảo:** Dòng bão hòa chuyển từ quan hệ bậc 2 sang quan hệ **bậc 1 tuyến tính**. Khả năng cấp dòng của nMOS bị suy giảm nghiêm trọng so với dự đoán lý thuyết.

#### 2. Hạ thấp rào thế do cực máng (DIBL - Drain-Induced Barrier Lowering)
- **Bản chất:** Khi kênh dẫn rất ngắn, vùng suy giảm quanh cực Máng tiến sát cực Nguồn. Điện thế dương lớn tại cực Máng thâm nhập vào lòng kênh và kéo tụt đỉnh rào cản thế năng tĩnh điện ở đầu nguồn.
- **Phương trình tối thiểu:**
  $$\Delta V_t = \text{ETA0} \cdot V_{ds}$$
- **Hệ quả lên cổng đảo:** Điện áp ngưỡng $V_t$ bị sụt giảm khi điện áp $V_{ds}$ tăng cao. Điều này làm tăng độ dẫn ngõ ra (trở kháng ngõ ra hữu hạn, đường đặc tuyến $I_{ds}-V_{ds}$ không còn nằm ngang mà dốc lên) và làm bùng nổ dòng rò rỉ khi chip ở điện áp nguồn cao.

#### 3. Dòng rò rỉ dưới ngưỡng (Subthreshold Leakage)
- **Bản chất:** Khi $V_{gs} < V_t$, kênh dẫn chưa mở hoàn toàn nhưng các hạt electron có năng lượng kích thích nhiệt vẫn khuếch tán vượt qua rào cản thế năng từ nguồn sang máng.
- **Phương trình tối thiểu:**
  $$I_{sub} \propto 10^{-\frac{V_t - V_{gs}}{S}}, \quad \text{với } S = n \left(\frac{k_B T}{q}\right) \ln(10) \approx 70 - 100\,\text{mV/decade}$$
- **Hệ quả lên cổng đảo:** Cổng logic tiêu tốn công suất tĩnh đáng kể ngay cả khi không hoạt động; các nốt thả nổi trong logic động bị mất điện tích nhanh chóng.

#### 4. Dòng rò xuyên hầm qua oxit cực cổng (Gate Tunneling)
- **Bản chất:** Khi lớp điện môi oxit cổng bị thu mỏng xuống dưới $1.5\,\text{nm}$ (chỉ tương đương vài lớp nguyên tử), hàm sóng lượng tử của electron có xác suất xuyên thủng hàng rào oxit.
- **Phương trình tối thiểu:**
  $$I_{gate} \propto \exp(-\alpha \cdot t_{ox} \sqrt{\Phi_B})$$
- **Hệ quả lên cổng đảo:** Cực cổng không còn là vật cách điện tuyệt đối; xuất hiện dòng rò trực tiếp từ cực cổng vào kênh dẫn hoặc chất nền, làm tăng công suất tĩnh tổng thể của chip.

### 6.2 Bảy tham số BSIM cốt lõi dùng trong mô phỏng SPICE
Mô hình BSIM (Berkeley Short-channel IGFET Model) giải quyết bài toán mô phỏng chính xác các hiệu ứng phi tuyến trên:
1. `TOXE`: Độ dày vật lý thực tế của lớp oxit cực cổng $\implies$ Quyết định điện dung đơn vị $C_{ox}$ và độ lớn dòng rò xuyên hầm $I_{gate}$.
2. `VTH0`: Điện áp ngưỡng danh định tại kênh dài khi $V_{ds} \approx 0\text{V} \implies$ Điểm mốc chuẩn để tính toán điện áp ngưỡng thực tế.
3. `VSAT`: Vận tốc bão hòa trôi cực đại của hạt mang điện $\implies$ Quyết định dòng bão hòa $I_{dsat}$ trong công thức bậc 1 tuyến tính.
4. `ETA0`: Hệ số điều khiển hiệu ứng DIBL $\implies$ Quyết định mức độ sụt giảm của $V_t$ theo điện áp cực máng $V_{ds}$.
5. `DROUT`: Hệ số chiều dài kênh điều khiển trở kháng ngõ ra $\implies$ Quyết định độ dốc của dòng điện trong vùng bão hòa.
6. `CJ`: Điện dung tiếp giáp khuếch tán đáy trên một đơn vị diện tích ($\text{F/m}^2$) $\implies$ Quyết định thành phần điện dung đáy của các tụ ký sinh $C_{db}$ và $C_{sb}$.
7. `CJSW`: Điện dung tiếp giáp khuếch tán thành bên trên một đơn vị chu vi ($\text{F/m}$) $\implies$ Quyết định thành phần điện dung viền của các tụ ký sinh $C_{db}$ và $C_{sb}$.

---

## 7. Định cỡ Transistor trong Kỷ nguyên Nanomet

### 7.1 Tư duy thời Shockley: Cân bằng thời gian tăng/giảm với $W_p / W_n \approx 2.5:1$
Trong lý thuyết kênh dài Shockley, dòng bão hòa tỷ lệ thuận với độ linh động hạt dẫn: $I_{dsat} \propto \mu W$.
- Do độ linh động electron cao gấp khoảng 2.5 lần lỗ trống ($\mu_n / \mu_p \approx 2.5$), điện trở dẫn của nMOS nhỏ hơn pMOS cùng kích thước 2.5 lần: $R_n \approx R_p / 2.5$.
- Để cân bằng thời gian trễ sườn lên và sườn xuống ($t_{pdr} = t_{pdf}$), các kỹ sư truyền thống bắt buộc phải phình to kích thước pMOS:
  $$\frac{W_p}{W_n} \approx 2.5:1$$

### 7.2 Thực tế nanomet: Bão hòa vận tốc dìm nMOS xuống $1.5 - 1.8:1$
Khi bước vào tiến trình $65\text{nm}, 28\text{nm}$ và FinFET:
1. **nMOS bị bão hòa vận tốc sớm hơn pMOS:**  
   Vì electron có độ linh động $\mu_n$ cao, điện trường tới hạn $E_c = 2 v_{sat} / \mu_n$ của nó rất nhỏ ($E_{c,n} \approx 1.5 \times 10^4\text{V/cm}$). Ngay ở điện áp $V_{ds} = 0.2\text{V}$, nMOS đã bị bão hòa vận tốc hoàn toàn, dòng dẫn bị dìm xuống mức tăng bậc 1.  
   Ngược lại, lỗ trống có độ linh động $\mu_p$ nhỏ nên $E_c$ lớn hơn gấp đôi. Trong phần lớn dải làm việc, pMOS ít bị bão hòa vận tốc hơn nMOS.
2. **Thu hẹp tỷ số dòng thực tế:**  
   Tỷ số khả năng cấp dòng thực tế trên một đơn vị bề rộng trong mô hình BSIM đo được chỉ còn:
   $$\frac{I_{on,n} / W_n}{I_{on,p} / W_p} \approx 1.5 - 1.8$$

### 7.3 Tối ưu hóa trễ trung bình: Tránh bẫy tự tải điện dung ký sinh
Nếu kỹ sư vẫn cố tình làm pMOS to gấp 2.5 hoặc 3.0 lần nMOS:
- Bề rộng pMOS khổng lồ sẽ làm phình to điện dung cực cổng ngõ vào $C_g$ và điện dung tiếp giáp khuếch tán $C_{db}$.
- Tải dung ký sinh nội tại này tự biến thành tải nặng ngáng chân tốc độ của chính cổng đảo và tầng logic phía trước.

**Kết luận định cỡ nanomet:**
Để đạt được **thời gian trễ trung bình nhỏ nhất ($t_{pd,avg} = \frac{t_{pdr} + t_{pdf}}{2} = \min$)**, tỷ số bề rộng tối ưu trong các tiến trình nanomet hiện đại chỉ là:
$$\frac{W_p}{W_n} \approx 1.5:1 \quad \text{đến} \quad 1.8:1$$
Tỷ số này vừa đem lại tốc độ tổng thể nhanh nhất cho toàn chip, vừa tiết kiệm hơn 30% diện tích silicon và cắt giảm công suất chuyển mạch động!

---

## 8. Bảng tra cứu tổng hợp các họ Inverter & BSIM

| Họ Cổng Đảo | Mạng PUN / PDN | Mức logic $V_{OH} / V_{OL}$ | Công suất tĩnh $P_{static}$ | Số linh kiện ($N$ ngõ vào) | Ưu điểm cốt lõi | Nhược điểm lớn nhất | Ứng dụng tiêu biểu |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Resistive-Load** | Điện trở $R_L$ / nMOS | $V_{OH}=V_{DD}$<br>$V_{OL} > 0\text{V}$ | Rất lớn khi $V_{out}=0$ | $N$ Tr + 1 điện trở | Cực kỳ đơn giản | $R_L$ chiếm diện tích lớn, hao điện tĩnh | Vi mạch lịch sử (thập niên 1960) |
| **Depletion nMOS** | nMOS ($V_t < 0$) / nMOS | $V_{OH}=V_{DD}$<br>$V_{OL} > 0\text{V}$ | Rất lớn khi $V_{out}=0$ | $N + 1$ nMOS | Sườn lên nhanh hơn tải trở | Cần thêm bước cấy mặt nạ $V_t < 0$ | Vi xử lý Intel 8085, Z80 |
| **Static CMOS** | pMOS / nMOS bổ sung | **Full Rail-to-Rail**<br>$V_{OH}=V_{DD}, V_{OL}=0\text{V}$ | **Lý tưởng = 0**<br>(chỉ có dòng rò) | $2N$ ($N$ pMOS + $N$ nMOS) | Dải động cực đại, không hao điện tĩnh | NOR nhiều ngõ vào bị chậm sườn lên | **Chuẩn mực cho >99% mạch số** |
| **Pseudo-nMOS** | 1 pMOS nối đất / nMOS | $V_{OH}=V_{DD}$<br>$V_{OL} > 0\text{V}$ (cần $\beta_n/\beta_p \ge 4$) | Rất lớn khi $V_{out}=0$ | $N + 1$ ($1$ pMOS + $N$ nMOS) | Rất gọn cho cổng nhiều ngõ vào | Tiêu tốn công suất tĩnh liên tục | Bộ giải mã địa chỉ ROM, PLA |
| **$C^2\text{MOS}$ / Tri-state** | Cặp pMOS / Cặp nMOS nối tiếp | $V_{OH}=V_{DD}, V_{OL}=0\text{V}$<br>Trạng thái Hi-Z | Lý tưởng = 0 | $2N + 2$ | Ghép bus không xung đột, chống race | Trở kháng dẫn tăng gấp đôi | Bus ghép kênh, chốt D-Latch |
| **Dynamic CMOS** | 1 pMOS Precharge / nMOS Evaluate | $V_{OH}=V_{DD}, V_{OL}=0\text{V}$<br>(2 pha xung nhịp) | Không có tĩnh thuần, nhạy cảm rò | $N + 2$ | Tải ngõ vào nhẹ, tốc độ cực nhanh | Nhạy cảm mất điện tích nốt thả nổi | Khối số học ALU, Register File |
| **Nanoscale BSIM CMOS** | FinFET pMOS / FinFET nMOS đa cổng | Full Rail-to-Rail<br>($V_{DD} \approx 0.7 - 0.9\text{V}$) | Đáng kể do dòng rò ($I_{sub} + I_{gate}$) | Tối ưu hóa 3D fin | Triệt tiêu hiệu ứng kênh ngắn | Nhạy cảm biến thiên quy trình PVT | CPU/GPU hiện đại (Apple, AMD, Intel) |

---

## 9. Năm câu hỏi tự kiểm tra (kèm lời giải chi tiết đã chuẩn hóa số liệu)

### Câu 1: Cơ chế Latch-up và kỹ thuật Guard Ring
**Đề bài:**  
Một vi điều khiển chế tạo trên chất nền p-substrate/N-well bị một xung âm $-0.8\text{V}$ tác động vào chân I/O trong $2\text{ns}$. Ngay sau đó, dòng tiêu thụ của chip tăng vọt từ $15\text{mA}$ lên $800\text{mA}$ và chip nóng rực:
1. Giải thích vòng lặp hồi tiếp dương giữa cặp BJT ký sinh $Q_1$ (pnp) và $Q_2$ (npn) và điều kiện duy trì trạng thái Latch-up?
2. Vì sao sau khi xung âm biến mất, việc gửi tín hiệu Reset mềm không thể đưa vi điều khiển trở lại bình thường mà bắt buộc phải ngắt hoàn toàn nguồn điện?
3. Phân tích nguyên lý bảo vệ của các vòng Guard Rings trong việc triệt tiêu hiện tượng này?

**Lời giải chi tiết:**
1. *Vòng hồi tiếp dương:* Transistor $Q_1$ (pnp ký sinh) và $Q_2$ (npn ký sinh) mắc ghép chéo: cực thu của $Q_1$ nối vào cực gốc của $Q_2$, cực thu của $Q_2$ nối vào cực gốc của $Q_1$. Khi xung âm $-0.8\text{V}$ làm sụt áp trên điện trở đế $I \cdot R_{sub} \ge 0.7\text{V}$, transistor $Q_2$ bật mở kéo dòng qua $R_{well}$ làm sụt áp mở tiếp $Q_1$. Transistor $Q_1$ lại bơm thêm dòng kích cho cực gốc của $Q_2$. Điều kiện tự khóa SCR là:
   $$A_{loop} = \beta_1 \cdot \beta_2 \ge 1$$
2. *Lý do Reset mềm không hoạt động:* Dòng ngắn mạch của SCR chạy trực tiếp qua khối bán dẫn thể tích (bulk substrate và N-well) giữa $V_{DD}$ và GND, hoàn toàn không đi qua kênh dẫn được kiểm soát bởi cực cổng Poly-Si. Tín hiệu Reset mềm chỉ điều khiển cực cổng nên không thể ngắt được dòng điện chạy trong chất nền. Bắt buộc phải ngắt nguồn ($V_{DD}$ Power Cycle) để dòng điện qua SCR tụt xuống dưới mức duy trì ($I < I_H$).
3. *Vai trò của Guard Rings:* Các đai khuếch tán $P^+$ nối GND và $N^+$ nối $V_{DD}$ giúp giảm điện trở phân tán $R_{sub}$ và $R_{well}$ về gần $0\,\Omega$, ngăn chặn tiếp giáp phát-gốc bị phân cực thuận. Đồng thời, các đai này đóng vai trò hố thu gom (sink) hút sạch các hạt dẫn thiểu số đi lạc, làm suy giảm hệ số khuếch đại khiến $\beta_1 \cdot \beta_2 \ll 1$.

---

### Câu 2: Dịch chuyển ngưỡng logic $V_M$ & Biến thiên tiến trình PVT góc FS
*(Ghi chú: Lời giải sử dụng một định nghĩa chuẩn duy nhất xuyên suốt $r = \sqrt{\beta_p / \beta_n}$ đã được chuẩn hóa so với bản gốc).*

**Đề bài:**  
Một cổng đảo CMOS danh định có $V_{DD} = 1.0\text{V}$, $V_{tn} = 0.3\text{V}$, $|V_{tp}| = 0.3\text{V}$ và $\beta_n = \beta_p$:
1. Dẫn xuất công thức tính $V_M$ và chứng minh $V_M = V_{DD}/2$.
2. Giả sử do sai lệch tiến trình chế tạo, chip rơi vào góc lệch **FS (Fast nMOS, Slow pMOS)** với: $\beta_n' = 1.44 \beta_n$, $V_{tn}' = 0.22\text{V}$, $\beta_p' = 0.64 \beta_p$, $|V_{tp}'| = 0.38\text{V}$. Tính giá trị chính xác của $V_M'$?
3. Đặc tuyến VTC bị lệch về phía nào và mạch trở nên nhạy cảm với loại nhiễu nào nhất?

**Lời giải chi tiết:**
1. *Dẫn xuất $V_M$:* Cân bằng dòng bão hòa Shockley: $\frac{1}{2} \beta_n (V_M - V_{tn})^2 = \frac{1}{2} \beta_p (V_{DD} - V_M - |V_{tp}|)^2$.  
   Đặt $r = \sqrt{\beta_p / \beta_n}$, ta có:
   $$V_M = \frac{V_{tn} + r(V_{DD} - |V_{tp}|)}{1 + r}$$
   Khi đối xứng chuẩn ($r = 1$, $V_{tn} = |V_{tp}| = 0.3\text{V}$):
   $$V_M = \frac{0.3 + 1 \cdot (1.0 - 0.3)}{1 + 1} = 0.5\text{V} = \frac{V_{DD}}{2}$$
2. *Tính toán góc FS:*
   $$r' = \sqrt{\frac{\beta_p'}{\beta_n'}} = \sqrt{\frac{0.64 \beta_p}{1.44 \beta_n}} = \frac{0.8}{1.2} = \frac{2}{3} \approx 0.667$$
   $$V_M' = \frac{V_{tn}' + r'(V_{DD} - |V_{tp}'|)}{1 + r'} = \frac{0.22 + 0.667 \times (1.0 - 0.38)}{1 + 0.667} = \frac{0.22 + 0.4133}{1.667} \approx 0.38\text{V}$$
3. *Kết luận:* Ngưỡng logic $V_M'$ giảm từ $0.50\text{V}$ xuống $0.38\text{V}$, đặc tuyến VTC bị **trượt lệch sang TRÁI**. Lề nhiễu mức thấp $NM_L \approx V_{IL}$ bị bóp nghẹt nghiêm trọng. Mạch trở nên cực kỳ nhạy cảm và dễ nhảy sai trạng thái logic khi có **Nhiễu nảy đất (Ground Bounce)** trên đường dây GND.

---

### Câu 3: Định cỡ nanomet: Bão hòa vận tốc vs Tự tải điện dung
**Đề bài:**  
1. Vì sao lý thuyết Shockley truyền thống khuyên định cỡ $W_p / W_n \approx 2.5:1$ để cân bằng thời gian trễ sườn lên và sườn xuống ($t_{pdr} = t_{pdf}$)?
2. Trong tiến trình $65\text{nm}$ BSIM, vì sao hiện tượng bão hòa vận tốc làm tỷ số khả năng cấp dòng thực tế $I_{on,n} / I_{on,p}$ co hẹp chỉ còn $1.5 - 1.8$?
3. Vì sao trong thực tế nanomet, việc chọn $W_p / W_n \approx 1.5 - 1.8:1$ lại cho thời gian trễ trung bình nhỏ hơn việc chọn $2.5:1$?

**Lời giải chi tiết:**
1. *Lý thuyết Shockley:* Khả năng dẫn dòng tỷ lệ thuận với độ linh động hạt dẫn ($I_{dsat} \propto \mu W$). Để cân bằng điện trở dẫn $R_{on,p} = R_{on,n}$, ta bắt buộc phải có $\mu_p W_p = \mu_n W_n \implies W_p / W_n = \mu_n / \mu_p \approx 2.5:1$.
2. *Bão hòa vận tốc nanomet:* Electron có độ linh động cao nên đạt tới điện trường tới hạn $E_c$ rất sớm, khiến nMOS bị bão hòa vận tốc hoàn toàn và dòng điện bị dìm xuống mức quan hệ tuyến tính bậc 1. Trong khi đó, lỗ trống có độ linh động thấp hơn nên ít bị bão hòa vận tốc hơn. Do đó, tỷ số dòng thực tế đo được co hẹp từ $2.5$ xuống chỉ còn $1.5 - 1.8$.
3. *Hiệu ứng tự tải điện dung:* Nếu cố tình làm $W_p = 2.5 W_n$, kích thước lớn của pMOS làm phình to điện dung cực cổng ngõ vào $C_g$ và điện dung tiếp giáp khuếch tán $C_{db}$. Điện dung ký sinh nội tại này tự biến thành tải nặng ngáng chân tốc độ của chính cổng đảo và kéo chậm tầng phía trước. Định cỡ $W_p / W_n \approx 1.5 - 1.8:1$ vừa tận dụng tối đa dòng dẫn thực tế, vừa tránh bẫy tự tải, đem lại thời gian trễ trung bình ($t_{pd,avg}$) nhỏ nhất.

---

### Câu 4: Đánh giá DIBL và bùng nổ dòng rò dưới ngưỡng
*(Ghi chú: Đã sửa và chuẩn hóa chính xác các bước tính số học so với bản gốc).*

**Đề bài:**  
Một transistor nMOS trong tiến trình $28\text{nm}$ hoạt động ở $V_{DD} = 0.9\text{V}$. Ở nhiệt độ phòng ($T = 300\text{K}$), transistor có hệ số dốc dưới ngưỡng $S = 80\text{mV/decade}$ và tham số DIBL trong file BSIM là $\text{ETA0} = 0.075$:
1. Khi điện áp cực Máng tăng từ chế độ đo tuyến tính ($V_{ds} = 0.05\text{V}$) lên mức nguồn đầy đủ ($V_{ds} = 0.9\text{V}$), điện áp ngưỡng $V_t$ bị sụt giảm bao nhiêu millivolt?
2. Dòng rò rỉ dưới ngưỡng $I_{sub}$ sẽ tăng lên bao nhiêu lần do sự sụt giảm điện áp ngưỡng này?
3. Nếu nhiệt độ chip tăng lên $87^\circ\text{C}$ ($360\text{K}$), hệ số $S$ thay đổi thế nào và dòng rò rỉ bị ảnh hưởng ra sao?

**Lời giải chi tiết:**
1. *Độ sụt giảm điện áp ngưỡng do DIBL:*
   $$\Delta V_t = \text{ETA0} \cdot (V_{ds,high} - V_{ds,low}) = 0.075 \times (0.9\text{V} - 0.05\text{V}) = 0.075 \times 0.85\text{V} = 0.06375\text{V} = 63.75\text{mV}$$
2. *Mức độ tăng vọt của dòng rò rỉ:*  
   Dòng rò dưới ngưỡng phụ thuộc hàm mũ theo công thức: $I_{sub} \propto 10^{-\frac{V_t}{S}}$.  
   Khi $V_t$ giảm một lượng $\Delta V_t = 63.75\text{mV}$:
   $$\frac{I_{sub}'}{I_{sub}} = 10^{\frac{\Delta V_t}{S}} = 10^{\frac{63.75\text{mV}}{80\text{mV}}} = 10^{0.7969} \approx 6.26 \text{ lần!}$$
   Chỉ riêng hiệu ứng DIBL đã làm dòng rò tĩnh tăng vọt gấp hơn 6.2 lần.
3. *Ảnh hưởng của nhiệt độ:*  
   Hệ số dốc dưới ngưỡng tỷ lệ thuận với nhiệt độ tuyệt đối: $S \propto T$.  
   Khi nhiệt độ tăng từ $300\text{K}$ lên $360\text{K}$:
   $$S_{360K} = 80\text{mV/dec} \times \frac{360}{300} = 96\text{mV/decade}$$
   Đồng thời, nhiệt năng $k_B T$ cung cấp năng lượng kích thích nhiệt giúp electron vượt rào thế dễ dàng hơn, khiến dòng rò tĩnh dưới ngưỡng của chip tăng từ 10 đến 30 lần so với ở nhiệt độ phòng.

---

### Câu 5: Thiết kế chuỗi đệm Inverter & Cú nhúng Miller
*(Ghi chú: Lời giải đã tách bạch rõ ràng hai trường hợp $\gamma = 0$ và $\gamma = 1$, không gộp lẫn lộn).*

**Đề bài:**  
Một cổng logic kích thước cơ sở ($C_{in} = 2\text{fF}$) cần lái một đường dây bus có điện dung tải $C_L = 512\text{fF}$ ($F = 256$):
1. Tính số tầng $N$ và tổng thời gian trễ chuẩn hóa $D$ trong trường hợp lý thuyết bỏ qua tự tải ($\gamma = 0$)?
2. Trong thực tế có tự tải ($\gamma = 1$), nếu chọn hệ số phóng đại $f = 4$, hãy tính số tầng $N$, tổng trễ $D$ và so sánh diện tích transistor so với câu 1?
3. Trong quá trình chuyển mạch sườn xuống của ngõ vào ($1 \to 0$), tại sao ngõ ra xuất hiện cú nhúng điện áp âm (Miller undershoot)? Nguy cơ đối với mạch là gì?

**Lời giải chi tiết:**
1. *Trường hợp lý thuyết $\gamma = 0$:*  
   Hệ số phóng đại tối ưu là $f = e \approx 2.718$.  
   Số tầng tối ưu: $N = \ln(256) \approx 5.55 \implies$ Chọn số nguyên $N = 6$ tầng.  
   Hệ số phóng đại thực tế: $f = 256^{1/6} \approx 2.52$.  
   Tổng thời gian trễ chuẩn hóa:
   $$D = N \cdot f = 6 \times 2.52 \approx 15.1\,\tau_0$$
2. *Trường hợp thực tế $\gamma = 1$ với $f = 4$:*  
   Số tầng đệm: $N = \log_4(256) = 4$ tầng.  
   Tổng thời gian trễ chuẩn hóa:
   $$D = N \cdot (f + \gamma) = 4 \times (4 + 1) = 20\,\tau_0$$
   *So sánh diện tích silicon:*
   - Chuỗi 4 tầng ($f = 4$): Tổng bề rộng transistor là $W_{total} = 1 + 4 + 16 + 64 = 85$ đơn vị.
   - Chuỗi 6 tầng ($f = 2.52$): Tổng bề rộng transistor là $W_{total} \approx 1 + 2.5 + 6.3 + 16 + 40 + 102 \approx 168$ đơn vị.
   - Chọn $f = 4$ giúp **tiết kiệm gần 50% diện tích silicon** và giảm 50% công suất nạp xả tụ động, dù độ trễ tăng nhẹ từ $15.1\,\tau_0$ lên $20\,\tau_0$.
3. *Cú nhúng âm Miller (Miller Undershoot):*  
   Do có tụ ký sinh chồng lấn cực Cổng - cực Máng $C_{gd}$, khi điện áp ngõ vào giảm dốc đứng ($1 \to 0$), dòng điện dịch $I = C_{gd} \frac{d(V_{in} - V_{out})}{dt}$ kéo giật nốt ngõ ra tụt xuống mức âm (tới $-0.15\text{V}$) trước khi pMOS kịp mở.  
   *Nguy cơ:* Nếu nốt ngõ ra tụt sâu quá $-0.6\text{V}$, tiếp giáp P-N giữa chất nền p-substrate và vùng khuếch tán $n^+$ ngõ ra sẽ bị phân cực thuận, bơm electron vào chất nền và có thể kích hoạt hiện tượng Latch-up.
