# Chương 4. Transistor thật không đi theo công thức Chương 3

> **Cách học:** Phong cách Richard Feynman — hình trước, tên sau, một câu tự nói.  
> **Người học:** Sinh viên Thiết kế Vi mạch, Đại học Công nghệ Thông tin (UIT).  
> **Thời gian:** 4 giờ. Mỗi giờ là một cụm hình, không phải một cụm tên.  
> **Đối chiếu:** `source/source_uit_vn/chapter4-nonideal.pdf` (slide 1–26) và CMOS VLSI Design (Weste & Harris).  
> **Phạm vi không đổi:** Vẫn là hiệu ứng điện trường cao, điện áp ngưỡng thay đổi, dòng rò nano, và góc mô phỏng PVT. Đổi cách học, không đổi vật lý.

---

## Cách dùng tài liệu này

Feynman không học bằng cách chép định nghĩa. Ông học bằng cách giải thích lại cho một người chưa biết từ chuyên môn. Chỗ nào phải núp sau một từ tiếng Anh mà không vẽ được — chỗ đó là lỗ hổng.

Mỗi mục trong chương này đi theo sáu bước. Bạn làm đủ sáu bước rồi mới sang mục sau.

1. **Đọc "Hình".** Che công thức bằng tay.
2. **Nói lại** cho một người chưa học môn này. Cấm dùng tên tiếng Anh ở lần nói đầu.
3. **Khoanh lỗ hổng.** Nếu bạn bí và phải thốt ra một từ mà bạn không vẽ được, đó là lỗ hổng. Đọc mục "Vá lỗ hổng".
4. **Nói lại lần hai,** chỉ một câu.
5. **Mở công thức.** Công thức phải nói cùng câu đó. Nếu không, bạn đang học thuộc.
6. **Tính một con số** ở cuối mục. Số dùng để kiểm tra hình, không dùng để thuộc lòng.

Đừng đọc bảng thuật ngữ trước. Bảng nằm ở cuối chương, sau khi hình đã có chỗ để gắn tên.

Bạn đã nắm từ Chương 3: tụ MOS, ba chế độ tích lũy / nghèo / đảo, dòng Shockley (ngắt, tuyến tính, bão hòa), và tỷ lệ \(W_p / W_n \approx 2\) đến \(3\). Chương 4 bắt đầu đúng lúc những giả định đó không còn đúng, khi chiều dài kênh \(L \le 0.25\,\mu\mathrm{m}\) và đi vào cỡ \(90\,\mathrm{nm}\), \(65\,\mathrm{nm}\), \(28\,\mathrm{nm}\).

---

## Bản đồ 4 giờ

| Giờ | Câu hỏi duy nhất của giờ đó | Xong giờ này, bạn nói được |
| :--- | :--- | :--- |
| **1** | Vì sao đường \(I\)–\(V\) đo được không giống hình bình phương của Shockley? | Hai lực trong kênh: một lực ép hạt vào trần oxit, một lực đẩy hạt dọc kênh cho đến khi tinh thể giật mất tốc độ. |
| **2** | Vì sao \(V_t\) không phải một số đóng trên vỏ transistor? | Ba cách làm đổi "hóa đơn điện tích" mà cực cổng phải trả: đế, máng, và chiều dài kênh. |
| **3** | Vì sao công tắc tắt vẫn có dòng? | Ba lối rò: trèo đồi bằng năng lượng nhiệt, chui qua tường oxit, và chui qua tiếp giáp. Cộng với cuộc kéo co của nhiệt độ. |
| **4** | Muốn bắt một chip hỏng, phải thử đúng tổ hợp xấu nào? | Góc chậm bắt lỗi trễ. Góc nhanh bắt lỗi dữ liệu đến quá sớm. Hạ xung nhịp chỉ cứu được một trong hai lỗi. |

---

## Giờ 1. Hai lực, và một cái trần tốc độ

*Slide 3–10. Mục tiêu: 60 phút.*

### 1.1 Ba lời hứa, và phép đo không chịu nghe

Ở Chương 3, mô hình Shockley cho kênh dài hứa ba điều:

$$
\begin{cases}
I_{ds} = 0 & \text{khi } V_{gs} < V_t \\
I_{ds} = \beta \left[(V_{gs}-V_t)V_{ds} - V_{ds}^2/2\right] & \text{khi } V_{ds} < V_{gs}-V_t \\
I_{ds} = \dfrac{\beta}{2}(V_{gs}-V_t)^2 & \text{khi } V_{ds} \ge V_{gs}-V_t
\end{cases}
$$

Nói bằng lời thường:

1. Cổng chưa đủ ngưỡng thì **không có dòng**.
2. Khi đã bão hòa, dòng **đứng yên** dù máng tăng thêm.
3. Dòng bão hòa tăng theo **bình phương** \((V_{gs}-V_t)\). Tăng cổng thêm một bước đều, các đường cong phải giãn ra càng lúc càng xa nhau.

Trên một transistor tiến trình \(65\,\mathrm{nm}\), \(V_{DD} = 1.0\,\mathrm{V}\) (cỡ số của tiến trình IBM \(65\,\mathrm{nm}\)), phép đo không giữ lời hứa nào:

1. Dòng bật \(I_{on}\) chỉ cỡ \(747\,\mu\mathrm{A}/\mu\mathrm{m}\). Công thức Shockley cho số lớn hơn \(1500\,\mu\mathrm{A}/\mu\mathrm{m}\).
2. Tăng \(V_{gs}\) theo bước đều \(0.4 \to 0.6 \to 0.8 \to 1.0\,\mathrm{V}\), các đường \(I_{ds}\) **cách đều**, gần như bậc 1, không giãn theo bậc 2.
3. Trong vùng bão hòa, đường không nằm ngang. Nó vẫn dốc lên theo \(V_{ds}\).

Ba lời hứa gãy vì **ba hình khác nhau**. Đừng gộp chúng thành một từ "phi lý tưởng".

| Lời hứa bị gãy | Hình sẽ vá ở mục | Dấu hiệu trên Hình 4.1 |
| :--- | :--- | :--- |
| Dòng nhỏ hơn dự đoán, và càng mở cổng mạnh càng không được như kỳ vọng | 1.3 Viên bi bị ép vào trần | Hình 4.1(a) |
| Các đường cách đều, không theo bình phương | 1.4 Trần tốc độ | Hình 4.1(b) và (c) |
| Đường bão hòa không nằm ngang | 1.5 Kênh bị ăn ngắn | Độ dốc bên phải Hình 4.1(c) |

Lời hứa "dòng bằng 0 khi tắt" gãy ở Giờ 3. Giờ 1 chỉ lo chuyện transistor **đang bật**.

![Hình 4.1: Hai điện trường, trần tốc độ, và đường I–V thật của tiến trình 65 nm](images/fig4_1_high_field_effects.png)

**Một câu, sau khi nhìn hình:** "Shockley vẽ một họ đường giãn dần và nằm ngang. Silicon vẽ một họ đường cách đều và hơi dốc."

---

### 1.2 Hai lực, hai hướng

Thu nhỏ kích thước mà \(V_{DD}\) không thu nhỏ cùng tỷ lệ, thì điện trường bên trong tăng. Có hai điện trường. Chúng làm hai việc khác nhau. Nếu bạn trộn chúng, cả giờ này sẽ rối.

**Lực thứ nhất kéo hạt lên trần.** Đó là điện trường dọc, xuyên qua lớp oxit, do cổng gây ra. Lấy điện áp cổng so với điểm giữa kênh:

$$
\mathcal{E}_{vert} = \frac{V_{gs} - V_{ds}/2}{t_{ox}}
$$

Vì sao có \(V_{ds}/2\): dọc kênh, điện thế không bằng điện thế source. Điểm giữa kênh nằm cao hơn source khoảng một nửa \(V_{ds}\). Cổng phải thắng cả mức đó.

Ước lượng cỡ \(65\,\mathrm{nm}\): \(t_{ox} \approx 1.2\,\mathrm{nm} = 1.2 \times 10^{-7}\,\mathrm{cm}\), \(V_{gs} = 1.0\,\mathrm{V}\),

$$
\mathcal{E}_{vert} \approx \frac{1.0}{1.2 \times 10^{-7}} \approx 8 \times 10^{6}\,\mathrm{V/cm}.
$$

Đó là điện trường rất mạnh, cùng cỡ điện trường làm hỏng chất cách điện. Nó không có nhiệm vụ kéo dòng từ source sang drain. Nó ép hạt vào mặt oxit.

**Lực thứ hai đẩy hạt dọc kênh.** Đó là điện trường ngang:

$$
\mathcal{E}_{lat} = \frac{V_{ds}}{L}.
$$

Với \(L = 65\,\mathrm{nm} = 0.065 \times 10^{-4}\,\mathrm{cm}\) và \(V_{ds} = 1.0\,\mathrm{V}\),

$$
\mathcal{E}_{lat} \approx \frac{1.0}{0.065 \times 10^{-4}} \approx 1.5 \times 10^{5}\,\mathrm{V/cm} = 150\,\mathrm{kV/cm}.
$$

**Vá lỗ hổng:** "Điện trường" không phải một mũi tên duy nhất. Hỏi tiếp: mũi tên này vuông góc với kênh, hay nằm dọc kênh? Vuông góc thì nó đổi độ linh động. Dọc kênh thì nó đổi vận tốc.

**Một câu:** "Cổng ép hạt lên trần. Máng kéo hạt dọc đường. Hai việc ấy không thay nhau được."

---

### 1.3 Viên bi và cái trần gồ ghề

**Hình.** Electron trong kênh là một viên bi. Ở điện trường dọc yếu, viên bi lăn trong lòng silicon, khá sâu dưới mặt. Độ linh động \(\mu\) khi ấy gần như một số của vật liệu (\(\mu_n\) cỡ vài trăm \(\mathrm{cm}^2/\mathrm{V}\cdot\mathrm{s}\)).

Bật cổng mạnh. Lực kéo lên rất lớn (\(\mathcal{E}_{vert} > 10^6\,\mathrm{V/cm}\)). Viên bi bị ép sát mặt tiếp xúc silicon và \(\mathrm{SiO}_2\). Mặt ấy không phải gương. Silicon là tinh thể. Oxit là thủy tinh. Chỗ hai thứ gặp nhau lồi lõm, có liên kết đứt dang (dangling bond — liên kết không có cặp) và điện tích bẫy.

