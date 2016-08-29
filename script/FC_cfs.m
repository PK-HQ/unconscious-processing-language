%% Overview
%1. Setting parameters
clearvars -except threshold
%% Setting parameters

%getenv('DYLD_LIBRARY_PATH')
%nVal='/opt/X11/lib:/Applications/MATLAB_R2015b.app/sys/os/maci64:/Applications/MATLAB_R2015b.app/bin/maci64/../../Contents/MacOS:/Applications/MATLAB_R2015b.app/bin/maci64:/Applications/MATLAB_R2015b.app/extern/lib/maci64:/Applications/MATLAB_R2015b.app/runtime/maci64:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./native_threads:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./server:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./lib/jli';
%setenv('DYLD_LIBRARY_PATH', '/opt/X11/lib:/Applications/MATLAB_R2015b.app/sys/os/maci64:/Applications/MATLAB_R2015b.app/bin/maci64/../../Contents/MacOS:/Applications/MATLAB_R2015b.app/bin/maci64:/Applications/MATLAB_R2015b.app/extern/lib/maci64:/Applications/MATLAB_R2015b.app/runtime/maci64:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./native_threads:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./server:/Applications/MATLAB_R2015b.app/sys/java/jre/maci64/jre/lib/./lib/jli');



% --- Subject parameters ---
subjNo                = input('subjNo: ','s');
runNo                 = input('run: ')';
DomEye                = input('DomEye:'); %1=R 2=L
keymode               = input('Mac1 Win2: ');
ContrastR             = input('ContrastR:'); %Right hemi contrast
ContrastL             = input('ContrastL:'); %Left hemi contrast
% --- Names ---
current_date=datestr(datetime('today'),'YYYYmmdd');
current_time=datestr(now, 'HHMM');
folder = {'/Users/pk/Desktop/fc/script/Mon/'};
%fName_r       = [ 'AU_' '_Sub' num2str(subjNo) '_Run' num2str(runNo) '.txt' ];
subno=sprintf('%02d', 2);
savefilename=['FC_cfs_sub' num2str(subno) '_' current_date '_' current_time '.csv'];
%header={'Trial_number' 'Sentence_ID' 'Sentence_pixel_length' 'Congruent_1' 'Familiar_1' 'LocationTop_1' 'Cued_1' 'Trialbroken_1' 'ST'};
fid = fopen(savefilename, 'w');
fprintf(fid, 'subID,Trial_number,Sentence_ID,Sentence_pixel_length,Congruent_1,Familiar_1,LocationTop_1,Cued_1,Trialcorrect_1,Trialbroken_1,ST\n');
fclose(fid);


%dlmwrite(savefilename, header,'delimiter','tab','-append');
% --- Open screen ---
screid = max(Screen('Screens'));
%screid = 1;
xgomid = 320;
ygomid = 140;
scsize = {[xgomid ygomid xgomid+1280 ygomid+800];[]};
disize = 2; %1=mini 2=full
[wPtr, rect] = Screen('OpenWindow', screid, [0 0 0] , scsize{disize});
rect_col=[102 255 255];
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
XCenter         =retX/2;
YCenter         =retY/2-disY;
YCenter2        =(retY/2-disY)+25;
LeftboxXCenter  =(1*retX/4)+disX;
RightboxXCenter =(3*retX/4)-disX;
Top_textposition=YCenter-11-45+22.5;%
Bottom_textposition=YCenter+11+45-22.5;%
boxsize         =80;
MondrianSize    =30;
fontsize1       =20;
fontsize2       =14;
% --- Timings and Mondrian Frequency ---
TimeSound=1;
TimeMon=5;
Wrdtime=2;
TimeImg=5;
Timeext=0.5;
NonBext=0.5;
MondFreq      = 10; %Unit: Hz
MondN  = round(refreshRate/MondFreq); % frames/img
% --- Location ---
if DomEye ==1,
    MonTop  = [RightboxXCenter-72 YCenter-11-45 RightboxXCenter+72 YCenter-11];
    MonBottom = [RightboxXCenter-72 YCenter+11 RightboxXCenter+72 YCenter+11+45];
    %stiLeft  = [RightboxXCenter-50-MondrianSize/2-MonStiDis+5 YCenter-35 RightboxXCenter-5-MonStiDis YCenter+MondrianSize-20];
    %stiRight = [RightboxXCenter+28-MondrianSize/2-MonStiDis+5 YCenter-35 RightboxXCenter+73-MonStiDis YCenter+MondrianSize-20];
