function [y]=scene(x,alpha)
%���ڸ�����������Ϸֲ����龰(alphaΪ�龰)��50%��75%
p_best=Bestfit_dan(x);
%ɾȥ�ظ�ֵ
x_=sort(x);
p_=sort(p_best);
j=1;
num=[];
    for i=1:(length(x_)-1)
        if x_(i)==x_(i+1)||p_(i)==p_(i+1)
         num(j)=i;%��Ҫ�ҵ��ظ�ֵȥ����������x_����pc_best_�е��ظ�����Ҫ�ҵ���
         j=j+1;
        end
    end
    if isempty(num)==0
x_(num)=[];
p_(num)=[];
    end
y=spline(sort(p_),sort(x_),alpha);
end