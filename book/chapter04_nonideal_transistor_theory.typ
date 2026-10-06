#set page(
  paper: "a4",
  margin: (x: 1.85cm, top: 1.9cm, bottom: 1.85cm),
  header: align(right)[
    #text(size: 8pt, fill: rgb("#64748b"))[Chương 4 · Học theo cách Feynman · Hình trước, tên sau]
  ],
  footer: [
    #line(length: 100%, stroke: 0.4pt + rgb("#cbd5e1"))
    #v(2pt)
    #grid(
      columns: (1fr, auto),
      align(left)[#text(size: 8pt, fill: rgb("#94a3b8"))[VLSI · UIT · 4 giờ · đối chiếu slide chapter4-nonideal]],
      align(right)[#context text(size: 8.5pt, weight: "bold", fill: rgb("#334155"))[#counter(page).display()]]
    )
  ]
)

#set text(font: "Segoe UI", size: 10.5pt, lang: "vi")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: none)
#set figure(numbering: none)

#let callout(title, body, border-color, bg-color) = block(
  breakable: true,
  fill: bg-color,
  stroke: (left: 3.5pt + border-color),
  inset: (x: 10pt, y: 8pt),
  radius: (right: 3pt),
  width: 100%,
  [
    #text(weight: "bold", size: 10pt, fill: border-color)[#title]
    #v(2pt)
    #body
  ]
)

#let hinh(body) = callout([Hình — đọc trước, che công thức], body, rgb("#0369a1"), rgb("#f0f9ff"))
#let lo(body) = callout([Vá lỗ hổng], body, rgb("#be123c"), rgb("#fff1f2"))
#let congthuc(body) = callout([Vì sao công thức có dạng này], body, rgb("#6d28d9"), rgb("#f5f3ff"))
#let so(body) = callout([Một số để kiểm tra hình], body, rgb("#047857"), rgb("#ecfdf5"))
#let cau(body) = callout([Một câu, sau khi đóng sách], body, rgb("#334155"), rgb("#f8fafc"))

#align(center)[
  #text(size: 20pt, weight: "bold", fill: rgb("#0f172a"))[Chương 4]
  #v(2pt)
  #text(size: 14pt, fill: rgb("#0f172a"))[Transistor thật không đi theo công thức Chương 3]
  #v(4pt)
  #text(size: 10.5pt, fill: rgb("#334155"))[Hiệu ứng điện trường cao, điện áp ngưỡng, dòng rò, và góc PVT]
  #v(2pt)
  #text(size: 9.5pt, style: "italic", fill: rgb("#64748b"))[
    Học theo cách Richard Feynman: hình bạn nói được, rồi mới đến tên, rồi công thức chỉ để kiểm tra câu ấy.
  ]
  #v(6pt)
  #line(length: 100%, stroke: 1.4pt + rgb("#0369a1"))
]

#v(8pt)

== Cách học chương này

Feynman không học bằng cách chép định nghĩa. Ông giải thích lại cho một người chưa biết từ chuyên môn. Chỗ nào phải núp sau một từ tiếng Anh mà không vẽ được, chỗ đó là lỗ hổng.

Mỗi mục đi sáu bước. Làm đủ rồi mới sang mục sau.

1. Đọc khung *Hình*. Che công thức.
2. Nói lại cho người chưa học môn này. Lần đầu không dùng tên tiếng Anh.
3. Nếu bạn bí và phải thốt ra một từ bạn không vẽ được, đó là lỗ hổng. Đọc khung *Vá lỗ hổng*.
4. Nói lại lần hai, chỉ một câu.
5. Mở công thức. Công thức phải nói cùng câu đó.
6. Nhìn con số cuối mục. Số để kiểm tra chiều của hiệu ứng, không để thuộc lòng.

Bảng tên nằm ở cuối, sau khi hình đã có chỗ để gắn tên. Vật lý không đổi so với slide UIT chapter4-nonideal (trang 1–26) và sách Weste & Harris. Đổi cách học.

Từ Chương 3 bạn đã có: tụ MOS, ba chế độ tích lũy / nghèo / đảo, dòng Shockley, và tỷ lệ $W_p$ trên $W_n$ khoảng 2 đến 3. Chương này bắt đầu khi những giả định đó không còn đúng, từ $L <= 0.25 mu"m"$ đi vào $90 "nm"$, $65 "nm"$, $28 "nm"$.

#v(4pt)
#table(
  columns: (0.7fr, 2.2fr, 2.6fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: 5.5pt,
  [*Giờ*], [*Một câu hỏi*], [*Xong giờ, bạn nói được*],
  [1], [Vì sao đường $I$–$V$ không giống hình bình phương?], [Một lực ép hạt lên trần oxit. Một lực đẩy hạt dọc kênh cho đến khi tinh thể giật mất tốc độ.],
  [2], [Vì sao $V_t$ không phải số in trên vỏ?], [Ba cách đổi hóa đơn điện tích của cổng: đế, máng, và chiều dài kênh.],
  [3], [Vì sao tắt rồi vẫn còn dòng?], [Ba lối: trèo đồi bằng nhiệt, chui qua tường oxit, chui qua tiếp giáp. Rồi cuộc kéo co của nhiệt độ.],
  [4], [Muốn bắt chip hỏng thì thử tổ hợp nào?], [Góc chậm bắt trễ dài. Góc nhanh bắt dữ liệu đến quá sớm. Hạ xung nhịp chỉ cứu được một trong hai.],
)


== Giờ 1 — Hai lực, và một cái trần tốc độ
#text(size: 9.5pt, fill: rgb("#64748b"))[Slide 3–10 · khoảng 60 phút · chỉ nói chuyện transistor đang bật. Chuyện dòng lúc tắt để Giờ 3.]

=== Ba lời hứa mà phép đo không giữ

Shockley cho kênh dài hứa ba điều. Nói bằng lời thường:

+ Cổng chưa đủ ngưỡng thì không có dòng.
+ Khi đã bão hòa, dòng đứng yên dù máng tăng.
+ Dòng bão hòa tăng theo bình phương $(V_(g s) - V_t)$. Các đường phải giãn dần, không cách đều.

Viết lại cho khỏi quên dạng:

$ I_(d s) = 0 "khi" V_(g s) < V_t $

$ I_(d s) = beta [ (V_(g s) - V_t) V_(d s) - V_(d s)^2 / 2 ] "khi" V_(d s) "còn nhỏ" $

$ I_(d s) = beta / 2 (V_(g s) - V_t)^2 "khi đã bão hòa theo kiểu kênh dài" $

Trên tiến trình $65 "nm"$, $V_(D D) = 1.0 "V"$ (cỡ số tiến trình IBM $65 "nm"$):

+ Dòng bật chỉ cỡ $747 mu"A" \/ mu"m"$. Shockley cho số lớn hơn $1500 mu"A" \/ mu"m"$.
+ Tăng $V_(g s)$ theo bước đều $0.4 -> 0.6 -> 0.8 -> 1.0 "V"$, các đường *cách đều*, gần bậc 1.
+ Trong vùng bão hòa, đường vẫn dốc lên theo $V_(d s)$.

Ba lời hứa gãy vì ba hình khác nhau. Đừng gộp thành một từ "phi lý tưởng".

#figure(
  image("images/fig4_1_high_field_effects.png", width: 100%),
  caption: [Hình 4.1. (a) Cổng ép electron vào mặt oxit gồ ghề. (b) Vận tốc không tăng mãi: electron chạm trần khoảng $10^7 "cm/s"$, lỗ trống thấp hơn. (c) Đường 65 nm cách đều và hơi dốc. Đường Shockley nét đứt thì giãn và nằm ngang.]
)

#cau[Shockley vẽ họ đường giãn dần và nằm ngang. Silicon vẽ họ đường cách đều và hơi dốc.]

=== Hai lực, hai hướng

Thu nhỏ kích thước mà $V_(D D)$ không thu cùng tỷ lệ thì điện trường bên trong tăng. Có hai mũi tên. Trộn chúng là rối cả giờ.

