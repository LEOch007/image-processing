clc;
close all;

imgA_name = './testIMG/group1/5.JPG';
imgB_name = './testIMG/group1/6.JPG';

imgA = imread(imgA_name);
imgB = imread(imgB_name);

% --------------------------Step 1--------------------------------
d = 0.9;
imgA = cylinderProjection(imgA, d);
imgB = cylinderProjection(imgB, d);
[height, width,~] = size(imgA);

figure,
subplot(1,2,1), imshow(imgA);
subplot(1,2,2), imshow(imgB);

[heightA,widthA,~] = size(imgA);

% --------------------------Step 2--------------------------------

[PointsA, V_A] = harris(imgA,0.01);
[PointsB, V_B] = harris(imgB,0.01);

x_A = PointsA(:,1);
y_A = PointsA(:,2);
figure,
subplot(1,2,1), imshow(imgA);
hold on
plot(y_A,x_A,'r+');
x_B = PointsB(:,1);
y_B = PointsB(:,2);
subplot(1,2,2), imshow(imgB);
hold on
plot(y_B,x_B,'r+');


describesA = featureDescribe(imgA, PointsA);
describesB = featureDescribe(imgB, PointsB);

% --------------------------Step 3--------------------------------
[matchA, matchB] = distanceMatch(describesA, describesB, PointsA, PointsB, 0.5);
newImg = [imgA, imgB];
figure,
imshow(newImg);
hold on
plot(matchA(1,:),matchA(2,:),'r+');
plot(matchB(1,:)+width,matchB(2,:),'r+');
for i = 1:size(matchA,2)
    plot([matchA(1,i) matchB(1,i)+width],[matchA(2,i) matchB(2,i)],'g-');
end

% --------------------------Step 4--------------------------------
[H, inliers] = RANSAC(matchA, matchB, 10, 2000);

% --------------------------Step 5--------------------------------
result = merge(imgA, imgB, H);


result = uint8(result);
figure,
imshow(result);