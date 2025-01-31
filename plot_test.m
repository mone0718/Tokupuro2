Force_list = [20,40,60,80];
x = Force_list';

% jonah_iEMG_list(5) = []; %[]でリストの要素を消去
% takeuchi_iEMG_list(5) = []; 
% yokota_iEMG_list(5) = [];

%jonah
jonah_y = jonah_iEMG_list';

%単回帰分析(何やってるかよくわかってない)
X = [ones(length(x), 1) x]; % 切片を含めて近似を改善
jonah_b = X\jonah_y;
jonah_yCalc = X * jonah_b; % 近似直線

disp(jonah_b);

%takeuchi
takeuchi_y = takeuchi_iEMG_list';

takeuchi_b = X\takeuchi_y;
takeuchi_yCalc = X * takeuchi_b; % 近似直線

disp(takeuchi_b);

%yokota
yokota_y = yokota_iEMG_list';

yokota_b = X\yokota_y;
yokota_yCalc = X * yokota_b; % 近似直線

disp(yokota_b);

%average
% iEMG_sum = [jonah_iEMG_list; takeuchi_iEMG_list; yokota_iEMG_list]; 
% err = max(iEMG_sum) - min(iEMG_sum);
% mean_y = mean(iEMG_sum)';
% mean_b = X\mean_y;
% mean_yCalc = X * mean_b;
% 
% disp(mean_b);
%
% hold on
% plot(x,mean_yCalc,'LineWidth', 5 ,'Color','0.2,0.2,0.2');
% hold off
% 
% hold on 
% plot(Force_list,mean(iEMG_sum),'.','MarkerSize',35,'Color','0.2,0.2,0.2');
% hold off

% hold on
% e = errorbar(x,mean_yCalc,err,"k.","MarkerSize",40,"LineWidth",2);
% hold off
% 
% e.CapSize = 0;
% axis padded


%図示
%回帰直線
hold on
plot(x,yokota_yCalc,'LineWidth', 5 ,'Color','0.9,0.7,0.1');
hold off

hold on
plot(x,takeuchi_yCalc,'LineWidth', 5 ,'Color','0.4,0.7,0.1');
hold off

hold on
plot(x,jonah_yCalc,'LineWidth', 5 ,'Color','0.1,0.5,0.7');
hold off

%点
hold on
plot(Force_list,yokota_iEMG_list,'w.','MarkerSize',50);
hold off

hold on 
p1 = plot(Force_list,yokota_iEMG_list,'.','MarkerSize',35,'Color','0.9,0.7,0.1');
hold off

hold on
plot(Force_list,takeuchi_iEMG_list,'w.','MarkerSize',50);
hold off

hold on 
p2 = plot(Force_list,takeuchi_iEMG_list,'.','MarkerSize',35,'Color','0.4,0.7,0.1');
hold off

hold on
plot(Force_list,jonah_iEMG_list,'w.','MarkerSize',50);
hold off

hold on 
p3 = plot(Force_list,jonah_iEMG_list,'.','MarkerSize',35,'Color','0.1,0.5,0.7');
hold off

%フォントサイズ
fontsize = 16;
h = gca;
set(h,'fontsize',fontsize);

title('EMGvsForce');

xlabel('% of MVC'); %名前
ylabel('iEMG (\muV*s)'); %単位あやしい、名前

xticks([20, 40, 60, 80, 100]);
%yticks([1.0, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]);
 
grid on
box on

legend([p1 p2 p3],{'subject 1','subject 2','subject 3'},'Location','southeast');

%竹内くん:緑　横田くん:黄色　ジョナ:青

