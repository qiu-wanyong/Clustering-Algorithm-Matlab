%求最大值
clear all;
close all;
%遗传算法参数设定和初始化
M=80;                                  %种群大小80个
T=100;                                 %遗传运算得终止进化代数100代
CL=10;                                 %二进制编码长度10位
F=0.6;            				       %交叉概率F=0.6
Bi=0.001;                               %变异概率Bi=0.001
Max=2.048;                             %输入值的取值上限
Min=-2.048;                             %输入值的取值下限

G=round(rand(M,CL*2));                  %初始化，使其成为布尔型数值
NG=zeros(M,CL*2);
for k=1:1:T
T(k)=k;
for s=1:1:M
        N=G(s,:);
        y1=0;y2=0;
N1=N(1:1:CL);                  %对x1进行解码，
for i=1:1:CL                    
        y1=y1+N1(i)*2^(i-1);
end
x1=(Max-Min)*y1/(2^CL-1)+Min;  
x1_G(k)=x1;               %为了便于最后图形输出，而引进的类似指针型变量
N2=N(CL+1:1:2*CL);          %对x2进行解码
for i=1:1:CL
        y2=y2+N2(i)*2^(i-1);
end
x2=(Max-Min)*y2/(2^CL-1)+Min;     
x2_G(k)=x2;                 %为了便于最后图形输出，而引进的类似指针型变量
F(s)=100*(x1^2-x2)^2+(1-x1)^2; %目标函数表达式
%F(s)=x1.^2+x2.^2;
end
Fit=F;
[Order,Index]=sort(Fit);          %将适应度从小到大进行排列
BF=Order(M);                 %选出适应度最大得值
BFI(k)=BF; 
BG=G(Index(M),:); 
In=M;                        %保护5个最优个体
for i=1:1:5              
BGG(i,:)=G(Index(In),:);       
In=In-1;
end
 %采用赌盘选择法
Fit_Sum=sum(Fit);                 %将群体中全部个体适应度累加求和? _sum  
%Fit_N=floor((Fit/Fit_Sum)*M);       %产生一个0至? _sum之间的随机数fit_n
%floor(x)返回小于或等于x的最小整数值。X的绝对值一定要大于最大整数值
                        %从编号为1的个体开始逐个累加适应度  
ada_sum=0;
for i=1:1:M                      %直到累加和>=fit_n，最后的累加就是复制个体
        ada_sum=ada_sum+F(i);
end
for i=1:(M-5)      %选择39次，最后一个个体留给历代最优解
    r=rand*ada_sum;  %随机产生一个数
    ada_temp=0;      %初始化累加值为0
    j=1;
    while(ada_temp<r)&(j<81)
        ada_temp=ada_temp+F(j); 
         j=j+1;
    end
    if j==1 
       j=1;
    else
       j=j-1;
    end
    NG(i,:)=G(j,:);
 
end
%Cn=ceil(2*CL*rand);           %产生单点交叉起始位，
%ceil(x)返回大于或等于x的最小整数值。X的绝对值一定要小于最大整数值
for i=1:2:(M-5)
     Rn=rand;                %Rn为0-1之间的随机数
     if F>Rn %交叉条件，F=0.6，Rn<0.6时就进行交叉运算
         Cn=ceil(2*CL*Rn);
        if or(Cn==0,Cn>=20)
            continue;
        end
        for j=Cn:1:2*CL       %随机交换部分染色体的基因，交换的位从Cn到末位止
          temp=NG(i,j);
          NG(i,j)=NG(i+1,j);
          NG(i+1,j)=temp;
        end
     end
end
%Rs=4;%对第76位到第80位（即后五位）进行保优
%for i=1:1:5
    %NG(M-Rs,:)=BGG(i,:);
    %Rs=Rs-1;
%end
%G=NG;
for i=1:1:(M-5)                    %变异运算
     for j=1:1:2*CL
        Mr=rand;              %产生基本位变异位，同样Mr是0-1之间的数
         if Bi>Mr             %变异条件，只有当Mr<0.001时才会进行变异运算，保证
            if NG(i,j)==0      
               NG(i,j)=1;
            else
               NG(i,j)=0;
            end
        end
    end
end
Rs=4;%对第76位到第80位（即后五位）进行保优
for i=1:1:5
    NG(M-Rs,:)=BGG(i,:);
    Rs=Rs-1;
end

G=NG;
end
k
Max=BF
x1
x2
subplot(2,1,2);plot(T,BFI); xlabel('次数');ylabel('最大值');
subplot(2,2,1);plot(T,x2_G); xlabel('次数');ylabel('X2');
subplot(2,2,2);plot(T,x1_G); xlabel('次数');ylabel('X1');