#hinh[
  *Mũi tên thứ nhất* vuông góc với kênh, xuyên qua oxit, do cổng gây ra. Nó không kéo dòng từ source sang drain. Nó ép hạt lên trần.

  $ cal(E)_(v e r t) = (V_(g s) - V_(d s) / 2) / t_(o x) $

  Có $V_(d s)/2$ vì điểm giữa kênh không nằm ở điện thế source. Với $t_(o x) approx 1.2 "nm" = 1.2 times 10^(-7) "cm"$ và $V_(g s) = 1 "V"$,

  $ cal(E)_(v e r t) approx 1.0 / (1.2 times 10^(-7)) approx 8 times 10^6 "V/cm" $

  Cùng cỡ điện trường làm hỏng chất cách điện.

  *Mũi tên thứ hai* nằm dọc kênh, do máng gây ra:

  $ cal(E)_(l a t) = V_(d s) / L $

  $L = 65 "nm"$, $V_(d s) = 1 "V"$ thì $cal(E)_(l a t) approx 1.5 times 10^5 "V/cm" = 150 "kV/cm"$.
]

#lo[Mỗi lần gặp từ "điện trường", hỏi: mũi tên vuông góc với kênh, hay nằm dọc kênh? Vuông góc thì đổi độ linh động. Dọc kênh thì đổi vận tốc.]

#cau[Cổng ép hạt lên trần. Máng kéo hạt dọc đường. Hai việc ấy không thay nhau được.]

=== Viên bi và cái trần gồ ghề

#hinh[
  Electron là một viên bi. Trường dọc yếu thì bi lăn trong lòng silicon, $mu$ gần như số của vật liệu, cỡ vài trăm $"cm"^2"/V·s"$.

  Bật cổng mạnh, $cal(E)_(v e r t) > 10^6 "V/cm"$. Bi bị ép sát mặt silicon và $S i O_2$. Silicon là tinh thể, oxit là thủy tinh. Chỗ gặp nhau lồi lõm, có liên kết đứt và điện tích bẫy.

  Bi vừa bị ép lên vừa phải lăn ngang, nên đập trần liên tục. Quãng bay tự do ngắn lại. Cùng một lực đẩy ngang, bi trôi chậm hơn. Đó là suy giảm độ linh động. Tên tiếng Anh, *sau* khi đã thấy viên bi, là mobility degradation. Hình 4.1(a).
]

#congthuc[
  Càng tăng $V_(g s)$ càng ép mạnh, càng va nhiều. Mẫu số phải lớn dần theo $(V_(g s) - V_t)$:

  $ mu_(e f f) = mu_0 / (1 + theta (V_(g s) - V_t)) $

  $mu_0$ là độ linh động lúc trường còn yếu. $theta$ cỡ $0.1$ đến $0.4 "V"^(-1)$.

  Tăng cổng được thêm điện tích, nhưng mỗi hạt chạy kém đi. Hai hiệu ứng đánh nhau. Dòng thật tăng ít hơn dòng trong đầu.
]

#so[
  $theta = 0.25 "V"^(-1)$, $V_(g s) - V_t = 0.7 "V"$:

  $ mu_(e f f) = mu_0 / (1 + 0.175) approx 0.85 mu_0 $

  Khoảng 15% biến mất chỉ vì trần gồ ghề.
]

#cau[Tăng cổng thì được thêm điện tích, nhưng hạt bị ép vào tường nhám nên mỗi hạt chạy kém hơn.]

=== Trần tốc độ không phải biển báo

#hinh[
  Shockley còn giả sử vận tốc tăng mãi: $v = mu cal(E)_(l a t)$. Thử $mu = 400 "cm"^2"/V·s"$ và $cal(E)_(l a t) = 1.5 times 10^5 "V/cm"$:

  $ v = 400 times 1.5 times 10^5 = 6 times 10^7 "cm/s" $

  Silicon không cho số đó. Electron bay trong mạng nguyên tử. Khi trường ngang vượt ngưỡng $cal(E)_c$, động năng đủ để rung mạnh một nguyên tử. Electron nhả một gói rung của mạng, gọi là phonon quang, cỡ $63 "meV"$ trong silicon. Nó mất tốc và phải chạy lại từ đầu.

  Đạp mạnh hơn không nâng trần. Nó chỉ làm electron gặp các gói rung thường xuyên hơn. Giống xe đạp trên đường đầy gờ giảm tốc: đạp mạnh thì gặp gờ dày hơn, tốc độ trần đứng yên.

  Hình 4.1(b): đường nét đứt đi lên mãi. Đường thật áp vào trần.
  - Electron: $v_(s a t) approx 10^7 "cm/s"$, $cal(E)_c approx 10 "kV/cm"$.
  - Lỗ trống: $v_(s a t) approx 8 times 10^6 "cm/s"$, $cal(E)_c$ cỡ $25 "kV/cm"$, vì lỗ trống nặng hơn.
]

#congthuc[
  Dạng làm cho $v$ áp vào trần, bạn không cần thuộc $alpha$:

  $ v = frac(mu_(e f f) cal(E)_(l a t), [1 + (cal(E)_(l a t) \/ cal(E)_c)^alpha]^(1\/alpha)) $

  Khi trường rất lớn, $v$ tiến tới $v_(s a t)$. $alpha = 2$ với electron, $alpha = 1$ với lỗ trống. Mẫu số nở ra nên $v$ ngừng tăng.

  Dòng qua một lát cắt là điện tích nhân vận tốc: $I = W Q_(i n v) v$. Khi $v$ kẹt ở $v_(s a t)$,

  $ I_(d s a t) = W C_(o x) (V_(g s) - V_t - V_(d s a t)) v_(s a t) $

  $v_(s a t)$ là hằng số. Phần còn đổi được là số hạt, và số hạt đi theo $(V_(g s) - V_t)$, *bậc 1*. Bình phương chết vì bình phương đến từ $v = mu cal(E)$ và từ cách kênh dài bị thắt. Cả hai không còn là chuyện chính. Vì vậy Hình 4.1(c) cách đều.

  Kênh dài chỉ bão hòa khi kênh thắt ở máng: $V_(d s a t) = V_(g s) - V_t$. Kênh ngắn: hạt đã chạm trần tốc độ từ trước. Hai giới hạn, cái nhỏ hơn thắng, chỗ chuyển tiếp thì trơn — cùng dạng hai điện trở song song:

  $ 1 / V_(d s a t) = 1 / (V_(g s) - V_t) + 1 / (cal(E)_c L) $
]

#so[
  Số tròn: $V_(g s) - V_t = 0.7 "V"$, $cal(E)_c L approx 0.1 "V"$.

  $ V_(d s a t) = (0.7 times 0.1) / 0.8 = 0.088 "V" $

  Với $L = 65 "nm"$ và $cal(E)_c = 1 "V"\/mu"m"$, thì $cal(E)_c L approx 0.065 "V"$, còn nhỏ hơn. Bão hòa đến rất sớm.
]

#lo["Bão hòa" ở Chương 3 nghĩa là kênh bị thắt. "Bão hòa vận tốc" ở chương này nghĩa là *tốc độ hạt* đứng. Hai từ trùng, hai hình khác. Hỏi: cái gì đang bão hòa?]

#cau[Hạt đã chạy hết tốc. Muốn thêm dòng chỉ còn cách bỏ thêm hạt, và số hạt tăng thẳng theo cổng, không theo bình phương.]

=== Cái kênh bị ăn ngắn

#hinh[
  Vận tốc đã chạm trần mà đường dòng vẫn dốc. Nhìn nửa phải Hình 4.1(c).

  Drain $n^+$ ở điện thế cao, đế $p$ ở $0 "V"$. Tiếp giáp bị phân cực ngược. Phân cực ngược mở một vùng nghèo: hết hạt tự do, còn ion cố định. Vùng này ăn lấn vào kênh một đoạn $L_d$ khi $V_(d s)$ tăng.

  $ L_d prop sqrt(V_(d s) - V_(d s a t)) , quad L_(e f f) = L - L_d $

  Dòng tỉ lệ nghịch với đoạn kênh còn lại. Đoạn còn lại ngắn đi thì dòng tăng, dù mỗi hạt đã kẹt ở trần tốc độ.
]

