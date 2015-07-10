function output = decodeBase64(A)
%note A is a 1 x n array consisting of the ASCII values representing the
%base 64 string

output = zeros(1,floor(size(A,2)*3/4));
rem = mod(size(A,2),4);
count = 1;
for(i=1:size(A,2))
    if(mod(i,4)==0)
        output(count) = bitor(bitshift(getIndexFromBase64(A(i-4+1)),2,'uint8'),bitshift(getIndexFromBase64(A(i-3+1)),-4,'uint8'));
        output(count+1) = bitor(bitshift(getIndexFromBase64(A(i-3+1)),4,'uint8'),bitshift(getIndexFromBase64(A(i-2+1)),-2,'uint8'));
        output(count+2) = bitor(bitshift(getIndexFromBase64(A(i-2+1)),6,'uint8'),uint8(getIndexFromBase64(A(i-1+1))));
        count = count + 3;
    elseif(i==size(A,2) && rem==2)
        output(count) = bitor(bitshift(getIndexFromBase64(A(i-2+1)),2,'uint8'),bitshift(getIndexFromBase64(A(i-1+1)),-4,'uint8'));
    elseif(i==size(A,2) && rem==3)
        output(count) = bitor(bitshift(getIndexFromBase64(A(i-3+1)),2,'uint8'),bitshift(getIndexFromBase64(A(i-2+1)),-4,'uint8'));
        output(count+1) = bitor(bitshift(getIndexFromBase64(A(i-2+1)),4,'uint8'),bitshift(getIndexFromBase64(A(i-1+1)),-2,'uint8'));
    end
end

function output = getIndexFromBase64(c)

%internal function used by decodeBase64
c = double(c);
if(c >= 65 && c <= 90)
    output = c-65;

elseif(c > 96 && c <= 122)
    output = c-97+26;

elseif(c > 47 && c <= 57)
    output = c-48+52;

elseif(c==43)
    output = c-43+62;

elseif(c==47)
    output = c-47+63;
end