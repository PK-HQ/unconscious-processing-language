%% Params
%% Overview
%1. Setting parameters
clear all
%% Setting parameters

%getenv('DYLD_LIBRARY_PATH')
%nVal='/opt/X11/lib:/Applications/MATLAB_R2015b.app/sys/os/maci64:/Applications/MATLAB_R2015b.app/bin/maci64/../../Contents/MacOS:/Applications/MATLAB_R2015b.app/bin/maci64:/Applications/MATLAB_R2015b.app/extern/lib/maci64:/Applications/MATLAB_R2015b.app/runtime/maci64:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./native_threads:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./server:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./lib/jli';
%setenv('DYLD_LIBRARY_PATH', '/opt/X11/lib:/Applications/MATLAB_R2015b.app/sys/os/maci64:/Applications/MATLAB_R2015b.app/bin/maci64/../../Contents/MacOS:/Applications/MATLAB_R2015b.app/bin/maci64:/Applications/MATLAB_R2015b.app/extern/lib/maci64:/Applications/MATLAB_R2015b.app/runtime/maci64:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./native_threads:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./server:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./lib/jli');



% --- Subject parameters ---
subjNo                = input('subjNo: ','s');
runNo                 = input('run: ')';
DomEye                = input('DomEye:'); %1=R 2=L
keymode               = input('Mac1 Win2: ');
% --- Names ---
current_date=datestr(datetime('today'),'YYYYmmdd');
current_time=datestr(now, 'HHMM');
folder = {'/Users/pk/Desktop/fc/script/Mon/'};
%fName_r       = [ 'AU_' '_Sub' num2str(subjNo) '_Run' num2str(runNo) '.txt' ];
subno=sprintf('%02d', 2);
savefilename=['FC_thresh_sub' num2str(subno) '_' current_date '_' current_time '.csv'];
%header={'Trial_number' 'Sentence_ID' 'Sentence_pixel_length' 'Congruent_1' 'Familiar_1' 'LocationTop_1' 'Cued_1' 'Trialbroken_1' 'ST'};
fid =   fopen(savefilename, 'w');
fpri ntf(fid, 'Trial_number,Sentence_ID,Sentence_pixel_length,Congruent_1,Familiar_1,LocationTop_1,Cued_1,Trialcorrect_1,Trialbroken_1,ST\n');
fc  lose(fid);  
  

%dlmwrite(savefilename, header,'delimiter','tab','-append');
% --- Open screen ---
screid = max(Screen('Screens'));
%screid = 1;
xgomid = 320;
ygomid = 140;
scsize = {[xgomid ygomid xgomid+1280 ygomid+800];[]};
disize = 2; %1=mini 2=full
[wPtr, rect] = Screen('OpenWindow', screid, [0 0 0] , scsize{disize}); % what is a windows pointer?
if disize == 2;
    HideCursor
end
% --- Check and read mondrian images ---
for i = 1:length(folder)
    s(i).fd = folder{i};
    file = dir(folder{i});
    fileIdx = find(~[file.isdir]);
    for k = length(fileIdx):-1:1
        if isempty(findstr(file(fileIdx(k)).name, '.jpg'))
            %disp(file(fileIdx(k)).name)
            fileIdx(k) = [];
        end
    end
    for k = 1:length(fileIdx)
        s(i).file{k} = file(fileIdx(k)).name;
    end
    s(i).file = sort(s(i).file);
    for k = 1:length(fileIdx)
        s(i).img{k} = imread([folder{i} char(s(i).file{k})], 'JPG');
        s(i).tex{k} = Screen('MakeTexture', wPtr, s(i).img{k});
    end 
end
% --- Monitor settings ---
monitorFlipInterval =Screen('GetFlipInterval', wPtr);
refreshRate = round(1/monitorFlipInterval); % Monitor refreshrate
% --- Miscellaneous ---
retX=rect(3);
retY=rect(4);
disX=200; % bigger closer
disY=150; % bigger higher
%imagepres= [01 02];
% --- Color ---
boxcolor=[255 255 255];
color1=[255 255 100];
% --- Space ---
proximity=12;
XCenter         =retX/2;
YCenter         =retY/2-disY;
YCenter2        =(retY/2-disY)+25;
LeftboxXCenter  =(1*retX/4)+disX;
RightboxXCenter =(3*retX/4)-disX;
Top_textposition=YCenter-11-45+22.5+proximity;%
Bottom_textposition=YCenter+11+45-22.5-proximity;%
boxsize         =80;
MondrianSize    =30;
fontsize1       =20;
fontsize2       =14;