#congthuc[
  Với đoạn bị ăn còn nhỏ so với $L$:

  $ I_(d s) = I_(d s a t) (1 + lambda V_(d s)) , quad lambda prop 1 / L $

  Cùng một đoạn $L_d$, kênh ngắn mất một *phần trăm* lớn hơn. Vì vậy transistor ngắn dốc hơn.

  Độ dốc là điện dẫn ra: $g_(d s) approx lambda I_(d s a t) = 1 / r_o$. Khuếch đại của một tầng tương tự là $A_v = - g_m r_o$. Mạch số thấy một đường không phẳng. Mạch tương tự thấy độ lợi giảm.
]

#cau[Máng càng cao thì càng ăn bớt kênh. Kênh cụt hơn thì cùng một trần tốc độ lại đẩy được nhiều dòng hơn.]

#block(fill: rgb("#f8fafc"), inset: 8pt, width: 100%, stroke: 0.4pt + rgb("#e2e8f0"))[
  *Đóng sách, nói ba câu rồi mới sang Giờ 2.*
  Tăng $V_(g s)$ làm $mu$ đổi chiều nào? Vì sao các đường $I_(d s)$ cách đều? Vì sao đường bão hòa dốc, và vì sao kênh ngắn dốc hơn?
]


== Giờ 2 — $V_t$ là một hóa đơn điện tích
#text(size: 9.5pt, fill: rgb("#64748b"))[Slide 11–15 · khoảng 60 phút]

=== $V_t$ thật ra là câu hỏi này

Cổng phải kéo các dải năng lượng ở mặt silicon đủ cong để mặt đầy electron như đế đầy lỗ trống. Mốc ấy là $phi_s = 2 phi_F$. $V_t$ là điện áp cổng đủ để làm việc đó.

Việc đó là bài toán điện tích. Cổng phải đủ điện tích dương để đuổi lỗ trống, để lại ion boron âm $B^-$ trong vùng nghèo, rồi mới kéo electron tạo kênh. Hễ hóa đơn ion tăng, hoặc có kẻ trả giúp, hoặc có kẻ bẻ dải năng lượng giúp cổng, thì $V_t$ đổi. Ba mục sau là ba cách ấy.

#figure(
  image("images/fig4_2_threshold_voltage_effects.png", width: 100%),
  caption: [Hình 4.2. (a) Source cao hơn đế, vùng nghèo dày, $V_t$ tăng. (b) $V_(d s)$ cao kéo thấp đỉnh đồi ở phía source. (c) Không có halo thì $V_t$ chỉ giảm khi $L$ ngắn. Có halo thì có một đỉnh trước khi rơi.]
)

#cau[$V_t$ là điện áp để trả xong hóa đơn ion rồi mới có kênh. Đổi hóa đơn là đổi $V_t$.]

=== Nâng source lên là đào cái hố sâu thêm

#hinh[
  Inverter thường: source nMOS và đế cùng $0 "V"$, nên $V_(s b) = 0$ và $V_t = V_(t 0)$.

  Hai chỗ source không ở 0:
  - nMOS truyền mức 1. Điện thế phía ra nâng dần.
  - nMOS trên cùng của một chồng NAND. Khi xả, các nMOS bên dưới kê source của nó lên.

  Source $n^+$ cao hơn đế $p$ thì tiếp giáp ấy phân cực ngược. Vùng nghèo dưới cổng dày ra. Hình 4.2(a): hố ion âm phình xuống. Hố sâu hơn thì nhiều ion $B^-$ hơn. Cổng phải trung hòa chúng *trước khi* có electron thừa làm kênh. $V_t$ tăng.
]

#congthuc[
  Bề rộng vùng nghèo đi theo căn điện thế, cùng lý do với diode phân cực ngược:

  $ W_(d e p) = sqrt(2 epsilon_(s i) (phi_s + V_(s b)) / (q N_A)) $

  Điện tích ion tỉ lệ với bề rộng ấy. Chỉ tính phần tăng thêm so với $V_(s b) = 0$:

  $ V_t = V_(t 0) + gamma ( sqrt(phi_s + V_(s b)) - sqrt(phi_s) ) $

  $phi_s = 2 phi_F$ thường cỡ $0.6$ đến $0.7 "V"$. $gamma$ nói cổng nhạy với đế đến mức nào. Tử là "hố chứa bao nhiêu ion". Mẫu là $C_(o x)$: oxit dày thì cùng một lượng ion làm đổi điện áp nhiều hơn.

  $ gamma = sqrt(2 q epsilon_(s i) N_A) / C_(o x) approx 0.4 "đến" 0.6 "V"^(1\/2) $

  Khi $V_(s b)$ nhỏ, đường gần thẳng: $V_t approx V_(t 0) + k_gamma V_(s b)$, với $k_gamma approx gamma / (2 sqrt(phi_s)) approx 0.1$ đến $0.3$.
]

#so[
  NAND 4 nMOS nối tiếp. Transistor trên cùng có source bị kê cỡ $0.6 "V"$. $V_t$ có thể từ $0.3 "V"$ lên quá $0.5 "V"$. Dòng xả yếu đi. Trễ dài ra. Không phải lỗi vẽ mạch. Là cái hố ion sâu thêm. Bài 2 tính tiếp chuyện truyền mức 1.
]

#cau[Source cao hơn đế thì vùng nghèo dày thêm. Cổng phải trả thêm ion. $V_t$ tăng.]

=== Máng đứng quá gần nên với tới đồi ở source

#hinh[
  Electron trong source muốn sang drain phải qua một đồi thế năng ở đầu source. Kênh dài, máng ở xa, đồi là việc riêng của cổng.

  Kênh dưới $100 "nm"$, máng ở ngay cạnh. Điện tích dương ở máng kéo đỉnh đồi xuống. Hình 4.2(b): đường xanh $V_(d s) = 0.05 "V"$ là đồi cao, đường đỏ $V_(d s) = 1.0 "V"$ là đồi thấp hơn một đoạn $eta V_(d s)$.

  Đồi thấp thì cổng không cần kéo mạnh bằng trước. $V_t$ giảm. Tên, sau khi đã thấy đồi, là DIBL: drain-induced barrier lowering, hạ rào do máng.
]

#congthuc[
  $ V_t' = V_(t 0) - eta V_(d s) $

  $eta$ cỡ $0.05$ đến $0.15$, tức $50$ đến $150 "mV"$ trên mỗi volt ở máng.
]

#so[
  Inverter ra mức 1, vào mức 0. nMOS lẽ ra tắt, $V_(g s) = 0$, nhưng $V_(d s) = 1.0 "V"$. Với $eta = 0.10$:

  $ Delta V_t = 0.10 times 1.0 = 100 "mV" $

  Giờ 3 sẽ cho thấy dòng dưới ngưỡng nhân theo hàm mũ. Hạ đồi $100 "mV"$ có thể là gần một bậc mười của dòng rò. DIBL và dòng rò là một chuyện, nhìn từ hai đầu.
]

#lo[Body effect *tăng* $V_t$ khi source nâng lên. DIBL *giảm* $V_t$ khi máng nâng lên. Hai cực, hai chiều. Đừng học một câu "điện áp cao thì $V_t$ đổi".]

#cau[Máng càng gần và càng cao thì càng kéo thấp đồi ở source. Cổng đỡ phải kéo. $V_t$ giảm.]

=== Ai trả những ion ở hai đầu kênh

