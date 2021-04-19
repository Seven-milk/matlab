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