% start from 2022/10
% ch1 = Torque
% ch2 = EMG

% LP = 500 Hz  課題�@
% Notch = on
% HP = 5 Hz  課題�@
% Sens HI (x1000)

%被験者名
defaultanswer = {'Egashira'};
subject = inputdlg({'subject'},'Input the answer',1,defaultanswer);
subject_name = char(subject(1));

Force_list = [20,40,60,80,100];
iEMG_list = [0,0,0,0,0];

% %20%,40%,60%,80%,MVCの順で読み込む(ために5回繰り返し)
for i = 1:5

    %サンプリング周波数
    fs = 1000;

    %解析するデータ（matファイル）を選択し、読み込む
    [fname,pname] = uigetfile('*.mat','解析するデータを選択してください');
    FP = [fname pname];
    if fname == 0;return;end
    %fnameがファイル名／pnameはファイルのある場所（ディレクトリ）
    load([pname fname]);

    %フィルタリング
    data_filtered = data;
    %ハムカットフィルタ:地域周波数(50Hz)の倍数をフィルタリング
    %なんで倍数？
    %ローパスを500Hzに設定してる(500以上はカットしてる)から450まで
    [b50,a50] = butter(3,[49 51]/500,'stop');
    [b100,a100] = butter(3,[99 101]/500,'stop');
    [b150,a150] = butter(3,[149 151]/500,'stop');
    [b200,a200] = butter(3,[199 201]/500,'stop');
    [b250,a250] = butter(3,[249 251]/500,'stop');
    [b300,a300] = butter(3,[299 301]/500,'stop');
    [b350,a350] = butter(3,[349 351]/500,'stop');
    [b400,a400] = butter(3,[399 401]/500,'stop');
    [b450,a450] = butter(3,[449 451]/500,'stop');
    data_filtered = filtfilt(b50,a50,data_filtered);
    data_filtered = filtfilt(b100,a100,data_filtered);
    data_filtered = filtfilt(b150,a150,data_filtered);
    data_filtered = filtfilt(b200,a200,data_filtered);
    data_filtered = filtfilt(b250,a250,data_filtered);
    data_filtered = filtfilt(b300,a300,data_filtered);
    data_filtered = filtfilt(b350,a350,data_filtered);
    data_filtered = filtfilt(b400,a400,data_filtered);
    data_filtered = filtfilt(b450,a450,data_filtered);

    %計測データの定義
    %リスト名(行,列) リストの要素を指定.指定しない(全選択)時は:.
    Force = data_filtered(:,1); %1列目のデータ
    EMG = data_filtered(:,2); %2列目のデータ

    %EMGは1000μV→1Vなので、マイクロボルト単位に変換（1000倍)
    %基線ズレがある可能性があるので平均を引く
    EMG = (EMG-mean(EMG))*1000;

    %全波整流（絶対値化）
    rEMG = abs(EMG);

    %時間行列を作成
    time = 0:1/fs:length(Force)/fs-1/fs;

    %生波形を描画
    figure('Position',[1 1 500 700]);
    subplot(2,1,1);
    plot(time,Force);
    ylabel('Force (V)','FontName','Arial','Fontsize',12);
    xlabel('time (s)','FontName','Arial','Fontsize',12);

    subplot(2,1,2);
    plot(time,rEMG);
    ylabel('rEMG (\muV)','FontName','Arial','Fontsize',12);
    xlabel('time (s)','FontName','Arial','Fontsize',12);

    uiwait; %何かのアクションがあるまでプログラムがストップ


    %解析対象区間を設定
    %安定した2秒間のデータを計算
    defaultanswer = {'12','14'};
    startend = inputdlg({'start','end'},'解析区間の2秒を設定してください',1,defaultanswer);
    start_time = str2num(char(startend(1)));
    end_time = str2num(char(startend(2)));

    %解析対象区間の2秒分のデータを切り出し
    Force = Force(start_time*fs+1:end_time*fs);
    rEMG = rEMG(start_time*fs+1:end_time*fs);

    %2秒間の積分振幅を計測
    iEMG = sum(rEMG);

    iEMG_list(i) = iEMG;

    if subject_name == "Egashira"
        jonah_iEMG_list(i) = iEMG;
    elseif subject_name == "Takeuchi"
            takeuchi_iEMG_list(i) = iEMG;
    elseif subject_name == "Yokota"
            yokota_iEMG_list(i) = iEMG;
    end