#hinh[
  Giữ mọi điện áp ở source, đế, máng bằng 0. Chỉ rút ngắn $L$ trên bản vẽ. $V_t$ vẫn đổi.

  Vùng nghèo dưới cổng trông như một hộp dài $L$. Nhưng source và drain đã có vùng nghèo riêng, xòe vào hai đầu kênh như hai hình quạt, vì tiếp giáp pn có điện thế tiếp xúc dù bạn chưa đặt $V_(d s)$.

  Ion trong hai hình quạt ấy source và drain đã trả. Cổng chỉ trả hình thang ở giữa. Đó là mô hình chia sẻ điện tích của Yau.

  Kênh dài: hai quạt nhỏ so với $L$, $V_t$ gần $V_(t 0)$. Kênh vài chục nanomet: hai quạt chiếm gần hết $L$, hóa đơn của cổng nhỏ, $V_t$ giảm. Đó là $V_t$ roll-off, đường nét đứt trên Hình 4.2(c).
]

#cau[Hai đầu kênh đã có source và drain trả ion. Kênh càng ngắn, phần cổng phải trả càng nhỏ, $V_t$ càng thấp.]

=== Nhà máy cấy thêm tạp ở hai mép

#hinh[
  Roll-off làm transistor in hơi ngắn có $V_t$ tụt, khó tắt, và có thể hai vùng nghèo chạm nhau. Cổng mất quyền. Việc chạm nhau gọi là punch-through, đấm xuyên.

  Cách chữa: cấy thêm tạp $p$ rất đậm, nghiêng vào đúng hai mép kênh nMOS. Vùng ấy gọi là halo, hay pocket.

  Kênh dài: hai túi nằm xa, giữa kênh vẫn loãng. $L$ cỡ $100$ đến $200 "nm"$: hai túi chồng. $N_A$ trung bình tăng, nên $V_t$ tăng. Ngược với roll-off. Tên là hiệu ứng kênh ngắn ngược, RSCE. Đó là cái bướu xanh trên Hình 4.2(c). Rút $L$ thêm nữa thì roll-off thắng, đường rơi.
]

#lo[Đường $V_t$ theo $L$ không đi một chiều. Có halo thì có một đoạn kênh ngắn vừa, $V_t$ *cao hơn* kênh dài. Nhìn Hình 4.2(c) trước khi nói "kênh ngắn thì $V_t$ thấp".]

#cau[Halo là hai túi tạp đậm ở hai mép. Kênh ngắn vừa đủ thì hai túi chồng, $V_t$ nhích lên, rồi kênh cực ngắn mới rơi.]

#block(fill: rgb("#f8fafc"), inset: 8pt, width: 100%, stroke: 0.4pt + rgb("#e2e8f0"))[
  *Đóng sách.* Pass transistor đang truyền mức 1: $V_t$ tăng hay giảm, cái hố nào sâu thêm? Inverter ra 1 vào 0: $V_t$ của nMOS tăng hay giảm, ai kéo đồi? Vì sao đường có halo trên Hình 4.2(c) có một đỉnh?
]


== Giờ 3 — Tắt không có nghĩa là hết hạt
#text(size: 9.5pt, fill: rgb("#64748b"))[Slide 16–22 · khoảng 60 phút]

=== Phép nhân làm một dòng nhỏ thành một dòng lớn

Chip kênh dài, cỡ trăm nghìn transistor, gần như không tốn điện khi nghỉ. Người thiết kế chỉ lo $P = C V_(D D)^2 f$.

Chip lớn có từ khoảng 10 tỷ đến 100 tỷ transistor. Phép nhân trong đầu — và phải gọi đúng là phép nhân, không phải số đo của một chiếc điện thoại:

$ 10^10 times 10 "nA" = 100 "A" $

Ở $1 "V"$ đó là $100 "W"$ khi chip không tính gì. Con số $10 "nA"$ mỗi transistor là giả sử để thấy phép nhân. Transistor thật được làm cho rò ít hơn. Điểm cần giữ: một dòng rất nhỏ nhân một số rất lớn thì không còn nhỏ. Phải biết dòng ấy đi lối nào.

#figure(
  image("images/fig4_3_nanoscale_leakage_mechanisms.png", width: 100%),
  caption: [Hình 4.3. (a) Ba lối: dưới ngưỡng dọc kênh, xuyên hầm qua oxit, và qua tiếp giáp xuống đế. (b) Dưới $V_t$, dòng vẽ trên thang log là một đường thẳng. Nóng thì đường kém dốc và $I_("off")$ cao hơn. (c) Tường $S i O_2$ mỏng thì sóng còn đuôi. $H f O_2$ dày hơn khoảng 5 lần mà điện dung giữ nguyên.]
)

#cau[Dòng rò của một transistor là chuyện nhỏ. Dòng rò của mười tỷ transistor là chuyện của cục pin.]

=== Dưới ngưỡng: một quả đồi và một cái đuôi nhiệt

#lo[Câu sai rất phổ biến: "$V_(g s)$ nhỏ hơn $V_t$ thì số electron bằng 0." Số electron không tắt như đèn. Xác suất đủ nóng để trèo đồi cao $q phi_B$ là đuôi Boltzmann, $exp(-q phi_B / k_B T)$.]

#hinh[
  Source $n^+$ đầy electron. Mặt kênh thì thưa. Hạt đi từ chỗ đông sang chỗ vắng. Đó là khuếch tán. Chúng không cần điện trường kéo cả quãng.

  Lúc này transistor giống một BJT: source là emitter, đế là base, drain là collector. Cổng không "mở kênh". Cổng hạ hoặc nâng quả đồi.
]

#congthuc[
  $ I_(s u b) = I_0 exp( (V_(g s) - V_(t 0) + eta V_(d s) - k_gamma V_(s b)) / (n v_T) ) (1 - exp(-V_(d s) / v_T)) $

  Đọc từng số hạng, vì mỗi số hạng là một hình đã gặp.
]

#table(
  columns: (1.5fr, 3fr),
  fill: (x, y) => if y == 0 { rgb("#f5f3ff") } else if calc.even(y) { rgb("#fafafa") } else { none },
  stroke: 0.4pt + rgb("#ddd6fe"),
  inset: 5pt,
  [*Số hạng*], [*Hình*],
  [$v_T = k_B T / q approx 26 "mV"$ ở $300 "K"$], [Độ rộng cái đuôi năng lượng. Nóng thì đuôi dài.],
  [$n = 1 + C_(d e p) / C_(o x)$, thường $1.3$–$1.7$], [Không phải mọi milivolt ở cổng đều tới mặt silicon. Tụ vùng nghèo chia bớt.],
  [$+ eta V_(d s)$], [DIBL. Máng cũng hạ đồi.],
  [$- k_gamma V_(s b)$], [Body effect. Đế làm đồi cao thêm.],
  [$1 - exp(-V_(d s)/v_T)$], [$V_(d s)$ rất nhỏ thì drain bắn hạt ngược lại. Trên khoảng $0.1 "V"$, số hạng này bằng 1.],
  [$I_0 prop mu_0 C_(o x) (W\/L) v_T^2$], [Cỡ dòng của công nghệ. $W\/L$ vẫn ở đó.],
)

$S$ là số milivolt cổng cần đổi để dòng đổi đúng 10 lần. Trên Hình 4.3(b), dưới $V_t$, $log_10 (I_(d s))$ là một đường thẳng.

$ S = ln(10) dot n v_T = 2.3 dot (k_B T / q) (1 + C_(d e p) / C_(o x)) $

Ở $300 "K"$, $n approx 1.4$, thì $S$ cỡ $80$ đến $100 "mV"$ cho mỗi bậc mười. Nếu cổng hoàn hảo, $n -> 1$:

$ S_("lý tưởng") = ln(10) dot v_T approx 60 "mV mỗi bậc mười, ở 300 K" $

#lo[
  $60 "mV"$ mỗi bậc mười không phải định luật của mọi công tắc trên đời. Nó là tường của *cơ chế này*: hạt trèo đồi bằng năng lượng nhiệt. Độ rộng năng lượng là $k_B T$. Nhà máy không làm $k_B T$ nhỏ đi bằng cách đổi $t_(o x)$. Một cơ chế không trèo đồi có thể dốc hơn. CMOS thông thường không dùng cơ chế đó.
]

