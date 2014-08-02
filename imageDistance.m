function [ fval ] = imageDistance( img1,img2 )
%IMAGEDISTANCE Summary of this function goes here
%   This MatLab function takes two image matrices as input and calculates
%   the Eatrh movers distance between them. The image passed will be
%   automatically convered to Grayscale.
%   For more details about Earth Movers Distance please see the
%   earthMoversDistance.m file
%
%   Program submitted by:
%           V Priyan        1100136
%           Aravind Sagar   1100104

    %	Convert the image to graysacle
    if(size(img1,3) == 3)
        img1 = rgb2gray(img1);
    end
    if(size(img2,3) == 3)
        img2 = rgb2gray(img2);
    end
    
    %resizing the images
    rsize = [size(img1,1) size(img2,1)];
    csize = [size(img1,2) size(img2,2)];
    img1 = imresize(img1, [min(rsize) min(csize)]);
    img2 = imresize(img2, [min(rsize) min(csize)]);
    
    
    %forming the histograms
    nbins = 4;        
    [c1,h1] = imhist(img1, nbins);
    [c2,h2] = imhist(img2, nbins);
    
    %features
    f1 = h1;
    f2 = h2;
    
    %weights
    w1 = c1/sum(c1);
    w2 = c2/sum(c2);
    
    %Earth movers distance
    [blah, fval] = emd(f1, f2, w1, w2, @gdf);
end

