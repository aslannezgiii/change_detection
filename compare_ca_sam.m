clc; clear; close all;
%%
hyperdata_gt = load('san_fra_data_change_gt.mat');
hyperdata_gt=cell2mat(struct2cell(hyperdata_gt));
%%
global sam_matris
global ca_matris
% disp(ca_matris);
% disp(sam_matris);
%%
[h,w]=size(ca_matris);
result = zeros(h,w);

for i=1:h
    for j=1:w
        if (ca_matris(i,j) == 'tp') || (sam_matris(i,j) == 'tp')
            result(i,j) = 1;
        elseif (ca_matris(i,j) == 'tn') || (sam_matris(i,j) == 'tn')
            result(i,j) = 0;
        end
    end 
end

%%
figure;
subplot(1,2,1); imshow(result); title('ca and sam');
subplot(1,2,2); imshow(hyperdata_gt) , title('gt');
% figure;
% imshow(result,[]);
%% roc
hyperdata_gt = reshape(hyperdata_gt,1,h*w);
result = reshape(result,1,h*w);
[Xpr,Ypr,Tpr,AUCpr] = perfcurve(hyperdata_gt,result,'1'); 
figure;
plot(Xpr,Ypr); 
xlabel('False positive rate'); ylabel( 'True positive rate');
title('ROC curve,ca and sam');

%%
hyperdata_gt = reshape(hyperdata_gt,h,w);
result = reshape(result,h,w);
TP = 0;
FP = 0;
TN = 0;
FN = 0;

for i=1:h
    for j=1:w
        if(hyperdata_gt(i,j)==1 && result(i,j)==1)
            TP=TP+1;
        elseif(hyperdata_gt(i,j)==0 && result(i,j)==1)
            FP=FP+1;
        elseif(hyperdata_gt(i,j)==0 && result(i,j)==0)
            TN=TN+1;
        else
            FN=FN+1;
        end
    end
end

accuracay_sam = (TP + TN) / (TP + TN + FP + FN);




