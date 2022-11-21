% start from 2022/10
% ch1 = Torque
% ch2 = EMG

% LP = 500 Hz  課題�@
% Notch = on
% HP = 5 Hz  課題�@
% Sens HI (x1000)

%被験者名
defaultanswer = {'Masumoto'};
subject = inputdlg({'subject'},'Input the answer',1,defaultanswer);
subject_name = char(subject(1));

Force_list = [20,40,60,80];
iEMG_list = [0,0,0,0];


for i = 1:4

    %サンプリング周波数
    fs = 1000;

    %解析するデータ（matファイル）を選択し、読み込む
    [fname,pname]=uigetfile('*.mat','解析するデータを選択してください');
    FP=[fname pname];
    if fname==0;return;end
    %fnameがファイル名／pnameはファイルのある場所（ディレクトリ）
    load([pname fname]);

    %フィルタリング
    data_filtered = data;
    %ハムカットフィルタ:地域周波数(50Hz)の倍数をフィルタリング
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
    Force = data_filtered(:,1);
    EMG = data_filtered(:,2);
    %EMGは1000μV→1Vなので、マイクロボルト単位に変換（1000倍)
    %基線ズレがある可能性があるので平均を引く:全波整流
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

    %Force_list(i) = Force;
    iEMG_list(i) = iEMG;

end

x = Force_list';
y = iEMG_list';

%単回帰分析(何やってるかよくわかってない)
X = [ones(length(x), 1) x]; % 切片を含めて近似を改善
b = X\y;
yCalc = X * b; % 近似直線

%図示
hold on
plot(x, yCalc,'LineWidth', 5,'Color','0.7,0.7,0.7');
hold off

hold on
plot(Force_list,iEMG_list,'w.','MarkerSize',55);
hold off

hold on 
plot(Force_list,iEMG_list,'k.','MarkerSize',40);
hold off

%フォントサイズ
fontsize = 16;
h = gca;
set(h,'fontsize',fontsize);

title('EMGvsForce');

xlabel('Force (%)');
ylabel('rEMG (\muV)'); %単位あやしい

xticks([0, 20, 40, 60, 80]);
yticks([1.0, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]);
 
grid on

%ファイルの保存
output_filename = sprintf('%s_EMGvsForce',subject_name);
save(output_filename,'iEMG_list');


%�@Low-pass fileterやHigh-pass filterの値を確認して記入しよう。
%�Afor文を使って、20%, 40% 60%, 80%それぞれのデータからiEMGを計算して、ひとつの行列に格納しよう。
%�B最後に、横軸を「力（%MVC）」、縦軸を「iEMG(μV）」のグラフを描画してみよう。
%�C回帰直線、回帰式、統計値も入れてみよう。
%�D（可能なら）Low-pass filterやHigh-pass filterについて、プログラム内で後からかける方法を探そう。