#so[
  Muốn $I_("on") / I_("off") >= 10^6$, tức 6 bậc, với $S = 80 "mV"$:

  $ V_t >= 6 times 80 "mV" = 0.48 "V" $

  so với điểm đang tắt. Hạ $V_t$ từ $0.48 "V"$ xuống $0.20 "V"$:

  $ (0.48 - 0.20) / 0.08 = 3.5 "bậc" , quad 10^(3.5) approx 3000 $

  Dòng tắt tăng khoảng ba nghìn lần. Hình 4.3(b): ở $125 degree C$, $S$ xấu tới cỡ $105 "mV"$ mỗi bậc, vì $v_T$ tăng. Đường nóng nằm cao hơn tại $V_(g s) = 0$.
]

#cau[Dưới ngưỡng, hạt không hết. Một ít hạt đủ nóng để trèo đồi. Hạ đồi khoảng $60 "mV"$ thì số hạt trèo được tăng khoảng 10 lần, và nhiệt độ phòng không cho bạn dốc hơn thế với cơ chế này.]

=== Bức tường mỏng bằng vài lớp nguyên tử

#hinh[
  $S i O_2$ dày hơn khoảng $2 "nm"$ thì gần như không có dòng cổng. Để cổng vẫn kẹp được kênh ngắn, oxit bị mài xuống cỡ $1.0$ đến $1.2 "nm"$, chỉ còn vài lớp phân tử. Khung trên Hình 4.3(c).

  Electron cũng là một sóng. Tường dày thì sóng tắt trước khi sang bên kia. Tường vài lớp nguyên tử thì còn một cái đuôi biên độ. Xác suất có mặt bên kia khác 0. Hạt sang bên kia mà không cần trèo quá đỉnh tường. Đó là xuyên hầm.

  Xác suất giảm theo hàm mũ của bề dày. Chỗ đáng sợ nằm trong hàm mũ:

  $ I_(g a t e) approx A (V_(D D) / t_(o x))^2 exp(-B t_(o x) / V_(D D)) $

  Mỏng thêm cỡ $0.2 "nm"$, chưa đầy một lớp, dòng cổng tăng cỡ 10 lần.

  Hai hình dạng tường. Điện áp trên oxit còn nhỏ hơn chiều cao tường: tường hình thang, hạt chui thẳng, gọi là xuyên hầm trực tiếp. Đây là lối chính của oxit nano. Điện áp lớn hơn chiều cao tường: tường bị bẻ thành tam giác, hạt chỉ chui qua mũi mỏng. Đó là Fowler–Nordheim.
]

#hinh[
  Cổng nMOS rò hơn cổng pMOS khoảng 10 đến 100 lần, vì hai việc:
  + Electron nhẹ hơn lỗ trống. Sóng của hạt nhẹ tắt chậm hơn trong tường.
  + Bậc năng lượng dải dẫn giữa Si và $S i O_2$ chỉ khoảng $3.15 "eV"$. Bậc dải hóa trị đối với lỗ trống khoảng $4.5 "eV"$. Tường thấp hơn thì đuôi sóng lớn hơn.
]

#congthuc[
  Muốn $C_(o x)$ lớn *và* tường dày. Với $kappa$ cố định thì hai mong muốn đánh nhau:

  $ C_(o x) = kappa epsilon_0 / t_("phys") $

  $S i O_2$ có $kappa = 3.9$. $H f O_2$ có $kappa$ cỡ $20$ đến $25$, khoảng 5 lần. Tăng bề dày thật lên khoảng 5 lần, tới $5$–$6 "nm"$, thì $C_(o x)$ giữ nguyên. Bề dày điện tương đương (EOT, bề dày $S i O_2$ giả tưởng cho cùng điện dung) vẫn cỡ $1 "nm"$.

  Sóng không nhìn EOT. Sóng nhìn bề dày thật. Tường $6 "nm"$ gần như tắt đuôi sóng. Dòng cổng giảm hơn khoảng 100 lần. Intel đưa cổng kim loại và điện môi $kappa$ cao vào sản xuất năm 2007, nút $45 "nm"$. Khung dưới Hình 4.3(c).
]

#cau[Dòng cổng là cái đuôi sóng qua tường quá mỏng. Muốn tường dày mà lực cổng vẫn mạnh, phải tăng $kappa$, không phải mài $S i O_2$ mỏng thêm.]

=== Lối thứ ba: tiếp giáp bị phân cực ngược

#hinh[
  Source và drain $n^+$ cắm vào đế $p$. Tiếp giáp thường bị phân cực ngược.

  *Sinh cặp vì nhiệt.* Trong vùng nghèo, nhiệt thỉnh thoảng bẻ một liên kết, sinh một electron và một lỗ trống. Điện trường quét chúng đi. Dòng diode ngược tiến tới $-I_s$ khi phân cực ngược mạnh. Ở nhiệt độ phòng thành phần này rất nhỏ, dưới cỡ $1 "fA"\/mu"m"^2$.

  *Chui từ dải này sang dải kia,* band-to-band tunneling. Halo và đế pha trên $10^18 "cm"^(-3)$ để chống kênh ngắn. Vùng nghèo bị ép còn vài nanomet, và dải dẫn bên $n$ bị kéo xuống thấp hơn dải hóa trị bên $p$. Electron không cần trèo cả vùng cấm $E_g = 1.12 "eV"$. Nó chui ngang. $V_(d s)$ cao thì chỗ chồng dải càng rõ. Ở công nghệ nano, đây là phần chính của dòng rò tiếp giáp, không phải dòng nhiệt $I_s$.
]

#cau[Tiếp giáp ngược vừa sinh hạt vì nhiệt, vừa cho hạt chui ngang qua vùng cấm khi vùng nghèo bị pha đậm đến mức mỏng vài nanomet.]

=== Nóng làm hai việc ngược nhau

#hinh[
  Chip máy chủ có thể ở $70$–$85 degree C$. Chip gần động cơ có thể tới $125 degree C$. Nhiệt kéo hai thông số theo hai chiều.

  Mạng rung mạnh hơn thì hạt đập phonon nhiều hơn, $mu$ giảm:

  $ mu(T) = mu(T_0) (T / T_0)^(-k_mu) , quad k_mu approx 1.5 "đến" 2 $

  Từ $25 degree C$ ($298 "K"$) lên $125 degree C$ ($398 "K"$), tỷ số là $1.34$. Với mũ $1.5$, $mu$ còn khoảng $65%$. Với mũ $2$, còn khoảng $56%$. Nói giảm cỡ $40%$ là đúng cỡ.

  Cùng lúc $V_t$ giảm khoảng $1$ đến $2 "mV"$ mỗi độ. Trên $100 degree C$, $V_t$ giảm cỡ $100$ đến $150 "mV"$.
]

Dòng tăng hay giảm phụ thuộc bạn đứng ở đâu trên Hình 4.4(b). Hình ấy ở trang Giờ 4. Hãy lật tới, nhìn khung (b), rồi đọc tiếp.

- *Đang bật mạnh,* $V_(g s)$ khá lớn so với $V_t$. $(V_(g s) - V_t)$ chỉ tăng một chút khi $V_t$ giảm $0.1 "V"$, trong khi $mu$ mất khoảng $40%$. $mu$ thắng. Chip nóng chạy chậm hơn. Đây là chuyện quen của chip số điện áp thường.
- *Đang tắt,* $V_(g s) = 0$. Đồi thấp hơn và đuôi nhiệt dài hơn. Cả hai làm rò tăng. Dòng tắt ở $125 degree C$ cỡ $20$ đến $50$ lần dòng tắt ở $25 degree C$. Nếu rò sinh nhiệt và nhiệt lại tăng rò, vòng ấy gọi là thoát nhiệt tự tăng. Hạ xung nhịp không cắt vòng này, vì dòng rò không cần xung nhịp.
- *Điểm hai đường cắt nhau,* gần $V_(g s) approx 0.52 "V"$, gọi là ZTC, zero-temperature coefficient. Đứng đúng chỗ ấy, dòng không phụ thuộc nhiệt độ. Bên trái điểm cắt, nóng nằm *trên* lạnh: mất $100 "mV"$ ngưỡng là một phần rất lớn của $(V_(g s) - V_t)$ khi số ấy vốn đã nhỏ. Một mạch $V_(D D)$ cỡ $0.4$–$0.5 "V"$ có thể chậm nhất khi trời lạnh.

