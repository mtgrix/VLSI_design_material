# Chương 3: Lý thuyết Transistor CMOS (CMOS Transistor Theory)
> **Phiên bản: Kể chuyện Cơ chế Vật lý Vi mô & Dẫn dắt Động học**  
> **Đối tượng:** Sinh viên Thiết kế Vi mạch ĐH Công nghệ Thông tin (UIT)  
> **Thời gian học tập tối ưu:** 4 Giờ Trọng tâm  
> **Tài liệu đối chiếu:** `source/source_uit_vn/chapter3-transistors.pdf` (Slides 1 – 20) & Giáo trình CMOS VLSI Design (Weste & Harris)  
> **Nguyên lý cốt lõi:** Bỏ qua các định nghĩa trừu tượng; mọi hiện tượng đều được giải thích từ sự chuyển động của các hạt electron, lỗ trống và lực tĩnh điện trong mạng tinh thể silicon.

---

## Lộ trình Học tập 4 Giờ Cốt lõi (4-Hour Study Roadmap)

```
[Giờ 1: 0:00 - 1:00] ──> Bản chất Tụ MOS & 3 Chế độ Hoạt động (Vật lý tụ MOS & Kênh 2D)
[Giờ 2: 1:00 - 2:00] ──> Cuộc chiến 2 Điện trường & Dẫn xuất Toán học Dòng điện I-V
[Giờ 3: 2:00 - 3:00] ──> Cuộc chiến Độ linh động (Electron vs Lỗ trống) & Tỷ lệ Wp = 2Wn
[Giờ 4: 3:00 - 4:00] ──> Giải phẫu Quá trình Xả tụ & Giới hạn Tốc độ Vi mạch
```

---

## Giờ 1: Bản chất Tụ MOS & Ba Chế độ Hoạt động
*(Tương ứng Slide 1 – 5 | Thời gian mục tiêu: 60 phút)*

### 1.1 Vượt qua tư duy công tắc lý tưởng (Beyond the Ideal Switch)
Trong môn học Logic số cơ bản, chúng ta thường coi transistor như một chiếc công tắc hoàn hảo: khi Cổng bật ($Gate = 1$), công tắc đóng hoàn toàn với điện trở bằng 0 ($R = 0$); khi Cổng tắt ($Gate = 0$), công tắc ngắt tuyệt đối ($I = 0$).

Tuy nhiên, trên phiến silicon thực tế, transistor bản chất là **một chiếc van điều tiết dòng hạt mang điện kết hợp với một hệ thống bể chứa điện tích**:

1. **Transistor luôn có nội trở khi dẫn (ON-resistance):**  
   Khi transistor mở, kênh dẫn không phải là một đường ống rỗng trơn tru. Hạt electron muốn di chuyển từ Source sang Drain phải len lỏi qua mạng tinh thể silicon dày đặc. Trên đường đi, chúng va chạm liên tục với các dao động nhiệt của nguyên tử silicon *(phonon scattering)* và các ion tạp chất *(impurity scattering)*. Sự cản trở tập thể này sinh ra **Điện trở kênh dẫn hữu hạn $R_{on}$**, khiến dòng điện dẫn qua transistor luôn có giới hạn chứ không thể tăng vô hạn.

2. **Điện dung ký sinh (Parasitic Capacitance) — Những chiếc "bình ắc quy ngoài ý muốn":**  
   Bất cứ khi nào hai khối dẫn điện đặt cạnh nhau và ngăn cách bởi một chất cách điện, một tụ điện sẽ tự động hình thành. Trong MOSFET, cực Cổng (Gate) đặt sát đế qua lớp oxide, cực Máng (Drain) và cực Nguồn (Source) tiếp giáp với chất nền qua các lớp tiếp giáp P-N. Vô tình, chúng ta có hàng loạt tụ điện ký sinh vây quanh transistor. Mỗi khi muốn chuyển mức logic từ $0 \to 1$ hoặc $1 \to 0$, mạch điện bắt buộc phải **bơm đầy hoặc rút cạn điện tích** trong những chiếc tụ này.

3. **Độ trễ chuyển mạch (Switching Delay):**  
   Thời gian để chip chuyển trạng thái logic thực chất là thời gian xả/nạp điện tích:
   $$\Delta t = \frac{C \cdot \Delta V}{I}$$

