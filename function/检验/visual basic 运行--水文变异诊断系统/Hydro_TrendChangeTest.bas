Attribute VB_Name = "Hydro_TrendChange"
'突变点分析，最短资料序列长度为10
'贝叶斯根据新方法需要调整
Public Function Hurst_Class(data() As Double, α As Double, β As Double) As String 'Hurst 分级系数表
'Data 存放两列数据，第一列时间数据，第二列测量数据
'α 为第一显著性，β为第二显著性 α>β
'Hurst_Class=0，1，2，3，4 分布表示无变异，弱变异，中变异，强变异，巨变异
Dim m1 As Long, n1 As Long, n2 As Long
Dim DA() As Double
Dim h As Double, i As Long
'On Error GoTo Hurcla:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
n2 = UBound(data, 2)
ReDim DA(m1 To n1)
For i = m1 To n1
DA(i) = data(i, n2)
Next
h = Abs(Hurst(DA))
If 0 <= h And h < 0.5 - 0.5 * Log(1 + 0.8) / Log(2) Then
Hurst_Class = -4
ElseIf 0.5 - 0.5 * Log(1 + 0.8) / Log(2) <= h And h < 0.5 - 0.5 * Log(1 + 0.6) / Log(2) Then
Hurst_Class = -3
ElseIf 0.5 - 0.5 * Log(1 + 0.6) / Log(2) <= h And h < 0.5 - 0.5 * Log(1 + Hydrological_S.Pearson_Critical_value_Correlation(n1 - m1 - 1, β)) / Log(2) Then
Hurst_Class = -2
ElseIf 0.5 - 0.5 * Log(1 + Hydrological_S.Pearson_Critical_value_Correlation(n1 - m1 - 1, β)) / Log(2) And 0.5 - 0.5 * Log(1 + Hydrological_S.Pearson_Critical_value_Correlation(n1 - m1 - 1, α)) / Log(2) Then
Hurst_Class = -1
ElseIf 0.5 - 0.5 * Log(1 + Hydrological_S.Pearson_Critical_value_Correlation(n1 - m1 - 1, α)) / Log(2) <= h And h < 0.5 + 0.5 * Log(1 + Hydrological_S.Pearson_Critical_value_Correlation(n1 - m1 - 1, α)) / Log(2) Then
Hurst_Class = 0
ElseIf 0.5 + 0.5 * Log(1 + Hydrological_S.Pearson_Critical_value_Correlation(n1 - m1 - 1, α)) / Log(2) <= h And h < 0.5 + 0.5 * Log(1 + Hydrological_S.Pearson_Critical_value_Correlation(n1 - m1 - 1, β)) / Log(2) Then
Hurst_Class = 1
ElseIf 0.5 + 0.5 * Log(1 + Hydrological_S.Pearson_Critical_value_Correlation(n1 - m1 - 1, β)) / Log(2) <= h And h < 0.5 + 0.5 * Log(1 + 0.6) / Log(2) Then
Hurst_Class = 2
ElseIf 0.5 + 0.5 * Log(1 + 0.6) / Log(2) <= h And h < 0.5 + 0.5 * Log(1 + 0.8) / Log(2) Then
Hurst_Class = 3
ElseIf 0.5 + 0.5 * Log(1 + 0.8) / Log(2) <= h And h <= 1 Then
Hurst_Class = 4
End If
Exit Function
Hurcla:
Hurst_Class = "Error:"
End Function
Private Function box_cox_single(data() As Double) As String '单变量Box_Cox 变换
Dim m1 As Long, n1 As Long, n As Long, n2 As Long
Dim i As Long, Min As Double, j As Long
Dim r As Double, p As Double, r_ As Double
Dim r0 As Double, r1 As Double, f4 As Double
Dim f1 As Double, f2 As Double, f3 As Double
Dim U As Double, h As Double
Dim DA() As Double
m1 = LBound(data, 1)
n1 = UBound(data, 1)
n2 = UBound(data, 2)
ReDim DA(m1 To n1)
n = n1 - m1 + 1
p = 0
For i = m1 To n1
DA(i) = data(i, n2)
p = p + Log(DA(i))
Next
r0 = 0
r1 = 5
U = 0.5 * (Sqr(5) - 1)
h = 0
Do While (h < 10000)
h = h + 1
f1 = box_cox_singleV(DA, p, r0)
f2 = box_cox_singleV(DA, p, r1)
If Abs(f1 - f2) < 1E-16 Then
r = (r1 + r2) / 2
Exit Do
End If
r = (r0 + r1) / 2
f3 = box_cox_singleV(DA, p, r)
If Sgn((f1 + f2) / 2 - f3) > 0 Then
r = r0 + (1 - U) * (r1 - r0)
r_ = r0 + U * (r1 - r0)
If Abs(r - r_) < 1E-16 Then
r = (r + r_) / 2
Exit Do
End If
f3 = box_cox_singleV(DA, p, r)
f4 = box_cox_singleV(DA, p, r_)
If Abs(f3 - f4) < 1E-16 Then
r = (r + r_) / 2
Exit Do
End If
If Sgn(f3 - f4) < 0 Then
r0 = r0
r1 = r_
ElseIf Sgn(f3 - f4) > 0 Then
r0 = r
r = r1
End If
Else
If Sgn(f1 - f2) < 0 Then
r1 = r0
r0 = r0 - 1
Else
r0 = r1
r1 = r1 + 1
End If
End If
Loop
box_cox_single = r
End Function
Private Function box_cox_singleV(data() As Double, p As Double, r As Double) As Double   '单变量Box_Cox 变换方差计算
Dim z() As Double, Q As Double, Ex As Double, i As Long, n As Long
Dim m1 As Long, n1 As Long
m1 = LBound(data)
n1 = UBound(data)
n = n1 - m1 + 1
ReDim z(m1 To n1)
Q = Exp((r - 1) / n * p)
Ex = 0
box_cox_singleV = 0
For i = m1 To n1
If r = 0 Then
z(i) = Log(data(i)) / Q
Else
z(i) = (data(i) ^ r - 1) / r / Q
End If
Ex = Ex + z(i)
box_cox_singleV = box_cox_singleV + z(i) * z(i)
Next
box_cox_singleV = box_cox_singleV - Ex * Ex / n '计算变换后的方差（类似）
End Function
' <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<突变检验方法<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Public Function Bayesian_Method_Variable(data() As Double, p() As String) As String  '基于贝叶斯方法的气候突变检验
'水文时间序列变点分析的贝叶斯方法 熊立华等 水电能源科学，2003，12
Dim m1 As Long, m2 As Long
Dim n1 As Long, n2 As Long
Dim i As Long, j As Long, s As Long
Dim max As Double, r() As Double
Dim Ex As Double, Var As Double
Dim Ex_() As Double, sum As Double
Dim rr As Double
On Error GoTo BaMev:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim p(m1 To n1 - 1, m2 To n2)
ReDim Ex_(m1 To n1)
ReDim r(m1 To n1)
rr = box_cox_single(data)
For i = m1 To n1
If rr <> 0 Then
r(i) = (data(i, n2) ^ rr - 1) / rr
Else
r(i) = Log(data(i, n2))
End If
If i = m1 Then
  max = r(i)
