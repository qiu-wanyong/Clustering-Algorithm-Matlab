function [class,i,core]=expand(num,core,corechart,corenumber,number,points,i,j,class)
%j:记录第j个类别;
%i:类别表中已有的类别数；
%number:需要扩展的节点编号;

class(i,j)=num;             %将节点num放入class j中
core(find(core==num))=[];   %删除节点num
i=i+1;
tem=points(num,1:number(num))';%记录所有num的密度可达节点
% class(i:i+number(num)-1,j)=tem;
% i=i+number(num);
if isempty(core)==1   %防止溢出现象
    return
end
m=0;
n=0;
for k=1:number(num)       
    if sum(tem(k)==core(:,1))==1  %若某个节点时密度可达节点为核心节点，则计入directcore中
        m=m+1;
        directcore(m,1)=tem(k);
    else                                %若不是核心节点记入n_core
        n=n+1;
        n_core(n,1)=tem(k);
    end
end
if m~=0                     %扩展每个核心节点
    for k=1:m
        if sum(directcore(k)==core(:,1))==1
        [class,i,core]=expand(directcore(k),core,corechart,corenumber,number,points,i,j,class);
        %递归调用expand函数，不断的寻找核心节点的直接密度可达点，以扩大类别大小
            if isempty(core)==1     %防止溢出现象
                return
            end
        end
    end
end
if n~=0
    for k=1:n
        if sum(sum(n_core(k)==class(1:i-1,1:j)))==0         %将未添加进class里的非核心节点添加入class
            class(i,j)=n_core(k);
            i=i+1;
        end
    end
%    class(i:i+n-1,j)=n_core;
%    i=i+n;
    return
end
end
       
        