Viên bi vừa bị ép lên vừa phải lăn ngang. Nó đập vào trần liên tục. Quãng đường bay tự do ngắn lại. Ta gọi đó là tán xạ vì mặt gồ ghề (surface roughness scattering). Hệ quả: cùng một lực đẩy ngang, viên bi trôi chậm hơn. \(\mu\) giảm. Đó là suy giảm độ linh động.

**Vì sao công thức có dạng này.** Càng tăng \(V_{gs}\), càng ép mạnh, càng va nhiều. Mẫu số phải lớn dần theo \((V_{gs}-V_t)\):

$$
\mu_{eff} = \frac{\mu_0}{1 + \theta (V_{gs}-V_t)}.
$$

\(\mu_0\) là độ linh động khi trường còn yếu. \(\theta\) cỡ \(0.1\) đến \(0.4\,\mathrm{V}^{-1}\).

Đây là chỗ dễ học sai. Người ta tưởng tăng \(V_{gs}\) chỉ làm kênh nhiều điện tích hơn, nên dòng phải tăng mạnh. Đúng là nhiều điện tích hơn. Nhưng cùng lúc \(\mu_{eff}\) giảm. Hai hiệu ứng đánh nhau. Dòng thật tăng ít hơn dòng trong đầu.

**Một số để cầm.** \(\theta = 0.25\,\mathrm{V}^{-1}\), \(V_{gs}-V_t = 0.7\,\mathrm{V}\):

$$
\mu_{eff} = \frac{\mu_0}{1 + 0.25 \times 0.7} = \frac{\mu_0}{1.175} \approx 0.85\,\mu_0.
$$

Mười lăm phần trăm biến mất chỉ vì trần gồ ghề. Hình 4.1(a) vẽ đúng việc này.

**Một câu:** "Tăng cổng thì được thêm điện tích, nhưng hạt bị ép vào tường nhám nên mỗi hạt chạy kém hơn."

---

### 1.4 Trần tốc độ không phải biển báo

**Hình.** Shockley còn giả sử vận tốc trôi tăng mãi với điện trường ngang:

$$
v = \mu \mathcal{E}_{lat} = \mu \frac{V_{ds}}{L}.
$$

Thử số. \(\mu = 400\,\mathrm{cm}^2/\mathrm{V}\cdot\mathrm{s}\), \(\mathcal{E}_{lat} = 1.5 \times 10^5\,\mathrm{V/cm}\):

$$
v = 400 \times 1.5 \times 10^5 = 6 \times 10^7\,\mathrm{cm/s}.
$$

Silicon không cho số đó.

Electron không bay trong chân không. Nó bay trong một mạng nguyên tử. Khi điện trường ngang vượt một ngưỡng, gọi là trường tới hạn \(\mathcal{E}_c\), động năng trên mỗi quãng bay đủ lớn để rung mạnh một nguyên tử. Electron nhả một gói rung của mạng tinh thể. Gói đó gọi là phonon quang (optical phonon). Trong silicon, gói này cỡ \(63\,\mathrm{meV}\). Electron mất tốc và phải tăng tốc lại.

Đạp mạnh hơn không nâng trần. Nó chỉ làm electron đập vào các gói rung thường xuyên hơn. Giống xe đạp trên đường có gờ giảm tốc dày đặc: đạp mạnh hơn thì gặp gờ dày hơn, tốc độ trần đứng yên.

Nhìn Hình 4.1(b). Đường nét đứt là \(v = \mu\mathcal{E}\), đi lên mãi. Đường thật cong xuống và áp vào trần:

- Electron: \(v_{sat,n} \approx 10^7\,\mathrm{cm/s} = 10^5\,\mathrm{m/s}\). \(\mathcal{E}_c \approx 10\,\mathrm{kV/cm}\).
- Lỗ trống: \(v_{sat,p} \approx 8 \times 10^6\,\mathrm{cm/s}\). \(\mathcal{E}_c\) cao hơn, cỡ \(25\,\mathrm{kV/cm}\), vì lỗ trống nặng hơn và khó được gia tốc.

Dạng làm cho đường cong áp vào trần:

$$
v = \frac{\mu_{eff}\mathcal{E}_{lat}}{\left[1 + \left(\mathcal{E}_{lat}/\mathcal{E}_c\right)^{\alpha}\right]^{1/\alpha}}
\xrightarrow{\mathcal{E}_{lat}\gg\mathcal{E}_c} v_{sat}.
$$

\(\alpha = 2\) với electron, \(\alpha = 1\) với lỗ trống. Bạn không cần thuộc \(\alpha\). Bạn cần thấy: mẫu số nở ra khi trường lớn, nên \(v\) ngừng tăng.

**Vì sao dòng bão hòa thành bậc 1.** Dòng là điện tích đi qua một lát cắt trong một giây:

$$
I_{dsat} = W \cdot Q_{inv} \cdot v.
$$

Khi \(v\) đã kẹt ở \(v_{sat}\),

$$
I_{dsat} = W \cdot C_{ox}(V_{gs}-V_t-V_{dsat})\cdot v_{sat}.
$$

\(v_{sat}\) là hằng số. \(W\) và \(C_{ox}\) là hằng số của con transistor ấy. Phần còn đổi được là lượng điện tích, và lượng ấy đi theo \((V_{gs}-V_t)\), **bậc 1**. Bình phương đã chết vì bình phương đến từ \(v = \mu\mathcal{E}\) và từ cách kênh dài bị thắt. Cả hai đều không còn là chuyện chính.

Đó là lý do Hình 4.1(c) có các đường \(65\,\mathrm{nm}\) cách đều khi \(V_{gs}\) tăng đều. Đường Shockley nét đứt thì giãn và nằm ngang.

**Vì sao bão hòa đến sớm.** Kênh dài chỉ bão hòa khi kênh bị thắt ở phía máng:

$$
V_{dsat,\mathrm{long}} = V_{gs}-V_t.
$$

Kênh ngắn: electron đã chạm \(v_{sat}\) từ trước khi kênh kịp thắt. Có hai điện áp giới hạn. Cái nào nhỏ hơn sẽ thắng. Cách viết "song song" là cách toán nói "cái nhỏ hơn thắng, và chỗ chuyển tiếp thì trơn":

$$
V_{dsat} = (V_{gs}-V_t) \parallel (\mathcal{E}_c L) = \frac{(V_{gs}-V_t)\cdot(\mathcal{E}_c L)}{(V_{gs}-V_t)+\mathcal{E}_c L}.
$$

Cùng dạng với hai điện trở song song: \(1/V_{dsat} = 1/(V_{gs}-V_t) + 1/(\mathcal{E}_c L)\).

**Một số để cầm.** Lấy số tròn \(V_{gs}-V_t = 0.7\,\mathrm{V}\), \(\mathcal{E}_c L \approx 0.1\,\mathrm{V}\):

$$
V_{dsat} = \frac{0.7 \times 0.1}{0.8} = 0.0875\,\mathrm{V}.
$$

Transistor đã bão hòa khi \(V_{ds}\) mới nhích khỏi 0. Với \(L = 65\,\mathrm{nm}\) và \(\mathcal{E}_c = 10\,\mathrm{kV/cm} = 1\,\mathrm{V}/\mu\mathrm{m}\), thì \(\mathcal{E}_c L \approx 0.065\,\mathrm{V}\), còn nhỏ hơn \(0.1\,\mathrm{V}\). Ý không đổi: bão hòa đến rất sớm.

**Vá lỗ hổng:** "Bão hòa" ở Chương 3 nghĩa là kênh bị thắt, dòng đứng. "Bão hòa" ở chương này, khi nói velocity saturation, nghĩa là **tốc độ hạt** đứng. Hai từ trùng tên, hai hình khác. Hỏi: cái gì đang bão hòa — vận tốc, hay dòng?

**Một câu:** "Hạt đã chạy hết tốc. Muốn thêm dòng, chỉ còn cách bỏ thêm hạt vào kênh, và số hạt tăng thẳng theo cổng, không tăng theo bình phương."

---

### 1.5 Cái kênh bị ăn ngắn

**Hình.** Sau khi vận tốc đã chạm trần, đường dòng vẫn chưa nằm ngang. Nhìn nửa phải Hình 4.1(c).

Drain là vùng \(n^+\) ở điện thế cao. Đế là \(p\) ở \(0\,\mathrm{V}\). Tiếp giáp ấy bị phân cực ngược. Phân cực ngược không dẫn theo kiểu thuận. Nó làm một vùng nghèo: một lớp hết hạt tự do, còn lại ion cố định.

Vùng nghèo phía máng có bề rộng \(L_d\). \(V_{ds}\) càng cao, vùng này càng dày và càng ăn lấn vào kênh:

$$
L_d \propto \sqrt{V_{ds}-V_{dsat}}, \qquad L_{eff} = L - L_d.
$$

Dòng tỉ lệ nghịch với chiều dài đoạn kênh còn lại. Đoạn còn lại ngắn đi thì dòng tăng, dù vận tốc mỗi hạt đã kẹt ở trần. Đó là biến điệu chiều dài kênh (channel length modulation, hệ số \(\lambda\)).

**Vì sao công thức có dạng này.** Với một đoạn \(\Delta L\) nhỏ so với \(L\), dòng tăng gần như thẳng theo \(V_{ds}\):

$$
I_{ds} = I_{dsat}(1 + \lambda V_{ds}), \qquad \lambda \propto \frac{1}{L}.
$$

Vì sao \(\lambda\) tỉ lệ nghịch với \(L\): cùng một đoạn \(L_d\) bị ăn, kênh ngắn mất một **phần trăm** lớn hơn kênh dài. Độ dốc nhìn thấy rõ hơn trên transistor ngắn.

Độ dốc ấy là điện dẫn ra:

$$
g_{ds} = \frac{\partial I_{ds}}{\partial V_{ds}} \approx \lambda I_{dsat} = \frac{1}{r_o}.
$$

Điện trở ra \(r_o\) nhỏ đi. Khuếch đại điện áp của một tầng tương tự là

$$
A_v = -g_m r_o = -\frac{g_m}{g_{ds}}.
$$

