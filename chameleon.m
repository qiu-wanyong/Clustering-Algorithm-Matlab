clear; 
clc; 
 
%产生随机点 
img=zeros(100,200); 
data=rand(1,100); 
x=zeros(1,100); 
y=zeros(1,100); 
for i=1:100 
    loc=ceil(data(1,i)*20000); %x为一个包含小数点的数组ceil(x)就是把x中所有小数点后面的去掉 整数位上加1
    x(1,i)=ceil(loc/200); 
    y(1,i)=mod(loc,200); 
    if (y(1,i)==0) 
        y(1,i)=200; 
    end 
    img(x(1,i),y(1,i))=255; 
end 
%image(img); 
 
%构造距离矩阵 
processed=1000000; 
for i=1:100 
    for j=i+1:100 
       dist(i,j)=(x(1,i)-x(1,j))*(x(1,i)-x(1,j))+(y(1,i)-y(1,j))*(y(1,i)-y(1,j)); 
       dist(j,i)=processed; 
   end 
   dist(i,i)=processed; 
end 
 
for i=1:100 
    category(1,i)=i; 
end 
num_category=100; 
%反复挑选距离最近的两类合并 
while (num_category>7) 
    mindist=1000000; 
 
    for i=1:100 
        for j=i+1:100 
            if (dist(i,j)<mindist) 
                mindist=dist(i,j); 
                minp1=i; 
                minp2=j; 
            end 
        end 
    end 
    dist(minp1,minp2)=processed; 
    dist(minp2,minp1)=processed; 
    for i=1:100 
        if (category(1,i) == minp2) 
            category(1,i)=minp1; 
        end 
    end 
    for i=1:100 
        if (dist(minp2,i)<dist(minp1,i)) 
            dist(minp1,i)=dist(minp2,i); 
        end 
        dist(minp2,i)=processed; 
        dist(i,minp2)=processed; 
    end 
    num_category=num_category-1; 
end 
 
%整理类别标记 
for i=1:100; 
    labeled(1,i)=0; 
end 
categories=0; 
for i=1:100 
    kind=category(1,i); 
    if (labeled(1,kind)==0) 
        categories=categories+1; 
        for j=i:100 
            if(category(1,j)==kind) 
                category(1,j)=categories; 
            end 
        end 
        labeled(1,categories)=1; 
    end 
end 
 
%显示 
x1=zeros(1,100); 
y1=zeros(1,100); 
x2=zeros(1,100); 
y2=zeros(1,100); 
x3=zeros(1,100); 
y3=zeros(1,100); 
x4=zeros(1,100); 
y4=zeros(1,100); 
x5=zeros(1,100); 
y5=zeros(1,100); 
x6=zeros(1,100); 
y6=zeros(1,100); 
x7=zeros(1,100); 
y7=zeros(1,100); 
 
for i=1:100 
    if(category(1,i)==1) 
        x1(1,i)=x(1,i); 
        y1(1,i)=y(1,i); 
    elseif (category(1,i)==2) 
        x2(1,i)=x(1,i); 
        y2(1,i)=y(1,i); 
    elseif (category(1,i)==3) 
        x3(1,i)=x(1,i); 
        y3(1,i)=y(1,i); 
    elseif (category(1,i)==4) 
        x4(1,i)=x(1,i); 
        y4(1,i)=y(1,i); 
    elseif (category(1,i)==5) 
        x5(1,i)=x(1,i); 
        y5(1,i)=y(1,i); 
    elseif (category(1,i)==6) 
        x6(1,i)=x(1,i); 
        y6(1,i)=y(1,i); 
    elseif (category(1,i)==7) 
        x7(1,i)=x(1,i); 
        y7(1,i)=y(1,i); 
    end 
end 
plot(x1,y1,'b.',x2,y2,'g.',x3,y3,'r.',x4,y4,'c.',x5,y5,'m.',x6,y6,'y.',x7,y7,'k.'); 