elseif DomEye ==2,
    %stiLeft  = [RightboxXCenter-50-(MondrianSize/2)+5 YCenter-MondrianSize/2 RightboxXCenter-5 YCenter+MondrianSize/2];
    %stiRight = [RightboxXCenter+28-(MondrianSize/2)+5 YCenter-MondrianSize/2 RightboxXCenter+73 YCenter+MondrianSize/2];
    MonTop  = [LeftboxXCenter-72 YCenter-11-45 LeftboxXCenter+72 YCenter-11];
    MonBottom = [LeftboxXCenter-72 YCenter+11 LeftboxXCenter+72 YCenter+11+45];
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
penWidthPixels = 3;
baseRect = [0 0 10 10];
maxDiameter = max(baseRect) * 8;
rectColor = [255 255 255];
%% --- Experimental Design --- 
% [SENTENCE_ID | CONGRUENT=1 | FAMILIAR=1 |  LOCATION TOP=1 | ATTENTION CUED=1]
ntrials  = 512; % [30sentences+2blanks (SENTENCE_ID) * 2(CONGRUENCY) * 2(FAMILIARITY) * 2 (LOCATION) * 2(ATTENTION CUE)
sentence_index=[1:30]'; % CondList(:,1) = [1:32]' repeated 16x
Condperms=[1,1,1,1;1,1,1,2;1,1,2,1;1,1,2,2;1,2,1,1;1,2,1,2;1,2,2,1;1,2,2,2;2,1,1,1;2,1,1,2;2,1,2,1;2,1,2,2;2,2,1,1;2,2,1,2;2,2,2,1;2,2,2,2]; % 16 unique combinations of 4 binary variables
CondList=zeros(480, 5);
row1=1;
row30=30;
for i=1:16,
    A=repmat(Condperms(i,:),30,1);
    B = [sentence_index A]; % combining into final Condition List
    CondList(row1:row30,:)=B;
    row1=row1+30;
    row30=row30+30;
end
CondList = CondList(randperm(length(CondList)),:);
blanks_index=[repmat(31,16,1); repmat(32,16,1)]; % CondList(:,1) = [1:32]' repeated 16x
Condperms=repmat([1,1,1,1;1,1,1,1;1,1,2,1;1,1,2,1;1,2,1,1;1,2,1,1;1,2,2,1;1,2,2,1;2,1,1,1;2,1,1,1;2,1,2,1;2,1,2,1;2,2,1,1;2,2,1,1;2,2,2,1;2,2,2,1],2,1); % 16 unique combinations of 4 binary variables
BlanksList=[blanks_index,Condperms];
BlanksList = BlanksList(randperm(length(BlanksList)),:);

% Pseudorandom blank trials
index_base=15;
for i=1:32,
    k=index_base+round((rand()-0.5)*6); %every 12 +-3
    CondList=[CondList(1:k,:); BlanksList(i,:); CondList(k+1:end,:)];
    index_base=index_base+15+round(rand(1));
end

a=CondList(:,1); % Randomized sentence index


CondList(:,6)=repmat(subjNo,512,1);
Catch    = 0; %Catch trial




%{
ntrials  = 512; % [30sentences+2blanks (SENTENCE_ID) * 2(CONGRUENCY) * 2(FAMILIARITY) * 2 (LOCATION) * 2(ATTENTION CUE)
sentence_index=[1:32]'; % CondList(:,1) = [1:32]' repeated 16x
Condperms=[1,1,1,1;1,1,1,2;1,1,2,1;1,1,2,2;1,2,1,1;1,2,1,2;1,2,2,1;1,2,2,2;2,1,1,1;2,1,1,2;2,1,2,1;2,1,2,2;2,2,1,1;2,2,1,2;2,2,2,1;2,2,2,2]; % 16 unique combinations of 4 binary variables
CondList=zeros(ntrials, 5);
row1=1;
row32=32;
for i=1:16,
    A=repmat(Condperms(i,:),32,1);
    B = [sentence_index A]; % combining into final Condition List
    B = B(randperm(length(B)),:); % randomize by shuffling rows
    CondList(row1:row32,:)=B;
    row1=row1+32;
    row32=row32+32;
end
CondList(:,6)=repmat(subjNo,512,1);
a=CondList(:,1); % Randomized sentence index
Catch    = 0; %Catch trial
%}
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

%% Start of Experiment
for i=1:ntrials;
    try
        text3=Sentence(a(i),CondList(i,2));
        timezero=GetSecs;%begining of the trial
        keydown=0;
        %nonbreak=0;
        SOA=rand(1);
        contrast=0;
        contrastW=0;
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
        disp(sprintf('     [%d]',i));
        if DomEye ==1,
            % ?
        end
        while 1,
            % --- Location ---
            if GetSecs-timezero>=SOA && GetSecs-timezero<=Wrdtime+SOA && keydown==0;
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
                            vert_position=Top_textposition-(0.5*ypixel_height)-1;
                            ResultSet(i,4)=xpixel_length;
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
                            ResultSet(i,4)=xpixel_length;
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
                            vert_position=Bottom_textposition-0.5*ypixel_height-1;
                            ResultSet(i,4)=xpixel_length;
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
                            ResultSet(i,4)=xpixel_length;
                            DrawFormattedText(wPtr, char(text3), (horz_position), vert_position, ConLCG1, [], [], 1); % Unfamiliar = 2 F too low +155
                        else
                            DrawFormattedText(wPtr, char(text3), LeftboxXCenter, Bottom_textposition, ConLCG1, [], [], 1); % Unfamiliar = 2 F too low
                        end
                    end
                end
            end
            %--- Mondrian display ---
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
                penWidthPixels = 2; % width for the cuing frame

                % --- Cue Validity ---
                if CondList(i,5)==1 % Cue valid = 1 (cue follows location of target sentence)
                    if CondList(i,4)==1 % if target is top, cue is on top
                        centeredRect = CenterRectOnPointd(baseRect, MonLeftXCenter+1, YCenter-32);
                        % --- Catch trial ---
                        if a(i)>30 % if sentence_ID corresponds to blank target(ID=31,32), display catch trial circle
                            Screen('FillOval', wPtr, rectColor, centeredRect, maxDiameter);
                        end
                        Screen('FrameRect', wPtr, rect_col, MonTop+[-2 -2 2 2], penWidthPixels); %cue
                        breakmon=GetSecs-timezero;
                    elseif CondList(i,4)==2 % vice versa
                        centeredRect = CenterRectOnPointd(baseRect, MonRightXCenter+1, YCenter+32);
                        % --- Catch trial ---
                        if a(i)>30 % if sentence_ID corresponds to blank target(ID=31,32), display catch trial circle
                            Screen('FillOval', wPtr, rectColor, centeredRect, maxDiameter);
                        end
                        Screen('FrameRect', wPtr, rect_col, MonBottom+[-2 -2 2 2], penWidthPixels);
                        breakmon=GetSecs-timezero;
                    end
                elseif CondList(i,5)==2 % Cue invalid = 2 (cue does not follow location of target sentence)
                    if CondList(i,4)==1 % if target is top, cue is on bottom
                        Screen('FrameRect', wPtr, rect_col, MonBottom+[-2 -2 2 2], penWidthPixels);
                        breakmon=GetSecs-timezero;
                    elseif CondList(i,4)==2 % vice versa
                        Screen('FrameRect', wPtr, rect_col, MonTop+[-2 -2 2 2], penWidthPixels);
                        breakmon=GetSecs-timezero;
                    end
                end
            end
            % --- Proceed to next trial ---
            if  keydown==3,
                Writetext(wPtr,text10,LeftboxXCenter,RightboxXCenter,YCenter-5,  60,60, [255 255 255],18);
                Writetext(wPtr,text11,LeftboxXCenter,RightboxXCenter,YCenter-5,  60,40, [255 255 255],18);
            end
            FixationBox(wPtr,LeftboxXCenter,RightboxXCenter,YCenter,boxsize,boxcolor)
            Screen(wPtr, 'Flip');
            % --- Keypresses ---
            % Esc key
            [keyIsDown, secs, keyCode] = KbQueueCheck(devInd);
            if keyCode(KbName(quitkey)),
                %CreateFile(fName_r, ResultSet)
                Screen('CloseAll');
                ShowCursor;
                return;
            end
            % Unbroken trials (Missed key press window of <Wrdtime+SOA>)
            if keydown==0
                if (GetSecs-(timezero)>Wrdtime+SOA),
                    NonBreakTime=GetSecs;
                    ResultSet(i,10)= 0; %target word unbroken
                    ResultSet(i,11)= NonBreakTime-(timezero+Wrdtime+SOA);
                    disp('*Non-broken*:');disp(num2str(NonBreakTime-(timezero+SOA)))
                    keydown=3;
                end
            end
            % False alarm trials (No space bar press + answers location question within 1.5s window)
            if keydown==1,
                Writetext(wPtr,textqn,LeftboxXCenter+20,RightboxXCenter+20,YCenter+26,  60,60, [255 255 255],18);
                if keyCode(KbName(UpArrow)) && (GetSecs-(timezero)<SOA+Wrdtime+1.5), % Answers Location question within time
                    BROKEN=1;
                    keydown=3;
                    disp('Top')
                    if CondList(i,4)==1 % stimulus Top
                        ResultSet(i,9)=1; %Broken correct
                        disp('[Broken]')
                    else disp('[FA]')
                        ResultSet(i,9)=0; %Broken wrong
                    end
                    if a(i)>30,
                        Catch=Catch+1; 
                    end    
                elseif keyCode(KbName(DownArrow)) && (GetSecs-(timezero)<SOA+Wrdtime+1.5), % Answers Location question
                    BROKEN=1;
                    keydown=3;
                    disp('Bottom')
                    if CondList(i,4)==2 % stimulus bottom
                        ResultSet(i,9)=1; %Broken correct
                        disp('[Broken]')
                    else disp('[FA]')
                        ResultSet(i,9)=0; %Broken wrong
                    end 
                    if a(i)>30,
                        Catch=Catch+1;
                    end
                elseif (GetSecs-(timezero)>SOA+Wrdtime+1.5), %stops Location question
                    keydown=3;
                end
            end
            % Actual broken trial (Space bar press + Location question)
            if  (keydown==0 && GetSecs-(timezero)>SOA) || keydown==1 || keydown==3, % haven't pressed space (becomes==1) || pressed space + haven't press arrow (becomes==0) || pressed space + pressed arrow (becomes==0)(end of trial)
                %if GetSecs-(timezero)-SOA<Wrdtime+1.5 %if timing is for current trial
                if GetSecs-timezero > SOA
                    if keyCode(KbName(space)),
                        if keydown==0 %???
                            %if (GetSecs-(timezero)<SOA+TimeMon) % if timing is within mondrian
                            if (GetSecs-timezero-SOA<=Wrdtime) % if timing is within trial
                                disp(keydown)
                                BreakTime=GetSecs;
                                Suppressiontime = BreakTime-timezero-SOA;
                                ResultSet(i,10)= 1; %target word broken
                                ResultSet(i,11)= Suppressiontime; %Suppression time
                                disp('ST:');disp(num2str(BreakTime-(timezero+SOA)))
                            end
                        end
                        keydown=keydown+1;
                        if keydown==2 || keydown==4, % false alarms = 2, ended trials = 4
                            keydown=0;
                            break
                        end
                    end

                end
            end
            %--- Results ---
            ResultSet(:,1)=CondList(:,6);
            ResultSet(:,2)=CondList(:,1); %TNum
            ResultSet(i,3)=a(i);          %actual trial a(i)
            %ResultSet(i,4)=xpixel_length;
            ResultSet(:,5)=CondList(:,2); %CON 1=CON 2=InCON
            ResultSet(:,6)=CondList(:,3); %Flip 1=Noflip 2=Flip
            ResultSet(:,7)=CondList(:,4); %Stimulus position 1=Top 0=Bottom
            ResultSet(:,8)=CondList(:,5); %Cue valid/invalid
            %ResultSet(i,9)= break correct
            %ResultSet(i,10)= broken
            %ResultSet(i,11)= ST
        end
        %disp(sprintf('passes end of loop'))
    catch err
        ShowCursor;
        Screen('CloseAll');
        rethrow(err);
    end
    ResultSet(ResultSet(i,5:8)==2)=0;
    dlmwrite(savefilename, ResultSet(i,:),'delimiter',',','-append');
end
sca

%{
try
    CreateFile(fName_r, ResultSet)
    disp('Catch acc')
    Catch/10
    Screen('CloseAll');
    ShowCursor;
    return;
catch err
    fclose('all');
    rethrow(err);
end
%}
