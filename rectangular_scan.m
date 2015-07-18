function [M y] = rectangular_scan(image,h,v,start)

% y is the window-sum vector block of the entire window-sum vector.
% M is the scan matrix block.
%
% image (is a matrix) is the piece of image to be scanned, i.e, if the "device" is
% smaller than the image to be scanned, the parameter image must be given
% as the piece of the image which fits in the "device".
%
% h and v (scalars) are the horizontal and vertical, respectively, length of the
% rectangle scanner.
%
% start (vector, entry of matrix image) is the parameter which defines the initial
% position of the upper left part of the scan rectangle. Default is (1,1).
% Must satisfy: (1,1)<=start<=(h,v)


[m,n] =  size(image);
if isempty(v)
    v=h;
end
sum = 0; k = 1;
c1 = start(1); c2 = start(2);
if c1>h||c2>v
    warning('not the best parameter to start');
end
a = 1; b = 1;

while start(1)+a*h<=m % loop the rectangle over the image
    while start(2)+b*v<=n
        
        A = spalloc(m,n,h*v); % alloc space for the scan matrix
        for i=0:h-1 % loop inside the rectangle
            for j=0:v-1
                sum = sum + image(c1+i,c2+j);
                A(c1+i,c2+j) = 1; % to build scan matrix
            end
        end
        y(k) = sum; % right hand side
        M(k,:) = reshape(A,m*n,1); % build scan matrix per row
        k = k+1;
        sum = 0;
        
        c2 = start(2)+b*v;
        b = b+1;
    end
    b=1;
    c2 = start(2);
    c1 = start(1)+a*h;
    a = a+1;
end