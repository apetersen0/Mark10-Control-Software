[t1,t2] = uigetfile('*.tiff','MultiSelect','on');

framerate = 8;

if(ischar(t1{1,1}))
    [s1,s2] = uiputfile('*.avi');
    if(ischar(s1))
        outputVideo = VideoWriter([s2,s1]);
        outputVideo.FrameRate = framerate;
        if(size(t1,2)>1)
            open(outputVideo);
            for(i=1:length(t1))
                img = imread([t2,t1{i}]);
                writeVideo(outputVideo,img);
            end
            close(outputVideo);
            disp('Video Creation Complete');
        end
    else
        disp('Creation Failed. Error 2')
    end
else
    disp('Creation Failed. Error 1')
end