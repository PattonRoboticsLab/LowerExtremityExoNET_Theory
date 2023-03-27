% % % % %
put_figure(1, 0.02, 0.07, 0.95, 0.82);
for i = 1 : length(PHIs)
    clf;
    BODY.pose = [PHIs(i,1) PHIs(i,2) PHIs(i,3)];
    drawBodyLeg(BODY);
    drawExonetsLeg(p,BODY.pose);
    %xline(0)
    %yline(0)
    %yline(-0.88)
    yline(-0.9)
    %axis([-0.8 0.8 -0.9 0.75]);
    xlim([-1.65 1.65])
    axis equal;
    fig(i) = getframe(gcf);
    drawnow;
    pause(0.00000001);
end
writerObj = VideoWriter('VideoExoNET.avi'); % create video writer object
writerObj.FrameRate = 15; % set the frame rate
open(writerObj); % open the video writer
for i = 1:length(fig) % write the frames to the video
    frame = fig(i); % convert the image to a frame
    writeVideo(writerObj,frame);
end
close(writerObj); % close the writer object
% % % % %