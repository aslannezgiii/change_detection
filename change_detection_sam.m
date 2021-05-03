clc; clear; close all;

%%  %input image
%san francisco
hyperdata1 = load('san_fra_data2009.mat');
hyperdata1=cell2mat(struct2cell(hyperdata1));

hyperdata2 = load('san_fra_data2015.mat');
hyperdata2=cell2mat(struct2cell(hyperdata2));

hyperdata_gt = load('san_fra_data_change_gt.mat');
hyperdata_gt=cell2mat(struct2cell(hyperdata_gt));

[h,w,spec_size]= size(hyperdata1);

%%
t=zeros(h,w);
sam=zeros(h,w);

% k=0;
for i=1:h
    for j=1:w
        a=hyperdata1(i,j);
        b=hyperdata2(i,j);
        
        t(i,j)=abs(dot(a,b) / (norm(a) / norm(b)));
       
        t=complex(t);
        t=real(t);
        
        sam(i,j)=rad2deg(acos(t(i,j))); 
        %             sam = ( sam - min(min(min(sam))) ) /  ( max(max(max(sam))) - min(min(min(sam))) );
        
        %             sam(i,j)=sam(i,j)+rad2deg(acos(t(i,j))); %link
        %         end
    end
end
%%
result=sam<=89; %san francisco

figure;
subplot(1,3,1); imshow(sam,[]);  title('without threshold');
subplot(1,3,2); imshow(result) , title('with threshold'); xlabel('norm ile elde ettiðim ancak veriyi hyperdata1(i,j,:) gibi alýnca çalýþmadý, hyperdata1(i,j) olarak aldým');
subplot(1,3,3); imshow(hyperdata_gt) , title('gt');

%link : https://github.com/renweidian/LTTR/blob/master/LTTR_file/functions/SAM.m

%% roc 
hyperdata_gt = reshape(hyperdata_gt,1,h*w);
sam = reshape(sam,1,h*w);
result = reshape(result,1,h*w);

%%
[Xpr,Ypr,Tpr,AUCpr] = perfcurve(hyperdata_gt,sam,'0'); %without threshold 

% [Xpr,Ypr,Tpr,AUCpr] = perfcurve(hyperdata_gt,abs(result),'1'); %with threshold

%konu anlatýmý
%[X,Y] = perfcurve(labels,scores,posclass);
%plot(X,Y);
%labels are the true labels of the data, scores are the output scores from 
%your classifier (before the threshold) and posclass is the positive class 
%in your labels.

% [Xpr,Ypr,Tpr,AUCpr] = perfcurve(hyperdata_gt,abs(sonuc), 1, 'xCrit', 'reca', 'yCrit', 'fpr');
figure;
plot(Xpr,Ypr); 
xlabel('False positive rate'); ylabel( 'True positive rate')
title(['ROC curve,sam AUC: ' num2str(AUCpr)]);
% link : https://www.mathworks.com/matlabcentral/answers/412446-i-want-to-plot-the-roc-curve-using-perfcurve-function-i-have-2-plot-which-code-is-right


%% %tp,tn,fp,fn 
hyperdata_gt = reshape(hyperdata_gt,h,w);
sam = reshape(sam,h,w);
result = reshape(result,h,w);

%%
TP=0;FP=0;TN=0;FN=0;

TPR = zeros(h,w);
FPR = zeros(h,w);

global sam_matris

sam_matris = zeros(h,w);
sam_matris = string (sam_matris);

for i=1:h
    for j=1:w
        if(hyperdata_gt(i,j)==1 && result(i,j)==1)
            TP=TP+1;
            sam_matris(i,j) = 'tp' ;
        elseif(hyperdata_gt(i,j)==0 && result(i,j)==1)
            FP=FP+1;
            sam_matris(i,j) = 'fp' ;
        elseif(hyperdata_gt(i,j)==0 && result(i,j)==0)
            TN=TN+1;
            sam_matris(i,j) = 'tn' ;
        else
            FN=FN+1;
            sam_matris(i,j) = 'fn' ;

        end
        TPR(i,j) = TP / (TP + FN);
        FPR(i,j) = FP / (FP + TN);     
    end
end

%% 
%  [result] = compare([],sam_matris);
accuracay_sam = (TP + TN) / (TP + TN + FP + FN);










 