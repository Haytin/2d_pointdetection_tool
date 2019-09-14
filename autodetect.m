function [points] = autodetect(img, graytone, handles)

mini = get(handles.edit_mintolerance,'String');
mini = str2num(mini);
if isempty(mini)
    mini = 0;
else
    mini = mini(1);
end

maxi = get(handles.edit_maxtolerance,'String');
maxi = str2num(maxi);
if isempty(maxi)
    maxi = 0;
else
    maxi = maxi(1);
end



markersize = get(handles.edit_markersize, 'String');
markersize = str2num(markersize);
if isempty(markersize)
    markersize = 50;
end


points = [];
if sum(size(size(img)))== 4
img = rgb2gray(img);
end
upper = img <= graytone + maxi;
under = img >= graytone + mini;


img_bw = upper .* under;
img_bw = imfill(img_bw,'holes');

%kleine stellen herauschlöschen

img_label = bwlabel(img_bw);

maxlabel = max(max(img_label));

w = waitbar(0,'Please wait');

for i = 1:maxlabel
 [x y] = find(img_label == i);
  waitbar(i/maxlabel);

    if length(x) <markersize
        img_label(x,y) = 0;
    end
end

delete(w);

img_bw = img_label>0;
imshow(img_label)
cs = regionprops(img_bw, 'centroid');


for i = 1:length(cs)

point = cs(i).Centroid;
points = [points, [point(1); point(2)]];
end

points = [points; ones(1, size(points,2))];
