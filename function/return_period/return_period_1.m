%���㵥������������
function [cxq]=return_period_1(x,T,varargin)
%�����Եֵx���¼�������ƽ�����ʱ��T
%���cxq������
%�ɱ����룬���������ֵ��������
[A]=Bestfit_dan_nop3(x);%ʹ��Bestfit_nop3�ļ򻯳����������ʱ��̫��
%����Ҫ0ֵ������Ϊ����Ҫcopula���
%���������ڼ���
cxq=T./(1-A);
if nargin==3
    [A1]=Bestfit_dan_nop3(x,varargin{1});%ʹ��Bestfit_nop3�ļ򻯳����������ʱ��̫��
    %���������ڼ���
    cxq=T./(1-A1);
end
end