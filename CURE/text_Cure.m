clear all;
close all;
clc;

%导入数据
data=load('testData.txt');

%curd 聚类
crs(1,:)=data(1,:);  %candidate reference set 候选参考点
number(1)=1;  %位于第一类的数据个数
N=1; %候选参考点的个数
Iterate=4;  %循环次数
Radius=1.4; %距离2
T=12; %筛选参考点的阈值
%class; %分类

%生成候选参考点
I=1;
data(1,:)=[];
while(I<Iterate)
   data=load('testData.txt');
   while(~isempty(data))
       i=1;
       while(i<=N)
           dis=Distance(crs(i,:),data(1,:));
           %dis=sqrt(sum((average(i,:)-data(1,:)).^2));
           if dis <=Radius;
               %snum(i,:)=data(1,:);
               crs(i,:)=(crs(i,:)*number(i)+data(1,:))/(number(i)+1);
               data(1,:)=[];
               number(i)=number(i)+1;
               break;
           else
               i=i+1;
           end
       end
       if i>N
           N=N+1;
           crs(N,:)=data(1,:);
           number(N)=1;
           data(1,:)=[];
       end
   end
   I=I+1;
end


%生成参考点
%生成参考点后
%N表示参考点的数目,
i=1;
while(i<=N)
   if number(i)<T;
       number(i)=[];
       crs(i,:)=[];
       N=N-1;
   else
       i=i+1;
   end
end


%对参考点经行分类

%第一步 画出无向图
tu=[1:N]';
tu(:,2)=0;
i=1;
while(i<=N)
    j=i+1;
    while(j<=N)
        dis=Distance(crs(i,:),crs(j,:));
        if dis<=2*Radius
            tu(i,2)=j;
            break;
        else
            j=j+1;
        end
    end
    if (j>N && tu(i,2)>0)
       j=1;
       while (j<=i)
          dis=Distance(crs(i,:),crs(j,:)); 
          if dis<=2*Radius
              k=2;
              while(tu(j,k)>0)
                 k=k+1; 
              end
             tu(j,k)=i;
             break;
          else
              j=j+1;
          end
       end
    else
        i=i+1;
    end
end
%第二步 利用图的广度优先搜索，对候选参考点进行分类
k=1;%第几类
i=1; %标记
while(~isempty(tu))
    class(k,1)=tu(1,1);
    if tu(1,2)==0
        tu(1,:)=[];
    else
        i=2;
        j=sum(tu(1,:)>0);
        class(k,2:j)=tu(1,2:j);
        tu(1,:)=[];
        t=sum(class(k,:)>0);
        while i<=t
            m1=find(tu(:,1)==class(k,i));
            j=sum(tu(m1,:)>0);
            if j>1
                class(k,t+1:j+t-1)=tu(m1,2:j); 
                tu(m1,:)=[];
            else
                tu(m1,:)=[];
                break;
            end
            t=sum(class(k,:)>0);
           i=i+1;
        end
    end
    k=k+1;
end
i=1;
while i<=N
    m=find(class==i);
    if length(m)>1
        l1=length(class(:,1));
        m1=rem(m(1),l1);
        j=2;
        while j<=length(m)
            m2=rem(m(j),l1);
            n2=fix(m(j)/l1);
            n1=sum(class(m1,:)>0);
            class(m1,n1:n1+n2)=class(m2,1:n2+1);
            j=j+1;
        end
        j=length(m);
        while j>1
           m2=rem(m(j),l1);
           class(m2,:)=[];
           j=j-1;
        end
    end
    i=i+1;
end


%参考点与数据的映射
%导入数据
data=load('testData.txt');
M=length(class(:,1));
Mdata=length(data(:,1));
i=1;
while i<=Mdata
    j=1;
    while j<=N
        dis=Distance(crs(j,1:2),data(i,1:2)); 
        if dis<=Radius
            m=find(class==j);
            n=fix(m/M)+1;
            data(i,3)=n;
            break;
        end
        j=j+1;
    end
    if j>N
       data(i,3)=-1;
    end
   i=i+1;
end


%最后显示聚类后的数据
figure;
for i=1:Mdata 
    if data(i,3)==1   
         plot(data(i,1),data(i,2),'r.'); 
    elseif data(i,3)==2
         plot(data(i,1),data(i,2),'g.'); 
    elseif data(i,3)==3
         plot(data(i,1),data(i,2),'b.'); 
    elseif data(i,3)==4
         plot(data(i,1),data(i,2),'k.'); 
    elseif data(i,3)==5
         plot(data(i,1),data(i,2),'y.'); 
    elseif data(i,3)==6
         plot(data(i,1),data(i,2),'k.'); 
    else
         plot(data(i,1),data(i,2),'ro'); 
    end
    hold on;
end
for i=1:N 
    if i==1
        plot(crs(i,1),crs(i,2),'r*');
    elseif i==2
        plot(crs(i,1),crs(i,2),'g*');
    elseif i==3
        plot(crs(i,1),crs(i,2),'b*');
    elseif i==4
        plot(crs(i,1),crs(i,2),'c*');
    elseif i==5
        plot(crs(i,1),crs(i,2),'y*');
    else
        plot(crs(i,1),crs(i,2),'k*');
    end
    hold on;
end
grid on;

