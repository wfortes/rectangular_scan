function [M y] = rectangular_scan_Beta(image,row,column,start)

% y is the window-sum vector block of the entire window-sum vector.
% M is the scan matrix block.
%
% image (is a matrix) is the piece of image to be scanned, i.e, if the "device" is
% smaller than the image to be scanned, the parameter image must be given
% as the piece of the image which fits in the "device".
%
% column and row (scalars) are the horizontal and vertical, respectively, length of the
% rectangle scanner.
%
% start (vector, entry of matrix image) is the parameter which defines the initial
% position of the upper left part of the scan rectangle. Default is (1,1).
% Must satisfy: (1,1)<=start<=(column,row)


[m,n] =  size(image);
if isempty(column)
    column=row;
end
sum = 0; k = 1;
c1 = start(1); c2 = start(2);
if c1>row||c2>column
    warning('not the best parameter to start');
end
a = 1; b = 1;

N_vert_shifts = floor((m-c1+1)/row);
N_horiz_shifts = floor((n-c2+1)/column);
y = zeros(1,N_horiz_shifts*N_vert_shifts);
M = spalloc(N_horiz_shifts*N_vert_shifts,m*n,column*row);

for a = 1:N_vert_shifts % loop the rectangle over the image
    for b = 1:N_horiz_shifts
       
        A = spalloc(m,n,column*row); % alloc space for the scan matrix
        for i=0:row-1 % loop inside the rectangle
            for j=0:column-1
                sum = sum + image(c1+i,c2+j);
                A(c1+i,c2+j) = 1; % to build scan matrix
            end
        end
        y(k) = sum; % right hand side
        M(k,:) = reshape(A,m*n,1); % build scan matrix per row
        k = k+1;
        sum = 0;
        
        c2 = start(2)+b*column;
    end
    c2 = start(2);
    c1 = start(1)+a*row;
end