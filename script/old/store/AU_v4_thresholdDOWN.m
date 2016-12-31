%2016, 1, 21
% 1. better randomization
% 2. reduce word length
% 3. ramping-up for the first 2 words?
% 4. able to change left-right answer
% 5. calibration

%2016, 1, 23
% 1. A summary table
% 2. How many broken trials are tolerable?
% 3. Writing results

clear all
close all
subjNo                = input('subjNo: ','s');
runNo                 = input('run: ')';
DomEye                = input('DomEye:'); %1=R 2=L
keymode               = input('Mac1 Win2: ');
%CV                    = input('CV:'); % 0=none 1=valid 2=invalid
%ContrastR             = input('ContrastR:'); %Right hemi contrast
%ContrastL             = input('ContrastL:'); %Right hemi contrast
%fName_r       = [ 'AU_Calibration_UP' '_Sub' num2str(subjNo) '_Run' num2str(runNo) '.txt' ];
% --- Names ---
current_date=datestr(datetime('today'),'ddmmYY');
current_time=datestr(now, 'HHMM');
folder = {'/Users/pk/Desktop/Script/Mon/'};
fName_r=['FC_cfs_Sub' num2str(subjNo) '_' current_date '_' current_time '_(Cal_D).csv'];
% ***** OPEN SCREEN *****
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

% ***** Check image folder and read images *****

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

% ***** monitor *****

monitorFlipInterval =Screen('GetFlipInterval', wPtr);
refreshRate = round(1/monitorFlipInterval); % Monitor refreshrate

% ***** MISC *****
retX=rect(3);
retY=rect(4);

disX=200; % bigger closer
disY=150; % bigger higher

% ***** color *****
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
% ***** Time & Freq *****
TimeSound=1;
TimeMon=5;
Wrdtime=2;
TimeImg=5;
Timeext=0.5;
NonBext=0.5;
MondFreq      = 10; %Hz
MondN  = round(refreshRate/MondFreq); % frames/img
% ***** Location *****
%MonStiDis=RightboxXCenter-LeftboxXCenter;
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
% ***** Text *****
text10 =  'Press space to';
text11 =  'proceed';
text4 =  'Right';
text5 =  'Different';
text12=  'Thank you!';
textqn= 'Location?';
% ***** Keyboard *****
KbName('UnifyKeyNames')
quitkey =   'ESCAPE';
space   =   'space';
UpArrow  =   'UpArrow';
DownArrow  =   'DownArrow';
% ***** frame & oval *****
penWidthPixels = 3;
baseRect = [0 0 10 10];
maxDiameter = max(baseRect) * 8;
rectColor = [255 255 255];
% ***** Design *****
ntrials  = 20; %20 sentences 0 blanks
Catch    = 0; %Catch trial
ResultSet = zeros(ntrials,9);
imagepres= [01 02];
CondList = ones(ntrials,6);
CondList(1:ntrials/2,2) =2; % Target word congruency: 1= CON 2=InCON
CondList(1:ntrials/4,3) =2; % Noflip=1 Flip=2
CondList((ntrials+2)/2:3*ntrials/4,3) =2; % Noflip=1 Flip=2
CondList(1:2:ntrials,4)=2; % Stimulus location
CondList(1:2:ntrials/2,5)=2; % Cue valid/invalid
CondList((ntrials+4)/2:2:ntrials,5)=2; % Cue valid/invalid
CondList(2:2:ntrials,6)=2; % Useless?
CondList=CondList(randperm(size(CondList,1)),:); %randomize
CondList(:,1)=1:ntrials; % # No.

for i=1:ntrials-3 % no >3 reps
    if diff(CondList(i:i+1,2))==0 && diff(CondList(i+1:i+2,2))==0 && diff(CondList(i+2:i+3,2))==0
        if CondList(i,2)==1
            CondList(i+3,2)=2;
        else CondList(i+3,2)=1;
        end
    end
    
    if diff(CondList(i:i+1,4))==0 && diff(CondList(i+1:i+2,4))==0 && diff(CondList(i+2:i+3,4))==0
        if CondList(i,4)==1
            CondList(i+3,4)=2;
        else CondList(i+3,4)=1;
        end
    end
end
a=randperm(ntrials); %better randomization for catch trials?
% ***** Devices *****
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

%UD_down Threshold Staircase
UD_down =PAL_AMUD_setupUD_down('startvalue',0.9,'up',1,'down',3,'stepsizeup',0.01,'stepsizedown',0.01,'stopcriterion','trials','stopRule',40);
%can try down-0.36965/up-0.5

%%%EXPERIMENT BEGINS
KbQueueCreate(devInd) %loads experiment sequence
KbQueueStart(devInd);

% ***** first frame *****
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

