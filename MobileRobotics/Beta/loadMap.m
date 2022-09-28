
clc
clear all
close all

xlim = 100;
ylim = 100; 

axis([0 xlim 0 ylim])
hold on

filename = 'test.mat'
load(filename)

for polyshape = obst

    plot(polyshape)

end