> **Ý nghĩa thực tế cho Kỹ sư Vi mạch (Engineering Takeaway):**  
> Muốn chip hoạt động ở tần số cao $3\text{ GHz} - 5\text{ GHz}$ (tức thời gian trễ $\Delta t$ chỉ được phép dưới vài chục picosecond), kỹ sư chỉ có 3 con đường thiết kế:
> 1. **Giảm điện dung $C$:** Thu nhỏ kích thước transistor và rút ngắn độ dài dây kim loại liên kết.
> 2. **Giảm biên độ điện áp $\Delta V$:** Hạ nguồn cấp $V_{dd}$ từ $5\text{V} \to 1.8\text{V} \to 0.8\text{V}$.
> 3. **Tăng dòng điện dẫn $I$:** Tối ưu cấu trúc transistor để dòng xả qua kênh mạnh nhất có thể.

---

### 1.2 Cấu trúc Giải phẫu của Tụ điện MOS (Structure of the MOS Capacitor)
Phần lõi điều khiển dòng của MOSFET là một cấu trúc tụ điện 3 lớp dạng bánh kẹp (sandwich):
1. **Gate (Cực Cổng - Điện cực trên):** Polysilicon được pha tạp nồng độ rất cao *(heavily doped)* để dẫn điện tốt tương đương kim loại.
2. **Dielectric (Lớp điện môi cách điện ở giữa):** Silicon Dioxide ($SiO_2$). Lớp này là chất cách điện tuyệt vời, ngăn không cho dòng điện một chiều chạy thẳng từ Gate xuống đế. Lớp này có độ dày $t_{ox}$ và độ điện môi $\epsilon_{ox} = 3.9 \epsilon_0$ (với $\epsilon_0 = 8.85 \times 10^{-14}\text{ F/cm}$).
3. **Body / Substrate (Đế bán dẫn - Điện cực dưới):** Phiến silicon loại p (p-type), được cấy thêm các nguyên tử nhận tạp chất như Boron ($N_A$) để tạo ra vô số lỗ trống tự do.

**Công thức Điện dung Oxit trên một đơn vị diện tích ($C_{ox}$):**  
Theo nguyên lý tụ điện phẳng $C = \frac{\epsilon A}{d}$, điện dung trên một đơn vị diện tích ($A = 1\text{ cm}^2$) là:
$$C_{ox} = \frac{\epsilon_{ox}}{t_{ox}} = \frac{3.9 \times 8.85 \times 10^{-14}\text{ F/cm}}{t_{ox}}$$

> **Ý nghĩa thực tế:** Khi thu nhỏ tiến trình công nghệ (scaling/shrink process), các kỹ sư luôn cố gắng bào mỏng lớp oxit cổng ($t_{ox}$ giảm) để tăng $C_{ox}$. $C_{ox}$ càng lớn thì điện trường cực cổng càng kiểm soát kênh dẫn bên dưới mạnh mẽ hơn, cho phép điều khiển dòng qua kênh hiệu quả hơn.

---

### 1.3 Biên niên sử Ba chế độ Hoạt động của Tụ MOS
Hãy tưởng tượng bạn đang đứng bên trong khối silicon ngay dưới lớp oxit cổng. Khi ta thay đổi điện áp cực Cổng ($V_g$) so với đế ($V_b = 0\text{V}$), ba màn kịch vật lý sẽ diễn ra tuần tự:

![Hình 3.1: Biên niên sử 3 chế độ hoạt động của tụ MOS](images/fig3_1_mos_capacitor_modes.png)

#### Màn 1: Chế độ Tích lũy (Accumulation) — Khi $V_g < 0\text{ V}$
* **Điện trường:** Cực cổng mang điện thế âm so với đế, thiết lập một **điện trường hướng thẳng đứng từ đế lên cổng** ($\uparrow$).
* **Chuyển động của hạt:** Các hạt lỗ trống ($h^+$, mang điện tích dương) trong đế p cảm nhận lực hút Coulomb kéo ngược lên bề mặt giáp oxit.
* **Trạng thái:** Hàng triệu lỗ trống tụ tập ken đặc sát mặt oxit. Tuy nhiên, transistor hoàn toàn **TẮT** vì không có hạt electron tự do nào để tạo thành kênh nối giữa cực Source và Drain.

