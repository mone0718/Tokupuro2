Force_list = [20,40,60,80,100];

x = Force_list';
y = iEMG_list';

%単回帰分析(何やってるかよくわかってない)
X = [ones(length(x), 1) x]; % 切片を含めて近似を改善
b = X\y;
yCalc = X * b; % 近似直線

disp(b);

hold on
plot(x,yCalc,'LineWidth', 7 ,'Color','0.4,0.4,0.4');
hold off

hold on
plot(Force_list,iEMG_list,'w.','MarkerSize',65);
hold off

hold on 
plot(Force_list,iEMG_list,'k.','MarkerSize',50);
hold off

%フォントサイズ
fontsize = 24;
h = gca;
set(h,'fontsize',fontsize);

title('EMGvsForce');

xlabel('Force (%)'); %名前
ylabel('iEMG (\muV*ms)'); %単位あやしい、名前

xticks([20, 40, 60, 80, 100]);
%yticks([1.0, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]);
 
%grid on
box on

%legend([p1 p2],{'finger','palm'},'Location','southeast');