#cau[Nóng làm hạt va nhiều hơn nên chậm, và làm $V_t$ thấp hơn nên dễ bật. Bật mạnh thì cái chậm thắng. Gần ngưỡng thì cái dễ bật thắng. Hai đường gặp nhau ở khoảng $0.5 "V"$.]


== Giờ 4 — Không có hai transistor giống hệt
#text(size: 9.5pt, fill: rgb("#64748b"))[Slide 23–26 · khoảng 60 phút]

Bạn không thử một cái cầu bằng chiếc xe tải trung bình. Bạn thử xe nặng nhất vào ngày cầu yếu nhất, và xe nhanh nhất vào ngày đường trơn. PVT là câu đó, viết cho transistor.

#figure(
  image("images/fig4_4_pvt_variations_and_corners.png", width: 100%),
  caption: [Hình 4.4. (a) TT ở giữa đám mây. FF cả hai nhanh. SS cả hai chậm. FS và SF là hai kiểu lệch ngược nhau. (b) Đường nóng và đường lạnh cắt nhau gần $0.52 "V"$. (c) Bốn tổ hợp ký duyệt, mỗi tổ hợp để bắt một lỗi.]
)

=== Ba lý do không vẽ được hai lần cùng một hình

+ *Chiều dài cổng.* Ánh sáng in cổng có bước sóng hữu hạn. Khắc cũng không đều. $L$ in ra không đúng từng nanomet trên bản vẽ.
+ *Bề dày điện môi.* Lệch một lớp nguyên tử đã là một phần trăm lớn, vì màng vốn chỉ vài lớp.
+ *Đếm nguyên tử tạp.* Kênh cỡ $20 "nm" times 20 "nm"$ chỉ chứa khoảng vài chục nguyên tử boron. Nếu có $N$ nguyên tử, độ lệch điển hình cỡ $sqrt(N)$. Với vài chục nguyên tử, lệch vài nguyên tử là chuyện của sự đếm, không phải chuyện nhà máy ẩu. Lệch $3$ đến $5$ nguyên tử đủ đẩy $V_t$ hàng chục milivolt giữa hai transistor cạnh nhau. Tên là random dopant fluctuation, thăng giáng tạp chất ngẫu nhiên.

#cau[$L$ và $t_(o x)$ lệch vì cách in và cách mọc màng. $V_t$ còn lệch vì trong kênh nano chẳng có bao nhiêu nguyên tử tạp để trung bình cho đều.]

=== Nguồn và nhiệt độ cũng không đứng yên

$V_(D D)$ thường được tính với biên $plus.minus 10%$. Dây có điện trở: dòng chạy qua thì sụt một đoạn $I R$. Dây có điện cảm: dòng đổi rất nhanh thì hiện điện áp $L dif i \/ dif t$. Nền và nguồn bị nảy. Nguồn danh định $1.0 "V"$ có thể thành $0.9 "V"$ hoặc $1.1 "V"$ ngay tại transistor.

Nhiệt độ đi từ $0 degree C$, có khi $-40 degree C$, tới $105$–$125 degree C$ khi tải nặng.

Ba chữ P, V, T là process, voltage, temperature: quy trình, điện áp, nhiệt độ. Một góc là một tổ hợp ở biên.

=== Năm góc, vì nMOS và pMOS không lệch cùng hướng

#table(
  columns: (0.9fr, 2.2fr, 1.3fr, 1.2fr),
  fill: (x, y) => if y == 0 { rgb("#e0f2fe") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: 5pt,
  [*Mức*], [*Hình trên silicon*], [*Dòng bật*], [*Dòng rò*],
  [Fast, F], [$L$ ngắn, oxit mỏng, $V_t$ thấp], [mạnh], [lớn],
  [Typical, T], [đúng mức thiết kế], [vừa], [vừa],
  [Slow, S], [$L$ dài, oxit dày, $V_t$ cao], [yếu], [nhỏ],
)

nMOS và pMOS dùng các mặt nạ khác nhau, nên sai số khá độc lập. Năm góc trên Hình 4.4(a). Elip là đám mây cỡ $plus.minus 3 sigma$ quanh TT.

#table(
  columns: (0.7fr, 0.8fr, 0.8fr, 3.2fr),
  fill: (x, y) => if y == 0 { rgb("#f1f5f9") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: 5pt,
  [*Góc*], [*nMOS*], [*pMOS*], [*Chuyện với một inverter*],
  [TT], [T], [T], [Điểm danh định. Đo số trung bình.],
  [FF], [F], [F], [Cả hai mạnh. Nhanh nhất. Rò nhất.],
  [SS], [S], [S], [Cả hai yếu. Chậm nhất.],
  [FS], [F], [S], [Kéo xuống mạnh, kéo lên yếu. Đường $V_("out")$ theo $V_("in")$ lệch sang trái. Khoảng nhiễu mức thấp hẹp. Sợ nền bị nảy.],
  [SF], [S], [F], [Kéo xuống yếu, kéo lên mạnh. Đường lệch sang phải. Khoảng nhiễu mức cao hẹp.],
)

#lo[FF không phải "góc xấu duy nhất". FF xấu cho rò và cho dữ liệu đến quá sớm. FF lại dễ sống cho setup. SS thì ngược lại. Góc không có tính cách. Góc chỉ làm một lỗi nào đó dễ lộ.]

#cau[Nhanh hay chậm là của từng loại transistor. n nhanh mà p chậm thì ngưỡng chuyển mạch lệch, dù chip không hẳn nhanh hơn hay chậm hơn.]

=== Bốn lần ký duyệt, bốn câu hỏi

Ký duyệt nghĩa là: trước khi làm mặt nạ, mạch phải sống ở tổ hợp biên của *đúng cái lỗi* đang sợ. Chọn tổ hợp bằng câu "tổ hợp nào làm lỗi này dễ xảy ra nhất?"

*1. Trễ dài nhất, setup.* Dữ liệu có đến kịp trước sườn xung không? Làm mọi transistor chậm: SS, $V_(D D)$ thấp nhất, và nóng nếu điện áp thường (nóng thì $mu$ thấp). Mạch gần ngưỡng thì phải thử lại đầu lạnh, vì ZTC đã đảo chiều.

$ T_(c l k) >= t_(p c q) + t_(p d, max) + t_("setup") $

Fail thì hạ xung nhịp, chu kỳ dài ra, dữ liệu kịp đến. Chip vẫn tính đúng. Nó chỉ không đạt tần số đã hứa.

*2. Trễ ngắn nhất, hold.* Dữ liệu mới có lao vào flip-flop sau quá sớm, đè lên bit mà flip-flop ấy còn phải giữ, hay không? Làm đường dữ liệu nhanh nhất: FF, $V_(D D)$ cao nhất, trời lạnh.

$ t_(p c q, c d) + t_("logic", c d) >= t_("hold") + t_("skew") $

Không có $T_(c l k)$ trong bất đẳng thức. Hạ xung nhịp không thêm được một số nào vào đây.

Hai người chạy tiếp sức nghe cùng một phát súng. Kéo dài đường đua không ngăn người thứ hai xuất phát trước khi gậy chạm tay, nếu lỗi nằm ngay ở phát súng. Hold là khoảng cách giữa hai việc quanh cùng một sườn, cộng với độ lệch pha hai xung đồng hồ.

