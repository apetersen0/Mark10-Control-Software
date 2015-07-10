ct = 1;
rt = 1;
output = zeros(494,659);

for(i=1:size(streamInputRaw,2))
    if(mod(i,659)==0)
        output(rt,ct) = streamInputRaw(2,i);
        ct=1;
        rt = rt+1;
    else
        output(rt,ct) = streamInputRaw(2,i);
        ct=ct+1;
    end
end

figure
imagesc(output,[0 255]);
colormap gray