#### Màn 2: Chế độ Nghèo (Depletion) — Khi $0 < V_g < V_t$
* **Điện trường:** Ta đặt một điện áp dương nhỏ lên cổng. Điện trường lập tức đảo chiều, **chĩa thẳng đứng xuống đế** ($\downarrow$).
* **Chuyển động của hạt:** Cực cổng mang điện dương sẽ đẩy các hạt lỗ trống ($h^+$) lặn sâu xuống đáy đế silicon.
* **Vết tích mạng tinh thể:** Khi các lỗ trống bị xua đuổi đi hết, chúng để lại phía sau các nguyên tử tạp chất Boron đã nhận electron ($B^-$). Vì các ion Boron này bị khóa chặt trong mạng tinh thể silicon, chúng không thể di chuyển. Một vùng hoàn toàn sạch bóng hạt tải điện tự do được hình thành, gọi là **Vùng Nghèo (Depletion Region)** với độ sâu $W_{dep}$. Vùng này đóng vai trò như một lớp cách điện thứ hai nối tiếp dưới lớp oxit.

#### Màn 3: Chế độ Đảo — Hình thành Kênh dẫn (Inversion) — Khi $V_g > V_t$
* **Điện trường:** Khi $V_g$ vượt qua một mốc then chốt gọi là **Điện áp Ngưỡng ($V_t$ - Threshold Voltage)**, điện trường hướng xuống trở nên cực kỳ mãnh liệt (lên tới $> 10^6\text{ V/cm}$).
* **Chuyển động của hạt:** Lực hút điện trường cực mạnh bẻ cong dải năng lượng của silicon, hút các hạt electron thiểu số ($e^-$) từ sâu trong lòng đế và từ hai đầu Source/Drain tràn lên bề mặt oxit.
* **Phép màu "Đảo ngược":** Lớp silicon sát bề mặt oxit ban đầu là loại p (nhiều lỗ trống), nay lại bị electron chiếm đóng áp đảo. Tính chất bán dẫn của nó bị **đảo ngược hoàn toàn từ p sang n**!
* Lớp electron mỏng chỉ khoảng $1 - 3\text{ nm}$ này chính là **Kênh dẫn (Inversion Channel)** — cây cầu cho phép dòng điện chạy giữa Source và Drain.

> **Bản chất Vật lý của Điện áp Ngưỡng $V_t$:**  
> $V_t$ không phải là một con số ngẫu nhiên do nhà sản xuất quy định. Nó chính là mức điện áp cổng tối thiểu cần thiết để uốn cong dải năng lượng silicon đủ lớn, sao cho mật độ electron tự do kéo lên bề mặt đạt mức bằng đúng mật độ lỗ trống ban đầu của chất nền ($n_{surface} = N_A$). Khi chưa đạt tới $V_t$, kênh dẫn chưa thể thông suốt!

---

## Giờ 2: Cuộc Rượt đuổi của Hai Điện trường & Mô hình Dòng điện $I-V$
*(Tương ứng Slide 6 – 14 | Thời gian mục tiêu: 60 phút)*

### 2.1 Cuộc chiến giữa Điện trường Dọc và Điện trường Ngang
Khi kênh dẫn đã hình thành ($V_{gs} > V_t$), dòng điện qua transistor được điều khiển bởi sự giằng co của hai điện trường vuông góc với nhau:
1. **Điện trường Dọc ($\mathcal{E}_\perp$ - do Cổng điều khiển):** Được quyết định bởi hiệu điện thế giữa Cổng và Kênh. Nó quyết định **độ sâu của kênh dẫn** (tức là có bao nhiêu electron được kéo lên bề mặt).
2. **Điện trường Ngang ($\mathcal{E}_\parallel$ - do Cực Máng Drain điều khiển):** Sinh ra bởi hiệu điện thế $V_{ds}$ giữa Drain và Source ($\mathcal{E}_\parallel = V_{ds} / L$). Nó đóng vai trò như động cơ phản lực **đẩy các electron chạy ngang từ Source sang Drain**.

![Hình 3.2: Cuộc chiến 2 điện trường và cơ chế súng cao su thắt kênh](images/fig3_2_nmos_conduction_modes.png)

Nhìn vào **Hình 3.2**, bạn sẽ thấy một hiện tượng hình học rất thú vị:
* Ở đầu Source ($x=0$), điện thế kênh là $V_s = 0\text{V}$. Hiệu điện thế dọc là $V_{gs}$ rất lớn $\implies$ kênh dẫn rất dày.
* Càng đi về phía Drain ($x=L$), điện thế kênh tăng dần lên $V_{ds}$. Hiệu điện thế dọc giảm xuống chỉ còn $V_{gd} = V_{gs} - V_{ds} \implies$ kênh dẫn bị bóp mỏng lại.
* Kênh dẫn của transistor thực tế có **hình cái nêm (wedge shape)**, dày ở đầu Source và mỏng dần về đầu Drain!