Sửa trên layout: thêm trễ vào đường dữ liệu, thường là buffer hoặc một cặp inverter. Cái giá: thêm diện tích, thêm công suất động, và đường ấy có thể fail setup ở góc SS.

*3. Rò tĩnh lớn nhất.* FF, nguồn cao, nóng. Cả dòng dưới ngưỡng lẫn dòng cổng đều được tiếp sức. Dùng để tính pin lúc ngủ, và để quyết định có ngắt nguồn cả một khối hay không. Dòng này không cần xung nhịp.

*4. Công suất động và nhiệt lớn nhất.* Cùng FF, nguồn cao, nóng, và thêm tần số cao nhất, vì $P_(d y n) = alpha C V_(D D)^2 f$. Số này để chọn cách tản nhiệt và để kiểm mật độ dòng trên dây nguồn. Dòng quá dày thì nguyên tử kim loại bị kéo dần theo dòng, dây mòn và đứt. Việc ấy là electromigration.

#table(
  columns: (1.6fr, 0.7fr, 0.8fr, 1.3fr, 2.1fr),
  fill: (x, y) => if y == 0 { rgb("#ecfdf5") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.4pt + rgb("#a7f3d0"),
  inset: 4.5pt,
  [*Việc cần bắt*], [*P*], [*V*], [*T*], [*Hạ xung nhịp*],
  [Trễ dài, setup], [SS], [thấp], [nóng, nếu điện áp thường], [Có. Chip chậm nhưng còn đúng.],
  [Trễ ngắn, hold], [FF], [cao], [lạnh], [Không. $T_(c l k)$ không có trong bất đẳng thức.],
  [Rò lúc ngủ], [FF], [cao], [nóng], [Không. Rò không cần xung nhịp.],
  [Công suất động, dây nguồn], [FF], [cao], [nóng, tại $f_(max)$], [Hạ $f$ thì $P_(d y n)$ giảm. Phải tính lại.],
)

#cau[Setup là nỗi sợ của con chậm. Hold là nỗi sợ của con nhanh. Hạ đồng hồ chỉ nới thời gian cho con chậm.]


== Sổ một câu

Che cột phải. Nói cột trái bằng lời của bạn. Rồi mới nhìn.

#table(
  columns: (1.4fr, 3.2fr),
  fill: (x, y) => if y == 0 { rgb("#f1f5f9") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: 4.5pt,
  [*Đang kiểm*], [*Một câu đủ*],
  [Hai điện trường], [Cổng ép hạt lên trần oxit. Máng kéo hạt dọc kênh.],
  [$mu$ giảm], [Trần gồ ghề. Càng ép mạnh, càng va nhiều.],
  [$I_(d s a t)$ bậc 1], [Tốc độ đã kẹt. Chỉ còn số hạt tăng theo $(V_(g s)-V_t)$.],
  [$V_(d s a t)$ nhỏ], [Trần tốc độ tới trước lúc kênh thắt. Giới hạn nhỏ hơn thắng.],
  [Đường bão hòa dốc], [Vùng nghèo máng ăn ngắn $L_(e f f)$. $lambda$ lớn khi $L$ nhỏ.],
  [Body effect], [Source cao hơn đế, hố ion sâu hơn, $V_t$ tăng.],
  [DIBL], [Máng gần kéo thấp đồi ở source, $V_t$ giảm.],
  [Roll-off], [Source và drain đã trả ion hai đầu. Kênh ngắn, $V_t$ giảm.],
  [RSCE], [Hai túi halo chồng, $V_t$ nhích lên trước khi rơi.],
  [Dưới ngưỡng], [Khuếch tán qua đồi, theo đuôi $k T$. Tường khoảng $60 "mV"$ mỗi bậc mười là của cơ chế này.],
  [Dòng cổng], [Đuôi sóng qua tường quá mỏng. Hàm mũ theo bề dày.],
  [HKMG], [Tăng $kappa$ để tường dày hơn mà $C_(o x)$ giữ nguyên. Sóng nhìn bề dày thật.],
  [BTBT], [Vùng nghèo pha đậm, mỏng, hạt chui ngang qua vùng cấm.],
  [Nhiệt độ], [Nóng: $mu$ xuống, $V_t$ xuống. Bật mạnh thì chậm. Gần ngưỡng thì nhanh.],
  [Đếm tạp chất], [Vài chục nguyên tử. Lệch vài nguyên tử là lệch $V_t$.],
  [Setup và hold], [Con chậm: hạ đồng hồ cứu được. Con nhanh đến sớm: hạ đồng hồ không có trong bất đẳng thức.],
)

Nếu một dòng bạn nói *ngược chiều* (tăng thành giảm), bạn chưa hiểu. Chiều sai thì mọi mạch sau này suy ra ngược.

== Tên gọi, sau khi đã có hình

#table(
  columns: (1.7fr, 1.6fr, 2.8fr),
  fill: (x, y) => if y == 0 { rgb("#f1f5f9") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: 4.5pt,
  [*Tên tiếng Anh*], [*Tên tiếng Việt*], [*Gắn vào hình nào*],
  [Mobility degradation], [Suy giảm độ linh động], [Viên bi ép vào trần gồ ghề.],
  [Velocity saturation], [Bão hòa vận tốc], [Phonon quang giật năng lượng. Trần cỡ $10^7 "cm/s"$ với electron.],
  [Channel-length modulation], [Biến điệu chiều dài kênh], [Máng ăn $L_(e f f)$. Đường bão hòa dốc.],
  [Body effect], [Hiệu ứng đế], [$V_(s b) > 0$, hố ion sâu, $V_t$ tăng.],
  [DIBL], [Hạ rào do máng], [$V_t' = V_(t 0) - eta V_(d s)$.],
  [$V_t$ roll-off], [Sụt ngưỡng kênh ngắn], [Cổng chỉ trả hình thang.],
  [Reverse short-channel effect], [Kênh ngắn ngược], [Halo chồng, $V_t$ nhích lên.],
  [Subthreshold swing $S$], [Độ dốc dưới ngưỡng], [mV để dòng đổi 10 lần.],
  [Gate tunneling], [Xuyên hầm cổng], [Đuôi sóng qua oxit cỡ $1 "nm"$.],
  [High-$kappa$ metal gate], [Điện môi $kappa$ cao], [$H f O_2$: tường dày, $C_(o x)$ giữ.],
  [Band-to-band tunneling], [Xuyên hầm giữa hai dải], [Hạt chui ngang vùng cấm ở tiếp giáp đậm.],
  [ZTC], [Hệ số nhiệt bằng 0], [Dưới khoảng $0.5 "V"$, nóng chạy nhanh hơn lạnh.],
  [PVT corners], [Góc quy trình], [Thử đúng biên của đúng cái lỗi.],
)

== Shockley đặt cạnh silicon

#table(
  columns: (1.3fr, 1.8fr, 2.4fr),
  fill: (x, y) => if y == 0 { rgb("#f1f5f9") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: 4.5pt,
  [*Việc*], [*Kênh dài*], [*Kênh nano*],
  [$mu$], [hằng số], [giảm khi $V_(g s)$ tăng],
  [vận tốc], [tăng mãi theo trường], [trần $v_(s a t)$],
  [$I_(d s a t)$], [bình phương $(V_(g s)-V_t)$], [bậc 1],
  [$V_(d s a t)$], [$V_(g s)-V_t$], [cái nhỏ hơn giữa quá kích và $cal(E)_c L$],
  [đường bão hòa], [nằm ngang], [dốc, $lambda prop 1\/L$],
  [$V_(s b) > 0$], [bỏ qua], [$V_t$ tăng],
  [máng và $V_t$], [không liên quan], [$V_t$ giảm],
  [$V_(g s) = 0$], [dòng bằng 0], [ba lối rò],
)


== Năm bài tính

Làm bằng lời trước. Mỗi bài có một câu "hình của bài này". Không nói được câu ấy thì đừng bấm máy tính.

=== Bài 1. Trần tốc độ có kéo dòng xuống thật không?

#hinh[Shockley dùng $mu$ và bình phương. Silicon có $mu$ bị trần gồ ghề làm giảm, và có $v_(s a t)$ làm dòng chỉ còn bậc 1. Hãy thấy Shockley cao hơn. Cũng hãy thấy công thức một dòng vẫn chưa phải số đo trên silicon.]

nMOS $65 "nm"$: $L = 65 "nm"$, $W = 1 mu"m"$, $t_(o x) = 1.2 "nm"$, $epsilon_(o x) = 3.9 epsilon_0$, $V_t = 0.30 "V"$, $mu_0 = 350 "cm"^2"/V·s"$, $theta = 0.25 "V"^(-1)$, $v_(s a t) = 10^7 "cm/s"$. Đặt $V_(g s) = V_(d s) = 1.0 "V"$.

Tính $C_(o x)$, rồi $mu_(e f f)$, rồi so sánh dòng Shockley (có dùng $mu_(e f f)$) với $I approx W C_(o x) v_(s a t) (V_(g s) - V_t)$.

#so[
  $ C_(o x) = (3.9 times 8.854 times 10^(-14)) / (1.2 times 10^(-7)) approx 2.88 times 10^(-6) "F/cm"^2 = 28.8 "fF/" mu"m"^2 $

  $ mu_(e f f) = 350 / (1 + 0.25 times 0.70) = 350 / 1.175 approx 298 "cm"^2"/V·s" $

  Còn khoảng $85%$ của $mu_0$.

  $ beta approx 298 times 2.88 times 10^(-6) times (1 / 0.065) approx 0.0132 "A/V"^2 $

  $ I_("Shockley") = beta / 2 times (0.70)^2 approx 3.23 "mA" $

  $ I_(v s a t) approx (10^(-4)) (2.88 times 10^(-6)) (10^7) (0.70) approx 2.02 "mA" $

  Shockley cao hơn công thức trần tốc độ khoảng $1.6$ lần, và cao hơn dòng cỡ $747 mu"A"$ trên $1 mu"m"$ khoảng $4$ lần.

  Đừng gọi $2.02 "mA"$ là dòng đo. Với $cal(E)_c L approx 0.065 "V"$, $V_(d s a t) approx 0.059 "V"$, và dạng

  $ I = W C_(o x) v_(s a t) (V_(g s)-V_t)^2 / [(V_(g s)-V_t) + cal(E)_c L] $

  còn khoảng $1.8 "mA"$. Khoảng cách từ $1.8 "mA"$ xuống $747 mu"A"$ là điện trở tiếp xúc, và việc không phải mọi hạt chạy đúng $v_(s a t)$ trên suốt kênh. Số ký duyệt lấy từ BSIM. Bài này chỉ cần thấy chiều: bình phương quá cao, trần tốc độ kéo xuống, công thức một dòng vẫn còn lạc quan.
]

