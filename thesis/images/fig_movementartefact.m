addpath('export_fig')

I1 = imread('movementseries13red001.pgm');
I2 = imread('movementseries13red002.pgm');
I3 = imread('movementseries13red003.pgm');
I4 = imread('movementseries13red004.pgm');
Is = {I1, I2 ,I3, I4};

for i=1:4
	Is{i} = imadjust(Is{i});
	% Is{i} = imsharpen(Is{i}, 'Amount', 2);
	Is{i} = imfilter(Is{i}, fspecial('unsharp'));
    Is{i} = medfilt2(Is{i}, [3 3]);
end

I1 = Is{1};
I2 = Is{2};
I3 = Is{3};
I4 = Is{4};

gap = zeros(size(I1, 1), 10);
I = horzcat(I1, gap, I2, gap, I3, gap, I4);

[h, w] = size(I);

figure(1); cla;
imshow(I);

% fprintf('Adjust image and press enter to save it\n');
% pause

% export_fig data_challenge_movement.png -native