---

### 2.2 Chứng minh Toán học Dòng điện Tuyến tính từ Nguyên lý Gốc
Dòng điện bản chất là lượng điện tích di chuyển qua một mặt cắt trong một đơn vị thời gian:
$$I_{ds} = \frac{Q_{channel}}{t_{transit}}$$

#### Bước 1: Tính Tổng Điện tích Kênh dẫn ($Q_{channel}$)
Vì kênh dẫn có dạng hình nêm mỏng dần về phía Drain, điện thế trung bình dọc theo kênh là:
$$V_{channel, avg} = \frac{V_s + V_d}{2} = \frac{0 + V_{ds}}{2} = \frac{V_{ds}}{2}$$

Hiệu điện thế hiệu dụng thực sự dùng để duy trì lớp electron nghịch đảo là:
$$V_{eff} = (V_{gs} - V_{channel, avg}) - V_t = \left(V_{gs} - \frac{V_{ds}}{2}\right) - V_t$$

Với diện tích cổng $A = W \times L$, tổng điện tích electron trong kênh là:
$$Q_{channel} = C_g \cdot V_{eff} = C_{ox} W L \left[ (V_{gs} - V_t) - \frac{V_{ds}}{2} \right]$$

#### Bước 2: Tính Thời gian Bay của Hạt mang điện ($t_{transit}$)
Điện trường ngang dọc theo chiều dài kênh $L$ là $\mathcal{E}_\parallel = \frac{V_{ds}}{L}$.  
Vận tốc trôi của electron tỷ lệ với điện trường qua độ linh động $\mu_n$ *(mobility)*:
$$v = \mu_n \mathcal{E}_\parallel = \mu_n \frac{V_{ds}}{L}$$

Thời gian để một hạt electron bay hết quãng đường chiều dài kênh $L$ là:
$$t_{transit} = \frac{L}{v} = \frac{L}{\mu_n \frac{V_{ds}}{L}} = \frac{L^2}{\mu_n V_{ds}}$$

#### Bước 3: Hợp nhất để tìm Dòng điện Tuyến tính (Linear Current)
Thay $Q_{channel}$ và $t_{transit}$ vào định nghĩa dòng điện:
$$I_{ds} = \frac{C_{ox} W L \left[ (V_{gs} - V_t) - \frac{V_{ds}}{2} \right]}{\frac{L^2}{\mu_n V_{ds}}} = \mu_n C_{ox} \frac{W}{L} \left[ (V_{gs} - V_t) V_{ds} - \frac{V_{ds}^2}{2} \right]$$

Đặt hệ số khuếch đại transistor $\beta = \mu_n C_{ox} \frac{W}{L}$, ta có phương trình Shockley ở **Vùng Tuyến tính (Linear Region)**:
$$\mathbf{I_{ds} = \beta \left[ (V_{gs} - V_t) V_{ds} - \frac{V_{ds}^2}{2} \right]} \quad (\text{khi } V_{ds} < V_{gs} - V_t)$$

---

### 2.3 Hiện tượng Thắt kênh (Pinch-off) và Cơ chế "Súng cao su"
Điều gì sẽ xảy ra nếu ta tiếp tục vặn tăng điện áp cực Máng $V_{ds}$ lên cao?
* Khi $V_{ds}$ tăng, hiệu điện thế dọc ở đầu Drain $V_{gd} = V_{gs} - V_{ds}$ sẽ giảm dần.
* Khi $V_{ds}$ đạt tới giá trị $V_{dsat} = V_{gs} - V_t$, hiệu thế tại đầu Drain rơi đúng về $V_{gd} = V_t$.
* Tại thời điểm này, điện trường dọc ở đầu Drain không còn đủ sức duy trì lớp đảo nữa. Kênh dẫn tại mép Drain bị bóp nghẹt về 0! Hiện tượng này gọi là **Thắt kênh (Pinch-off)**.