Else
If max < r(i) Then
max = r(i)
End If
End If
Next
''''''''''''''''均一化处理'''''''''''''''''''''''''''''
Ex = 0
Var = 0
For i = m1 To n1
r(i) = r(i) / max
Ex = Ex + r(i)
Var = Var + r(i) * r(i)
Next
Ex = Ex / (n1 - m1 + 1)
Var = Var / (n1 - m1 + 1) - Ex * Ex
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
sum = 0
i = m1
Do While (i < n1)
s = 0
For j = m1 To i
s = s + r(j)
Next
For j = m1 To i
Ex_(j) = (Ex / 6 + s) / (1 / 6 + i - m1 + 1)
Next
s = 0
For j = i + 1 To n1
s = s + r(j)
Next
For j = i + 1 To n1
Ex_(j) = (Ex / 6 + s) / (1 / 6 + (n1 - i))
Next
p(i, n2) = 0
For j = m1 To n1
p(i, n2) = p(i, n2) - 0.5 * Log(2 * 3.14 * Var) - (r(j) - Ex_(j)) * (r(j) - Ex_(j)) / 2 / Var
Next
p(i, n2) = Exp(p(i, n2))
sum = sum + p(i, n2)
p(i, m2) = data(i, m2)
i = i + 1
Loop
For i = m1 To n1 - 1
p(i, n2) = p(i, n2) / sum
If i = m1 + 9 Then
max = p(i, n2)
Bayesian_Method_Variable = p(i, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If max < p(i, n2) Then
max = p(i, n2)
Bayesian_Method_Variable = p(i, m2)
End If
End If
Next
Bayesian_Method_Variable = "The Change_Point is:" & Bayesian_Method_Variable & " with Adjusted"
Exit Function
BaMev:
Bayesian_Method_Variable = "Error:"
End Function
Public Function Bernaola_Galvan(data() As Double, t() As String, a As Double) As String   ' BG 算法,基于启发式分割算法的气候突变检测研究(单点分割）
''Data 存储两列数据，第一列时间数据，第二列观测数据
'SNR 存储两列数据，第一列时间数据,第二列观测数据
Dim m1 As Long, m2 As Long
Dim n1 As Long, n2 As Long
Dim i As Long, j As Long
Dim max As Double
Dim Ex1 As Double, Ex2 As Double
Dim Std1 As Double, Std2 As Double
Dim Std As Double, ETA As Double
Dim v As Long, Beta As Double
On Error GoTo BerGal:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim t(m1 To n1 - 3, m2 To n2)
i = m1 + 1
Do While (1)
Ex1 = 0
Std1 = 0
For j = m1 To i
Ex1 = Ex1 + data(j, n2)
Std1 = Std1 + data(j, n2) * data(j, n2)
Next
Ex1 = Ex1 / (i - m1 + 1)
Std1 = Sqr(Std1 / (i - m1) - Ex1 * Ex1)
Ex2 = 0
Std2 = 0
For j = i + 1 To n1
Ex2 = Ex2 + data(j, n2)
Std2 = Std2 + data(j, n2) * data(j, n2)
Next
Ex2 = Ex2 / (n1 - i)
Std2 = Sqr(Std2 / (n1 - i - 1) - Ex2 * Ex2)
t(i - 1, m2) = data(i, m2)
Std = Sqr(((i - m1) * Std1 * Std1 + (n1 - i - 1) * Std2 * Std2) / (n1 - m1 - 1)) * Sqr(1 / (i - m1 + 1) + 1 / (n1 - i))
t(i - 1, n2) = Abs((Ex1 - Ex2) / Std)
If i = m1 + 9 Then
max = t(i - 1, n2)
Bernaola_Galvan = t(i - 1, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If max < t(i - 1, n2) Then
max = t(i - 1, n2)
Bernaola_Galvan = t(i - 1, m2)
End If
End If
If i < n1 - 3 Then
i = i + 1
Else
Exit Do
End If
Loop
ETA = 4.19 * Log(n1 - m1 + 1) - 11.54
v = n1 - m1 - 1
Beta = (1 - Hydrological_S.Incomplete_Beta(0.4 * v, 0.4, v / (v + max * max))) ^ ETA
If Beta > 1 - a Then
Bernaola_Galvan = "The change point is :" & Bernaola_Galvan & " with signficance"
Exit Function
Else
Bernaola_Galvan = "The change point is :" & Bernaola_Galvan & " with no signficance"
Exit Function
End If
BerGal:
Bernaola_Galvan = "Error:"
End Function
Public Function Yamamoto(data() As Double, SNR() As String, a As Double)  'Yamaoto 突变性检验（检验突变点）
''Data 存储两列数据，第一列时间数据，第二列观测数据
'SNR 存储两列数据，第一列时间数据,第二列观测数据
Dim m1 As Long, m2 As Long
Dim n1 As Long, n2 As Long
Dim i As Long, j As Long
Dim Ex1 As Double, Ex2 As Double
Dim Std1 As Double, Std2 As Double
Dim max As Double, max_num As Long
On Error GoTo Yamo:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim SNR(m1 To n1 - 3, m2 To n2)
i = m1 + 1
Do While (i < n1 - 1)
Ex1 = 0
Std1 = 0
For j = m1 To i
Ex1 = Ex1 + data(j, n2)
Std1 = Std1 + data(j, n2) * data(j, n2)
Next
Ex1 = Ex1 / (i - m1 + 1)
Std1 = Sqr(Std1 / (i - m1) - Ex1 * Ex1)
Ex2 = 0
Std2 = 0
For j = i + 1 To n1
Ex2 = Ex2 + data(j, n2)
Std2 = Std2 + data(j, n2) * data(j, n2)
Next
Ex2 = Ex2 / (n1 - i)
Std2 = Sqr(Std2 / (n1 - i - 1) - Ex2 * Ex2)
SNR(i - 1, m2) = data(i, m2)
SNR(i - 1, n2) = Abs(Ex1 - Ex2) / (Std1 + Std2)
If i = m1 + 9 Then
max = SNR(i - 1, n2)
Yamamoto = SNR(i - 1, m2)
If (n1 - i) > (i - m1 + 1) Then
max_num = i - m1 + 1
Else
max_num = n1 - i
End If
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If max < SNR(i - 1, n2) Then
max = SNR(i - 1, n2)
Yamamoto = SNR(i - 1, m2)
If (n1 - i) > (i - m1 + 1) Then
max_num = i - m1 + 1
Else
max_num = n1 - i
End If
End If
End If
i = i + 1
Loop
If max > Hydrological_S.T_INV(n1 - m1 - 1, 1 - a / 2) / Sqr(max_num) Then
Yamamoto = "The change point is :" & Yamamoto & " with signficance(suggested)"
Exit Function
Else
Yamamoto = "The change point is :" & Yamamoto & " with no signficance(suggested)"
Exit Function
End If
Yamo:
 Yamamoto = "Error:"
End Function
Public Function Pettitt(data() As Double, KT() As String) As String 'Pettitt 法突变性检验
'Data 存储两列数据，第一列时间数据，第二列观测数据
'KT 存储两列数据，第一列时间数据,第二列统计计算数据
Dim m1 As Long, m2 As Long
Dim n1 As Long, n2 As Long
Dim i As Long, j As Long, k As Long, s As Long
Dim max As Double
On Error GoTo Pett:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
s = 0
For i = m1 To n1
s = s + Sgn(data(m1, n2) - data(i, n2))
Next
ReDim KT(m1 To n1 - 1, m2 To n2)
For i = m1 + 1 To n1
  KT(i - 1, m2) = data(i, m2)
  k = 0
For j = m1 To n1
  k = k + Sgn(data(i, n2) - data(j, n2))
Next
If i = m1 + 1 Then
 KT(i - 1, n2) = s + k
Else
 KT(i - 1, n2) = k + KT(i - 2, n2)
End If
If i = m1 + 9 Then
  max = Abs(KT(i - 1, n2))
  Pettitt = KT(i - 1, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If max < Abs(KT(i - 1, n2)) Then
  max = Abs(KT(i - 1, n2))
  Pettitt = KT(i - 1, m2)
End If
End If
 Next
If 2 * Exp(-6 * max * max / ((n1 - m1 + 1) * (n1 - m1 + 1) * (n1 - m1 + 2))) <= 0.5 Then
Pettitt = "The change point is :" & Pettitt & " with signficance"
Exit Function
Else
Pettitt = "The change point is :" & Pettitt & " with no signficance"
Exit Function
End If
Pett:
 Pettitt = "Error:"
End Function
Public Function Cramer_S(data() As Double, t() As String, a As Double) As String 'Cramer's 突变性检验(检验突变点）
''Data 存储两列数据，第一列时间数据，第二列观测数据
'T 存储两列数据，第一列时间数据,第二列统计计算数据
Dim m1 As Long, m2 As Long
Dim n1 As Long, n2 As Long
Dim i As Long, j As Long
Dim Ex As Double, s As Double
Dim Ex_1 As Double, tt As Double
On Error GoTo CraS:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim t(m1 To n1 - 1, m2 To n2)
Ex = 0
s = 0
For i = m1 To n1
Ex = Ex + data(i, n2)
s = s + data(i, n2) * data(i, n2)
Next
Ex = Ex / (n1 - m1 + 1)
s = s / (m1 - n1 + 1) - Ex * Ex
i = m1
Do While (i < n1)
Ex_1 = 0
For j = m1 To i
Ex_1 = Ex_1 + data(j, n2)
Next
Ex_1 = Ex_1 / (i - m1 + 1)
tt = (Ex_1 - Ex) / s
t(i, m2) = data(i, m2)
t(i, n2) = tt * Sqr((i - m1 + 1) * (n1 - m1 - 1) / (n1 - m1 + 1 - (i - m1 + 1) * (1 + tt)))
If i = m1 + 9 Then
 max = Abs(t(i, n2))
 Cramer_S = t(i, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
 If max < Abs(t(i, n2)) Then
  max = Abs(t(i, n2))
Cramer_S = t(i, m2)
 End If
End If
i = i + 1
Loop
If max > Hydrological_S.T_INV(n1 - m1 - 1, 1 - a / 2) Then
Cramer_S = "The change point is :" & Cramer_S & " with signficance"
Exit Function
Else
Cramer_S = "The change point is :" & Cramer_S & " with no signficance"
Exit Function
End If
CraS:
Cramer_S = "Error:"
End Function
Public Function Sliding_Chi_Square_Method(data() As Double, C() As String, a As Double) As String  '中位数突变检验(滑动卡方检验法）
''中位数的置信区间和假设检验
Dim i As Long, j As Long
Dim m1 As Long, n1 As Long
Dim m2 As Long, n2 As Long
Dim s As Double, Min As Double
Dim Re() As Double, max As Double
Dim x1 As Double, x2 As Double, x3 As Double, x4 As Double
On Error GoTo CHSM:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim Re(m1 To n1)
For i = m1 To n1
Re(i) = data(i, n2)
Next
For i = m1 To n1
 For j = i + 1 To n1
 If Re(j) < Re(i) Then
 s = Re(j)
 Re(j) = Re(i)
 Re(i) = s
 End If
 Next
 Next
If (n1 - m1 + 1) Mod 2 = 1 Then
 s = Re((n1 + m1) / 2)
Else
s = 0.5 * (Re((n1 + m1 - 1) / 2) + Re((n1 + m1 + 1) / 2))
End If
Debug.Print s
ReDim C(m1 To n1 - 3, m2 To n2)
i = m1 + 1
Do While (1)
x1 = 0
x2 = 0
x3 = 0
x4 = 0
For j = m1 To i
If data(j, n2) > s Then
x1 = x1 + 1
End If
Next
For j = i + 1 To n1
If data(j, n2) > s Then
x2 = x2 + 1
End If
Next
x3 = i - m1 + 1 - x1
x4 = n1 - i - x2
If (x1 + x2) < (x3 + x4) Then
Min = x1 + x2
Else
Min = x3 + x4
End If
If (x1 + x3) < (x2 + x4) Then
Min = Min * (x1 + x3) / (n1 - m1 + 1)
Else
Min = Min * (x2 + x4) / (n1 - m1 + 1)
End If
C(i - 1, m2) = data(i, m2)
If Min >= 5 Then
C(i - 1, n2) = (n1 - m1 + 1) * (x1 * x4 - x2 * x3) ^ 2 / (x1 + x2) / (x2 + x4) / (x3 + x4) / (x1 + x3)
Else
C(i - 1, n2) = (n1 - m1 + 1) * (Abs(x1 * x4 - x2 * x3) - (n1 - m1 + 1) / 2) ^ 2 / (x1 + x2) / (x2 + x4) / (x3 + x4) / (x1 + x3)
End If
'Debug.Print x1, x2, x3, x4, C(i - 1, m2), C(i - 1, n2), Min
If i = m1 + 9 Then
 max = C(i - 1, n2)
Sliding_Chi_Square_Method = C(i - 1, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If max < C(i - 1, m2 + 1) Then
max = C(i - 1, n2)
Sliding_Chi_Square_Method = C(i - 1, m2)
End If
End If
If i < n1 - 2 Then
  i = i + 1
 Else
  Exit Do
 End If
Loop
If max > Hydrological_S.Chi_Square_INV(1, 1 - a) Then
Sliding_Chi_Square_Method = "The change point is :" & Sliding_Chi_Square_Method & " with signficance"
Exit Function
Else
Sliding_Chi_Square_Method = "The change point is :" & Sliding_Chi_Square_Method & " with no signficance"
Exit Function
End If
CHSM:
Sliding_Chi_Square_Method = "Error:"
End Function
Public Function Sliding_F_Method(data() As Double, F() As String, a As Double) As String   '滑动F法（跳跃变异分析）
'Data 存储两列数据，第一列时间数据，第二列观测数据(最少11年观测数据，变异点设置为5年后）
'F 储存两列数据，第一列储存变异点的时间节点，第二列存储F值
Dim i As Long, j As Long
Dim m1 As Long, n1 As Long
Dim m2 As Long, n2 As Long
Dim b As Double
Dim Ex1 As Double, Ex2 As Double
Dim s1 As Double, s2 As Double
Dim max As Double, max_num As Long
'On Error GoTo SlFM:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
If n1 - m1 < 3 Then
Sliding_F_Method = " The number of data is too small to calculate"
Exit Function
End If
ReDim Preserve F(m1 To n1 - 3, m2 To n2)
'i = m1 + 1 ~ n1 - 2
i = m1 + 1
Do While (1)
F(i - 1, m2) = data(i, m2)
  Ex1 = 0
  s1 = 0
  b = 0
 For j = m1 To i
 Ex1 = Ex1 + data(j, n2)
 b = b + (data(j, n2)) * data(j, n2)
 Next
 Ex1 = Ex1 / (i - m1 + 1)
 s1 = (b - (i - m1 + 1) * Ex1 * Ex1) / (i - m1)
 Ex2 = 0
 s2 = 0
 b = 0
 For j = i + 1 To n1
 Ex2 = Ex2 + data(j, n2)
 b = b + data(j, n2) * data(j, n2)
 Next
 Ex2 = Ex2 / (n1 - i)
 s2 = (b - (n1 - i) * Ex2 * Ex2) / (n1 - i - 1)
 If s1 > s2 Then
 F(i - 1, m2 + 1) = s1 / s2
  If i = m1 + 9 Then
 max = F(i - 1, m2 + 1)
 max_num = i - m1
 Sliding_F_Method = F(i - 1, m2)
 ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
 If max < F(i - 1, m2 + 1) Then
 max = F(i - 1, m2 + 1)
 max_num = i - m1
 Sliding_F_Method = F(i - 1, m2)
 End If
 End If
' f(i - 1, m2 + 2) = Hydrological_S.F_INV(i - m1, n1 - i - 1, 1 - a)
 Else
 If s1 <> 0 Then
 F(i - 1, m2 + 1) = s2 / s1
 Else
 F(i - 1, m2 + 1) = 0
 End If
  If i = m1 + 9 Then
 max = F(i - 1, m2 + 1)
 max_num = n1 - i - 1
 Sliding_F_Method = F(i - 1, m2)
 ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
 If max < F(i - 1, m2 + 1) Then
 max = F(i - 1, m2 + 1)
 max_num = n1 - i - 1
 Sliding_F_Method = F(i - 1, m2)
 End If
 End If
' f(i - 1, m2 + 2) = Hydrological_S.F_INV(n1 - i - 1, i - m1, 1 - a)
 End If
 If i < n1 - 2 Then
  i = i + 1
 Else
  Exit Do
 End If
Loop
If max > Hydrological_S.F_INV(max_num, n1 - m1 - 1 - max_num, 1 - a) Then
Sliding_F_Method = "The change point is :" & Sliding_F_Method & " with signficance"
Exit Function
Else
Sliding_F_Method = "The change point is :" & Sliding_F_Method & " with no signficance"
Exit Function
End If
SlFM:
Sliding_F_Method = "Error:"
End Function
Public Function Sliding_T_Method(data() As Double, t() As String, a As Double) As String  '滑动T检验法,判定最可能变异点
'Data 存储两列数据，第一列时间数据，第二列观测数据
'T()存储两列数据，第一列时间数据，第二列计算统计量的值
'a 表示置信度
Dim m1 As Long, n1 As Long
'Dim Re() As Double
Dim m2 As Long, n2 As Long
Dim Ex1 As Double, Ex2 As Double
'Dim Std1 As Double, Std2 As Double
Dim Med1 As Double, Med2 As Double
Dim i As Long, j As Long
'Dim k As Long
Dim max As Double
On Error GoTo SlTm:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
''''''''''''''''''''''''''''''''''''''''''''''''''''''Box-Cox 变换
'max = box_cox_single(Data)
'For i = m1 To n1
'If max <> 0 Then
'Data(i, n2) = (Data(i, n2) ^ max - 1) / max
'Else
'Data(i, n2) = Log(Data(i, n2))
'End If
'Next
''''''''''''''''''''''''''''''''''''''''''''''
ReDim t(m1 To n1 - 3, m2 To n2)
i = m1 + 1
Do While (1)
Ex1 = 0
Std1 = 0
'ReDim Re(m1 To i)
For j = m1 To i
'Re(j) = Data(j, n2)
Ex1 = Ex1 + data(j, n2)
Std1 = Std1 + data(j, n2) * data(j, n2)
Next
'''''''''''''''''''''''''''''''''''''''''中位数提取
'For j = m1 To i
 ' For k = j To i
 ' If Re(k) > Re(j) Then
 ' Med1 = Re(k)
 ' Re(k) = Re(j)
 ' Re(j) = Med1
 ' End If
 ' Next
'Next
'If (i - m1 + 1) Mod 2 = 1 Then
'Med1 = Re((m1 + i) / 2)
'Else
'Med1 = 0.5 * (Re((m1 + i - 1) / 2) + Re((m1 + i + 1) / 2))
'End If
''''''''''''''''''''''''''''''''''''''''''
Ex1 = Ex1 / (i - m1 + 1)
Std1 = Std1 - Ex1 * Ex1 * (i - m1 + 1)
Ex2 = 0
Std2 = 0
'ReDim Re(i + 1 To n1)
For j = i + 1 To n1
'Re(j) = Data(j, n2)
Ex2 = Ex2 + data(j, n2)
Std2 = Std2 + data(j, n2) * data(j, n2)
Next
''''''''''''''''''''''''''''''''''''''''''中位数提取
'For j = i + 1 To n1
'  For k = j To n1
'  If Re(k) > Re(j) Then
 ' Med2 = Re(k)
 ' Re(k) = Re(j)
 ' Re(j) = Med2
'  End If
'  Next
'Next
'If (n1 - i) Mod 2 = 1 Then
'Med2 = Re((n1 + i + 1) / 2)
'Else
'Med2 = 0.5 * (Re((n1 + i) / 2) + Re((n1 + i + 2) / 2))
'End If
''''''''''''''''''''''''''''''''''''''''''
Ex2 = Ex2 / (n1 - i)
Std2 = Std2 - Ex2 * Ex2 * (n1 - i)
t(i - 1, m2) = data(i, m2)
t(i - 1, n2) = (Ex1 - Ex2) / (Sqr(1 / (i - m1 + 1) + 1 / (n1 - i))) / Sqr((Std1 + Std2) / (n1 - m1 - 1))
't(i - 1, n2) = (Med1 - Med2) / (Sqr(1 / (i - m1 + 1) + 1 / (n1 - i))) / Sqr((Std1 + Std2) / (n1 - m1 - 1))
If i = m1 + 9 Then
 max = Abs(t(i - 1, n2))
 Sliding_T_Method = data(i, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If max < Abs(t(i - 1, n2)) Then
 max = Abs(t(i - 1, n2))
 Sliding_T_Method = data(i, m2)
End If
End If
If i < n1 - 2 Then
 i = i + 1
Else
Exit Do
End If
Loop
If max > Hydrological_S.T_INV(n1 - m1 - 1, 1 - a / 2) Then
Sliding_T_Method = "The change point is :" & Sliding_T_Method & " with signficance"
Exit Function
Else
Sliding_T_Method = "The change point is :" & Sliding_T_Method & " with no signficance"
Exit Function
End If
SlTm:
Sliding_T_Method = "Error:"
End Function
Public Function Sliding_RunTest_Method(data() As Double, U() As String, a As Double) As String '滑动游程法
'要求数据至少40个，否则查游程检验临界值表即可。
'考虑到数据的不可靠性，如果存在一子序列小于20，则应结合成因进行分析
'data 存放两列数据，第一列时间数据，第二列存放观测数据
'U 存放两列数据，第一列时间数据，第二列统计值数据
' a 置信度
Dim m1 As Long, m2 As Long
Dim n1 As Long, n2 As Long
Dim i As Long, j As Long, k As Long
Dim max As Double, kk As Long
Dim nn1 As Long, nn2 As Long
Dim rr() As Double, uu() As Double
Dim n As Double, Tr As Boolean
'On Error GoTo SliRunT:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim U(m1 To n1 - 1, m2 To n2)
ReDim rr(m1 To n1)
ReDim uu(m1 To n1)
n = -m1 + n1 + 1
If (n1 - m1 + 1) < 40 Then
Sliding_RunTest_Method = " Please use the the limit table of the run test to make the test of the data."
Exit Function
End If
For i = m1 To n1
rr(i) = data(i, n2)
Next
For i = m1 To n1
 For j = i + 1 To n1
 If rr(i) > rr(j) Then
   kk = rr(i)
   rr(i) = rr(j)
   rr(j) = kk
 End If
 Next
 Next
i = m1
Do While (1)
For j = m1 To n1
uu(j) = 1
Next
For j = m1 To i
For k = m1 To n1
If rr(k) = data(j, n2) Then
If uu(k) = 1 Then
uu(k) = 0
Exit For
End If
End If
Next
Next
kk = 0
For j = m1 To n1 - 1
If uu(j) = uu(j + 1) Then
kk = kk + 0
Else
kk = kk + 1
End If
Next
kk = kk + 1
nn1 = i - m1 + 1
nn2 = n - nn1
U(i, m2) = data(i, m2)
U(i, n2) = (kk - 0.5 * Sgn(kk - (1 + 2 * nn1 * nn2 / n)) - (1 + 2 * nn1 * nn2 / n)) / Sqr(2 * nn1 * nn2 * (2 * nn1 * nn2 - n) / (n * n * (n - 1)))
If i = m1 + 9 Then
max = Abs(U(i, n2))
Tr = True
Sliding_RunTest_Method = U(i, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If max < Abs(U(i, n2)) Then
max = Abs(U(i, n2))
Sliding_RunTest_Method = U(i, m2)
If (nn1) < 20 Or (nn2) < 20 Then
Tr = True
Else
Tr = False
End If
End If
End If
If i < n1 - 1 Then
i = i + 1
Else
If max > Hydrological_S.Normal_INV(0, 1, 1 - a / 2) Then
If Tr = False Then
Sliding_RunTest_Method = "The change point is :" & Sliding_RunTest_Method & " with signficance"
Else
Sliding_RunTest_Method = "The change point is :" & Sliding_RunTest_Method & " with signficance but not reliable"
End If
Exit Function
Else
If Tr = True Then
Sliding_RunTest_Method = "The change point is :" & Sliding_RunTest_Method & " with no signficance"
Else
Sliding_RunTest_Method = "The change point is :" & Sliding_RunTest_Method & " with no signficance but not reliable "
End If
Exit Function
End If
End If
Loop
SliRunT:
Sliding_RunTest_Method = "Error:"
End Function
Public Function Sliding_RankSum_Method(data() As Double, U() As String, a As Double) As String    '滑动秩和法,判定最有可能跳跃点
' 要求数据系列长度不小于20,认为子序列最短长度为5(本程序计算数据并没考虑这一点，尽可能点点聚到，但在判定时按照此要求进行）
'即数据系列为x1,x2,x3,x4,x5,....,xn-4,xn-3,xn-2,xn-1,xn,分割点应在x5~xn-4
'考虑到数据的不可靠性，如果存在一子序列小于10，则应结合成因进行分析
'data 存放两列数据，第一列时间数据，第二列存放观测数据
'U 存放两列数据，第一列时间数据，第二列统计值数据
' a 置信度
Dim m1 As Long, m2 As Long
Dim n1 As Long, n2 As Long
Dim i As Long, j As Long, k As Long
Dim w1 As Double, w2 As Double, p As Long
Dim max As Double
Dim c1 As Double, c2 As Double '修正
Dim DA() As Double
Dim ran() As Double
On Error GoTo SLrM:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
If (n1 - m1 + 1) < 20 Then
Sliding_RankSum_Method = " Please use the the upper and lower table to make the test of the data."
Exit Function
End If
ReDim U(m1 To n1 - 1, m2 To n2)
ReDim DA(m1 To n1)
ReDim ran(m1 To n1)
For i = m1 To n1
DA(i) = data(i, n2)
ran(i) = i - m1 + 1
Next
c1 = 0 '记录秩相同的个数
c2 = 0 '记录修正值
For i = m1 To n1
 For j = i + 1 To n1
 If DA(i) > DA(j) Then
 w1 = DA(i)
 DA(i) = DA(j)
 DA(j) = w1
 End If
 Next
 Next
For i = m1 To n1 - 1
    k = 0
For j = i + 1 To n1
  If DA(j) = DA(i) Then
    k = k + 1
  Else
    If k <> 0 Then
      w1 = ran(i)
     For p = i To j - 1
       ran(p) = w1 + k / 2
     Next
      c1 = c1 + k
      c2 = k ^ 3 - k + c2
       k = 0
    End If
   i = j - 1
  Exit For
 End If
Next
Next
If c1 < 0.25 * (n1 - m1 + 1) Then
 c2 = 1
Else
c2 = 1 - c2 / ((n1 - m1 + 1) ^ 3 - (n1 - m1 + 1))
End If
i = m1
w1 = 0
w2 = 0
Do While (1)
If (i - m1 + 1) < (n1 - i + 1) Then
For j = m1 To n1
If DA(j) = data(i, n2) Then
w1 = w1 + ran(j)
Exit For
End If
Next
'''''''''''''''''''''''''''''''''''''''''
U(i, m2) = data(i, m2)
U(i, n2) = (w1 - (i - m1 + 1) * (n1 - m1 + 2) / 2) / Sqr((i - m1 + 1) * (n1 - i) * (n1 - m1 + 2) / 12 * c2)
'''''''''''''''''''''''''''''''''''''''''
ElseIf (i - m1 + 1) = (n1 - i + 1) Then
For j = m1 To n1
If DA(j) = data(i, n2) Then
w1 = w1 + ran(j)
Exit For
End If
Next
For k = i + 1 To n1
For j = m1 To n1
If DA(j) = data(k, n2) Then
w2 = w2 + ran(j)
Exit For
End If
Next
Next
U(i, m2) = data(i, m2)
U(i, n2) = (w1 / 2 + w2 / 2 - (n1 - i) * (n1 - m1 + 2) / 2) / Sqr((i - m1 + 1) * (n1 - i) * (n1 - m1 + 2) / 12 * c2)
Else
For j = m1 To n1
If DA(j) = data(i, n2) Then
w2 = w2 - ran(j)
Exit For
End If
Next
'''''''''''''''''''''''''''''''''''''''''
U(i, m2) = data(i, m2)
U(i, n2) = (w2 - (n1 - i) * (n1 - m1 + 2) / 2) / Sqr((i - m1 + 1) * (n1 - i) * (n1 - m1 + 2) / 12 * c2)
'''''''''''''''''''''''''''''''''''''''''
End If
If i - m1 = 9 Then
max = Abs(U(i, n2))
Sliding_RankSum_Method = U(i, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If max < Abs(U(i, n2)) Then
max = Abs(U(i, n2))
Sliding_RankSum_Method = U(i, m2)
End If
End If
If i < n1 - 1 Then
i = i + 1
Else
Exit Do
End If
Loop
If max > Hydrological_S.Normal_INV(0, 1, 1 - a / 2) Then
Sliding_RankSum_Method = "The change point is :" & Sliding_RankSum_Method & " with signficance"
Exit Function
Else
Sliding_RankSum_Method = "The change point is :" & Sliding_RankSum_Method & " with no signficance"
Exit Function
End If
SLrM:
Sliding_RankSum_Method = "Error:"
End Function
Public Function Ordered_Clustering_Method(data() As Double, Nod() As String) As String  '有序聚类法,判定最有可能跳跃点
'Data 存储两列数据，第一列时间数据，第二列观测数据
'Nod  第一列时间数据，第二列总离差平方和最小数据
Dim i As Long, j As Long
Dim s1 As Double, s2 As Double, s As Double
Dim Ex1 As Double, Ex2 As Double
Dim Min As Double
Dim m1 As Long, n1 As Long
Dim m2 As Long, n2 As Long
On Error GoTo OrClM:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim Nod(m1 To n1 - 1, m2 To n2)
i = m1
k = 0
Do While (1)
 Ex1 = 0
 s = 0
For j = m1 To i
Ex1 = Ex1 + data(j, n2)
s = s + data(j, n2) * data(j, n2)
Next
s1 = s - Ex1 * Ex1 / (i - m1 + 1)
 Ex2 = 0
 s = 0
For j = i + 1 To n1
Ex2 = Ex2 + data(j, n2)
s = s + data(j, n2) * data(j, n2)
Next
s2 = s - Ex2 * Ex2 / (n1 - i)
Nod(i, m2) = data(i, m2)
Nod(i, n2) = s2 + s1
If i = m1 + 9 Then
  Min = s1 + s2
Ordered_Clustering_Method = Nod(i, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If Min > s1 + s2 Then
 Min = s1 + s2
Ordered_Clustering_Method = Nod(i, m2)
End If
End If
If i < n1 - 1 Then
 i = i + 1
Else
Ordered_Clustering_Method = "The Change_Point is:" & Ordered_Clustering_Method & " with Adjusted"
 Exit Function
End If
Loop
OrClM:
Ordered_Clustering_Method = "Error:"
End Function
Public Function LeeHeghinian_Method(data() As Double, Fdx() As String) As String  'Lee-Heghinian 法（变异分析）
'Data 存储两列数据，第一列时间数据，第二列观测数据
'Fdx 存储两列数据,'第一列时间数据，第二列后沿概率密度函数
Dim i As Long, j As Long
Dim s1 As Double, s2 As Double, s As Double
Dim s_ As Double
Dim Ex1 As Double, Ex2 As Double
Dim max As Double
Dim m1 As Long, n1 As Long
Dim m2 As Long, n2 As Long
On Error GoTo LeHme:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim Fdx(m1 To n1 - 1, m2 To n2)
i = m1
k = 0
Do While (1)
 Ex1 = 0
 s = 0
For j = m1 To i
Ex1 = Ex1 + data(j, n2)
s = s + data(j, n2) * data(j, n2)
Next
s1 = s - Ex1 * Ex1 / (i - m1 + 1)
s_ = s
 Ex2 = 0
 s = 0
For j = i + 1 To n1
Ex2 = Ex2 + data(j, n2)
s = s + data(j, n2) * data(j, n2)
Next
s_ = s_ + s
s2 = s - Ex2 * Ex2 / (n1 - i)
Fdx(i, m2) = data(i, m2)
Fdx(i, n2) = ((((s2 + s1) / (s_ - (Ex1 + Ex2) * (Ex1 + Ex2) / (n1 - m1 + 1)))) ^ (1 - (n1 - m1 + 1) / 2)) * Sqr((n1 - m1 + 1) / ((i - m1 + 1) * (n1 - i)))
If i = m1 + 9 Then
  max = Fdx(i, n2)
LeeHeghinian_Method = Fdx(i, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If max < Fdx(i, n2) Then
 max = Fdx(i, n2)
LeeHeghinian_Method = Fdx(i, m2)
End If
End If
If i < n1 - 1 Then
 i = i + 1
Else
LeeHeghinian_Method = "The Change_Point is:" & LeeHeghinian_Method & " with adjusted"
 Exit Function
End If
Loop
LeHme:
LeeHeghinian_Method = "Error:"
End Function
Private Function Hurst(data() As Double) As String  'Hurst 指数计算
'data 单列实测数据
Dim i As Long, j As Long, k As Long
Dim Ex As Double, s_ As Double
Dim Ex_ As Double, Q As Double
Dim r() As Double, s() As Double
Dim max As Double, Min As Double
Dim x() As Double
Dim t As Long
Dim m1 As Double, n1 As Double
On Error GoTo Hurs:
m1 = LBound(data)
n1 = UBound(data)
i = m1 + 1
ReDim s(m1 To n1)
ReDim r(m1 To n1)
Do While (1)
Ex = 0
s_ = 0
For j = m1 To i
Ex = Ex + data(j)
s_ = s_ + data(j) * data(j)
Next
Ex = Ex / (i - m1 + 1)
If Abs(s_ / (i - m1) - Ex * Ex * (i - m1 + 1) / (i - m1)) < 1E-16 Then
s(i) = 0
Else
s(i) = Sqr(s_ / (i - m1) - Ex * Ex * (i - m1 + 1) / (i - m1))
End If
ReDim x(m1 To i, m1 To i)
For j = m1 To i
x(j, i) = 0
For k = m1 To j
x(j, i) = x(j, i) + (data(k) - Ex)
Next
If j = m1 Then
max = x(j, i)
Min = x(j, i)
Else
If max < x(j, i) Then
   max = x(j, i)
End If
If Min > x(j, i) Then
Min = x(j, i)
End If
End If
Next
r(i) = max - Min
If i < n1 Then
i = i + 1
Else
Exit Do
End If
Loop
Min = 0
max = 0
Ex_ = 0
Ex = 0
t = 0
For j = m1 + 1 To n1
If r(j) = 0 Then
t = t + 1
Else
Ex = Ex + Log(j - m1 + 1)
Ex_ = Ex_ + Log(r(j) / s(j))
End If
Next
Ex = Ex / (n1 - m1 - t)
Ex_ = Ex_ / (n1 - m1 - t)
For j = m1 + 1 To n1
If r(j) <> 0 Then
Min = Min + (Log(j - m1 + 1) - Ex) * (Log(r(j) / s(j)) - Ex_)
max = max + (Log(j - m1 + 1) - Ex) * (Log(j - m1 + 1) - Ex)
End If
Next
Hurst = Min / max
Exit Function
Hurs:
Hurst = "Error:"
End Function
Public Function Brown_Forsythe(data() As Double, Vr() As String, a As Double) As String   'Borwn-Forsythe法（最可能变异子序列分析）
''Data 存储两列数据，第一列时间数据，第二列观测数据
'考虑统计数据，后一个分割样本数据比前一个分割样本数据大10个（这里未考虑）
'VR 存储三列数据,,,第一列时间数据，第二列检验数据值
Dim m1 As Double, n1 As Double
Dim m2 As Double, n2 As Double
Dim i As Long, n As Long
Dim s1 As Double, s2 As Double, s As Double
Dim Ex1 As Double, Ex2 As Double, Ex As Double
Dim c1 As Double, c2 As Double
Dim max As Double, max_number As Double
On Error GoTo BrFs:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim Vr(m1 To n1 - m1 - 3, m2 To n2)
i = m1 + 1
Do While (1)
Ex1 = 0
s1 = 0
For j = m1 To i
Ex1 = Ex1 + data(j, n2)
s1 = s1 + data(j, n2) * data(j, n2)
Next
Ex = Ex1
s1 = s1 / (i - m1) - Ex1 * Ex1 / (i - m1 + 1) / (i - m1)
s2 = 0
Ex2 = 0
For j = i + 1 To n1
Ex2 = Ex2 + data(j, n2)
s2 = s2 + data(j, n2) * data(j, n2)
Next
Ex = Ex + Ex2
s2 = s2 / (n1 - i - 1) - Ex2 * Ex2 / (n1 - i) / (n1 - i - 1)
Vr(i - 1, m2) = data(i, m2)
Vr(i - 1, n2) = (i - m1 + 1) * (Ex1 / (i - m1 + 1) - Ex / (n1 - m1 + 1)) ^ 2 + (n1 - i) * (Ex2 / (n1 - i + 1) - Ex / (n1 - m1 + 1)) ^ 2
Vr(i - 1, n2) = Vr(i - m1 - 1, n2) / ((1 - (i - m1 + 1) / (n1 - m1 + 1)) * s1 + (1 - (n1 - i) / (n1 - m1 + 1)) * s2)
c1 = (1 - (i - m1 + 1) / (n1 - m1 + 1)) * s1 / ((1 - (i - m1 + 1) / (n1 - m1 + 1)) * s1 + (1 - (n1 - i) / (n1 - m1 + 1)) * s2)
c2 = (1 - (i - m1 + 1) / (n1 - m1 + 1)) * s1 / ((1 - (i - m1 + 1) / (n1 - m1 + 1)) * s1 + (1 - (n1 - i) / (n1 - m1 + 1)) * s2)
'VR(i  - 1, n2 + 1) = (1 / (c1 * c1 / (i - m1) + c2 * c2 / (n1 - i - 1)))
If i = m1 + 9 Then
max = Vr(i - 1, n2)
max_num = (1 / (c1 * c1 / (i - m1) + c2 * c2 / (n1 - i - 1)))
Brown_Forsythe = Vr(i - 1, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If max < Vr(i - 1, n2) Then
max = Vr(i - 1, n2)
max_num = (1 / (c1 * c1 / (i - m1) + c2 * c2 / (n1 - i - 1)))
Brown_Forsythe = Vr(i - 1, m2)
End If
End If
If Abs(Fix(max_num) - max_num) > 1E-16 Then
max_num = Fix(max_num) + 1
End If
If i < n1 - 2 Then
i = i + 1
Else
Exit Do
End If
Loop
If max > Hydrological_S.F_INV(1, CLng(max_num), 1 - a) Then
Brown_Forsythe = "The change point is :" & Brown_Forsythe & " with signficance"
Exit Function
Else
Brown_Forsythe = "The change point is :" & Brown_Forsythe & " with no signficance"
Exit Function
End If
BrFs:
Brown_Forsythe = "Error:"
End Function
Public Function R_S_Method(data() As Double, HH() As String) As String  'R/S 检验法（变异数据检测）
'Data 存储两列数据，第一列时间数据，第二列观测数据
'HH 存储两列数据，第一列时间数据，第二列变异点前后Hurst绝对值之差（10，11，，，，n-10),这里从3开始
Dim m1 As Long, n1 As Long
Dim m2 As Long, n2 As Long
Dim j As Long
Dim p As Long, H1 As Double, H2 As Double
Dim max As Double
Dim xx() As Double
On Error GoTo Rsmd:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim HH(m1 To n1 - 5, m2 To n2)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
For p = m1 + 2 To n1 - 3
HH(p - 2, m2) = data(p, m2)
Q = 1
Do While (1)
If Q = 1 Then
  ReDim xx(m1 To p)
 For j = m1 To p
   xx(j) = data(j, n2)
 Next
ElseIf Q = 2 Then
ReDim xx(m1 To m1 + n1 - p1 - 1)
 For j = p + 1 To n1
 xx(j - p - 1 + m1) = data(j, n2)
 Next
End If
If Q = 1 Then
H1 = CDbl(Hurst(xx()))
Else
H2 = CDbl(Hurst(xx())) ' p + 2 - m1
End If
Q = Q + 1
If Q > 2 Then
Exit Do
End If
HH(p - 2, n2) = Abs(H1 - H2)
If p = m1 + 9 Then
max = Abs(H1 - H2)
R_S_Method = HH(p - 2, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If max < Abs(H1 - H2) Then
max = Abs(H1 - H2)
R_S_Method = HH(p - 2, m2)
End If
End If
Loop
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Next
R_S_Method = "The Change_Point is:" & R_S_Method & " With adjusted "
Exit Function
Rsmd:
R_S_Method = "Error:"
End Function
Public Function Optimal_Information_Two_Method(data() As Double, Coi() As String)  '最优信息二分割法（变异分析）
'Data 存储两列数据，第一列时间数据，第二列观测数据
'Coi 两列数据，第一列时间数据，第二列差异幅值数据
Dim i As Long, j As Long
Dim Ex1 As Double, Ex2 As Double
Dim max As Double
Dim m1 As Long, n1 As Long
Dim m2 As Long, n2 As Long
Dim sum As Double, s As Double, s_ As Double
Dim z() As Double, ii() As Double, C() As Double
On Error GoTo OpInTm:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim z(m1 To n1)
ReDim ii(m1 To n1)
ReDim C(m1 To n1)
ReDim Coi(m1 To n1, m2 To n2)
i = m1
Do While (i < n1 + 1)
Ex1 = 0
Ex2 = 0
For j = m1 To i
 Ex1 = Ex1 + data(j, n2)
Next
Ex1 = Ex1 / (i - m1 + 1)
For j = i + 1 To n1
Ex2 = Ex2 + data(j, n2)
Next
If i < n1 Then
Ex2 = Ex2 / (n1 - i)
Else
Ex2 = Ex1
End If
sum = 0
For j = m1 To n1
If j < i + 1 Then
z(j) = (data(j, n2) - Ex1) ^ 2
Else
z(j) = (data(j, n2) - Ex2) ^ 2
End If
sum = sum + 1 / (1 + z(j))
Next
 s = 0
For j = m1 To n1
s_ = 1 / (1 + z(j)) / sum
s = s + s_ * Log(s_)
Next
ii(i) = 1 / Log(2) * (Log(n1 - m1 + 1) + s)
If i = 1 Then
max = ii(i)
Else
If max < ii(i) Then
  max = ii(i)
End If
End If
i = i + 1
Loop
  sum = 0
For i = m1 To n1
  ii(i) = ii(i) / max
  C(i) = ii(i) / ii(n1)
  sum = sum + C(i)
Next
For i = m1 To n1
Coi(i, m2) = data(i, m2)
Coi(i, n2) = C(i) / sum - 1
If i = m1 + 9 Then
  s = Coi(i, n2)
Optimal_Information_Two_Method = Coi(i, m2)
ElseIf (n1 - i) > 9 And (i > m1 + 9) Then
If s > Coi(i, n2) Then
  s = Coi(i, n2)
 Optimal_Information_Two_Method = Coi(i, m2)
End If
End If
Next
Optimal_Information_Two_Method = "The Change_Point is:" & Optimal_Information_Two_Method & " with adjusted "
Exit Function
OpInTm:
 Optimal_Information_Two_Method = "Error:"
End Function
Public Function Mann_Kendall(data() As Double, U() As String) As String  'Mann-kendall 突变检验
'Data 存储两列数据，第一列时间数据，第二列观测数据
Dim m1 As Long, n1 As Long
Dim m2 As Long, n2 As Long
Dim i As Long, j As Long, k As Long
Dim D() As Double
Dim E() As Double
Dim s() As Double
Dim DA() As Double ''''''存储反向数据
On Error GoTo MaKendl:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim U(m1 To n1, m2 To n2 + 1)
ReDim D(m1 + 1 To n1)
ReDim E(m1 + 1 To n1)
ReDim s(m1 + 1 To n1)
ReDim DA(m1 To n1)
For i = m1 To n1
DA(i) = data(m1 + n1 - i, n2)
Next
For i = m1 + 1 To n1
E(i) = (1 - m1 + i) * (i - m1) / 4
s(i) = (1 - m1 + i) * (i - m1) * (2 * (1 - m1 + i) + 5) / 72
D(i) = 0
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
For j = m1 To i
  For k = m1 To j
If data(j, n2) > data(k, n2) Then
   D(i) = D(i) + 1
End If
Next
Next
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
U(i, n2) = (D(i) - E(i)) / Sqr(s(i))
U(i, m2) = data(i, m2)
Next
U(m1, n2) = 0
U(m1, m2) = data(m1, m2)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
For i = m1 + 1 To n1
E(i) = (1 - m1 + i) * (i - m1) / 4
s(i) = (1 - m1 + i) * (i - m1) * (2 * (1 - m1 + i) + 5) / 72
D(i) = 0
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
For j = m1 To i
  For k = m1 To j
If DA(j) > DA(k) Then
   D(i) = D(i) + 1
End If
Next
Next
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
U(m1 + n1 - i, n2 + 1) = -(D(i) - E(i)) / Sqr(s(i))
Next
U(n1, n2 + 1) = 0
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Exit Function
MaKendl:
 Mann_Kendall = "Error:"
End Function
Public Function Mann_Whitney(data() As Double, t() As String, a As Double) As String  '突变检验
Dim m1 As Long, n1 As Long
Dim m2 As Long, n2 As Long
Dim i As Long, j As Long, k As Long
Dim r() As String, s As Double
Dim rr() As Double, max As Double
On Error GoTo ManWh:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim r(m1 To n1)
ReDim rr(m1 To n1)
ReDim t(m1 To n1 - 1, m2 To n2)
For i = m1 To n1
r(i) = data(i, n2)
rr(i) = i - m1 + 1
Next
For i = m1 To n1 - 1
 For j = i + 1 To n1
 If (r(i)) > (r(j)) Then
  s = r(i)
  r(i) = r(j)
  r(j) = s
End If
 Next
 Next
 k = 0
For i = m1 To n1 - 1
If r(i) = r(i + 1) Then
k = k + 1
Else
If k <> 0 Then
For j = i - k To i
rr(j) = i - m1 + 1 - k / 2 '秩的平均化
Next
 k = 0
i = j - 1
End If
End If
Next
i = m1
s = 0
Do Until (i > n1 - 1)
For k = m1 To n1
If r(k) = CStr(data(i, n2)) Then
 s = s + rr(k)
 r(k) = "*"
 Exit For
End If
Next
t(i, m2) = data(i, m2)
t(i, n2) = (s - (i - m1 + 1) * (n1 - m1 + 2) / 2) / Sqr((i - m1 + 1) * (n1 - i) * (n1 - m1 + 2) / 12)
If i = m1 + 9 Then
max = Abs(t(i, n2))
Mann_Whitney = t(i, m2)
ElseIf (n1 - i) > 9 And i > m1 + 9 Then
If max < Abs(t(i, n2)) Then
max = Abs(t(i, n2))
Mann_Whitney = t(i, m2)
End If
End If
i = i + 1
Loop
If max > Hydrological_S.Normal_INV(0, 1, 1 - a / 2) Then
Mann_Whitney = "The change point is :" & Mann_Whitney & " with signficance"
Exit Function
Else
Mann_Whitney = "The change point is :" & Mann_Whitney & " with no signficance"
Exit Function
End If
ManWh:
Mann_Whitney = "Error:"
End Function
'<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<趋势性分析<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Public Function SpearmanRankCorrelation_Test(data() As Double, Res() As String, a As Double) As String  '斯皮尔曼（Spearman）秩次相关检验法（检验是否存在趋势）
'Data 存储两列数据，第一列时间数据，第二列观测数据
' Res 检验结果数组(计算结果值+分布限值）
'R() 存储两列数据，第一列观测数据的自然序号，第二列观测数据由小到大后的自然序号
Dim i As Long, j As Long
Dim r() As Double
Dim s As Double, r_ As Double '中间变量
Dim r__ As Double '中间变量
Dim m1 As Double, n1 As Double
Dim m2 As Double, n2 As Double
Dim DA() As String
On Error GoTo SPrct:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim r(m1 To n1, m2 To n2)
ReDim Res(m2 To n2)
ReDim DA(m1 To n1)
For i = m1 To n1
r(i, m2) = i - m1 + 1
DA(i) = data(i, n2)
Next
For i = m1 To n1
  For j = i + 1 To n1
  If DA(i) > DA(j) Then
  s = DA(i)
  DA(i) = DA(j)
  DA(j) = s
  End If
  Next
  Next
For i = m1 To n1
For j = m1 To n1
If CStr(DA(j)) = CStr(data(i, n2)) Then
 r(i, n2) = j - m1 + 1
 DA(j) = "*"
 Exit For
End If
Next
Next
s = 0
For i = m1 To n1
s = s + (r(i, n2) - r(i, m2)) * (r(i, n2) - r(i, m2))
Next
r_ = 1 - 6 * s / (n1 - m1 + 1) / (n1 - m1 + 2) / (n1 - m1)
r_ = r_ * Sqr(((n1 - m1 - 3) / (1 - r_ * r_)))
r__ = Hydrological_S.T_INV(n1 - m1 - 1, 1 - a / 2)
Res(m2) = r_
Res(n2) = r__
If Abs(r_) > r__ Then
SpearmanRankCorrelation_Test = " There exists the signficant in the data series."
Exit Function
Else
SpearmanRankCorrelation_Test = " There exists no the signficant in the data series."
Exit Function
End If
SPrct:
SpearmanRankCorrelation_Test = "Error:"
End Function
Public Function Mann_Kendall_Trend(data() As Double, a As Double) ' Mann-kendall 趋势性分析(修正）
'''年径流序列趋势识别研究
Dim s As Double, z As Double
Dim i As Long, j As Long
Dim n1 As Long, m1 As Long
Dim m2 As Long, n2 As Long, n As Long
Dim CF As Double, m As Long
Dim s1 As Double, s2 As Double
Dim r() As Double
Dim rr()  As Long
On Error GoTo MaKe:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
 s = 0
n = n1 - m1 + 1
If n < 10 Then
Mann_Kendall_Trend = "**"
End If
m = Fix(n / 4) - 1 + m1
ReDim r(m1 To m)
ReDim rr(m1 To n1) ' 秩记录矩阵
For i = m1 To n1 - 1
  For j = i + 1 To n1
  s = s + Sgn(data(j, n2) - data(i, n2))
  Next
  Next
For i = m1 To n1
  rr(i) = 1
For j = m1 To n1
If data(i, n2) > data(j, n2) Then
 rr(i) = rr(i) + 1
End If
Next
Next
  CF = 0
  s1 = 0
For i = m1 To n1
  CF = CF + rr(i)
  s1 = s1 + rr(i) * rr(i)
Next
CF = CF / (n1 - m1 + 1)
s1 = s1 - CF * CF * (n1 - m1 + 1)
For i = m1 To m
s2 = 0
For j = m1 To n1 - i
s2 = s2 + (rr(j + i) - CF) * (rr(j) - CF)
Next
r(i) = s2 / s1
Next
CF = 0
For i = m1 To m
CF = CF + (n1 - i) * (n1 - i - 1) * (n1 - i - 2) * r(i)
Next
CF = CF * 2 / (n - 1) / n / (n - 2) + 1
 If s > 0 Then
 z = (s - 1) / (Sqr(n * (n - 1) * (2 * n + 5) / 18 * CF))
 ElseIf s = 0 Then
 z = 0
 Else
 z = (s + 1) / (Sqr(n * (n - 1) * (2 * n + 5) / 18 * CF))
 End If
If Abs(z) > Hydrological_S.Normal_INV(0, 1, 1 - a / 2) Then
 If z > 0 Then Mann_Kendall_Trend = "There exists an uptrend in the serie."
 If z < 0 Then Mann_Kendall_Trend = "There exists an downtrend in the serie."
 Exit Function
Else
Mann_Kendall_Trend = "There exists no trend in the serie."
Exit Function
End If
MaKe:
Mann_Kendall_Trend = "Error:"
End Function
Public Function Linear_Trend(data() As Double, Rea() As String, a As Double) As String '线性趋势检验
Dim m1 As Long, n1 As Long
Dim m2 As Long, n2 As Long
Dim i As Long, j As Long
Dim Ex_1 As Double, Ex_2 As Double
Dim Std_1 As Double, Std_2 As Double, Std_3 As Double
On Error GoTo LeaT:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim Rea(m2 To n2)
Ex_1 = 0
Ex_2 = 0
Std_1 = 0
Std_2 = 0
Std_3 = 0
For i = m1 To n1
Ex_1 = Ex_1 + (data(i, m2))
Ex_2 = Ex_2 + data(i, n2)
Std_1 = Std_1 + (data(i, m2)) * (data(i, m2))
Std_2 = Std_2 + data(i, n2) * data(i, n2)
Std_3 = Std_3 + (data(i, m2)) * data(i, n2)
Next
Ex_1 = Ex_1 / (n1 - m1 + 1)
Ex_2 = Ex_2 / (n1 - m1 + 1)
Std_1 = Std_1 - (n1 - m1 + 1) * Ex_1 * Ex_1
Std_2 = Std_2 - (n1 - m1 + 1) * Ex_2 * Ex_2
Std_3 = Std_3 - (n1 - m1 + 1) * Ex_1 * Ex_2
Rea(m2) = Std_3 / Sqr(Std_1 * Std_2)
Rea(n2) = Hydrological_S.Pearson_Critical_value_Correlation(n1 - m1 - 1, a)
 If Abs(Rea(m2)) > Rea(n2) Then
 Linear_Trend = "There exists the signficant in the data series."
 Exit Function
 Else
Linear_Trend = "There exists no the signficant in the data series."
 Exit Function
 End If
LeaT:
Linear_Trend = "Error:"
End Function
Public Function KendallRankCorrelation_Test(data() As Double, Uea() As String, a As Double) '肯德尔（Kendall）秩次相关检验法(检验趋势是否存在）
'Data 存储两列数据，第一列时间数据，第二列观测数据
' Uea 检验结果数组(计算结果值+分布限值）
Dim p As Double
Dim s1 As Double, s2 As Double
Dim m1 As Double, n1 As Double
Dim m2 As Double, n2 As Double
Dim i As Long, j As Long
On Error GoTo KeRCT:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim Uea(m2 To n2)
p = 0
For i = m1 To n1 - 1
 For j = i + 1 To n1
  If data(j, n2) > data(i, n2) Then
    p = p + 1
  End If
 Next
 Next
 s1 = 4 * p / (n1 - m1 + 1) / (n1 - m1) - 1
 s2 = 2 * (2 * (n1 - m1 + 1) + 5) / 9 / (n1 - m1 + 1) / (n1 - m1)
 Uea(m2) = s1 / Sqr(s2)
 Uea(n2) = Hydrological_S.Normal_INV(0, 1, 1 - a / 2)
 If Abs(Uea(m2)) > Uea(n2) Then
 KendallRankCorrelation_Test = "There exists the signficant in the data series."
 Exit Function
 Else
 KendallRankCorrelation_Test = "There exists no the signficant in the data series."
 Exit Function
 End If
KeRCT:
 KendallRankCorrelation_Test = "Error:"
End Function
Public Function Cox_Stuart(data() As Double, a As Double) As String ' Cox-stuart 趋势检验模型
Dim m1 As Long, n1 As Long
Dim m2 As Long, n2 As Long
Dim C As Long, i As Long
Dim k_1 As Long, k_2 As Long, k As Long
Dim s As Double
Dim D() As Double
On Error GoTo CoStu:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
If (n1 - m1 + 1) Mod 2 = 0 Then
   C = (n1 - m1 + 1) / 2
 ReDim D(m1 To C - 1 + m1)
Else
 C = (n1 - m1 + 2) / 2
 ReDim D(m1 To C - 2 + m1)
End If
k_1 = 0
k_2 = 0
For i = m1 To UBound(D)
D(i) = data(i, n2) - data(i + C, n2)
If D(i) > 0 Then
k_1 = k_1 + 1
ElseIf D(i) < 0 Then
k_2 = k_2 + 1
End If
Next
If k_1 < k_2 Then
k = k_1
Else
k = k_2
End If
If k_1 + k_2 < 100 Then
   s = 0 ' 二项分布
 For i = 0 To k
 s = s + Exp((Hydrological_S.GammaLn(k_1 + k_2 + 1) - Hydrological_S.GammaLn(i + 1) - Hydrological_S.GammaLn(k_1 + k_2 - i + 1)) - (k_1 + k_2) * Log(2))
 Next
If 2 * s < a Then
Cox_Stuart = "There exists the signficant in the data series."
Exit Function
Else
Cox_Stuart = "There exists no  signficant in the data series"
Exit Function
End If
Else
If k < C Then
s = (k + 0.5 - 0.5 * (k_1 + k_2)) / (0.5 * Sqr(k_1 + k_2))
Else
s = (k - 0.5 - 0.5 * (k_1 + k_2)) / (0.5 * Sqr(k_1 + k_2))
End If
If Abs(s) > Hydrological_S.Normal_INV(0, 1, 1 - a / 2) Then ' 正态分布检验
Cox_Stuart = "There exists the signficant in the data series."
Exit Function
Else
Cox_Stuart = "There exists no signficant in the data series"
Exit Function
End If
End If
CoStu:
Cox_Stuart = "Error:"
End Function
Public Function Difference_Mean(data() As Double, Tea() As String, a As Double) As String '差分均质趋势检验模型
''''气候状态变化趋势与突变分析
'' 大于0 增加趋势，小于零减少趋势
Dim m1 As Long, n1 As Long
Dim m2 As Long, n2 As Long
Dim Ex As Double, Std As Double
Dim i As Long
Dim r() As Long
On Error GoTo DiMe:
m1 = LBound(data, 1)
n1 = UBound(data, 1)
m2 = LBound(data, 2)
n2 = UBound(data, 2)
ReDim r(m1 To n1 - 1)
ReDim Tea(m2 To n2)
Ex = 0
Std = 0
For i = m1 + 1 To n1
r(i - 1) = data(i, n2) - data(i - 1, n2)
Ex = Ex + r(i - 1)
Std = Std + r(i - 1) * r(i - 1)
Next
Ex = Ex / (n1 - m1)
Std = Sqr(Std / (n1 - m1) - Ex * Ex)
Tea(m2) = Ex * Sqr(n1 - m1 - 1) / Std
Tea(n2) = Hydrological_S.T_INV(n1 - m1 - 1, 1 - a / 2)
If Abs(Tea(m2)) > Tea(n2) Then
 Difference_Mean = "There exists the signficant in the data series."
 Exit Function
 Else
 Difference_Mean = "There exists no the signficant in the data series."
 Exit Function
 End If
DiMe:
  Difference_Mean = "Error:"
End Function

