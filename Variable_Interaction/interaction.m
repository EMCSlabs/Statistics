syms x1 x2
f(x1,x2) = -0.09*x1 +  0.12*x2 + 414.85
h = ezsurf(f,[671,4176]);
shg

%%
syms x1 x2
f(x1,x2) = 269 -0.0007563*x1 +  0.1706*x2 -0.00002936*x1*x2 
h = ezsurf(f,[671,4176]);
shg

%%
  % create figure and get handle to it (store handle in hf)
  close all;clear all
% Create file to hold the animation
vidObj = VideoWriter('new.avi');
open(vidObj);
% %%
% % [create 3d plot]
% syms x1 x2
% f(x1,x2) = -0.09*x1 +  0.12*x2 + 414.85;
% ezsurf(f,[671,4176]);


syms x1 x2 
f(x1,x2) = 269 -0.0007563*x1 +  0.1706*x2 -0.00002936*x1*x2;
ezsurf(f,[671,4176]);

axis tight
set(gca,'nextplot','replacechildren');
% rotate3d on

    for k = -0.00002:0.001:0.05
        fnew = f+(0.00002936+k)*x1*x2;
       ezsurf(fnew);
 
       % Write each frame to the file.
       currFrame = getframe;
       writeVideo(vidObj,currFrame);
    end
    
%     rotate(gca)
  
% Close the file.
close(vidObj);

