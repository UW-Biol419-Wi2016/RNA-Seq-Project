%% Assessing within group correlation
% Run PCA
[coeff, score, latent] = pca(melFPKM);

figure;
stairs(cumsum(latent)/sum(latent));

% 2 PCs can account for 95% of the variability.

% Plot first two PCs

groundtruth=[1;1;1;1;1;1;2;2;2;2;2;2]; %generating groups
group1=find(groundtruth==1);
group2=find(groundtruth==2);

figure;
plot(score(group1, 1), score(group1, 2), 'ro');
hold on
plot(score(group2, 1), score(group2, 2), 'bo');
xlabel('pc1');
ylabel('pc2');
title('Melanophore Data PCA With 2 Groups');
axis equal;

%% LDA

LDA = fitcdiscr(score(:,1:10), groundtruth');
pX = predict(LDA, score(:,1:10));

lCVA = sum(groundtruth'-pX' ==0)/length(groundtruth);

LDA.ClassNames([1;2])
K=LDA.ClassNames(1,2).Const;
L=LDA.ClassNames(1,2).Linear;
y=@(x1,x2)K+L(1)*x1+L(2)*x2
x1=(.9:7.1);
x2=(0:2.5);

figure;
plot(score(group1, 1), score(group1, 2), 'ro');
hold on
plot(score(group2, 1), score(group2, 2), 'bo');
plot(x1,x2,y, 'r-');
xlabel('pc1');
ylabel('pc2');
title('Melanophore Data PCA With 2 Groups');
axis equal;




%%  QDA 
% broken

QDA = fitcdiscr(score(:,1:10), groundtruth','DiscrimType', 'quadratic');
pXq = predict(QDA, score(:,1:10));

qCVA = sum(groundtruth'-pXq' ==0)/length(groundtruth);

%% Train a decision tree
% also sooo broken
tree = fitctree(score(:,1:10), groundtruth', 'CrossVal', 'on');
pTree = predict(tree, score(:,1:10));
tCVA = sum(groundtruth'-pXq' ==0)/length(groundtruth);

view(tree.Trained{1}, 'Mode', 'graph');

%% kmeans
melkmeans=kmeans(melFPKM, 2);
melkmeans3=kmeans(melFPKM, 3);