> **Tại sao Thắt kênh mà Dòng điện KHÔNG bị ngắt?**  
> * **Cơ chế Súng cao su (Slingshot):** Các hạt electron xuất phát từ Source vẫn chạy ào ạt trong kênh dẫn nêm và đến điểm thắt kênh với vận tốc cực lớn. Giữa điểm thắt kênh và vùng khuếch tán $n^+$ của Drain xuất hiện một khe hở vùng nghèo hẹp, nhưng có **điện trường ngang cực kỳ khủng khiếp**. 
> * Điện trường này đóng vai trò như một chiếc **súng cao su**, chộp lấy các electron vừa ló đầu ra khỏi điểm thắt và bắn vọt chúng qua khe nghèo vào thẳng cực Drain!
> * Khi ta tăng $V_{ds}$ cao hơn nữa, phần điện áp dư thừa chỉ làm khe nghèo này dãn rộng ra một chút xíu, chứ điện áp đặt lên đoạn kênh dẫn còn lại vẫn bị ghim cứng ở mức $V_{dsat} = V_{gs} - V_t$. Do đó, **dòng điện không thể tăng thêm nữa mà đạt trạng thái bão hòa hoàn toàn**!

Thay $V_{ds} = V_{gs} - V_t$ vào phương trình tuyến tính, ta thu được dòng điện ở **Vùng Bão hòa (Saturation Region)**:
$$\mathbf{I_{ds, sat} = \frac{\beta}{2} (V_{gs} - V_t)^2} \quad (\text{khi } V_{ds} \ge V_{gs} - V_t)$$

---

### 2.4 Quỹ đạo Làm việc Động học trên Đồ thị $I-V$ khi Mạch Xả Điện
Thay vì nhìn vào các đường cong tĩnh vô hồn, hãy nhìn vào **Hình 3.3** để theo dõi **cuộc hành trình thực tế** của một transistor nMOS khi xả điện cho tụ ngõ ra từ $5\text{V} \to 0\text{V}$:

![Hình 3.3: Quỹ đạo điểm làm việc khi tụ xả](images/fig3_3_nmos_iv_curves.png)

> **Đọc Quỹ đạo Chuyển mạch từ Phải qua Trái (Mũi tên đỏ):**  
> 1. **Điểm A ($t = 0$):** Khi ngõ vào vừa bật lên, ngõ ra tụ điện vẫn đang ở mức cao $V_{out} = V_{ds} = 5\text{V}$. Transistor rơi vào vùng **Bão hòa sâu** ($V_{ds} > 4.3\text{V}$). Dòng điện đạt đỉnh tối đa $I_{ds} = 2.24\text{ mA}$, xả điện cho tụ với tốc độ sụt áp nhanh nhất ($dV/dt = -I_{sat}/C$).
> 2. **Điểm B ($t = t_1$):** Điện áp tụ sụt xuống mốc $4.3\text{V}$, chạm đúng đường ranh giới thắt kênh parabol nét đứt ($V_{ds} = V_{gs} - V_t$). Kênh dẫn bắt đầu mở thông trở lại ở mép Drain.
> 3. **Điểm C $\to$ D ($t > t_1$):** Transistor trượt vào vùng **Tuyến tính**. Khi điện áp tụ cạn dần về 0, điện trường ngang yếu đi, dòng xả suy giảm nhanh chóng, làm quá trình xả về cuối bị kéo dài thành một cái đuôi hàm mũ chậm chạp.

---

## Giờ 3: Cuộc chiến Độ linh động & Bài toán AMI 0.6$\mu$m
*(Tương ứng Slide 15 – 17 | Thời gian mục tiêu: 60 phút)*

### 3.1 Vật lý Hạt: Cao tốc Phẳng (Electron) vs Trò chơi Ghế Âm nhạc (Lỗ trống)
Trong công nghệ CMOS, nMOS dẫn điện bằng **electron**, còn pMOS dẫn điện bằng **lỗ trống**. Tại sao hai loại transistor này lại có sức mạnh chênh lệch nhau một trời một vực?

![Hình 3.4: Cơ chế dải năng lượng và tỷ lệ kích thước Wp = 2Wn](images/fig3_4_nmos_vs_pmos.png)

> **Bản chất Vi mô của Sự Chênh lệch Độ linh động:**  
> * **Electron trong nMOS (Đường Cao tốc):** Khi kênh n hình thành, electron tự do chuyển động trong **Dải Dẫn (Conduction Band)**. Dải dẫn có mật độ trạng thái thoáng đãng, electron có khối lượng hiệu dụng nhẹ ($m^*_e \approx 0.26 m_0$) và ít bị va chạm cản trở. Độ linh động rất cao: $\mu_n \approx 350\text{ cm}^2/(\text{V}\cdot\text{s})$.
> * **Lỗ trống trong pMOS (Trò chơi Ghế Âm nhạc):** Lỗ trống không phải là một hạt vật chất thực sự có thể tự do bay lượn! Nó bản chất là một **vị trí khuyết liên kết hóa trị** trong **Dải Hóa trị (Valence Band)**. Để một lỗ trống dịch chuyển sang phải, một electron liên kết gần đó phải bứt ra và nhảy sang lấp vào chiếc ghế trống đó. Quá trình "chuyền tay liên kết" này chịu lực cản mạng tinh thể cực lớn, khiến độ linh động của lỗ trống bị bóp nghẹt: $\mu_p \approx 120\text{ cm}^2/(\text{V}\cdot\text{s})$.
> $$\frac{\mu_n}{\mu_p} \approx 2 \text{ đến } 3$$

