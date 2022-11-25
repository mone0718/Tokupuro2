% start from 2022/10
% ch1 = Torque
% ch2 = EMG

% LP = 500 Hz  �ۑ�@
% Notch = on
% HP = 5 Hz  �ۑ�@
% Sens HI (x1000)

%�팱�Җ�
defaultanswer = {'Egashira'};
subject = inputdlg({'subject'},'Input the answer',1,defaultanswer);
subject_name = char(subject(1));

Force_list = [20,40,60,80,100];
iEMG_list = [0,0,0,0,0];

% %20%,40%,60%,80%,MVC�̏��œǂݍ���(���߂�5��J��Ԃ�)
% for i = 1:5
% 
%     %�T���v�����O���g��
%     fs = 1000;
% 
%     %��͂���f�[�^�imat�t�@�C���j��I�����A�ǂݍ���
%     [fname,pname] = uigetfile('*.mat','��͂���f�[�^��I�����Ă�������');
%     FP = [fname pname];
%     if fname == 0;return;end
%     %fname���t�@�C�����^pname�̓t�@�C���̂���ꏊ�i�f�B���N�g���j
%     load([pname fname]);
% 
%     %�t�B���^�����O
%     data_filtered = data;
%     %�n���J�b�g�t�B���^:�n����g��(50Hz)�̔{�����t�B���^�����O
%     %�Ȃ�Ŕ{���H
%     %���[�p�X��500Hz�ɐݒ肵�Ă�(500�ȏ�̓J�b�g���Ă�)����450�܂�
%     [b50,a50] = butter(3,[49 51]/500,'stop');
%     [b100,a100] = butter(3,[99 101]/500,'stop');
%     [b150,a150] = butter(3,[149 151]/500,'stop');
%     [b200,a200] = butter(3,[199 201]/500,'stop');
%     [b250,a250] = butter(3,[249 251]/500,'stop');
%     [b300,a300] = butter(3,[299 301]/500,'stop');
%     [b350,a350] = butter(3,[349 351]/500,'stop');
%     [b400,a400] = butter(3,[399 401]/500,'stop');
%     [b450,a450] = butter(3,[449 451]/500,'stop');
%     data_filtered = filtfilt(b50,a50,data_filtered);
%     data_filtered = filtfilt(b100,a100,data_filtered);
%     data_filtered = filtfilt(b150,a150,data_filtered);
%     data_filtered = filtfilt(b200,a200,data_filtered);
%     data_filtered = filtfilt(b250,a250,data_filtered);
%     data_filtered = filtfilt(b300,a300,data_filtered);
%     data_filtered = filtfilt(b350,a350,data_filtered);
%     data_filtered = filtfilt(b400,a400,data_filtered);
%     data_filtered = filtfilt(b450,a450,data_filtered);
% 
%     %�v���f�[�^�̒�`
%     %���X�g��(�s,��) ���X�g�̗v�f���w��.�w�肵�Ȃ�(�S�I��)����:.
%     Force = data_filtered(:,1); %1��ڂ̃f�[�^
%     EMG = data_filtered(:,2); %2��ڂ̃f�[�^
% 
%     %EMG��1000��V��1V�Ȃ̂ŁA�}�C�N���{���g�P�ʂɕϊ��i1000�{)
%     %����Y��������\��������̂ŕ��ς�����
%     EMG = (EMG-mean(EMG))*1000;
% 
%     %�S�g�����i��Βl���j
%     rEMG = abs(EMG);
% 
%     %���ԍs����쐬
%     time = 0:1/fs:length(Force)/fs-1/fs;
% 
%     %���g�`��`��
%     figure('Position',[1 1 500 700]);
%     subplot(2,1,1);
%     plot(time,Force);
%     ylabel('Force (V)','FontName','Arial','Fontsize',12);
%     xlabel('time (s)','FontName','Arial','Fontsize',12);
% 
%     subplot(2,1,2);
%     plot(time,rEMG);
%     ylabel('rEMG (\muV)','FontName','Arial','Fontsize',12);
%     xlabel('time (s)','FontName','Arial','Fontsize',12);
% 
%     uiwait; %�����̃A�N�V����������܂Ńv���O�������X�g�b�v
% 
% 
%     %��͑Ώۋ�Ԃ�ݒ�
%     %���肵��2�b�Ԃ̃f�[�^���v�Z
%     defaultanswer = {'12','14'};
%     startend = inputdlg({'start','end'},'��͋�Ԃ�2�b��ݒ肵�Ă�������',1,defaultanswer);
%     start_time = str2num(char(startend(1)));
%     end_time = str2num(char(startend(2)));
% 
%     %��͑Ώۋ�Ԃ�2�b���̃f�[�^��؂�o��
%     Force = Force(start_time*fs+1:end_time*fs);
%     rEMG = rEMG(start_time*fs+1:end_time*fs);
% 
%     %2�b�Ԃ̐ϕ��U�����v��
%     iEMG = sum(rEMG);
% 
%     iEMG_list(5) = iEMG;
% 
%     if subject_name == "Egashira"
%         jonah_iEMG_list(5) = iEMG;
%     elseif subject_name == "Takeuchi"
%             takeuchi_iEMG_list(5) = iEMG;
%     elseif subject_name == "Yokota"
%             yokota_iEMG_list(5) = iEMG;
%     end
% 
% end

%���X�g�̏���ۑ�
output_filename = sprintf('%s_EMGvsForce',subject_name);
save(output_filename,"iEMG_list");


%jonah
jonah_iEMG_list_r = jonah_iEMG_list ./ jonah_iEMG_list(5) * 100;

jonah_y = jonah_iEMG_list_r';

%�P��A����
x = Force_list';
X = [ones(length(x), 1) x]; % �ؕЂ��܂߂ċߎ������P
jonah_b = X\jonah_y;
jonah_yCalc = X * jonah_b; % �ߎ�����

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


%�}��
%��A����
hold on
plot(x,yokota_yCalc,'LineWidth', 5 ,'Color','0.9,0.7,0.1');
hold off

hold on
plot(x,takeuchi_yCalc,'LineWidth', 5 ,'Color','0.4,0.7,0.1');
hold off

hold on
plot(x,jonah_yCalc,'LineWidth', 5 ,'Color','0.1,0.5,0.7');
hold off

%�_
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

%�t�H���g�T�C�Y
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

%�|������:�΁@���c����:���F�@�W���i:��



%�@Low-pass fileter��High-pass filter�̒l���m�F���ċL�����悤�B
%�Afor�����g���āA20%, 40% 60%, 80%���ꂼ��̃f�[�^����iEMG���v�Z���āA�ЂƂ̍s��Ɋi�[���悤�B
%�B�Ō�ɁA�������u�́i%MVC�j�v�A�c�����uiEMG(��V�j�v�̃O���t��`�悵�Ă݂悤�B
%�C��A�����A��A���A���v�l������Ă݂悤�B
%�D�i�\�Ȃ�jLow-pass filter��High-pass filter�ɂ��āA�v���O�������Ōォ�炩������@��T�����B