Mạch số chủ yếu thấy chuyện này như một dòng không hoàn toàn phẳng. Mạch tương tự thấy nó trực tiếp: độ lợi giảm.

**Một câu:** "Máng càng cao thì càng ăn bớt kênh. Kênh cụt hơn thì cùng một trần tốc độ lại đẩy được nhiều dòng hơn. Vì vậy đường bão hòa dốc."

### Tự kiểm Giờ 1 — đóng tài liệu, nói ba câu

1. Tăng \(V_{gs}\) làm \(\mu\) đổi chiều nào, và vì sao?
2. Vì sao các đường \(I_{ds}\) cách đều, không giãn theo bình phương?
3. Vì sao đường bão hòa không nằm ngang, và vì sao transistor ngắn dốc hơn transistor dài?

Nếu một câu nào phải dùng từ tiếng Anh mà không kèm hình, quay lại mục tương ứng. Chưa sang Giờ 2.

---

## Giờ 2. \(V_t\) là một hóa đơn điện tích, không phải một con số in sẵn

*Slide 11–15. Mục tiêu: 60 phút.*

### 2.1 \(V_t\) thật ra là câu hỏi này

Cổng phải kéo các dải năng lượng ở mặt silicon đủ cong để mặt silicon đầy electron như đế đầy lỗ trống. Mốc ấy là \(\phi_s = 2\phi_F\). \(V_t\) là điện áp cổng đủ để làm việc đó.

Việc đó là một bài toán điện tích. Cổng phải cung cấp đủ điện tích dương để:

- đuổi lỗ trống đi, để lại các ion boron âm \(B^-\) trong vùng nghèo;
- rồi mới kéo electron đến, tạo kênh.

Bất cứ điều gì làm **tăng số ion mà cổng phải trả**, hoặc **có kẻ khác trả giúp**, hoặc **có kẻ khác bẻ dải năng lượng giúp cổng**, đều làm \(V_t\) đổi. Ba mục sau là ba cách đó xảy ra. Nhìn Hình 4.2 trước khi đọc tên.

![Hình 4.2: Ba cách \(V_t\) đổi — đế làm vùng nghèo dày, máng hạ đồi thế, chiều dài kênh đổi phần điện tích cổng phải trả](images/fig4_2_threshold_voltage_effects.png)

**Một câu:** "\(V_t\) là điện áp để trả xong hóa đơn ion rồi mới có kênh. Đổi hóa đơn là đổi \(V_t\)."

---

### 2.2 Nâng source lên là đào cái hố sâu thêm

**Hình.** Trong cổng inverter thường, source của nMOS ở \(0\,\mathrm{V}\), đế cũng ở \(0\,\mathrm{V}\). \(V_{sb} = 0\). Hóa đơn ở mức thường, \(V_t = V_{t0}\).

Hai chỗ source không ở \(0\,\mathrm{V}\):

- nMOS dùng như công tắc truyền mức 1 (pass transistor). Điện thế phía ra nâng dần lên.
- nMOS nằm trên cùng của một chồng NAND. Khi xả, source của nó bị các nMOS bên dưới kê lên.

Source là \(n^+\), đế là \(p\). Source cao hơn đế nghĩa là tiếp giáp ấy bị phân cực ngược. Vùng nghèo dưới cổng dày ra. Nhìn Hình 4.2(a): cái hố ion âm phình xuống.

Bề rộng vùng nghèo của một tiếp giáp ngược đi theo căn bậc hai của điện thế, vì điện tích lộ ra phải cân bằng điện thế (cùng lý do vùng nghèo của diode):

$$
W_{dep} = \sqrt{\frac{2\epsilon_{si}(\phi_s + V_{sb})}{q N_A}}.
$$

Hố sâu hơn thì nhiều ion \(B^-\) hơn. Cổng phải mang thêm điện tích dương để trung hòa chúng **trước khi** có electron thừa để làm kênh. \(V_t\) tăng.

**Vì sao công thức là hiệu của hai căn.** Điện tích ion tỉ lệ với \(W_{dep}\), nên tỉ lệ với \(\sqrt{\text{điện thế}}\). Ta chỉ tính **phần tăng thêm** so với lúc \(V_{sb} = 0\):

$$
V_t = V_{t0} + \gamma\left(\sqrt{\phi_s + V_{sb}} - \sqrt{\phi_s}\right).
$$

\(\phi_s = 2\phi_F = 2 v_T \ln(N_A/n_i)\), thường cỡ \(0.6\) đến \(0.7\,\mathrm{V}\).

\(\gamma\) nói cổng nhạy với đế đến mức nào. Tử số là "một hố sâu bao nhiêu ion". Mẫu số là \(C_{ox}\): oxit dày thì cùng một lượng ion làm đổi điện áp nhiều hơn.

$$
\gamma = \frac{\sqrt{2 q \epsilon_{si} N_A}}{C_{ox}} = \frac{t_{ox}}{\epsilon_{ox}}\sqrt{2 q \epsilon_{si} N_A}.
$$

CMOS thường gặp \(\gamma\) cỡ \(0.4\) đến \(0.6\,\mathrm{V}^{1/2}\).

Khi \(V_{sb}\) nhỏ, khai triển căn cho một đường thẳng:

$$
V_t \approx V_{t0} + k_\gamma V_{sb}, \qquad k_\gamma \approx \frac{\gamma}{2\sqrt{\phi_s}} \approx 0.1 \text{ đến } 0.3.
$$

**Một số để cầm.** NAND 4 nMOS nối tiếp. Transistor trên cùng có source bị kê lên cỡ \(0.6\,\mathrm{V}\). \(V_t\) có thể từ \(0.3\,\mathrm{V}\) lên quá \(0.5\,\mathrm{V}\). Dòng xả của nhánh yếu đi. Trễ của NAND rộng dài ra. Đây không phải lỗi vẽ mạch. Đây là cái hố ion sâu thêm.

Bài tập 2 tính tiếp chuyện pass transistor: nMOS truyền mức 1 tự tắt sớm hơn người ta nghĩ, vì chính lúc điện thế ra tăng thì \(V_t\) cũng tăng.

**Một câu:** "Source cao hơn đế thì vùng nghèo dày thêm. Cổng phải trả thêm ion. \(V_t\) tăng."

---

### 2.3 Máng đứng quá gần, nên nó với tay tới đồi ở source

**Hình.** Electron trong source muốn sang drain thì phải qua một đồi thế năng. Đồi ấy nằm ở đầu source. Khi transistor tắt, đa số electron không đủ năng lượng nhiệt để trèo đồi.

Kênh dài (\(L > 1\,\mu\mathrm{m}\)): máng ở xa. Đồi là việc riêng của cổng. Máng không với tới.

Kênh dưới \(100\,\mathrm{nm}\): máng ở ngay cạnh. \(V_{ds}\) dương nghĩa là máng có điện tích dương. Đường sức của nó đâm vào kênh và kéo đỉnh đồi xuống. Nhìn Hình 4.2(b). Đường xanh là \(V_{ds} = 0.05\,\mathrm{V}\), đồi cao. Đường đỏ là \(V_{ds} = 1.0\,\mathrm{V}\), đỉnh đồi thấp hơn một đoạn \(\Delta V_t = \eta V_{ds}\).

Đồi thấp hơn thì cổng không cần kéo mạnh bằng trước thì electron đã tràn. \(V_t\) giảm. Tên của việc này là hạ rào thế do cực máng (drain-induced barrier lowering, DIBL).

$$
V_t' = V_{t0} - \eta V_{ds}.
$$

\(\eta\) cỡ \(0.05\) đến \(0.15\) (tức \(50\) đến \(150\,\mathrm{mV}\) trên mỗi volt ở máng) ở tiến trình nano.

**Vì sao việc này đau khi transistor đang cố tắt.** Inverter ra mức 1, vào mức 0. nMOS lẽ ra tắt: \(V_{gs} = 0\). Nhưng \(V_{ds} = V_{DD} = 1.0\,\mathrm{V}\). Lấy \(\eta = 0.10\):

$$
\Delta V_t = 0.10 \times 1.0 = 100\,\mathrm{mV}.
$$

Giờ 3 sẽ cho thấy dòng rò dưới ngưỡng nhân theo hàm mũ của \(V_t\). Hạ đồi \(100\,\mathrm{mV}\) không phải "rò thêm một chút". Có thể là gần một bậc mười. DIBL và dòng rò là một chuyện, nhìn từ hai đầu.

**Vá lỗ hổng:** Body effect **tăng** \(V_t\) khi source nâng lên. DIBL **giảm** \(V_t\) khi máng nâng lên. Hai cực, hai chiều. Đừng học một câu "điện áp cao thì \(V_t\) đổi".

**Một câu:** "Máng càng gần và càng cao thì càng kéo thấp đồi ở source. Cổng đỡ phải kéo. \(V_t\) giảm."

---

### 2.4 Ai trả tiền những ion ở hai đầu kênh

**Hình.** Giữ mọi điện áp bằng 0 ở source, đế, máng. Chỉ rút ngắn \(L\) trên bản vẽ. \(V_t\) vẫn đổi. Người mới học hay nói "không, \(V_t\) là của công nghệ". Hình nói khác.

Khi dẫn, vùng nghèo dưới cổng trông như một hình hộp dài \(L\), sâu \(W_{dep}\). Nhưng source và drain tự chúng đã có vùng nghèo, xòe vào hai đầu kênh như hai hình quạt, vì tiếp giáp pn có điện thế tiếp xúc \(V_{bi}\) dù bạn chưa đặt \(V_{ds}\).