% --- Timings and Mondrian Frequency ---
TimeSound=1;
TimeMon=5;
Wrdtime=2;
extratime=3;
TimeImg=5;
Timeext=0.5;
NonBext=0.5;
MondFreq      = 10; %Unit: Hz
MondN  = round(refreshRate/MondFreq); % frames/img
% --- Location ---
if DomEye ==1,
    LeftboxXCenter  =(1*retX/4)+disX;
    RightboxXCenter =(3*retX/4)-disX;
    MonTop  = [RightboxXCenter-71 YCenter-11-45+(2*proximity)-2 RightboxXCenter+71 YCenter-11+2];
    MonBottom = [RightboxXCenter-71 YCenter+11-2 RightboxXCenter+71 YCenter+11+45-(2*proximity)+2];
    %stiLeft  = [RightboxXCenter-50-MondrianSize/2-MonStiDis+5 YCenter-35 RightboxXCenter-5-MonStiDis YCenter+MondrianSize-20];
    %stiRight = [RightboxXCenter+28-MondrianSize/2-MonStiDis+5 YCenter-35 RightboxXCenter+73-MonStiDis YCenter+MondrianSize-20];
elseif DomEye ==2,
    LeftboxXCenter =(3*retX/4)-disX; %flipped
    RightboxXCenter =(1*retX/4)+disX; %flipped
    %stiLeft  = [RightboxXCenter-50-(MondrianSize/2)+5 YCenter-MondrianSize/2 RightboxXCenter-5 YCenter+MondrianSize/2];
    %stiRight = [RightboxXCenter+28-(MondrianSize/2)+5 YCenter-MondrianSize/2 RightboxXCenter+73 YCenter+MondrianSize/2];
    MonTop  = [RightboxXCenter-71 YCenter-11-45+(2*proximity)-2 RightboxXCenter+71 YCenter-11+2];
    MonBottom = [RightboxXCenter-71 YCenter+11-2 RightboxXCenter+71 YCenter+11+45-(2*proximity)+2];
end
MonLeftXCenter=(MonTop(1)+MonTop(3))/2;
MonRightXCenter=(MonBottom(1)+MonBottom(3))/2;
%MonStiDis=RightboxXCenter-LeftboxXCenter;
% --- Displayed text strings ---
text10 =  'Press space to';
text11 =  'proceed';
%text4 =  'Right';
text5 =  'Different';
text12=  'Thank you!';
textqn= 'Location?';
% --- Keyboard mappings ---
KbName('UnifyKeyNames')
quitkey =   'ESCAPE';
space   =   'space';
UpArrow  =   'UpArrow';
DownArrow  =   'DownArrow';
% --- Frame & circle (catch trial) ---
penWidthPixels = 5;
baseRect = [0 0 10 10];
maxDiameter = max(baseRect) * 8;
rectColor = 0.75*[255 255 255];
rect_col=[102 255 255];
%% --- Experimental Design --- 
% Up/Down randomizer
up_or_down=[];
for no_trials=1:32,
    up_or_down=[up_or_down, randperm(2)];
end