=== Bài 2. Truyền mức 1 thì tự tắt sớm

#hinh[nMOS truyền mức 1. Điện thế ra chính là $V_(s b)$. Ra càng cao thì $V_t$ càng tăng. Nó tắt khi $V_(D D) - V_("out") = V_t (V_("out"))$, không phải khi hiệu ấy bằng $V_(t 0)$.]

$V_(D D) = 1.2 "V"$, đế $0 "V"$, $V_(t 0) = 0.35 "V"$, $gamma = 0.45 "V"^(1\/2)$, $phi_s = 0.65 "V"$.

#so[
  $ V_("out") = 1.213 - 0.45 sqrt(0.65 + V_("out")) $

  Thử $0.70 "V"$: vế phải khoảng $0.690 "V"$. Thử lại $0.690 "V"$: vế phải khoảng $0.692 "V"$.

  $V_("out")$ dừng ở khoảng $0.692 "V"$. Khi ấy $V_t = 1.200 - 0.692 = 0.508 "V"$.

  Nếu quên body effect, bạn sẽ nói ra đạt $0.85 "V"$. Thật ra $V_t$ tăng thêm khoảng $0.16 "V"$. Mức 1 bị cụt.
]

=== Bài 3. Hạ đồi $68 "mV"$ thì dòng rò nhân bao nhiêu?

#hinh[DIBL trừ $eta Delta V_(d s)$ khỏi $V_t$. Dòng dưới ngưỡng nhân 10 mỗi khi đồi thấp đi $S$ milivolt.]

$eta = 0.08$, $S = 85 "mV"$ mỗi bậc mười, $V_(g s) = 0$. $V_(d s)$ từ $0.05 "V"$ lên $0.90 "V"$.

#so[
  $ Delta V_t = 0.08 times 0.85 = 68 "mV" $

  $ I_("sau") / I_("trước") = 10^(68\/85) = 10^(0.80) approx 6.3 $

  Đưa máng lên $0.9 "V"$ đã nhân dòng tắt khoảng 6 lần. Hạ nguồn lúc ngủ hạ luôn $eta V_(d s)$, nên tiết kiệm rò mạnh.
]

=== Bài 4. Tường mỏng đáng giá bao nhiêu, tường dày trả lại bao nhiêu?

#hinh[Dòng cổng là đuôi sóng, rất nhạy với bề dày thật. HKMG tăng bề dày thật. Đây là ước lượng cỡ công suất, không phải số ký duyệt. Không phải lúc nào nMOS và pMOS cũng rò cùng lúc. Lấy trung bình để thấy cỡ.]

$500$ triệu inverter ở $45 "nm"$. Nếu còn $S i O_2$: $J_("n") = 15 "A/cm"^2$, $J_("p") = 1.5 "A/cm"^2$. Mỗi cổng $100 "nm" times 45 "nm"$. $V_(D D) = 1 "V"$. $H f O_2$ làm mật độ dòng giảm $150$ lần.

#so[
  Electron thấy tường khoảng $3.15 "eV"$ và nhẹ hơn. Lỗ trống thấy tường khoảng $4.5 "eV"$. Vì vậy $J$ của nMOS lớn hơn.

  Diện tích một cổng: $A = 4.5 times 10^(-11) "cm"^2$.

  Trung bình một inverter: $I approx 4.5 times 10^(-11) times 8.25 approx 0.37 "nA"$.

  Cả chip: $I approx 0.186 "A"$, nên $P approx 0.19 "W"$.

  Sau HKMG: $P approx 186 "mW" \/ 150 approx 1.2 "mW"$.

  Tường dày thật, $C_(o x)$ giữ bằng $kappa$ lớn. Công suất rò cổng ở ước lượng này rơi từ gần $0.2 "W"$ xuống khoảng $1 "mW"$.
]

=== Bài 5. Góc nhanh làm sai chức năng, góc chậm chỉ làm chậm

#hinh[Hold là dữ liệu đến quá sớm quanh một sườn đồng hồ. Muốn bắt nó phải đứng ở FF, nguồn cao, trời lạnh. $T_(c l k)$ không có trong bất đẳng thức.]

$t_("hold") = 30 "ps"$, $t_("skew") = 25 "ps"$. Góc nhanh: $t_(p c q, c d) = 40 "ps"$, $t_("logic", c d) = 10 "ps"$. Góc chậm: $85 "ps"$ và $22 "ps"$.

#so[
  Góc chậm làm đường dữ liệu dài, nên che mất việc dữ liệu có thể đến quá sớm. Không được dùng góc chậm để kết luận hold ổn.

  Cần $30 + 25 = 55 "ps"$. Góc nhanh chỉ có $40 + 10 = 50 "ps"$. Slack $= -5 "ps"$.

  Chip sai chức năng ở mọi tần số. Thêm khoảng $10 "ps"$ trễ trên đường dữ liệu ở góc nhanh thì $50 + 10 = 60 "ps"$, slack dương cỡ $+5 "ps"$. Thường là buffer hoặc cặp inverter.

  Cái giá: thêm diện tích, thêm công suất động, và chính khoản trễ ấy có thể làm fail setup ở góc SS. Sửa hold xong phải kiểm lại góc chậm.
]
