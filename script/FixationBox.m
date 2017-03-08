function [] = FixationBox(wPtr,LeftboxXCenter,RightboxXCenter,YCenter,boxsize,boxcolor)

% if nargin<6,
%     boxcolor=[255 255 255];
% end

fixationlength  =1;
border          =boxsize;
linewt          =2;
fixationcolor   =[255 0 0];

    Screen('FrameRect', wPtr, boxcolor, [LeftboxXCenter-border, YCenter-border, LeftboxXCenter+border, YCenter+border], linewt);
    Screen('FrameRect', wPtr, boxcolor, [RightboxXCenter-border, YCenter-border, RightboxXCenter+border, YCenter+border], linewt);

% *****Fixation point/cross*****
Screen('DrawLine', wPtr, fixationcolor, LeftboxXCenter-fixationlength, YCenter ,LeftboxXCenter+fixationlength, YCenter,  linewt);
Screen('DrawLine', wPtr, fixationcolor, LeftboxXCenter, YCenter-fixationlength ,LeftboxXCenter, YCenter+fixationlength,  linewt);
Screen('DrawLine', wPtr, fixationcolor, RightboxXCenter-fixationlength, YCenter ,RightboxXCenter+fixationlength,YCenter, linewt);
Screen('DrawLine', wPtr, fixationcolor, RightboxXCenter, YCenter-fixationlength ,RightboxXCenter, YCenter+fixationlength,linewt);

end
