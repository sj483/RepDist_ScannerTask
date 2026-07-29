function [] = makeDots(fName)
% makeDots2 - Generates an annotated image with color-modified dots.
% Works in HSV color space, adjusts brightness/hue/saturation locally,
% and saves the resulting image with the same alpha layer.
fName = char(fName);
category = fName(1:3);
%ii = fName(4); % Extract numeric code from filename (e.g., 'face2.png' → 2)

% --------------------------- Setup ----------------------------------------
%figure;
%hold on; axis equal ij;
%T = linspace(-pi,pi,256)';
%Basis = [cos(T), 1i*sin(T)];

% --------------------------- Load image -----------------------------------
cd ./####
Im = imread(fName);
[~,~,alpha] = imread(fName); % separate alpha to preserve transparency
cd ..

Im = imresize(Im, [830, 830]);
mask = im2gray(Im) > 1; % binary mask
strictMask = makeStrictMask(mask);

% --------------------------- Main component analysis ----------------------
CC = regionprops('table', mask, 'Area','Centroid',...
    'MajorAxisLength','MinorAxisLength','Orientation');
CC.Orientation = deg2rad(CC.Orientation);
CC = sortrows(CC, 'Area', 'descend');

% Ellipse for outline
Mu = CC.Centroid(1,:) * [1; 1i];
%A = CC.MajorAxisLength(1) / 2;
%B = CC.MinorAxisLength(1) / 2;
%Theta = CC.Orientation(1);
%Trace = Basis * [A; B] * exp(1i * Theta) + Mu;
%plot(real(Trace), imag(Trace), 'k', 'LineWidth', 1);

% --------------------------- Select sample points -------------------------
h = real(Mu);
k = imag(Mu);

scalar_idxs = find(strictMask);
scalar_idxs = Shuffle(scalar_idxs); % randomized foreground pixels

[points_y, points_x] = ind2sub([830,830], scalar_idxs);
distances = hypot(points_x - h, points_y - k);

withinRange = distances <= 200;
chosen_points = [points_x(withinRange), points_y(withinRange)];

% --------------------------- Draw modified dots ---------------------------
fh = figure;
background = uint8(128 * ones(830, 830, 3));
testIm = background .* (1 - alpha/255) + Im .* (alpha/255);
imshow(testIm)

%delta values based on category
dels.Ani = [0.3, 0.1, 0.3];
dels.Art = [0.2, 0.2, 0.3];
dels.Fac = [0.12, 0.05, 0.22];
dels.Foo = [0.12, 0.08, 0.4];
dels.Lin = [0, 0.8, 0.25];
dels.Obj = [0.22, 0.15, 0.24];
dels.Pla = [0.25, 0.1, 0.24];
dels.Spa = [0.35, 0.6, 0.26];
dels.Tex = [0.12, 0.08, 0.20];



for jj = 1:3
    x = chosen_points(jj,1);
    y = chosen_points(jj,2);

    % --- Sample and convert local colour ---
    rgb = double(squeeze(Im(y, x, :))') / 255;
    hsv = rgb2hsv(rgb);

    %find the correct delta values
    cdel = dels.(category);
    
    % --- HSV transformations (fixed circular deltas) ---
    dH = cdel(1,1); dS = cdel(1,2); dV = cdel(1,3);
    hsv(1) = mod((hsv(1) + dH),1);
    if hsv(3) < 1 - dV, hsv(3) = hsv(3) + dV; else, hsv(3) = hsv(3) - dV; end
    if hsv(2) < 1 - dS, hsv(2) = hsv(2) + dS; else, hsv(2) = hsv(2) - dS; end
    % if hsv(1) < 1 - dH, hsv(1) = hsv(1) + dH; else, hsv(1) = hsv(1) - dH; end

    colour = hsv2rgb(hsv);

    % --- Draw dot ---
    p = drawcircle('Center',[x, y],'Radius',5);
    p.Color = colour;
    p.FaceAlpha = 0.5;
    p.LineWidth = 1e-9;
    p.InteractionsAllowed = 'none';
    p.StripeColor = colour;
end

% --------------------------- Save output ----------------------------------
fPath = [pwd,filesep, '#####', filesep, fName];
F = getframe(gca);
rgbimage = imresize(F.cdata, [830, 830]);
imwrite(rgbimage, fPath, 'Alpha', alpha);
close(fh)
end