Những ion nằm trong hai hình quạt ấy **đã được source và drain trả**. Cổng chỉ còn trả phần hình thang ở giữa. Đây là mô hình chia sẻ điện tích của Yau (Yau's charge-sharing model).

Kênh dài: hai quạt nhỏ so với \(L\). Hóa đơn của cổng gần như cả hình chữ nhật. \(V_t\) gần \(V_{t0}\).

Kênh vài chục nanomet: hai quạt chiếm gần hết \(L\). Hóa đơn của cổng nhỏ. \(V_t\) giảm khi \(L\) giảm. Đó là \(V_t\) roll-off, đường nét đứt trên Hình 4.2(c).

**Một câu:** "Hai đầu kênh đã có source và drain trả ion. Kênh càng ngắn, phần cổng phải trả càng nhỏ, \(V_t\) càng thấp."

---

### 2.5 Nhà máy cấy thêm tạp ở hai mép, và đường cong đội lên

Roll-off làm một transistor in hơi ngắn có \(V_t\) tụt. Tụt nhiều thì khó tắt, dòng rò tăng, và có thể hai vùng nghèo source–drain chạm nhau. Cổng mất quyền. Việc chạm nhau đó gọi là đấm xuyên (punch-through).

Cách chữa trên silicon: cấy thêm tạp chất \(p\) rất đậm, nghiêng vào đúng hai mép kênh của nMOS. Vùng cấy ấy gọi là halo, hay pocket.

- Kênh còn dài: hai túi halo nằm xa nhau. Giữa kênh vẫn pha loãng. \(V_t\) gần mức kênh dài.
- \(L\) vào cỡ \(100\) đến \(200\,\mathrm{nm}\): hai túi tiến lại và chồng lên nhau. Nồng độ \(N_A\) trung bình trong kênh tăng. \(N_A\) tăng thì \(\phi_s\) và \(\gamma\) tăng, nên \(V_t\) tăng.

\(V_t\) tăng khi \(L\) giảm — ngược với roll-off. Tên là hiệu ứng kênh ngắn ngược (reverse short-channel effect, RSCE). Đó là cái bướu xanh trên Hình 4.2(c). Rút \(L\) thêm nữa, roll-off thắng lại, đường rơi xuống.

**Vá lỗ hổng:** Đường \(V_t\) theo \(L\) không đơn điệu. Nhìn hình trước khi nói "kênh ngắn thì \(V_t\) thấp". Với halo, có một đoạn kênh ngắn vừa thì \(V_t\) **cao hơn** kênh dài.

**Một câu:** "Halo là hai túi tạp đậm ở hai mép. Kênh ngắn vừa đủ thì hai túi chồng, kênh đậm hơn, \(V_t\) nhích lên, rồi kênh cực ngắn mới rơi."

### Tự kiểm Giờ 2

Nói, không nhìn tài liệu:

1. Pass transistor nMOS đang truyền mức 1. \(V_t\) của nó tăng hay giảm? Cái hố nào đang sâu thêm?
2. Inverter ra mức 1, vào mức 0. \(V_t\) của nMOS tăng hay giảm? Ai đang kéo đồi?
3. Trên Hình 4.2(c), vì sao đường có halo có một đỉnh, còn đường không halo chỉ đi xuống?

---

## Giờ 3. Tắt không có nghĩa là không còn hạt nào đi qua

*Slide 16–22. Mục tiêu: 60 phút.*

### 3.1 Phép nhân làm một dòng nhỏ thành một dòng lớn

Ngày kênh dài, một chip trăm nghìn transistor gần như không tốn điện khi nghỉ. Người thiết kế chỉ lo công suất động \(P = C V_{DD}^2 f\).

Chip lớn hôm nay có từ khoảng 10 tỷ đến 100 tỷ transistor. Làm một phép nhân trong đầu, và **gọi đúng tên nó là phép nhân**, không phải số đo của một chiếc điện thoại:

$$
10^{10} \times 10\,\mathrm{nA} = 100\,\mathrm{A}.
$$

Ở \(1\,\mathrm{V}\), đó là \(100\,\mathrm{W}\) khi chip không tính gì cả. Con số \(10\,\mathrm{nA}\) mỗi transistor là một giả sử để thấy phép nhân. Transistor thật được thiết kế để rò ít hơn nhiều. Điểm Feynman muốn giữ: **một dòng rất nhỏ nhân với một số rất lớn thì không còn nhỏ.** Vì vậy phải biết dòng ấy đi lối nào. Hình 4.3(a) vẽ ba lối.

![Hình 4.3: Ba lối rò, độ dốc dưới ngưỡng, và vì sao tường oxit phải dày trở lại](images/fig4_3_nanoscale_leakage_mechanisms.png)

**Một câu:** "Dòng rò của một transistor là chuyện nhỏ. Dòng rò của mười tỷ transistor là chuyện của cục pin."

---

### 3.2 Dưới ngưỡng: một quả đồi và một cái đuôi nhiệt

**Lỗ hổng rất phổ biến.** "\(V_{gs} < V_t\) thì số electron bằng 0." Câu này sai.

Ở mặt silicon, số electron không tắt như công tắc đèn. Nó theo thống kê nhiệt. Xác suất có đủ năng lượng để trèo một đồi cao \(q\phi_B\) là đuôi Boltzmann:

$$
\text{xác suất} \propto \exp\left(-\frac{q\phi_B}{k_B T}\right).
$$

Source \(n^+\) đầy electron. Mặt kênh thì thưa. Hạt đi từ chỗ đông sang chỗ vắng. Đó là khuếch tán (diffusion). Chúng không cần một điện trường kéo cả quãng. Transistor lúc này giống một BJT: source là emitter, đế là base, drain là collector. Cổng không "mở kênh". Cổng **hạ hoặc nâng quả đồi**.

**Vì sao công thức có từng số hạng.**

$$
I_{sub} = I_0 \exp\left(\frac{V_{gs}-V_{t0}+\eta V_{ds}-k_\gamma V_{sb}}{n v_T}\right)\left(1-\exp\left(-\frac{V_{ds}}{v_T}\right)\right).
$$

Đọc từng thứ, vì mỗi thứ là một hình đã gặp:

| Số hạng | Hình |
| :--- | :--- |
| \(v_T = k_B T/q \approx 26\,\mathrm{mV}\) ở \(300\,\mathrm{K}\) | Độ rộng cái đuôi năng lượng. Nóng thì đuôi dài. |
| \(n = 1 + C_{dep}/C_{ox}\), thường \(1.3\) đến \(1.7\) | Không phải mọi milivolt ở cổng đều tới mặt silicon. \(C_{dep}\) chia bớt với \(C_{ox}\). |
| \(+\eta V_{ds}\) | DIBL, Giờ 2. Máng cũng hạ đồi. |
| \(-k_\gamma V_{sb}\) | Body effect. Đế làm đồi cao thêm. |
| \(1-\exp(-V_{ds}/v_T)\) | \(V_{ds}\) rất nhỏ thì drain cũng bắn hạt ngược về. Khi \(V_{ds} > 3v_T \approx 0.1\,\mathrm{V}\), số hạng này bằng 1. |
| \(I_0 = \mu_0 C_{ox}(W/L)(n-1)v_T^2\) | Cỡ dòng của công nghệ ấy. Không cần thuộc. Cần thấy \(W/L\) vẫn ở đó. |

**Độ dốc dưới ngưỡng** \(S\) là số milivolt cổng cần đổi để dòng đổi đúng 10 lần. Trên Hình 4.3(b), trong vùng dưới \(V_t\), \(\log_{10} I_{ds}\) là một đường thẳng. Độ dốc của đường thẳng ấy là \(S\):

$$
S = \ln(10)\cdot n v_T = 2.303\cdot\frac{k_B T}{q}\left(1+\frac{C_{dep}}{C_{ox}}\right).
$$

Ở \(300\,\mathrm{K}\), \(n \approx 1.4\):

$$
S \approx 2.303 \times 26\,\mathrm{mV} \times 1.4 \approx 80 \text{ đến } 100\,\mathrm{mV/decade}.
$$

Nếu cổng điều khiển hoàn hảo, \(C_{ox}\) rất lớn, \(n \to 1\):

$$
S_{ideal} = \ln(10)\cdot v_T \approx 60\,\mathrm{mV/decade} \text{ ở } 300\,\mathrm{K}.
$$

**Vá lỗ hổng quan trọng.** \(60\,\mathrm{mV/decade}\) không phải "định luật mọi công tắc trên đời". Nó là tường của **cơ chế này**: hạt trèo đồi bằng năng lượng nhiệt. Độ rộng năng lượng là \(k_B T\). Nhà máy không làm \(k_B T\) nhỏ đi bằng cách đổi \(t_{ox}\). Một cơ chế khác, không trèo đồi, có thể dốc hơn. CMOS thông thường không dùng cơ chế đó.

Muốn \(I_{on}/I_{off} \ge 10^6\), tức 6 bậc mười, với \(S = 80\,\mathrm{mV/decade}\):

$$
V_t \ge 6 \times 80\,\mathrm{mV} = 0.48\,\mathrm{V}
$$

so với điểm đang tắt (\(V_{gs} = 0\)). Hạ \(V_t\) từ \(0.48\,\mathrm{V}\) xuống \(0.20\,\mathrm{V}\) để chip điện áp thấp chạy nhanh hơn:

$$
\frac{0.48-0.20}{0.08} = 3.5 \text{ bậc mười}, \qquad 10^{3.5} \approx 3\,000.
$$

Dòng tắt tăng khoảng ba nghìn lần. Hình 4.3(b) còn cho thấy lúc \(125^\circ\mathrm{C}\), \(S\) xấu đi tới cỡ \(105\,\mathrm{mV/decade}\), vì \(v_T\) tăng theo \(T\). Đường nóng nằm cao hơn ở \(V_{gs} = 0\): cùng một transistor, nóng thì tắt kém hơn.

**Một câu:** "Dưới ngưỡng, hạt không hết. Một ít hạt đủ nóng để trèo đồi. Hạ đồi \(60\,\mathrm{mV}\) thì số hạt trèo được tăng khoảng 10 lần, và nhiệt độ phòng không cho bạn dốc hơn thế với cơ chế này."

---

### 3.3 Bức tường mỏng bằng vài lớp nguyên tử

**Hình.** \(\mathrm{SiO}_2\) dày hơn khoảng \(2\,\mathrm{nm}\) thì gần như không có dòng cổng. Muốn cổng vẫn kẹp được kênh ngắn, người ta mài oxit xuống cỡ \(1.0\) đến \(1.2\,\mathrm{nm}\). Bề dày ấy chỉ còn vài lớp phân tử. Hình 4.3(c), khung trên.

Electron cũng là một sóng. Sóng đập vào một tường dày thì tắt trước khi sang bên kia. Tường chỉ vài lớp nguyên tử thì sóng không tắt hết. Còn một cái đuôi biên độ ở bên kia. Xác suất có mặt ở bên kia khác 0. Hạt "có mặt" ở bên kia mà không cần trèo quá đỉnh tường. Đó là xuyên hầm (tunneling).

Xác suất ấy giảm theo hàm mũ của bề dày tường. Vì vậy dạng dòng là:

$$
I_{gate} \approx A\left(\frac{V_{DD}}{t_{ox}}\right)^2 \exp\left(-B\frac{t_{ox}}{V_{DD}}\right).
$$

Chỗ đáng sợ nằm trong hàm mũ, không nằm ở \(A\). Mỏng thêm cỡ \(0.2\,\mathrm{nm}\) — chưa đầy một lớp — dòng cổng tăng cỡ **10 lần**.

Hai hình dạng của tường:

1. **Xuyên hầm trực tiếp.** Điện áp trên oxit còn nhỏ hơn chiều cao tường. Tường nhìn như hình thang. Electron đi từ dải dẫn của cổng sang dải dẫn của silicon. Đây là lối chính khi oxit nano.
2. **Xuyên hầm Fowler–Nordheim.** Điện áp lớn hơn chiều cao tường. Tường bị bẻ thành hình tam giác. Hạt chỉ chui qua phần mũi mỏng, không chui qua cả bề dày.

**Vì sao cổng nMOS rò hơn cổng pMOS khoảng 10 đến 100 lần.**

1. Electron nhẹ hơn lỗ trống (khối lượng hiệu dụng nhỏ hơn). Sóng của hạt nhẹ tắt chậm hơn trong tường.
2. Bậc năng lượng dải dẫn giữa \(\mathrm{Si}\) và \(\mathrm{SiO}_2\) chỉ khoảng \(3.15\,\mathrm{eV}\). Bậc dải hóa trị đối với lỗ trống khoảng \(4.5\,\mathrm{eV}\). Tường thấp hơn thì đuôi sóng lớn hơn.

**Cách làm tường dày lại mà không làm cổng yếu.** Điện dung cổng là

$$
C_{ox} = \frac{\kappa\epsilon_0}{t_{phys}}.
$$

Bạn muốn \(C_{ox}\) lớn (cổng vẫn ra lệnh được) **và** \(t_{phys}\) lớn (sóng tắt hết). Hai mong muốn đánh nhau nếu \(\kappa\) cố định. Tăng \(\kappa\) thì được cả hai.

\(\mathrm{SiO}_2\) có \(\kappa = 3.9\). \(\mathrm{HfO}_2\) có \(\kappa\) cỡ \(20\) đến \(25\), khoảng 5 lần lớn hơn. Tăng bề dày vật lý lên khoảng 5 lần, tới \(t_{phys} \approx 5\) đến \(6\,\mathrm{nm}\), thì \(C_{ox}\) giữ nguyên. Bề dày điện tương đương (EOT — bề dày \(\mathrm{SiO}_2\) giả tưởng cho cùng điện dung) vẫn cỡ \(1\,\mathrm{nm}\).

Sóng không nhìn EOT. Sóng nhìn bề dày thật. Tường \(6\,\mathrm{nm}\) gần như tắt đuôi sóng. Dòng xuyên hầm cổng giảm hơn khoảng 100 lần. Intel đưa cổng kim loại và điện môi \(\kappa\) cao (high-\(\kappa\) metal gate, HKMG) vào sản xuất năm 2007, ở nút \(45\,\mathrm{nm}\). Khung dưới Hình 4.3(c) là hình này.

**Một câu:** "Dòng cổng là cái đuôi sóng qua một tường quá mỏng. Muốn tường dày mà lực cổng vẫn mạnh, phải đổi sang vật liệu có \(\kappa\) cao, không phải mài \(\mathrm{SiO}_2\) mỏng thêm."

---

### 3.4 Lối thứ ba: tiếp giáp bị phân cực ngược

Source và drain \(n^+\) cắm vào đế \(p\), hoặc vào giếng. Các tiếp giáp ấy thường bị phân cực ngược. Chúng rò theo hai cách.

**Sinh cặp vì nhiệt.** Trong vùng nghèo, nhiệt thỉnh thoảng bẻ một liên kết, sinh một electron và một lỗ trống. Điện trường quét chúng đi. Dòng diode ngược:

$$
I_D = I_s\left(e^{V_D/v_T}-1\right) \xrightarrow{V_D \ll -v_T} -I_s.
$$

Ở nhiệt độ phòng, thành phần này rất nhỏ, dưới cỡ \(1\,\mathrm{fA}/\mu\mathrm{m}^2\).

**Chui từ dải này sang dải kia (band-to-band tunneling, BTBT).** Halo và đế pha rất đậm, trên \(10^{18}\,\mathrm{cm}^{-3}\), để chống kênh ngắn. Vùng nghèo của tiếp giáp bị ép còn vài nanomet. Đồng thời dải dẫn bên \(n\) bị kéo xuống **thấp hơn** dải hóa trị bên \(p\). Electron không cần trèo qua cả vùng cấm \(E_g = 1.12\,\mathrm{eV}\). Nó chui ngang từ dải hóa trị của đế sang dải dẫn của drain. \(V_{ds}\) cao thì chỗ chồng dải càng rõ, dòng BTBT càng lớn. Ở công nghệ nano, đây mới là phần chính của dòng rò tiếp giáp, không phải dòng nhiệt \(I_s\).

**Một câu:** "Tiếp giáp ngược vừa sinh hạt vì nhiệt, vừa cho hạt chui ngang qua vùng cấm khi vùng nghèo bị pha đậm đến mức mỏng vài nanomet."

---

### 3.5 Nóng làm hai việc ngược nhau

Chip trong máy chủ có thể ở \(70\) đến \(85^\circ\mathrm{C}\). Chip gần động cơ có thể tới \(125^\circ\mathrm{C}\). Nhiệt độ kéo hai thông số theo hai chiều.

**Độ linh động giảm khi nóng.** Mạng tinh thể rung mạnh hơn. Hạt đập phonon nhiều hơn.

$$
\mu(T) = \mu(T_0)\left(\frac{T}{T_0}\right)^{-k_\mu}, \qquad k_\mu \approx 1.5 \text{ đến } 2.
$$

Từ \(25^\circ\mathrm{C}\) (\(298\,\mathrm{K}\)) lên \(125^\circ\mathrm{C}\) (\(398\,\mathrm{K}\)), tỷ số nhiệt độ là \(1.34\). Với \(k_\mu = 1.5\), \(\mu\) còn khoảng \(65\%\). Với \(k_\mu = 2\), còn khoảng \(56\%\). Nói "giảm cỡ \(40\%\)" là đúng cỡ.

**\(V_t\) giảm khi nóng.** \(n_i\) tăng, mức Fermi tiến về giữa vùng cấm, \(\phi_F\) giảm.

$$
\frac{dV_t}{dT} \approx -1 \text{ đến } -2\,\mathrm{mV}/^\circ\mathrm{C}.
$$

Trên \(100^\circ\mathrm{C}\), \(V_t\) giảm cỡ \(100\) đến \(150\,\mathrm{mV}\).

Bây giờ hỏi dòng tăng hay giảm. Câu trả lời phụ thuộc bạn đang đứng ở đâu trên Hình 4.4(b).

**Đang bật mạnh,** \(V_{gs} = V_{DD}\) khá lớn so với \(V_t\). \((V_{gs}-V_t)\) chỉ tăng một chút khi \(V_t\) giảm \(0.1\,\mathrm{V}\). Trong khi \(\mu\) mất khoảng \(40\%\). \(\mu\) thắng. Dòng bật giảm. Chip nóng chạy chậm hơn. Đây là chuyện quen của chip số điện áp thường.

**Đang tắt,** \(V_{gs} = 0\). Cả hai chiều đều làm rò tăng: đồi thấp hơn vì \(V_t\) giảm, và đuôi nhiệt dài hơn vì \(v_T\) tăng. Dòng tắt ở \(125^\circ\mathrm{C}\) cỡ \(20\) đến \(50\) lần dòng tắt ở \(25^\circ\mathrm{C}\).

Nếu rò sinh nhiệt, nhiệt lại tăng rò, vòng ấy gọi là thoát nhiệt tự tăng (thermal runaway). Nó không tự dừng chỉ vì bạn hạ xung nhịp, vì dòng rò không cần xung nhịp.

**Điểm hai đường cắt nhau.** Hình 4.4(b): đường lạnh \(0^\circ\mathrm{C}\) và đường nóng \(125^\circ\mathrm{C}\) cắt nhau gần \(V_{gs} \approx 0.52\,\mathrm{V}\). Đó là điểm hệ số nhiệt bằng 0 (zero-temperature coefficient, ZTC). Đứng đúng chỗ ấy, dòng không thèm biết nhiệt độ.

Bên trái điểm cắt, tức \(V_{gs}\) nhỏ: đường nóng nằm **trên** đường lạnh. Mất \(100\,\mathrm{mV}\) điện áp ngưỡng là một phần rất lớn của \((V_{gs}-V_t)\) khi \((V_{gs}-V_t)\) vốn đã nhỏ. \(V_t\) thắng \(\mu\). Nóng thì chạy nhanh hơn.

Bên phải điểm cắt: lạnh chạy nhanh hơn. \(\mu\) thắng.

Vì vậy một mạch gần ngưỡng, \(V_{DD}\) cỡ \(0.4\) đến \(0.5\,\mathrm{V}\) (một số mạch IoT, mạch cấy), có thể **chậm nhất khi trời lạnh**, không phải khi nóng. Ký duyệt thời gian phải thử cả hai đầu nhiệt độ. Đây là chỗ Hình 4.4(b) đáng giá hơn một đoạn chữ.

**Một câu:** "Nóng làm hạt va nhiều hơn nên chậm, và làm \(V_t\) thấp hơn nên dễ bật. Bật mạnh thì cái chậm thắng. Gần ngưỡng thì cái dễ bật thắng. Hai đường gặp nhau ở khoảng \(0.5\,\mathrm{V}\)."

### Tự kiểm Giờ 3

1. Vì sao \(S\) không xuống dưới khoảng \(60\,\mathrm{mV/decade}\) ở nhiệt độ phòng, với transistor trèo đồi?
2. Vì sao tăng \(\kappa\) lên 5 lần cho phép tường dày gấp 5 mà \(C_{ox}\) không đổi? Sóng electron nhìn bề dày nào?
3. Một mạch \(V_{DD} = 0.4\,\mathrm{V}\). Góc chậm của nó có thể là góc nóng hay góc lạnh? Nhìn Hình 4.4(b) rồi trả lời.

---

## Giờ 4. Không có hai transistor giống hệt nhau

*Slide 23–26. Mục tiêu: 60 phút.*

Bạn không thử một cái cầu bằng chiếc xe tải trung bình. Bạn thử chiếc xe nặng nhất vào ngày cầu yếu nhất, và thử chiếc xe nhanh nhất vào ngày đường trơn. PVT là câu đó, viết cho transistor.

### 4.1 Ba lý do nhà máy không vẽ được hai lần cùng một hình

Tham số thật dao động quanh mức điển hình (typical).

1. **Chiều dài cổng \(\Delta L\).** Ánh sáng in cổng (DUV, EUV) có bước sóng hữu hạn. Khắc ăn cũng không đều. \(L\) in ra không đúng từng nanomet trên bản vẽ.
2. **Bề dày điện môi \(\Delta t_{ox}\).** Mọc oxit mà lệch một lớp nguyên tử, phần trăm đã lớn, vì màng vốn chỉ vài lớp.
3. **Đếm nguyên tử tạp chất.** Một kênh cỡ \(20\,\mathrm{nm} \times 20\,\mathrm{nm}\) chỉ chứa khoảng vài chục nguyên tử boron. Đây là thống kê số nhỏ. Nếu có \(N\) nguyên tử, độ lệch điển hình cỡ \(\sqrt{N}\). Với vài chục nguyên tử, lệch vài nguyên tử là chuyện bình thường của sự đếm, không phải chuyện nhà máy "ẩu". Lệch \(3\) đến \(5\) nguyên tử đủ đẩy \(V_t\) hàng chục milivolt giữa hai transistor ngồi cạnh nhau. Tên là thăng giáng tạp chất ngẫu nhiên (random dopant fluctuation, RDF).

**Một câu:** "\(L\) và \(t_{ox}\) lệch vì cách in và cách mọc màng. \(V_t\) còn lệch vì trong kênh nano chẳng có bao nhiêu nguyên tử tạp để mà trung bình cho đều."

---

### 4.2 Nguồn và nhiệt độ cũng không đứng yên

- **\(V_{DD}\)** thường được tính với biên \(\pm 10\%\). Dây kim loại có điện trở: dòng chạy qua thì sụt một đoạn \(IR\) (IR drop). Dây cũng có điện cảm: dòng đổi rất nhanh thì hiện một điện áp \(L\,di/dt\) (ground bounce — nền và nguồn bị nảy). Nguồn danh định \(1.0\,\mathrm{V}\) có thể thành \(0.9\,\mathrm{V}\) hoặc \(1.1\,\mathrm{V}\) ngay tại transistor.
- **Nhiệt độ** đi từ môi trường lạnh (\(0^\circ\mathrm{C}\), có khi \(-40^\circ\mathrm{C}\)) tới nhiệt độ tự nóng khi tải nặng (\(105\) đến \(125^\circ\mathrm{C}\)).

Ba chữ P, V, T là process, voltage, temperature: quy trình, điện áp, nhiệt độ. Một "góc" là một tổ hợp ở biên, không phải một điểm làm việc dễ chịu.

---

### 4.3 Năm góc, vì nMOS và pMOS không lệch cùng một hướng

Nhà máy xếp transistor thành ba mức tốc độ:

| Mức | Hình trên silicon | Dòng bật | Dòng rò |
| :--- | :--- | :--- | :--- |
| **Fast (F)** | \(L\) ngắn, \(t_{ox}\) mỏng, \(V_t\) thấp | mạnh | lớn |
| **Typical (T)** | đúng mức thiết kế | vừa | vừa |
| **Slow (S)** | \(L\) dài, \(t_{ox}\) dày, \(V_t\) cao | yếu | nhỏ |

nMOS và pMOS dùng các mặt nạ khác nhau (giếng, vùng \(n^+\), vùng \(p^+\)). Sai số của chúng khá độc lập. Kết hợp lại thành năm góc trên Hình 4.4(a). Đám mây elip là phân bố cỡ \(\pm 3\sigma\) quanh TT. Bốn góc kia là các biên người ta cố ý mô phỏng.

| Góc | nMOS | pMOS | Chuyện xảy ra với một inverter |
| :---: | :---: | :---: | :--- |
| **TT** | T | T | Điểm danh định. Đo các số trung bình. |
| **FF** | F | F | Cả hai đều mạnh. Nhanh nhất. Rò nhất. |
| **SS** | S | S | Cả hai đều yếu. Chậm nhất. |
| **FS** | F | S | Kéo xuống mạnh, kéo lên yếu. Đường truyền một chiều (VTC — \(V_{out}\) theo \(V_{in}\)) lệch **sang trái**. Khoảng nhiễu mức thấp \(NM_L\) hẹp. Sợ nền bị nảy. |
| **SF** | S | F | Kéo xuống yếu, kéo lên mạnh. VTC lệch **sang phải**. Khoảng nhiễu mức cao \(NM_H\) hẹp. |

**Vá lỗ hổng:** FF không phải "góc xấu duy nhất" hay "góc tốt duy nhất". FF xấu cho rò và cho dữ liệu đến quá sớm. FF lại dễ sống cho thời gian setup. SS thì ngược lại. Góc không có tính cách. Góc chỉ làm một lỗi nào đó dễ lộ.

![Hình 4.4: Elip các góc, điểm ZTC, và bốn tổ hợp dùng để ký duyệt](images/fig4_4_pvt_variations_and_corners.png)

**Một câu:** "Nhanh hay chậm là của từng loại transistor. n nhanh mà p chậm thì ngưỡng chuyển mạch lệch, dù chip không hẳn nhanh hơn hay chậm hơn."

---

### 4.4 Bốn lần ký duyệt, bốn câu hỏi khác nhau

Ký duyệt (signoff) nghĩa là: trước khi cho đi làm mặt nạ, mạch phải sống được ở tổ hợp biên tương ứng với **đúng cái lỗi** bạn đang sợ. Chọn tổ hợp bằng cách hỏi "tổ hợp nào làm lỗi này dễ xảy ra nhất?"

**1. Trễ dài nhất — thời gian thiết lập (setup).**

Hỏi: dữ liệu có đến kịp trước sườn xung đồng hồ không?

Muốn bắt lỗi, hãy làm mọi transistor chậm: **SS**, \(V_{DD}\) thấp nhất (\(-10\%\)), và nhiệt độ cao nếu mạch ở điện áp thường (nóng thì \(\mu\) thấp, Giờ 3). Ở mạch gần ngưỡng thì phải thử lại đầu lạnh, vì ZTC đã đảo chiều.

$$
T_{clk} \ge t_{pcq} + t_{pd,max} + t_{setup}.
$$

Nếu fail, hạ xung nhịp thì chu kỳ dài ra, dữ liệu kịp đến. Chip vẫn tính đúng. Nó chỉ không đạt tần số đã hứa.

**2. Trễ ngắn nhất — thời gian giữ (hold).**

Hỏi: dữ liệu mới có lao vào flip-flop sau quá sớm, đè lên bit mà flip-flop ấy còn phải giữ, hay không?

Muốn bắt lỗi, hãy làm đường dữ liệu nhanh nhất: **FF**, \(V_{DD}\) cao nhất, nhiệt độ thấp ( \(\mu\) lớn).

$$
t_{pcq,cd} + t_{logic,cd} \ge t_{hold} + t_{skew}.
$$

Nhìn bất đẳng thức. **Không có \(T_{clk}\).** Hạ xung nhịp không thêm được một số nào vào đây.

Hình để khỏi quên: hai người chạy tiếp sức nghe cùng một phát súng. Kéo dài đường đua không ngăn người thứ hai xuất phát trước khi gậy chạm tay, nếu lỗi nằm ngay ở phát súng. Hold là khoảng cách giữa hai việc xảy ra quanh **cùng một sườn**, cộng với độ lệch pha của hai xung đồng hồ (\(t_{skew}\)).

Sửa trên layout: thêm trễ vào đường dữ liệu, thường là một chuỗi buffer hoặc một cặp inverter. Cái giá: thêm diện tích, thêm công suất động, và đường ấy có thể trở thành đường fail setup ở góc SS. Bạn đang tiêu một khoản thời gian mà góc chậm có thể đang cần.

**3. Rò tĩnh lớn nhất.**

**FF** ( \(V_t\) thấp), \(V_{DD}\) cao, nhiệt độ cao. Cả \(I_{sub}\) lẫn \(I_{gate}\) đều được tiếp sức. Dùng số này để tính pin lúc ngủ, và để quyết định có cần ngắt nguồn cả một khối (power gating) hay không. Dòng này không cần xung nhịp.

**4. Công suất động và nhiệt lớn nhất.**

Cùng **FF**, \(V_{DD}\) cao, nhiệt độ cao, và thêm tần số cao nhất, vì

$$
P_{dyn} = \alpha C V_{DD}^2 f.
$$

\(\alpha\) là phần điện dung thật sự chuyển mạch. Số này dùng để chọn cách tản nhiệt và để kiểm tra mật độ dòng trên dây nguồn. Dòng quá dày thì các nguyên tử kim loại bị kéo dần theo dòng, dây mòn và đứt. Việc ấy gọi là electromigration.

Góc 3 và góc 4 cùng một chỗ trên bản đồ PVT, trừ một điểm: công suất động cần \(f_{max}\), dòng rò thì không.

| Việc cần bắt | P | V | T | Hạ xung nhịp có cứu không? |
| :--- | :---: | :---: | :---: | :--- |
| Trễ dài, setup | SS | thấp | nóng (điện áp thường) | Có. Chip chậm lại nhưng còn đúng. |
| Trễ ngắn, hold | FF | cao | lạnh | Không. \(T_{clk}\) không có trong bất đẳng thức. |
| Rò lúc ngủ | FF | cao | nóng | Không. Rò không cần xung nhịp. |
| Công suất động, nhiệt, dây nguồn | FF | cao | nóng, tại \(f_{max}\) | Hạ \(f\) thì \(P_{dyn}\) giảm. Phải tính lại. |

**Một câu:** "Setup là nỗi sợ của con chậm. Hold là nỗi sợ của con nhanh. Hạ đồng hồ chỉ nới thời gian cho con chậm."

### Tự kiểm Giờ 4

1. Vì sao hold không được mô phỏng ở góc SS?
2. FS làm đường VTC lệch về bên nào? Khoảng nhiễu nào bị hẹp?
3. Một mạch \(V_{DD} = 0.45\,\mathrm{V}\). Bạn có dám ký duyệt setup chỉ ở \(125^\circ\mathrm{C}\) không? Nhắc lại điểm ZTC.

---

## Sổ một câu

Che cột phải. Nói cột trái bằng lời của bạn. Rồi mở cột phải.

| Bạn đang kiểm tra | Một câu đủ |
| :--- | :--- |
| Hai điện trường | Cổng ép hạt lên trần oxit. Máng kéo hạt dọc kênh. |
| \(\mu_{eff}\) giảm | Trần gồ ghề. Càng ép mạnh, càng va nhiều. |
| \(I_{dsat}\) bậc 1 | Tốc độ đã kẹt ở \(v_{sat}\). Chỉ còn số hạt tăng theo \((V_{gs}-V_t)\). |
| \(V_{dsat}\) nhỏ | Trần tốc độ tới trước lúc kênh thắt. Giới hạn nhỏ hơn thắng. |
| Đường bão hòa dốc | Vùng nghèo máng ăn ngắn \(L_{eff}\). \(\lambda\) lớn khi \(L\) nhỏ. |
| Body effect | Source cao hơn đế, hố ion sâu hơn, cổng trả thêm, \(V_t\) tăng. |
| DIBL | Máng gần kéo thấp đồi ở source, \(V_t\) giảm, dòng rò tăng theo mũ. |
| Roll-off | Source và drain đã trả ion hai đầu. Kênh ngắn, hóa đơn cổng nhỏ, \(V_t\) giảm. |
| RSCE | Hai túi halo chồng, kênh đậm hơn, \(V_t\) nhích lên trước khi rơi. |
| Dưới ngưỡng | Khuếch tán qua đồi, theo đuôi \(kT\). Tường khoảng \(60\,\mathrm{mV}/\)bậc mười là của cơ chế này. |
| Dòng cổng | Đuôi sóng qua tường quá mỏng. Hàm mũ theo \(t_{ox}\). |
| HKMG | Tăng \(\kappa\) để tăng bề dày thật mà \(C_{ox}\) giữ nguyên. Sóng nhìn bề dày thật. |
| BTBT | Vùng nghèo pha đậm, mỏng, dải năng lượng chồng, hạt chui ngang qua vùng cấm. |
| Nhiệt độ | Nóng: \(\mu\) xuống, \(V_t\) xuống. Bật mạnh thì chậm. Gần ngưỡng thì nhanh. Cắt nhau ở ZTC. |
| RDF | Vài chục nguyên tử tạp. Lệch vài nguyên tử là lệch \(V_t\). |
| Setup và hold | Con chậm trễ dài, hạ đồng hồ cứu được. Con nhanh đến sớm, hạ đồng hồ không có trong bất đẳng thức. |

Nếu một dòng nào bạn nói khác cột phải về **chiều** của hiệu ứng (tăng hay giảm), bạn chưa hiểu. Chiều sai thì mọi mạch sau này sẽ suy ra ngược.

---

## Tên gọi, sau khi đã có hình

| Tên tiếng Anh | Tên tiếng Việt | Gắn vào hình nào |
| :--- | :--- | :--- |
| Mobility degradation | Suy giảm độ linh động | Viên bi bị ép vào trần \(\mathrm{Si}/\mathrm{SiO}_2\) gồ ghề. \(\mu_{eff} = \mu_0 / [1+\theta(V_{gs}-V_t)]\). |
| Velocity saturation \(v_{sat}\) | Bão hòa vận tốc | Tinh thể giật năng lượng bằng phonon quang. Trần cỡ \(10^7\,\mathrm{cm/s}\) với electron. |
| Channel length modulation \(\lambda\) | Biến điệu chiều dài kênh | Vùng nghèo máng ăn \(L_{eff} = L-L_d\). \(I = I_{dsat}(1+\lambda V_{ds})\). |
| Body effect \(\gamma\) | Hiệu ứng đế | \(V_{sb}>0\) làm hố ion sâu hơn. \(V_t\) tăng theo hiệu hai căn. |
| DIBL \(\eta\) | Hạ rào do máng | \(V_t' = V_{t0}-\eta V_{ds}\). |
| Short-channel effect, \(V_t\) roll-off | Hiệu ứng kênh ngắn | Cổng chỉ trả hình thang. \(L\) ngắn thì \(V_t\) giảm. |
| Reverse short-channel effect | Hiệu ứng kênh ngắn ngược | Halo chồng, \(V_t\) tăng một đoạn khi \(L\) giảm. |
| Subthreshold leakage \(I_{sub}\) | Dòng rò dưới ngưỡng | Khuếch tán qua đồi khi \(V_{gs}<V_t\). |
| Subthreshold swing \(S\) | Độ dốc dưới ngưỡng | mV cổng để dòng đổi 10 lần. Tường lý tưởng cỡ \(60\,\mathrm{mV}/\)bậc mười ở \(300\,\mathrm{K}\). |
| Gate tunneling \(I_{gate}\) | Dòng xuyên hầm cổng | Đuôi sóng qua oxit cỡ \(1\,\mathrm{nm}\). |
| High-\(\kappa\) metal gate | Cổng kim loại, điện môi \(\kappa\) cao | \(\mathrm{HfO}_2\), tường dày hơn, \(C_{ox}\) giữ nguyên. |
| Band-to-band tunneling | Xuyên hầm giữa hai dải | Hạt chui ngang vùng cấm ở tiếp giáp pha rất đậm. |
| Temperature inversion, ZTC | Đảo nhiệt, hệ số nhiệt bằng 0 | Dưới khoảng \(0.5\,\mathrm{V}\), nóng chạy nhanh hơn lạnh. |
| Process corners, PVT | Góc quy trình, điện áp, nhiệt độ | Thử đúng biên của đúng cái lỗi. |

---

## Shockley và silicon, đặt cạnh nhau

| Việc | Kênh dài, Shockley | Kênh nano | Hình gốc |
| :--- | :--- | :--- | :--- |
| \(\mu\) | Hằng số \(\mu_0\) | \(\mu_{eff}=\mu_0/[1+\theta(V_{gs}-V_t)]\) | Ép vào trần gồ ghề |
| Vận tốc | \(v=\mu\mathcal{E}\), tăng mãi | Trần \(v_{sat}\approx 10^7\,\mathrm{cm/s}\) | Phonon quang giật năng lượng |
| \(I_{dsat}\) | \(\propto (V_{gs}-V_t)^2\) | \(\propto (V_{gs}-V_t)\) | \(v\) đã là hằng số |
| \(V_{dsat}\) | \(V_{gs}-V_t\) | \((V_{gs}-V_t)\parallel(\mathcal{E}_c L)\), nhỏ hơn nhiều | Trần tốc độ tới trước lúc thắt kênh |
| \(g_{ds}\) lúc bão hòa | \(0\), đường ngang | \(\approx \lambda I_{dsat}\), đường dốc | \(L_{eff}=L-L_d\) |
| \(V_{sb}>0\) | Bỏ qua | \(V_t\) tăng | Hố ion sâu thêm |
| Máng ảnh hưởng \(V_t\) | Không | \(V_t\) giảm \(\eta V_{ds}\) | Đồi ở source bị kéo thấp |
| \(V_{gs}=0\) | \(I=0\) | \(I_{sub}+I_{gate}+I_{junc}>0\) | Đồi nhiệt, tường mỏng, tiếp giáp |

---

## Năm bài tính — số chỉ để kiểm tra hình

Làm bài bằng lời trước. Mỗi bài có một câu "hình của bài này". Nếu câu ấy bạn không nói được, đừng tính. Tính lúc chưa có hình chỉ ra một số bạn không biết để làm gì.

### Bài 1. Trần tốc độ có kéo dòng xuống thật không?

**Hình của bài này:** Shockley dùng \(\mu\) và bình phương. Silicon có \(\mu\) bị trần gồ ghề làm giảm, và có \(v_{sat}\) làm dòng chỉ còn bậc 1. Hãy thấy Shockley cao hơn, và thấy công thức một dòng vẫn chưa phải số đo trên silicon.

nMOS \(65\,\mathrm{nm}\): \(L = 65\,\mathrm{nm}\), \(W = 1\,\mu\mathrm{m}\), \(t_{ox} = 1.2\,\mathrm{nm}\), \(\epsilon_{ox} = 3.9\epsilon_0\), \(V_t = 0.30\,\mathrm{V}\), \(\mu_0 = 350\,\mathrm{cm}^2/\mathrm{V}\cdot\mathrm{s}\), \(\theta = 0.25\,\mathrm{V}^{-1}\), \(v_{sat} = 10^7\,\mathrm{cm/s}\). Đặt \(V_{gs} = V_{ds} = 1.0\,\mathrm{V}\).

1. Tính \(C_{ox}\).
2. Tính \(\mu_{eff}\).
3. So sánh \(I_{sat}\) kiểu Shockley (có dùng \(\mu_{eff}\)) với \(I \approx W C_{ox} v_{sat}(V_{gs}-V_t)\).

**Lời giải.**

1. \(C_{ox}\)

$$
C_{ox} = \frac{3.9 \times 8.854 \times 10^{-14}}{1.2 \times 10^{-7}} \approx 2.878 \times 10^{-6}\,\mathrm{F/cm}^2 = 28.78\,\mathrm{fF}/\mu\mathrm{m}^2.
$$

2. Trần gồ ghề

$$
\mu_{eff} = \frac{350}{1+0.25\times(1.0-0.30)} = \frac{350}{1.175} \approx 298\,\mathrm{cm}^2/\mathrm{V}\cdot\mathrm{s}.
$$

Còn khoảng \(85\%\) của \(\mu_0\). Đúng chiều mục 1.3.

3. Hai công thức dòng

$$
\beta = 298 \times (2.878 \times 10^{-6}) \times \frac{1}{0.065} \approx 0.0132\,\mathrm{A/V}^2,
$$

$$
I_{Shockley} = \frac{\beta}{2}(0.70)^2 \approx 3.23\,\mathrm{mA}.
$$

$$
I_{vsat} \approx (10^{-4}\,\mathrm{cm})(2.878\times 10^{-6})(10^7)(0.70) \approx 2.02\,\mathrm{mA}.
$$

Shockley cao hơn công thức trần tốc độ khoảng \(1.6\) lần, và cao hơn dòng cỡ \(747\,\mu\mathrm{A}\) trên \(1\,\mu\mathrm{m}\) ở đầu chương khoảng \(4\) lần.

Đừng dừng ở \(2.02\,\mathrm{mA}\) rồi gọi đó là dòng đo. Công thức ấy dùng cả \((V_{gs}-V_t)\). Điện tích đúng hơn là \(C_{ox}(V_{gs}-V_t-V_{dsat})\). Với \(\mathcal{E}_c L \approx 0.065\,\mathrm{V}\),

$$
V_{dsat} = \frac{0.70\times 0.065}{0.70+0.065} \approx 0.059\,\mathrm{V},
$$

và dòng dạng \(W C_{ox} v_{sat}(V_{gs}-V_t)^2 / [(V_{gs}-V_t)+\mathcal{E}_c L]\) còn khoảng \(1.8\,\mathrm{mA}\). Khoảng cách từ \(1.8\,\mathrm{mA}\) xuống \(747\,\mu\mathrm{A}\) là điện trở tiếp xúc, và việc không phải mọi hạt chạy đúng \(v_{sat}\) trên suốt kênh. Số để ký duyệt lấy từ model BSIM. Bài này chỉ cần bạn thấy **chiều**: bình phương quá cao, trần tốc độ kéo xuống, công thức một dòng vẫn còn lạc quan.

### Bài 2. Pass transistor tự tắt sớm hơn vì cái hố sâu thêm

**Hình của bài này:** nMOS truyền mức 1. Điện thế ra chính là \(V_{sb}\). Ra càng cao thì \(V_t\) càng tăng. Nó tắt khi \(V_{DD}-V_{out} = V_t(V_{out})\), không phải khi \(V_{DD}-V_{out} = V_{t0}\).

Cho \(V_{DD} = 1.2\,\mathrm{V}\), đế \(0\,\mathrm{V}\), \(V_{t0} = 0.35\,\mathrm{V}\), \(\gamma = 0.45\,\mathrm{V}^{1/2}\), \(\phi_s = 0.65\,\mathrm{V}\). Tìm \(V_{out}\) lớn nhất và \(V_t\) tại đó.

**Lời giải.**

$$
V_{out} = 1.2 - \left[0.35 + 0.45\left(\sqrt{0.65+V_{out}}-\sqrt{0.65}\right)\right].
$$

\(\sqrt{0.65} \approx 0.806\), nên

$$
V_{out} = 1.213 - 0.45\sqrt{0.65+V_{out}}.
$$

Thử \(0.70\,\mathrm{V}\): \(\sqrt{1.35}\approx 1.162\), vế phải \(\approx 0.690\,\mathrm{V}\).

Thử \(0.690\,\mathrm{V}\): \(\sqrt{1.340}\approx 1.158\), vế phải \(\approx 0.692\,\mathrm{V}\).

Dừng ở \(V_{out,max} \approx 0.692\,\mathrm{V}\). Khi ấy

$$
V_t = 1.200 - 0.692 = 0.508\,\mathrm{V}.
$$

Nếu quên body effect, bạn sẽ nói ra đạt \(1.2-0.35 = 0.85\,\mathrm{V}\). Thật ra \(V_t\) tăng thêm khoảng \(0.16\,\mathrm{V}\). Mức 1 bị cụt. Đúng hình mục 2.2.

### Bài 3. Hạ đồi \(68\,\mathrm{mV}\) thì dòng rò nhân lên bao nhiêu?

**Hình của bài này:** DIBL trừ một đoạn \(\eta\Delta V_{ds}\) khỏi \(V_t\). Dòng dưới ngưỡng nhân \(10\) lần mỗi khi đồi thấp đi \(S\) milivolt.

Cho \(\eta = 0.08\), \(S = 85\,\mathrm{mV}/\)bậc mười, \(V_{gs} = 0\). \(V_{ds}\) từ \(0.05\,\mathrm{V}\) lên \(0.90\,\mathrm{V}\).

**Lời giải.**

$$
\Delta V_t = 0.08 \times (0.90-0.05) = 0.068\,\mathrm{V} = 68\,\mathrm{mV}.
$$

$$
\frac{I_{sau}}{I_{trước}} = 10^{68/85} = 10^{0.80} \approx 6.3.
$$

Chỉ việc đưa máng lên \(0.9\,\mathrm{V}\) đã nhân dòng tắt khoảng \(6\) lần. Hạ \(V_{DD}\) lúc ngủ (dynamic voltage scaling — giảm nguồn khi không cần chạy nhanh) hạ luôn \(\eta V_{ds}\), nên tiết kiệm rò mạnh hơn là người ta nghĩ nếu chỉ nhìn dòng ohmic.

### Bài 4. Tường mỏng đáng giá bao nhiêu watt, và tường dày trả lại bao nhiêu?

**Hình của bài này:** Dòng cổng là đuôi sóng, rất nhạy với bề dày thật. HKMG tăng bề dày thật. Bài này chỉ ước lượng **cỡ** công suất, không phải số ký duyệt.

\(500\) triệu inverter, tức \(500\) triệu nMOS và \(500\) triệu pMOS, nút \(45\,\mathrm{nm}\), \(t_{ox} = 1.1\,\mathrm{nm}\) nếu còn dùng \(\mathrm{SiO}_2\). \(J_{gate,n} = 15\,\mathrm{A/cm}^2\), \(J_{gate,p} = 1.5\,\mathrm{A/cm}^2\). Mỗi cổng có diện tích \(W\times L = 100\,\mathrm{nm}\times 45\,\mathrm{nm}\). \(V_{DD} = 1.0\,\mathrm{V}\).

1. Vì sao \(J\) của nMOS gấp \(10\) lần pMOS?
2. Ước lượng công suất rò cổng của cả chip với \(\mathrm{SiO}_2\).
3. \(\mathrm{HfO}_2\) dày vật lý \(5.5\,\mathrm{nm}\) làm mật độ dòng giảm \(150\) lần. Công suất mới cỡ bao nhiêu?

**Lời giải.**

1. Electron thấy tường khoảng \(3.15\,\mathrm{eV}\) và có khối lượng hiệu dụng nhỏ hơn. Lỗ trống thấy tường khoảng \(4.5\,\mathrm{eV}\) và nặng hơn. Sóng electron còn đuôi lớn hơn. Đúng mục 3.3.

2. Diện tích một cổng:

$$
A = (100\times 10^{-7})(45\times 10^{-7}) = 4.5\times 10^{-11}\,\mathrm{cm}^2.
$$

Giả sử **trung bình** mỗi inverter có một transistor đang thấy điện áp đủ để rò cỡ trung bình của n và p. Đây là ước lượng bậc độ lớn. Không phải lúc nào n và p cũng rò cùng lúc.

$$
I_{một\ inverter} \approx 4.5\times 10^{-11}\times\frac{15+1.5}{2} \approx 0.37\,\mathrm{nA}.
$$

$$
I_{chip} \approx 500\times 10^6 \times 0.37\times 10^{-9} \approx 0.186\,\mathrm{A}, \qquad P \approx 0.186\,\mathrm{W}.
$$

3. Giảm \(150\) lần:

$$
P_{HKMG} \approx 186\,\mathrm{mW}/150 \approx 1.2\,\mathrm{mW}.
$$

Tường dày thật, \(C_{ox}\) giữ bằng \(\kappa\) lớn, công suất rò cổng ở ước lượng này rơi từ gần \(0.2\,\mathrm{W}\) xuống khoảng \(1\,\mathrm{mW}\).

### Bài 5. Vì sao góc nhanh làm chết chức năng, còn góc chậm chỉ làm chậm?

**Hình của bài này:** Hold là dữ liệu đến quá sớm quanh một sườn đồng hồ. Muốn bắt nó, phải đứng ở FF, nguồn cao, trời lạnh. \(T_{clk}\) không có trong bất đẳng thức.

Cho \(t_{hold} = 30\,\mathrm{ps}\), \(t_{skew} = 25\,\mathrm{ps}\).

| | Góc nhanh (FF, \(V_{DD}\) cao, \(0^\circ\mathrm{C}\)) | Góc chậm (SS, \(V_{DD}\) thấp, \(125^\circ\mathrm{C}\)) |
| :--- | :---: | :---: |
| \(t_{pcq,cd}\) | \(40\,\mathrm{ps}\) | \(85\,\mathrm{ps}\) |
| \(t_{logic,cd}\) | \(10\,\mathrm{ps}\) | \(22\,\mathrm{ps}\) |

1. Vì sao không được lấy góc chậm để kết luận "hold ổn"?
2. Góc nhanh có vi phạm không?
3. Sửa bằng cách nào trên layout, và cái giá là gì?

**Lời giải.**

1. Góc chậm làm đường dữ liệu dài. Nó che mất việc dữ liệu có thể đến quá sớm. Hold chỉ lộ khi đường ấy ngắn nhất: FF, nguồn cao, lạnh, \(\mu\) lớn.

2. Điều kiện an toàn:

$$
t_{pcq,cd}+t_{logic,cd} \ge t_{hold}+t_{skew}.
$$

Góc nhanh: \(40+10 = 50\,\mathrm{ps}\). Cần \(30+25 = 55\,\mathrm{ps}\).

$$
\text{slack} = 50-55 = -5\,\mathrm{ps}.
$$

Thiếu \(5\,\mathrm{ps}\). Chip sai chức năng ở mọi tần số, vì hạ tần số không thêm số vào bất đẳng thức này.

3. Thêm trễ trên đường dữ liệu, khoảng \(10\,\mathrm{ps}\) ở **góc nhanh**, để slack dương cỡ \(+5\,\mathrm{ps}\) (\(50+10 = 60\), cần \(55\)). Thường là buffer hoặc cặp inverter. Cái giá: thêm diện tích, thêm \(P_{dyn}\), và chính khoản trễ ấy có thể làm fail setup ở góc SS. Phải kiểm lại góc chậm sau khi thêm. Bạn không được sửa hold bằng cách chỉ nhìn góc hold.
