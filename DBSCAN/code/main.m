clc;clear;
% load('moon.mat');
% locate=a;
% E=0.01;%密度半径
% Minpts=5;%邻域最小个数
% 
% load('long.mat');
% locate=long1;
% E=0.02;%密度半径
% Minpts=3;%邻域最小个数
% 
% load('sizes5.mat');
% locate=sizes5;
% E=0.7;%密度半径
% Minpts=7;%邻域最小个数
% 
% load('2d4c.mat');
% locate=a;
% E=0.5;%密度半径
% Minpts=7;%邻域最小个数
% 
% load('smile.mat');
% locate=smile;
% E=0.003;%密度半径
% Minpts=5;%邻域最小个数
% 
% load('spiral.mat');
% locate=spiral;
% E=0.1;%密度半径
% Minpts=5;%邻域最小个数
% 
% load('square1.mat');
% locate=square1;
% E=0.4;%密度半径
% Minpts=10;%邻域最小个数
% 
load('square4.mat');
locate=b;
E=0.45;%密度半径
Minpts=13;%邻域最小个数

l=length(locate);
for i=1:l
    distance(i,:)=((locate(i,1)-locate(:,1)).^2+(locate(i,2)-locate(:,2)).^2).^1/2;%计算点与点距离；
end

for i=1:l
number(i)=length(find(distance(i,:)<=E));       %每个点邻域内的点个数
points(i,1:number(i))=find(distance(i,:)<=E)';  %每个点邻域内的点标号
end
number=number';
core(:,1)=find(number(:,1)>Minpts); %记录所有核心点
corechart=points(core,:);           %记录所有核心点邻域的点
corenumber=number(core);            %记录所有核心点邻域点的个数
j=1;
class=zeros(l,l);
while ~isempty(core)
i=1;%标识类别表中类别数
[class,i,core]=expand(core(1),core,corechart,corenumber,number,points,i,j,class);
classnumber(j)=i-1;
j=j+1;
end

for i=1:length(classnumber)
    locate(class(1:classnumber(i),i),4)=i;
end


%% 分类结果绘图：通用
figure;
plot(locate(locate(:,3)==0,1),locate(locate(:,3)==0,2),'.r');
hold on;
plot(locate(locate(:,3)==1,1),locate(locate(:,3)==1,2),'.g');
hold on;
plot(locate(locate(:,3)==2,1),locate(locate(:,3)==2,2),'.b');
hold on;
plot(locate(locate(:,3)==3,1),locate(locate(:,3)==3,2),'.y');
title('理论分类结果');

figure;
plot(locate(locate(:,4)==1,1),locate(locate(:,4)==1,2),'.r');
hold on;
plot(locate(locate(:,4)==2,1),locate(locate(:,4)==2,2),'.g');
hold on;
plot(locate(locate(:,4)==3,1),locate(locate(:,4)==3,2),'.b');
hold on;
plot(locate(locate(:,4)==4,1),locate(locate(:,4)==4,2),'.y');

title('实际分类结果');



