clc; clear; close all;

%% % %input image 
%san francisco
hyperdata1 = load('san_fra_data2009.mat');
hyperdata1=cell2mat(struct2cell(hyperdata1));

hyperdata2 = load('san_fra_data2015.mat'); 
hyperdata2=cell2mat(struct2cell(hyperdata2));

hyperdata_gt = load('san_fra_data_change_gt.mat');
hyperdata_gt=cell2mat(struct2cell(hyperdata_gt));
%%
% figure;
% subplot(1,2,1); imshow(hyperdata1(:,:,30),[]); title('2009');
% subplot(1,2,2); imshow(hyperdata2(:,:,30),[]); title('2015');
%%
[h,w,spec_size]= size(hyperdata1);

%%
for i=1:h
    for j=1:w 
        
CA(i,j) = sum((abs(hyperdata1(i,j,:) - hyperdata2(i,j,:))) ./ (abs(hyperdata1(i,j,:)) + abs(hyperdata2(i,j,:))));

    end 
end

%%
max_CA= max(max(CA));
min_CA= min(min(CA));

CA = im2single(CA);

%% 
% figure;
result=CA>=75; %san francisco
% imshow(sonuc,[]);

%%
figure; 
subplot(1,3,1); imshow(CA,[]);  title('without threshold');
subplot(1,3,2); imshow(result) , title('with threshold'); xlabel('farklarýn toplamlarýna bölümü');
subplot(1,3,3); imshow(hyperdata_gt) , title('gt');
%% roc deneme
hyperdata_gt = reshape(hyperdata_gt,1,h*w);
CA = reshape(CA,1,h*w);
result = reshape(result,1,h*w);

%%
% [Xpr,Ypr,Tpr,AUCpr] = perfcurve(hyperdata_gt,abs(result),'1');
[Xpr,Ypr,Tpr,AUCpr] = perfcurve(hyperdata_gt,abs(CA),'1');

%konu anlatýmý
%[X,Y] = perfcurve(labels,scores,posclass);
%plot(X,Y);
%labels are the true labels of the data, scores are the output scores from 
%your classifier (before the threshold) and posclass is the positive class 
%in your labels.

figure;
plot(Xpr,Ypr,'r'); 

xlabel('False positive rate'); ylabel( 'True positive rate');

title(['ROC curve,ca AUC: ' num2str(AUCpr)]); 

% link : https://www.mathworks.com/matlabcentral/answers/412446-i-want-to-plot-the-roc-curve-using-perfcurve-function-i-have-2-plot-which-code-is-right

%% %tp,tn,fp,fn 
hyperdata_gt = reshape(hyperdata_gt,h,w);
CA = reshape(CA,h,w);
result = reshape(result,h,w);

%%
TP=0;FP=0;TN=0;FN=0;

TPR = zeros(h,w);
FPR = zeros(h,w);

global ca_matris

ca_matris = zeros(h,w);
ca_matris = string (ca_matris);

for i=1:h
    for j=1:w
        if(hyperdata_gt(i,j)==1 && result(i,j)==1)
            TP=TP+1;
            ca_matris(i,j) = 'tp' ;
        elseif(hyperdata_gt(i,j)==0 && result(i,j)==1)
            FP=FP+1;
            ca_matris(i,j) = 'fp' ;
        elseif(hyperdata_gt(i,j)==0 && result(i,j)==0)
            TN=TN+1;
            ca_matris(i,j) = 'tn' ;
        else
            FN=FN+1;
            ca_matris(i,j) = 'fn' ;
        end
        TPR(i,j) = TP / (TP + FN);
        FPR(i,j) = FP / (FP + TN);     
    end
end

%% 
%  [result] = compare(ca_matris,[]);
accuracay_ca = (TP + TN) / (TP + TN + FP + FN);