end

%リストの情報を保存
output_filename = sprintf('%s_EMGvsForce',subject_name);
save(output_filename,"iEMG_list");

%jonah
jonah_iEMG_list_r = jonah_iEMG_list ./ jonah_iEMG_list(5) * 100;

jonah_y = jonah_iEMG_list_r';

%単回帰分析
x = Force_list';
X = [ones(length(x), 1) x]; % 切片を含めて近似を改善
jonah_b = X\jonah_y;
jonah_yCalc = X * jonah_b; % 近似直線

disp(jonah_b);

%takeuchi
takeuchi_iEMG_list_r = takeuchi_iEMG_list ./ takeuchi_iEMG_list(5) * 100;

takeuchi_y = takeuchi_iEMG_list_r';

takeuchi_b = X\takeuchi_y;
takeuchi_yCalc = X * takeuchi_b;

disp(takeuchi_b);

%yokota
yokota_iEMG_list_r = yokota_iEMG_list ./ yokota_iEMG_list(5) * 100;

yokota_y = yokota_iEMG_list_r';

yokota_b = X\yokota_y;
yokota_yCalc = X * yokota_b;

disp(yokota_b);

%average
% iEMG_sum = [jonah_iEMG_list; takeuchi_iEMG_list; yokota_iEMG_list]; 
% err = max(iEMG_sum) - min(iEMG_sum);
% mean_y = mean(iEMG_sum)';
% mean_b = X\mean_y;
% mean_yCalc = X * mean_b;
% 
% disp(mean_b);


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
plot(Force_list,yokota_iEMG_list_r,'w.','MarkerSize',50);
hold off

hold on 
p1 = plot(Force_list,yokota_iEMG_list_r,'.','MarkerSize',35,'Color','0.9,0.7,0.1');
hold off

hold on
plot(Force_list,takeuchi_iEMG_list_r,'w.','MarkerSize',50);
hold off

hold on 
p2 = plot(Force_list,takeuchi_iEMG_list_r,'.','MarkerSize',35,'Color','0.4,0.7,0.1');
hold off

hold on
plot(Force_list,jonah_iEMG_list_r,'w.','MarkerSize',50);
hold off

hold on 
p3 = plot(Force_list,jonah_iEMG_list_r,'.','MarkerSize',35,'Color','0.1,0.5,0.7');
hold off

%フォントサイズ
fontsize = 16;
h = gca;
set(h,'fontsize',fontsize);

title('EMGvsForce');

xlabel('%MVC');
ylabel('iEMG / MVC (%)');

xticks([20, 40, 60, 80, 100]);
%yticks(0:0.1:1.1);
 
grid on
box on

legend([p1 p2 p3],{'subject 1','subject 2','subject 3'},'Location','southeast');

%竹内くん:緑　横田くん:黄色　ジョナ:青



%�@Low-pass fileterやHigh-pass filterの値を確認して記入しよう。
%�Afor文を使って、20%, 40% 60%, 80%それぞれのデータからiEMGを計算して、ひとつの行列に格納しよう。
%�B最後に、横軸を「力（%MVC）」、縦軸を「iEMG(μV）」のグラフを描画してみよう。
%�C回帰直線、回帰式、統計値も入れてみよう。
%�D（可能なら）Low-pass filterやHigh-pass filterについて、プログラム内で後からかける方法を探そう。