> **Tỷ lệ Vàng Thiết kế Kích thước Cổng Đảo ($W_p / W_n = 2$):**  
> Vì lỗ trống di chuyển chậm hơn electron từ 2 đến 3 lần, nếu ta chế tạo transistor pMOS có cùng kích thước với nMOS ($W_p = W_n$), dòng kéo lên (pull-up) của pMOS sẽ yếu hơn dòng kéo xuống (pull-down) gần 3 lần! Khi đó, thời gian nạp tụ ($t_{pLH}$) sẽ chậm rì so với thời gian xả tụ ($t_{pHL}$).  
> **Giải pháp của kỹ sư vi mạch:** Bắt buộc phải thiết kế bề rộng kênh của pMOS **gấp đôi nMOS** ($W_p \approx 2 W_n$) để bù đắp sự thua thiệt về độ linh động, giúp cổng logic chuyển mạch cân bằng và đối xứng hoàn hảo!

---

### 3.2 Giải Chi tiết Bài toán Tiến trình AMI 0.6$\mu$m (Slide 15)
Chúng ta sẽ cùng nhau bấm máy tính từng bước để giải bài toán trong Slide 15 của trường UIT:

**Thông số đề bài cho:**
* Tiến trình công nghệ: $0.6\ \mu\text{m}$ (hãng AMI Semiconductor).
* Độ dày lớp oxit cổng: $t_{ox} = 100\text{ \AA} = 100 \times 10^{-8}\text{ cm} = 10\text{ nm}$.
* Độ linh động electron: $\mu_n = 350\text{ cm}^2/(\text{V}\cdot\text{s})$.
* Điện áp ngưỡng: $V_t = 0.7\text{ V}$. Tỷ lệ kích thước kênh: $W/L = (4\lambda) / (2\lambda) = 2$.

**Các bước tính toán:**
1. **Tính điện dung oxit trên đơn vị diện tích ($C_{ox}$):**
   $$\epsilon_{ox} = 3.9 \times (8.85 \times 10^{-14}\text{ F/cm}) = 3.45 \times 10^{-13}\text{ F/cm}$$
   $$C_{ox} = \frac{\epsilon_{ox}}{t_{ox}} = \frac{3.45 \times 10^{-13}\text{ F/cm}}{100 \times 10^{-8}\text{ cm}} = \mathbf{3.45 \times 10^{-7}\text{ F/cm}^2}$$

