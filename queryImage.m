function [ ssort ] = queryImage( query,folder )
%OPEN_IMAGES Summary of this function goes here
%   This function will take the name of the image file passed and will
%   calculate the earth movers distance between the query image and images
%   in the database using the imageDistance function.
%   For more details about the EMD calculation please see the function
%   emd.m and imageDistance.m
%
%   Program submitted by:
%           V Priyan        1100136
%           Aravind Sagar   1100104

    %folder details
    temp = pwd;
    folder = [temp '\' folder '\'];
    
    %eading the query image.
    Q = dir([folder query]);
    Q = imread([folder Q.name]);
    
    %reading the other images in the database.
    d = dir([folder '*.jpg']);
    n = length(d);
    
    %temporary structure to store the images and EMD value.
    s = [];
    
    %finding the EMD val between the query image and other images.
    for i = 1:n
        temp = [folder d(i).name];
        A = imread(temp);
        fval = imageDistance(Q,A);
        s = [s struct('img',{A},'val',{fval})];
    end
    
    %Sorting the images with respect to the EMD val
    
    sfields = fieldnames(s);        %Gets the fields of the struct
    scell = struct2cell(s);         %converts the structure to a cell (without fieldnames)
    sz = size(scell);               %size of the matrix
    
    scell = reshape(scell,sz(1),[]); %convert the cell to a matrix
    scell = scell';
    scell = sortrows(scell,2);      %sorting according to EMD val
    
    scell = reshape(scell',sz);     %put back to original cell format
    ssort = cell2struct(scell,sfields,1);   %converting the cell back to struct
    
    %plotting
    check = input('Do you want to plot the images? (Y/N): ','s');
    if(check == 'y' || check == 'Y')
        figure('Name','EMD');
        for i = 1:n
            scrollsubplot(2,2,i);imshow(ssort(i).img);title(ssort(i).val);
        end
    end
end

