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