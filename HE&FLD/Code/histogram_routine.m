
G = imread('task1_G.png');

figure,
imshow(G);

% ------------------------------------------------------------
% Compute the histogram of G
% ------------------------------------------------------------
gray_table = compute_histogram(G);

% ------------------------------------------------------------
% Display the histogram
% gray_table: the histogram of G
% ------------------------------------------------------------
figure,
plot((0:1:255),gray_table(:,1));
ylabel('Count');
xlabel('Gray level value');

% ------------------------------------------------------------
% perform histogram equalization on G
% ------------------------------------------------------------
out_img = myhistogram_eq(G, gray_table);

% ------------------------------------------------------------
% Compute the histogram of equalized image 
% ------------------------------------------------------------
gray_table_new = compute_histogram(out_img);

% ------------------------------------------------------------
% Display the histogram
% gray_table_new: the histogram of the equalized image
% ------------------------------------------------------------
figure,
plot((0:1:255),gray_table_new(:,1));
ylabel('Count_new');
xlabel('Gray level value');

figure,
imshow(out_img);

% ----------------------------------------------------------------------
% ----------------------------------------------------------------------
C = imread('task1_C.png');
C_R = C(:,:,1);
C_G = C(:,:,2);
C_B = C(:,:,3);
height = size(C,1);
width = size(C,2);

% ------------------------------------------------------------
% Compute the histograms of C_R, C_G, C_B 
% ------------------------------------------------------------
gray_table_C_R = compute_histogram(C_R);
gray_table_C_G = compute_histogram(C_G);
gray_table_C_B = compute_histogram(C_B);

% ------------------------------------------------------------
% perform histogram equalization on the R, G, B channels of C separately
% gray_table_C_R: the histogram of C_R
% gray_table_C_G: the histogram of C_G
% gray_table_C_B: the histogram of C_B
% ------------------------------------------------------------
out_C_R = myhistogram_eq(C_R, gray_table_C_R);
out_C_G = myhistogram_eq(C_G, gray_table_C_G);
out_C_B = myhistogram_eq(C_B, gray_table_C_B);

% ------------------------------------------------------------
% Rebuild an RGB image from these processed channels.
% out_C_R: result image of C_R after histogram equalization
% out_C_G: result image of C_G after histogram equalization
% out_C_B: result image of C_B after histogram equalization
% ------------------------------------------------------------
out_C = uint8(zeros(height, width, 3));
out_C(:,:,1) = out_C_R;
out_C(:,:,2) = out_C_G;
out_C(:,:,3) = out_C_B;

figure,
imshow(out_C);

% ------------------------------------------------------------
% Calculate an average histogram from the R,G,B histograms
% ------------------------------------------------------------
average_hist = (gray_table_C_R + gray_table_C_G + gray_table_C_B)/3;

% ------------------------------------------------------------
% Use this average histogram as the basis to obtain a single histogram 
% equalization intensity transformation function. Apply this function to 
% the R, G, B channels individually
% ------------------------------------------------------------
out_match_C_R = myhistogram_eq(C_R,average_hist);
out_match_C_G = myhistogram_eq(C_G,average_hist);
out_match_C_B = myhistogram_eq(C_B,average_hist);

% ------------------------------------------------------------
% Rebuild an RGB image from these processed channels.
% out_match_C_R: result image of C_R after histogram matching
% out_match_C_G: result image of C_G after histogram matching
% out_match_C_B: result image of C_B after histogram matching
% ------------------------------------------------------------
out_match_C = uint8(zeros(height, width, 3));
out_match_C(:,:,1) = out_match_C_R;
out_match_C(:,:,2) = out_match_C_G;
out_match_C(:,:,3) = out_match_C_B;

figure,
imshow(out_match_C);