% Pseudorandomize trial structure [(TRIAL_NO.) * 2(ASCENDING_STAIRCASE) * 32(SENTENCE_ID) * 2(CONGRUENCY) * 2(FAMILIARITY) * 2 (LOCATION) * 2(ATTENTION CUE)
ntrials  = 64; 
sentence_index=[1:ntrials/2,ntrials/2:-1:1]'; % CondList(:,1) = [1:32]' repeated 16x
Condperms=[1,1,1,1;1,1,1,2;1,1,2,1;1,1,2,2;1,2,1,1;1,2,1,2;1,2,2,1;1,2,2,2;2,1,1,1;2,1,1,2;2,1,2,1;2,1,2,2;2,2,1,1;2,2,1,2;2,2,2,1;2,2,2,2]; % 16 unique combinations of 4 binary variables
A=repmat(Condperms,ntrials/16,1);

B = [up_or_down' sentence_index A]; % combining into final Condition List
CondList = B(randperm(length(B)),:); % randomize by shuffling rows
CondList=[(1:ntrials)',CondList(:,1:6)];
a=CondList(:,3);

% --- Results container ---
ResultSet = zeros(ntrials,9); % Creating container for results

% --- Devices ---
if keymode==1,
    targetUsageName = 'Keyboard';
    targetProduct = 'Apple Keyboard';
    dev=PsychHID('Devices');
    devInd = find(strcmpi(targetUsageName, {dev.usageName}) & strcmpi(targetProduct, {dev.product}));
elseif keymode==2,
    targetUsageName = 'Keyboard';
    targetProduct = 'USB Keyboard';
    dev=PsychHID('Devices');
    devInd = find(strcmpi(targetUsageName, {dev.usageName}) & strcmpi(targetProduct, {dev.product}));
end

%% Beginning Experiment
KbQueueCreate(devInd) %loads experiment sequence
KbQueueStart(devInd);
% --- First frame ---
try
    FixationBox(wPtr,LeftboxXCenter,RightboxXCenter,YCenter,boxsize,boxcolor)
    Writetext(wPtr,text10,LeftboxXCenter,RightboxXCenter,YCenter,  60,60, [255 255 255],18);
    Writetext(wPtr,text11,LeftboxXCenter,RightboxXCenter,YCenter,  60,40, [255 255 255],18);
    Screen(wPtr, 'Flip');
    while 1,
        [keyIsDown1st, secs1st, keyCode1st] = KbQueueCheck(devInd);
        if  keyIsDown1st,
            if keyCode1st(KbName(quitkey)),
                Screen('CloseAll');
                ShowCursor;
                return;
            else
                break;
            end
        end
    end
    
catch err
    ShowCursor;
    Screen('CloseAll');
    rethrow(err);
end


%% AMUD
UD_up=PAL_AMUD_setupUD_up('startvalue',0.1,'up',1,'down',3,'xMax',1,'stepsizeup',0.01,'stepsizedown',0.01,'stopcriterion','reversals','stopRule',8);
UD_down =PAL_AMUD_setupUD_down('startvalue',0.9,'up',1,'down',3,'xMax',1,'stepsizeup',0.01,'stepsizedown',0.01,'stopcriterion','reversals','stopRule',8);


%% Script start
for i=1:64, %total trials for both staircases
    pause(0.3)
    %% Ascending staircase
    if CondList(i,2)==1,
        while ~UD_up.stop,
            try
                text3=Sentence_calibrate(CondList(i,3),CondList(i,4));
                timezero=GetSecs;%begining of the trial
                keydown=0;
                %nonbreak=0;
                SOA=rand(1);
                contrast=0;
                contrastW=0;
                ContrastR=(UD_up.xCurrent*255);
                ContrastL=(UD_up.xCurrent*255);
                ConIncrR=ContrastR/((refreshRate*Wrdtime)-1);
                ConIncrL=ContrastL/((refreshRate*Wrdtime)-1);
                ConRCG1=0;
                ConLCG1=0;
                ConRCG2=0;
                ConLCG2=0;
                %ConIncrW=(255/((refreshRate*10)-1)*2); % contrast increase rate: 20% for the target word
                o=1;%for Mondrians
                MonSpeed=[];
                BreakTime=0;
                NonBreakTime=1000000000000000;
                breakmon=100000;
                Aud=0;
                Buffer=0.5;
                disp(sprintf('     [T%d]',i))
                if DomEye ==1,
                    %f
                end
                while 1, %-37 & +25
                    % CONTEXT first two words %change the timing and location
                    if GetSecs-timezero>=SOA && GetSecs-timezero<=Wrdtime+SOA+TimeMon && keydown==0;
                        if CondList(i,4)==1 % Location Top = 1
                            Screen(wPtr,'TextSize',fontsize2); % text size
                            ConLCG1=ConLCG1+ConIncrL; % ramp up speed
                            Screen(wPtr,'TextFont','Arial'); % text font
                            % --- Familiarity ---
                            if CondList(i,3)==1
                                if length(char(text3))>1;
                                    [normBoundsRect, offsetBoundsRect]= Screen('TextBounds', wPtr, char(text3), (LeftboxXCenter), Top_textposition, [], []); %offset for top
                                    xpixel_length=(normBoundsRect(3));
                                    ypixel_height=(normBoundsRect(4));
                                    horz_position=LeftboxXCenter-(0.5*xpixel_length);
                                    vert_position=Top_textposition-(0.5*ypixel_height);
                                    DrawFormattedText(wPtr, char(text3), horz_position, vert_position, ConLCG1, [], []); % Familiar = 1 NF too high %char(text3)

                                else
                                    DrawFormattedText(wPtr, char(text3), LeftboxXCenter, Top_textposition, ConLCG1, [], []); % Familiar = 1
                                end
                            else
                                if length(char(text3))>1;
                                    [normBoundsRect, offsetBoundsRect]= Screen('TextBounds', wPtr, char(text3), (LeftboxXCenter), Top_textposition, [], []); %offset for top
                                    xpixel_length=(normBoundsRect(3));
                                    ypixel_height=(normBoundsRect(4));
                                    horz_position=(LeftboxXCenter-0.5*xpixel_length);
                                    vert_position=Top_textposition-0.5*ypixel_height+2;
                                    DrawFormattedText(wPtr, char(text3), horz_position, vert_position, ConLCG1, [], [], 1); % Unfamiliar = 2 F too low +205
                                else
                                    DrawFormattedText(wPtr, char(text3), LeftboxXCenter, Top_textposition, ConLCG1, [], [], 1); % Unfamiliar = 2 F too low
                                end
                            end
                        else % Location Bottom = 2
                            ConLCG1=ConLCG1+ConIncrL; % ramp up speed
                            Screen(wPtr,'TextSize',fontsize2); % text size
                            Screen(wPtr,'TextFont','Arial'); % text font
                            %if length(char(text3))>1;
                            %    [normBoundsRect, offsetBoundsRect]= Screen('TextBounds', wPtr, char(text3), (LeftboxXCenter), ((Bottom_textposition)), [], []); %offset for bottom
                            %end
                            % --- Familiarity ---
                            if CondList(i,3)==1; 
                                if length(char(text3))>1;
                                    [normBoundsRect, offsetBoundsRect]= Screen('TextBounds', wPtr, char(text3), (LeftboxXCenter), Bottom_textposition, [], []); %offset for bottom
                                    xpixel_length=(normBoundsRect(3));
                                    ypixel_height=(normBoundsRect(4));
                                    horz_position=LeftboxXCenter-0.5*xpixel_length;
                                    vert_position=Bottom_textposition-0.5*ypixel_height;
                                    DrawFormattedText(wPtr, char(text3), (horz_position), vert_position, ConLCG1, [], []); % Familiar = 1 NF too high
                                else
                                    DrawFormattedText(wPtr, char(text3), LeftboxXCenter, Bottom_textposition, ConLCG1, [], []); % Familiar = 1 NF too high
                                end
                            else
                                if length(char(text3))>1;
                                    [normBoundsRect, offsetBoundsRect]= Screen('TextBounds', wPtr, char(text3), (LeftboxXCenter), Bottom_textposition, [], []); %offset for bottom
                                    xpixel_length=(normBoundsRect(3));
                                    ypixel_height=(normBoundsRect(4));
                                    horz_position=LeftboxXCenter-0.5*xpixel_length;
                                    vert_position=Bottom_textposition-0.5*ypixel_height;
                                    DrawFormattedText(wPtr, char(text3), (horz_position), vert_position, ConLCG1, [], [], 1); % Unfamiliar = 2 F too low +155
                                else
                                    DrawFormattedText(wPtr, char(text3), LeftboxXCenter, Bottom_textposition, ConLCG1, [], [], 1); % Unfamiliar = 2 F too low
                                end
                            end
                        end
                    end
                    %***** Mondrians ***** % change the size 
                    if GetSecs-timezero>=0 && GetSecs-timezero<=SOA+Wrdtime+TimeMon && keydown==0 %for context
                        MonSpeed(end+1) = floor((GetSecs-timezero)/(1/MondFreq));
                        if length(MonSpeed)~=1 && MonSpeed(end)~=MonSpeed(end-1)
                            o=o+1;
                        end
                        if o==11
                            o=1;
                        end
                        Screen('DrawTexture', wPtr, s(1).tex{o}, [], MonTop, [], [], [], ([255 255 255]));
                        Screen('DrawTexture', wPtr, s(1).tex{o}, [], MonBottom, [], [], [], ([255 255 255]));
                        penWidthPixels = 3; % width for the cuing frame

                        % Draw the rect to the screen
                        if CondList(i,5)==1 % cue valid
                            if CondList(i,4)==1 %Top
                                centeredRect = CenterRectOnPointd(baseRect, MonLeftXCenter, Top_textposition);  
%                                 if a(i)>20
%                                     Screen('FillOval', wPtr, rectColor, centeredRect, maxDiameter);
%                                 end
                                %Screen('FrameRect', wPtr, [0 255 0], MonTop, penWidthPixels); %cue
                                Screen('FrameRect', wPtr, rect_col, MonTop+[-3 -3 3 3], penWidthPixels); %cue
                                breakmon=GetSecs-timezero;
                            elseif CondList(i,4)==2 %Bottom
                                centeredRect = CenterRectOnPointd(baseRect, MonRightXCenter, Bottom_textposition);
%                                 if a(i)>20
%                                     Screen('FillOval', wPtr, rectColor, centeredRect, maxDiameter);
%                                 end
                                %Screen('FrameRect', wPtr, [0 255 0], MonBottom, penWidthPixels);
                                Screen('FrameRect', wPtr, rect_col, MonBottom+[-3 -3 3 3], penWidthPixels);
                                breakmon=GetSecs-timezero;
                            end
                        elseif CondList(i,5)==2 % cue invalid
                            if CondList(i,4)==1 %Top
                                Screen('FrameRect', wPtr, rect_col, MonBottom+[-3 -3 3 3], penWidthPixels);
                                breakmon=GetSecs-timezero;
                            elseif CondList(i,4)==2 %Bottom
                                Screen('FrameRect', wPtr, rect_col, MonTop+[-3 -3 3 3], penWidthPixels);
                                breakmon=GetSecs-timezero;
                            end
                        end
                    end
                    if  keydown==3,
                        Writetext(wPtr,text10,LeftboxXCenter,RightboxXCenter,YCenter-5,  60,60, [255 255 255],18);
                        Writetext(wPtr,text11,LeftboxXCenter,RightboxXCenter,YCenter-5,  60,40, [255 255 255],18);
                    end

                    FixationBox(wPtr,LeftboxXCenter,RightboxXCenter,YCenter,boxsize,boxcolor)
                    Screen(wPtr, 'Flip');

                    %***** Keypresses *****
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                    if keyCode(KbName(quitkey)),
%                        CreateFile_calibrate(fName_r, ResultSet)
                        Screen('CloseAll');
                        ShowCursor;
                        return;
                    end

                    if keydown==0
                        if (GetSecs-(timezero)>Wrdtime+SOA),
                            NonBreakTime=GetSecs;
                            ResultSet(i,9)= 0; %target word unbroken
                            ResultSet(i,10)= NonBreakTime-(timezero+Wrdtime+SOA);
                            disp('Non-broken target:');disp(num2str(NonBreakTime-(timezero+SOA)))
                            response = 0;
                            UD_up = PAL_AMUD_updateUD_up(UD_up, response);
                            disp('up here')
                            keydown=3;
                        end
                        %if (GetSecs-(timezero)>SOA+0.5)
                            %ResultSet(i,7)= 0; %0=Non-broken 1=Right 2=Left
                        %end
                    end
                    if keydown==1,
                        Writetext(wPtr,textqn,LeftboxXCenter+20,RightboxXCenter+20,YCenter+26,  60,60, [255 255 255],18);
                        if keyCode(KbName(UpArrow)) && (GetSecs-(timezero)<SOA+Wrdtime+1.5), % Answers Location question
                            BROKEN=1;
                            keydown=3;
                            disp('Right')
                            if CondList(i,4)==1 % stimulus right
                                disp('broken')
                                ResultSet(i,8)=1; %Broken correct
                                if (Suppressiontime<0.5)
                                    %
                                elseif (Suppressiontime>2.0)
                                    response = 0;
                                    UD_up = PAL_AMUD_updateUD_up(UD_up, response);
                                elseif (Suppressiontime>0.5 && Suppressiontime<2.0);
                                    response = 1;
                                    UD_up = PAL_AMUD_updateUD_up(UD_up, response);
                                end
                            else disp('false alarm')
                                ResultSet(i,8)=0; %Broken wrong
                            end
                            %{
                            if a(i)>20,
                                Catch=Catch+1; 
                            end
                            %}
                        elseif keyCode(KbName(DownArrow)) && (GetSecs-(timezero)<SOA+Wrdtime+1.5), % Answers Location question
                            BROKEN=1;
                            
                            keydown=3;
                            disp('Left')
                            if CondList(i,4)==2 % stimulus left
                                disp('broken')
                                ResultSet(i,8)=1; %Broken correct
                                if (Suppressiontime<0.5)
                                    %
                                elseif (Suppressiontime>2.0)
                                    response = 0;
                                    UD_up = PAL_AMUD_updateUD_up(UD_up, response);
                                elseif (Suppressiontime>0.5 && Suppressiontime<2.0);
                                    response = 1;
                                    UD_up = PAL_AMUD_updateUD_up(UD_up, response);
                                end
                            else disp('false alarm')
                                ResultSet(i,8)=0; %Broken wrong
                            end 
%                             if a(i)>20,
%                                 Catch=Catch+1;
%                             end
                        elseif (GetSecs-(timezero)>SOA+Wrdtime+1.5), %stops Location question
                            keydown=3;
                        end
                    end
                    if  (keydown==0 && GetSecs-(timezero)>SOA) || keydown==1 || keydown==3,
                        if GetSecs-timezero > 1
                            if keyCode(KbName(space)),
                                if keydown==0
                                    if (GetSecs-(timezero)<SOA+TimeMon)
                                        disp(keydown)
                                        BreakTime=GetSecs;
                                        Suppressiontime = BreakTime-(timezero+SOA);
                                        ResultSet(i,9)= 1; %target word broken
                                        ResultSet(i,10)= BreakTime-(timezero+SOA); %break time
                                        disp('ST:');disp(num2str(BreakTime-(timezero+SOA)))
                                    end
                                end
                                keydown=keydown+1;
                                if keydown==2 || keydown==4,
                                    keydown=0;
                                    break
                                end
                            end

                        end
                    end
                    %***** Results *****
                    %{
                    ResultSet(:,1)=CondList(:,1); %TNum
                    ResultSet(:,2)=CondList(:,2); %Ascending/Descending
                    ResultSet(:,3)=CondList(:,3); %actual trial a(i)
                    ResultSet(:,4)=CondList(:,4); %CON 1=CON 2=InCON
                    ResultSet(:,5)=CondList(:,5); %Flip 1=Noflip 2=Flip
                    ResultSet(:,6)=CondList(:,6); %Stimulus position 1=Right 2=Left
                    ResultSet(:,7)=CondList(:,7); %Cue valid/invalid
                    %}
                end
            catch err
                ShowCursor;
                Screen('CloseAll');
                rethrow(err);
            end
            ResultSet(ResultSet(i,4:7)==2)=0;
            dlmwrite(savefilename, ResultSet(i,:),'delimiter',',','-append');
            break
        end
    %% Descending staircase    
    elseif CondList(i,2)==2,    
        while ~UD_down.stop,
            try
                text3=Sentence_calibrate(CondList(i,3),CondList(i,4));
                timezero=GetSecs;%begining of the trial
                keydown=0;
                %nonbreak=0;
                SOA=rand(1);
                contrast=0;
                contrastW=0;
                ContrastR=(UD_down.xCurrent*255);
                ContrastL=(UD_down.xCurrent*255);
                ConIncrR=ContrastR/((refreshRate*Wrdtime)-1);
                ConIncrL=ContrastL/((refreshRate*Wrdtime)-1);
                ConRCG1=0;
                ConLCG1=0;
                ConRCG2=0;
                ConLCG2=0;
                %ConIncrW=(255/((refreshRate*10)-1)*2); % contrast increase rate: 20% for the target word
                o=1;%for Mondrians
                MonSpeed=[];
                BreakTime=0;
                NonBreakTime=1000000000000000;
                breakmon=100000;
                Aud=0;
                Buffer=0.5;
                disp(sprintf('     [T%d]',i))
                disp(num2str(i)) %current trial no
                centralize_word = ((cellfun('length',text3))/2);
                %centralize_word=((cellfun('length',text3))/2);
                if DomEye ==1,
                    %f
                end
                while 1, %-37 & +25
                    if GetSecs-timezero>=SOA && GetSecs-timezero<=Wrdtime+SOA+TimeMon && keydown==0;
                        if CondList(i,4)==1 % Location Top = 1
                            Screen(wPtr,'TextSize',fontsize2); % text size
                            ConLCG1=ConLCG1+ConIncrL; % ramp up speed
                            Screen(wPtr,'TextFont','Arial'); % text font
                            % --- Familiarity ---
                            if CondList(i,3)==1
                                if length(char(text3))>1;
                                    [normBoundsRect, offsetBoundsRect]= Screen('TextBounds', wPtr, char(text3), (LeftboxXCenter), Top_textposition, [], []); %offset for top
                                    xpixel_length=(normBoundsRect(3));
                                    ypixel_height=(normBoundsRect(4));
                                    horz_position=LeftboxXCenter-(0.5*xpixel_length);
                                    vert_position=Top_textposition-(0.5*ypixel_height);
                                    DrawFormattedText(wPtr, char(text3), horz_position, vert_position, ConLCG1, [], []); % Familiar = 1 NF too high %char(text3)

                                else
                                    DrawFormattedText(wPtr, char(text3), LeftboxXCenter, Top_textposition, ConLCG1, [], []); % Familiar = 1
                                end
                            else
                                if length(char(text3))>1;
                                    [normBoundsRect, offsetBoundsRect]= Screen('TextBounds', wPtr, char(text3), (LeftboxXCenter), Top_textposition, [], []); %offset for top
                                    xpixel_length=(normBoundsRect(3));
                                    ypixel_height=(normBoundsRect(4));
                                    horz_position=(LeftboxXCenter-0.5*xpixel_length);
                                    vert_position=Top_textposition-0.5*ypixel_height+2;
                                    DrawFormattedText(wPtr, char(text3), horz_position, vert_position, ConLCG1, [], [], 1); % Unfamiliar = 2 F too low +205
                                else
                                    DrawFormattedText(wPtr, char(text3), LeftboxXCenter, Top_textposition, ConLCG1, [], [], 1); % Unfamiliar = 2 F too low
                                end
                            end
                        else % Location Bottom = 2
                            ConLCG1=ConLCG1+ConIncrL; % ramp up speed
                            Screen(wPtr,'TextSize',fontsize2); % text size
                            Screen(wPtr,'TextFont','Arial'); % text font
                            %if length(char(text3))>1;
                            %    [normBoundsRect, offsetBoundsRect]= Screen('TextBounds', wPtr, char(text3), (LeftboxXCenter), ((Bottom_textposition)), [], []); %offset for bottom
                            %end
                            % --- Familiarity ---
                            if CondList(i,3)==1; 
                                if length(char(text3))>1;
                                    [normBoundsRect, offsetBoundsRect]= Screen('TextBounds', wPtr, char(text3), (LeftboxXCenter), Bottom_textposition, [], []); %offset for bottom
                                    xpixel_length=(normBoundsRect(3));
                                    ypixel_height=(normBoundsRect(4));
                                    horz_position=LeftboxXCenter-0.5*xpixel_length;
                                    vert_position=Bottom_textposition-0.5*ypixel_height;
                                    DrawFormattedText(wPtr, char(text3), (horz_position), vert_position, ConLCG1, [], []); % Familiar = 1 NF too high
                                else
                                    DrawFormattedText(wPtr, char(text3), LeftboxXCenter, Bottom_textposition, ConLCG1, [], []); % Familiar = 1 NF too high
                                end
                            else
                                if length(char(text3))>1;
                                    [normBoundsRect, offsetBoundsRect]= Screen('TextBounds', wPtr, char(text3), (LeftboxXCenter), Bottom_textposition, [], []); %offset for bottom
                                    xpixel_length=(normBoundsRect(3));
                                    ypixel_height=(normBoundsRect(4));
                                    horz_position=LeftboxXCenter-0.5*xpixel_length;
                                    vert_position=Bottom_textposition-0.5*ypixel_height+2;
                                    DrawFormattedText(wPtr, char(text3), (horz_position), vert_position, ConLCG1, [], [], 1); % Unfamiliar = 2 F too low +155
                                else
                                    DrawFormattedText(wPtr, char(text3), LeftboxXCenter, Bottom_textposition, ConLCG1, [], [], 1); % Unfamiliar = 2 F too low
                                end
                            end
                        end
                    end

                    %{
                    % CONTEXT first two words %change the timing and location
                    if GetSecs-timezero>=SOA && GetSecs-timezero<=Wrdtime+SOA && keydown==0;
                        if CondList(i,4)==1
                            ConLCG1=ConLCG1+ConIncrL;
                            Screen(wPtr,'TextSize',fontsize2);
                            Screen(wPtr,'TextFont','Arial');
                            if CondList(i,3)==1
                                DrawFormattedText(wPtr, char(text3), Loctext1, (YCenter-19-22), ConLCG1, [], []);
                            else
                                DrawFormattedText(wPtr, char(text3), Loctext1, (YCenter-14-22), ConLCG1, [], [], 1); %flipped
                            end
                        else
                            ConLCG1=ConLCG1+ConIncrL;
                            Screen(wPtr,'TextSize',fontsize2);
                            Screen(wPtr,'TextFont','Arial');
                            if CondList(i,3)==1;
                                DrawFormattedText(wPtr, char(text3), Loctext1, (YCenter+0+22), ConLCG1, [], []);
                            else
                                DrawFormattedText(wPtr, char(text3), Loctext1, (YCenter+5+22), ConLCG1, [], [], 1); %flipped
                            end
                        end
                    end
                    %}
                    %***** Mondrians ***** % change the size 
                    if GetSecs-timezero>=0 && GetSecs-timezero<=SOA+Wrdtime+TimeMon && keydown==0 %for context
                        MonSpeed(end+1) = floor((GetSecs-timezero)/(1/MondFreq));
                        if length(MonSpeed)~=1 && MonSpeed(end)~=MonSpeed(end-1)
                            o=o+1;
                        end
                        if o==11
                            o=1;
                        end
                        Screen('DrawTexture', wPtr, s(1).tex{o}, [], MonTop, [], [], [], ([255 255 255]));
                        Screen('DrawTexture', wPtr, s(1).tex{o}, [], MonBottom, [], [], [], ([255 255 255]));
                        penWidthPixels = 3; % width for the cuing frame

                        % Draw the rect to the screen
                        if CondList(i,5)==1 % cue valid
                            if CondList(i,4)==1 %Top
                                centeredRect = CenterRectOnPointd(baseRect, MonLeftXCenter, Top_textposition);
%                                 if a(i)>20
%                                     Screen('FillOval', wPtr, rectColor, centeredRect, maxDiameter);
%                                 end
                                Screen('FrameRect', wPtr, rect_col, MonTop+[-3 -3 3 3], penWidthPixels); %cue
                                breakmon=GetSecs-timezero;
                            elseif CondList(i,4)==2 %Bottom
                                centeredRect = CenterRectOnPointd(baseRect, MonRightXCenter, Bottom_textposition);
%                                 if a(i)>20
%                                     Screen('FillOval', wPtr, rectColor, centeredRect, maxDiameter);
%                                 end
                                Screen('FrameRect', wPtr, rect_col, MonBottom+[-3 -3 3 3], penWidthPixels);
                                breakmon=GetSecs-timezero;
                            end
                        elseif CondList(i,5)==2 % cue invalid
                            if CondList(i,4)==1 %Top
                                Screen('FrameRect', wPtr, rect_col, MonBottom+[-3 -3 3 3], penWidthPixels);
                                breakmon=GetSecs-timezero;
                            elseif CondList(i,4)==2 %Bottom
                                Screen('FrameRect', wPtr, rect_col, MonTop+[-3 -3 3 3], penWidthPixels);
                                breakmon=GetSecs-timezero;
                            end
                        end
                    end
                    if  keydown==3,
                        Writetext(wPtr,text10,LeftboxXCenter,RightboxXCenter,YCenter-5,  60,60, [255 255 255],18);
                        Writetext(wPtr,text11,LeftboxXCenter,RightboxXCenter,YCenter-5,  60,40, [255 255 255],18);
                    end

                    FixationBox(wPtr,LeftboxXCenter,RightboxXCenter,YCenter,boxsize,boxcolor)
                    Screen(wPtr, 'Flip');

                    %***** Keypresses *****
                    [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
                    if keyCode(KbName(quitkey)),
%                        CreateFile_calibrate(fName_r, ResultSet)
                        Screen('CloseAll');
                        ShowCursor;
                        return;
                    end

                    if keydown==0
                        if (GetSecs-(timezero)>Wrdtime+SOA),
                            NonBreakTime=GetSecs;
                            ResultSet(i,9)= 0; %target word unbroken
                            ResultSet(i,10)= NonBreakTime-(timezero+Wrdtime+SOA);
                            disp('Non-broken target:');disp(num2str(NonBreakTime-(timezero+SOA)))
                            response = 0;
                            UD_down = PAL_AMUD_updateUD_down(UD_down, response);
                            keydown=3;
                        end
                        %if (GetSecs-(timezero)>SOA+0.5)
                            %ResultSet(i,7)= 0; %0=Non-broken 1=Right 2=Left
                        %end
                    end
                    if keydown==1,
                        Writetext(wPtr,textqn,LeftboxXCenter+20,RightboxXCenter+20,YCenter+26,  60,60, [255 255 255],18);
                        if keyCode(KbName(UpArrow)) && (GetSecs-(timezero)<SOA+Wrdtime+1.5), % Answers Location question
                            BROKEN=1;
                            ResultSet(i,8)=1; %Broken on Right
                            keydown=3;
                            disp('Top')
                            if CondList(i,4)==1 % stimulus right
                                disp('B')
                                if (Suppressiontime<0.5)
                                    %
                                elseif (Suppressiontime>2.0)
                                    response = 0;
                                    UD_down = PAL_AMUD_updateUD_down(UD_down, response);
                                elseif (Suppressiontime>0.5 && Suppressiontime<2.0);
                                    response = 1;
                                    UD_down = PAL_AMUD_updateUD_down(UD_down, response);
                                end
                            else disp('FALSE ALARM')
                            end
%                             if a(i)>20,
%                                 Catch=Catch+1; 
%                             end    
                        elseif keyCode(KbName(DownArrow)) && (GetSecs-(timezero)<SOA+Wrdtime+1.5), % Answers Location question
                            BROKEN=1;
                            ResultSet(i,8)=2; %Broken on Left
                            keydown=3;
                            disp('Botton')
                            if CondList(i,4)==2 % stimulus left
                                disp('B')
                                if (Suppressiontime<0.5)
                                    %
                                elseif (Suppressiontime>2.0)
                                    response = 0;
                                    UD_down = PAL_AMUD_updateUD_down(UD_down, response);
                                elseif (Suppressiontime>0.5 && Suppressiontime<2.0);
                                    response = 1;
                                    UD_down = PAL_AMUD_updateUD_down(UD_down, response);
                                end
                            else disp('FALSE ALARM')
                            end 
%                             if a(i)>20,
%                                 Catch=Catch+1;
%                             end
                        elseif (GetSecs-(timezero)>SOA+Wrdtime+1.5), %stops Location question
                            keydown=3;
                        end
                    end
                    if  (keydown==0 && GetSecs-(timezero)>SOA) || keydown==1 || keydown==3,
                        if GetSecs-timezero > SOA
                            if keyCode(KbName(space)),
                                if keydown==0
                                    if (GetSecs-timezero-SOA<=Wrdtime) 
                                        disp(keydown)
                                        BreakTime=GetSecs;
                                        Suppressiontime = BreakTime-timezero-SOA;
                                        ResultSet(i,9)= 1; %target word broken
                                        ResultSet(i,10)= Suppressiontime; %Suppression time
                                        disp('ST:');disp(num2str(BreakTime-(timezero+SOA)))
                                    end
                                end
                                keydown=keydown+1;
                                if keydown==2 || keydown==4,
                                    keydown=0;
                                    break
                                end
                            end

                        end
                    end
                    %***** Results *****
                    %{
                    ResultSet(:,1)=CondList(:,1); %TNum
                    ResultSet(:,2)=CondList(:,2); %Ascending/Descending
                    ResultSet(:,3)=CondList(:,3); %actual trial a(i)
                    ResultSet(:,4)=CondList(:,4); %CON 1=CON 2=InCON
                    ResultSet(:,5)=CondList(:,5); %Flip 1=Noflip 2=Flip
                    ResultSet(:,6)=CondList(:,6); %Stimulus position 1=Right 2=Left
                    ResultSet(:,7)=CondList(:,7); %Cue valid/invalid
                    %}
                end
            catch err
                ShowCursor;
                Screen('CloseAll');
                rethrow(err);
            end
            ResultSet(ResultSet(i,4:7)==2)=0;
            dlmwrite(savefilename, ResultSet(i,:),'delimiter',',','-append');
            break
        end
    end
end
sca

%% Plots fpr staircases
t = 1:length(UD_up.x);
figure('name','Ascending staircase');
plot(t,UD_up.x,'k');
hold on;
plot(t(UD_up.response == 1),UD_up.x(UD_up.response == 1),'ko', 'MarkerFaceColor','k');
plot(t(UD_up.response == 0),UD_up.x(UD_up.response == 0),'ko', 'MarkerFaceColor','w');
set(gca,'FontSize',16);
axis([0, max(t)+1, min(UD_up.x)-(max(UD_up.x)-min(UD_up.x))/10, max(UD_up.x)+(max(UD_up.x)-min(UD_up.x))/10]);
%line([1 length(UD_up.x)], [targetX targetX],'linewidth', 2, 'linestyle', '--', 'color','k');
xlabel('Trial');
ylabel('Stimulus Intensity');

t = 1:length(UD_down.x);
figure('name','Descending staircase');
plot(t,UD_down.x,'k');
hold on;
plot(t(UD_down.response == 1),UD_down.x(UD_down.response == 1),'ko', 'MarkerFaceColor','k');
plot(t(UD_down.response == 0),UD_down.x(UD_down.response == 0),'ko', 'MarkerFaceColor','w');
set(gca,'FontSize',16);
axis([0, max(t)+1, min(UD_down.x)-(max(UD_down.x)-min(UD_down.x))/10, max(UD_down.x)+(max(UD_down.x)-min(UD_down.x))/10]);
%line([1 length(UD_down.x)], [targetX targetX],'linewidth', 2, 'linestyle', '--', 'color','k');
xlabel('Trial');
ylabel('Stimulus Intensity');


Mean_up = PAL_AMUD_analyzeUD_up(UD_up, 'reversals', 4);
disp(sprintf('\nAscending threshold (last 4 reversals): %f', Mean_up))
Mean_down = PAL_AMUD_analyzeUD_down(UD_down, 'reversals', 4);
disp(sprintf('\nDescending threshold (last 4 reversals): %f', Mean_down))
mean_threshold=(Mean_up+Mean_down)/2;
disp(sprintf('\nMean threshold: %f', mean_threshold))