2. **Tính tham số dẫn truyền của tiến trình ($k'_n = \mu_n C_{ox}$):**
   $$k'_n = \mu_n C_{ox} = 350\text{ cm}^2/(\text{V}\cdot\text{s}) \times (3.45 \times 10^{-7}\text{ F/cm}^2) = \mathbf{120.8\ \mu\text{A/V}^2}$$

3. **Tính hệ số khuếch đại dòng của transistor ($\beta$):**
   $$\beta = k'_n \frac{W}{L} = 120.8\ \mu\text{A/V}^2 \times 2 = \mathbf{241.6\ \mu\text{A/V}^2 = 0.242\text{ mA/V}^2}$$

4. **Tính dòng điện bão hòa cực đại khi $V_{gs} = 5\text{ V}$:**
   $$V_{dsat} = V_{gs} - V_t = 5.0\text{ V} - 0.7\text{ V} = 4.3\text{ V}$$
   $$I_{ds, sat} = \frac{\beta}{2} (V_{gs} - V_t)^2 = \frac{0.242\text{ mA/V}^2}{2} \times (4.3\text{ V})^2 = 0.121 \times 18.49 = \mathbf{2.24\text{ mA}}$$

**So sánh thực tế với pMOS cùng kích thước:**  
Nếu dùng pMOS với $\mu_p = 120\text{ cm}^2/(\text{V}\cdot\text{s})$, ta tính được $\beta_p \approx 0.083\text{ mA/V}^2$. Dòng bão hòa tương ứng chỉ đạt:
$$|I_{ds, p}| = \frac{0.083}{2} \times (4.3)^2 \approx \mathbf{0.77\text{ mA}}$$
Tỷ số dòng điện: $\frac{I_{ds, n}}{|I_{ds, p}|} = \frac{2.24}{0.77} \approx \mathbf{2.91\text{ lần}}$! Con số này chứng minh hùng hồn bằng toán học vì sao pMOS bắt buộc phải làm rộng gấp đôi nMOS.

---

## Giờ 4: Giải phẫu Quá trình Xả tụ & Giới hạn Tốc độ Chip
*(Tương ứng Slide 18 – 20 | Thời gian mục tiêu: 60 phút)*

### 4.1 Cuộc Hành trình Xả tụ ở Cấp độ Nguyên tử (The Capacitor Discharge Odyssey)
Điều gì thực sự diễn ra bên trong mạch vi mạch khi một cổng đảo chuyển mức logic từ $1 \to 0$? Hãy nhìn vào **Hình 3.5**:

![Hình 3.5: Vòng lặp electron và dạng sóng thời gian thực khi xả tụ](images/fig3_5_transistor_capacitances.png)

> **Bốn Hồi của Vở kịch Xả tụ:**  
> 1. **Hồi 1 (Trữ lượng Điện tích):** Tụ tải $C_L$ (tổng điện dung của cổng kế tiếp, dây dẫn kim loại và vùng khuếch tán) ban đầu được nạp đầy điện tích dương ở bản cực trên nối với node ngõ ra $Y$ ($Q = C_L V_{dd}$).
> 2. **Hồi 2 (Cổng Mở Kênh):** Điện áp ngõ vào $V_{in}$ nhảy vọt từ $0 \to V_{dd}$. Trong vòng vài picosecond, cực cổng dựng nên điện trường dọc, kéo electron tạo thành cây cầu kênh dẫn nối liền Source với Drain.
> 3. **Hồi 3 (Thủy triều Electron tràn từ Đất lên):** Cực Nguồn Source nối đất ($0\text{V}$) là một **kho chứa electron dồi dào vô tận**. Điện thế dương cao ngất ngưởng ($5\text{V}$) ở node $Y$ lập tức tạo ra một lực hút tĩnh điện cực mạnh, **kéo electron từ Nối Đất tràn ngược qua cực Source, chạy băng qua kênh nMOS và lao thẳng lên bản cực tụ $Y$** để trung hòa các điện tích dương!
> 4. **Hồi 4 (Va chạm Mạng tinh thể & Giới hạn Tốc độ):** Tại sao tụ không xả sạch trong 0 giây? Vì các electron khi chạy qua kênh dẫn bị cản trở bởi ma sát mạng tinh thể ($R_{on}$). Dòng xả bị giới hạn khiến điện áp tụ phải mất một khoảng thời gian hữu hạn $\Delta t = (C_L \Delta V) / I$ mới có thể tụt về 0.

---

### 4.2 Phân loại Điện dung: Ký sinh Độc hại vs Điện dung Chức năng
Transistor MOSFET chứa hai nhóm điện dung có bản chất đối lập nhau:
1. **Điện dung Cổng ($C_g = C_{ox} W L$ - Functional Capacitance):** Đây là điện dung hữu ích. Nhờ có tụ điện này thì điện trường cổng mới có thể tích lũy điện tích để mở kênh dẫn. Giá trị thực tế của nó vào khoảng $1.5 - 2.0\text{ fF}/\mu\text{m}$.
2. **Điện dung Khuếch tán ($C_{sb}, C_{db}$ - Parasitic Capacitance):** Vùng Source và Drain là chất bán dẫn $n^+$, trong khi đế là chất bán dẫn $p$. Tiếp giáp giữa chúng tạo thành các **diode bán dẫn phân cực nghịch** ($P-N$ junction). Lớp nghèo của các diode này vô tình tạo thành các tụ điện ký sinh nối từ Source/Drain xuống đế. 

> **Mẹo Bố trí Layout của Kỹ sư Vi mạch (Shared Diffusion Trick):**  
> Điện dung khuếch tán $C_{db}$ là kẻ thù số một làm chậm tốc độ chip. Trong bố cục hình học (layout), các kỹ sư luôn cố gắng **cho hai transistor nằm cạnh nhau dùng chung một vùng khuếch tán Source/Drain** (uncontacted shared diffusion). Bằng cách này, diện tích tiếp giáp giảm đi một nửa, triệt tiêu $50\%$ điện dung khuếch tán ký sinh, giúp cổng logic chuyển mạch nhanh hơn đáng kể!

---

### 4.3 Bảng Tra cứu Thông số Cốt lõi Toàn chương (Summary Cheat Sheet)

| Ký hiệu / Khái niệm | Bản chất Vật lý | Giá trị Tiêu biểu / Công thức |
| :--- | :--- | :--- |
| **$C_{ox}$** | Điện dung oxit trên đơn vị diện tích | $\epsilon_{ox} / t_{ox} \approx 3.45 \times 10^{-7}\text{ F/cm}^2$ |
| **$\beta$** | Hệ số khuếch đại dòng của transistor | $\mu C_{ox} (W/L)$ |
| **Vùng Tuyến tính (Linear)** | Kênh dẫn liên tục từ S sang D | $V_{gs} \ge V_t$ và $V_{ds} < V_{gs} - V_t$ |
| **Vùng Bão hòa (Saturation)** | Kênh bị thắt nghẹt ở đầu D | $V_{gs} \ge V_t$ và $V_{ds} \ge V_{gs} - V_t$ |
| **$I_{ds, sat}$** | Dòng bão hòa Shockley | $\frac{\beta}{2}(V_{gs} - V_t)^2$ |
| **$\mu_n / \mu_p$** | Tỷ số độ linh động (electron / lỗ trống) | $\approx 2 \text{ đến } 3 \implies$ Quy tắc $W_p = 2W_n$ |
| **$\Delta t$** | Thời gian trễ nạp/xả tụ | $(C_L \Delta V) / I_{avg}$ |

---

### 4.4 Bộ Câu hỏi Phản xạ Tư duy Kỹ sư Vi mạch (Self-Assessment Quiz)

1. **Câu 1:** Một transistor nMOS có $V_{gs} = 3.0\text{ V}$, $V_t = 0.6\text{ V}$, và $V_{ds} = 1.5\text{ V}$. Transistor đang làm việc ở vùng nào?  
   *Lời giải:* Điện áp bão hòa là $V_{dsat} = V_{gs} - V_t = 3.0 - 0.6 = 2.4\text{ V}$. Vì điện áp thực tế $V_{ds} = 1.5\text{ V} < 2.4\text{ V}$, kênh dẫn vẫn mở thông suốt từ S sang D, transistor nằm ở **Vùng Tuyến tính (Linear Region)**.
2. **Câu 2:** Tại sao khi transistor đã thắt kênh (Saturation), ta tiếp tục tăng $V_{ds}$ mà dòng điện $I_{ds}$ vẫn đứng yên không tăng?  
   *Lời giải:* Vì khi đã thắt kênh, điện áp rơi trên đoạn kênh dẫn thực tế bị ghim cố định ở mức $V_{dsat} = V_{gs} - V_t$. Mọi điện áp $V_{ds}$ tăng thêm đều rơi trên khe hẹp của vùng nghèo thắt kênh. Điện trường ngang trong kênh không đổi, do đó dòng điện hoàn toàn bão hòa.
3. **Câu 3:** Vì sao trong các cổng logic chuẩn CMOS, transistor pMOS luôn được thiết kế rộng gấp đôi nMOS ($W_p \approx 2 W_n$)?  
   *Lời giải:* Vì hạt mang điện của pMOS là lỗ trống trong dải hóa trị, di chuyển theo kiểu nhảy liên kết nên chịu lực cản mạng tinh thể lớn, độ linh động kém hơn electron 2.5 lần ($\mu_n / \mu_p \approx 2-3$). Bề rộng $W_p$ gấp đôi giúp dòng nạp ngang bằng dòng xả, đảm bảo độ trễ đối xứng ($t_{pLH} \approx t_{pHL}$).
4. **Câu 4:** Khi tụ ngõ ra xả điện, tại sao giai đoạn đầu điện áp tụt rất dốc nhưng giai đoạn cuối lại tụt chậm rì?  
   *Lời giải:* Giai đoạn đầu transistor ở vùng Bão hòa, hoạt động như một nguồn bơm dòng không đổi cực đại $I_{sat}$ làm tụ xả dốc thẳng. Khi điện áp tụ rơi xuống dưới mức $V_{gs} - V_t$, transistor chuyển sang vùng Tuyến tính — lúc này dòng xả tỷ lệ thuận với điện áp còn lại trên tụ, điện trường yếu dần khiến dòng xả suy kiệt và kéo dài thành đuôi hàm mũ.