%% ***** Experiment running *****
while ~UD_down.stop,
    for i=1:ntrials;
        try
            text3=Sentence_calibrate(a(i),CondList(i,2));
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
            ConIncrW=(255/((refreshRate*10)-1)*2); % contrast increase rate: 20% for the target word
            o=1;%for Mondrians
            MonSpeed=[];
            BreakTime=0;
            NonBreakTime=1000000000000000;
            breakmon=100000;
            Aud=0;
            Buffer=0.5;
            sprintf('trial [%d]',i);
            disp(num2str(i)) %current trial no
            centralize_word = ((cellfun('length',text3))/2);
            %centralize_word=((cellfun('length',text3))/2);
            if DomEye ==1,
                %f
            end
            while 1, %-37 & +25
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
                                vert_position=Top_textposition-(0.5*ypixel_height)-2;
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
                            centeredRect = CenterRectOnPointd(baseRect, MonLeftXCenter+1, YCenter-32);
                            if a(i)>20
                                Screen('FillOval', wPtr, rectColor, centeredRect, maxDiameter);
                            end
                            Screen('FrameRect', wPtr, [0 255 0], MonTop, penWidthPixels); %cue
                            breakmon=GetSecs-timezero;
                        elseif CondList(i,4)==2 %Bottom
                            centeredRect = CenterRectOnPointd(baseRect, MonRightXCenter+1, YCenter+32);
                            if a(i)>20
                                Screen('FillOval', wPtr, rectColor, centeredRect, maxDiameter);
                            end
                            Screen('FrameRect', wPtr, [0 255 0], MonBottom, penWidthPixels);
                            breakmon=GetSecs-timezero;
                        end
                    elseif CondList(i,5)==2 % cue invalid
                        if CondList(i,4)==1 %Top
                            Screen('FrameRect', wPtr, [0 255 0], MonBottom, penWidthPixels);
                            breakmon=GetSecs-timezero;
                        elseif CondList(i,4)==2 %Bottom
                            Screen('FrameRect', wPtr, [0 255 0], MonTop, penWidthPixels);
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
                    CreateFile_calibrate(fName_r, ResultSet)
                    Screen('CloseAll');
                    ShowCursor;
                    return;
                end

                if keydown==0
                    if (GetSecs-(timezero)>Wrdtime+SOA),
                        NonBreakTime=GetSecs;
                        ResultSet(i,8)= 0; %target word unbroken
                        ResultSet(i,9)= NonBreakTime-(timezero+Wrdtime+SOA);
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
                        ResultSet(i,7)=1; %Broken on Right
                        keydown=3;
                        disp('Right')
                        if CondList(i,4)==1 % stimulus right
                            disp('broken')
                            if (Suppressiontime<1.0)
                                response = 1;
                                UD_down = PAL_AMUD_updateUD_down(UD_down, response);
                            elseif (Suppressiontime>2.0)
                                response = 0;
                                UD_down = PAL_AMUD_updateUD_down(UD_down, response);
                            elseif (Suppressiontime>1.0 && Suppressiontime<2.0);
                                response = 1;
                                UD_down = PAL_AMUD_updateUD_down(UD_down, response);
                            end
                        else disp('false alarm')
                        end
                        if a(i)>20,
                            Catch=Catch+1; 
                        end    
                    elseif keyCode(KbName(DownArrow)) && (GetSecs-(timezero)<SOA+Wrdtime+1.5), % Answers Location question
                        BROKEN=1;
                        ResultSet(i,7)=2; %Broken on Left
                        keydown=3;
                        disp('Left')
                        if CondList(i,4)==2 % stimulus left
                            disp('broken')
                            if (Suppressiontime<1.0)
                                response = 1;
                                UD_down = PAL_AMUD_updateUD_down(UD_down, response);
                            elseif (Suppressiontime>2.0)
                                response = 0;
                                UD_down = PAL_AMUD_updateUD_down(UD_down, response);
                            elseif (Suppressiontime>1.0 && Suppressiontime<2.0);
                                response = 1;
                                UD_down = PAL_AMUD_updateUD_down(UD_down, response);
                            end
                        else disp('false alarm')
                        end 
                        if a(i)>20,
                            Catch=Catch+1;
                        end
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
                                    ResultSet(i,8)= 1; %target word broken
                                    ResultSet(i,9)= BreakTime-(timezero+SOA); %break time
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
                ResultSet(:,1)=CondList(:,1); %TNum
                ResultSet(i,2)=a(i);          %actual trial a(i)
                ResultSet(:,3)=CondList(:,2); %CON 1=CON 2=InCON
                ResultSet(:,4)=CondList(:,3); %Flip 1=Noflip 2=Flip
                ResultSet(:,5)=CondList(:,4); %Stimulus position 1=Right 2=Left
                ResultSet(:,6)=CondList(:,5); %Cue valid/invalid
            end
        catch err
            ShowCursor;
            Screen('CloseAll');
            rethrow(err);
        end
    end
end
%%
t = 1:length(UD_down.x);
figure('name','Up/Down Adaptive Procedure');
plot(t,UD_down.x,'k');
hold on;
plot(t(UD_down.response == 1),UD_down.x(UD_down.response == 1),'ko', 'MarkerFaceColor','k');
plot(t(UD_down.response == 0),UD_down.x(UD_down.response == 0),'ko', 'MarkerFaceColor','w');
set(gca,'FontSize',16);
axis([0 max(t)+1 min(UD_down.x)-(max(UD_down.x)-min(UD_down.x))/10 max(UD_down.x)+(max(UD_down.x)-min(UD_down.x))/10]);
%line([1 length(UD_down.x)], [targetX targetX],'linewidth', 2, 'linestyle', '--', 'color','k');
xlabel('Trial');
ylabel('Stimulus Intensity');

Mean = PAL_AMUD_analyzeUD_down(UD_down, 'reversals', 4);
disp(sprintf('\n-----------------------------------------------------\n[Contrast threshold across last 3 reversals]: %f\n', Mean))

%{
% ***** WRITE RESULTS *****
try
    CreateFile_calibrate(fName_r, ResultSet)
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

