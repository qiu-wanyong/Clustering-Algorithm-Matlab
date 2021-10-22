function [dis]=Distance(average ,data)
    dis=sqrt(sum((average(1,:)-data(1,:)).^2));