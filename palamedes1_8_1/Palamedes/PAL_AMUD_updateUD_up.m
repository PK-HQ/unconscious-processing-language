%
%PAL_AMUD_up_updateUD_up  Updates structure which contains settings for and 
%   results of up/down adaptive method.
%
%   syntax: UD_up = PAL_AMUD_up_updateUD_up(UD_up, response)
%
%   After having created a structure 'UD_up' using PAL_AMUD_up_setupUD_up, use 
%   something akin to the following loop to control stimulus intensity
%   during experimental run:
%
%   while ~UD_up.stop
%       
%       %Present trial here at stimulus magnitude in 'UD_up.xCurrent'
%       %and collect response (1: correct/greater than, 0: incorrect/
%       %smaller than)
%
%       UD_up = PAL_AMUD_up_updateUD_up(UD_up, response); %update UD_up structure based 
%                                             %on response                                    
%    
%   end
%
% Introduced: Palamedes version 1.0.0 (NP)
% Modified: Palamedes version 1.4.0, 1.4.5 (see History.m)

function UD_up = PAL_AMUD_updateUD_up(UD_up, response)

trial = length(UD_up.x);
UD_up.response(trial) = response;

if trial == 1
    UD_up.xStaircase(trial) = UD_up.x(trial);
    if response == 1
        UD_up.direction = -1;        
    else
        UD_up.direction = 1;
    end
end
    
if response == 1
    UD_up.d = UD_up.d + 1;
    if UD_up.d == UD_up.down || max(UD_up.reversal) < 1
        UD_up.xStaircase(trial+1) = UD_up.xStaircase(trial)-(-log10((UD_up.stepSizeDown*trial)+(0.5)));
        if UD_up.xStaircase(trial+1) < UD_up.xMin && strcmp(UD_up.truncate,'yes')
            UD_up.xStaircase(trial+1) = UD_up.xMin;
        end
        UD_up.u = 0;
        UD_up.d = 0;
        UD_up.reversal(trial) = 0;
        if UD_up.direction == 1
            UD_up.reversal(trial) = sum(UD_up.reversal~=0) + 1;
        else
            UD_up.reversal(trial) = 0;
        end
        UD_up.direction = -1;
    else
        UD_up.xStaircase(trial+1) = UD_up.xStaircase(trial);
    end    
else
    UD_up.u = UD_up.u + 1;
    if UD_up.u == UD_up.up || max(UD_up.reversal) < 1
        UD_up.xStaircase(trial+1) = UD_up.xStaircase(trial)+(-log10((UD_up.stepSizeDown*trial)+(0.5)));
        if UD_up.xStaircase(trial+1) > UD_up.xMax && strcmp(UD_up.truncate,'yes')
            UD_up.xStaircase(trial+1) = UD_up.xMax;
        end
        UD_up.u = 0;
        UD_up.d = 0;
        UD_up.reversal(trial) = 0;
        if UD_up.direction == -1
            UD_up.reversal(trial) = sum(UD_up.reversal~=0) + 1;
        else
            UD_up.reversal(trial) = 0;
        end
        UD_up.direction = 1;
    else
        UD_up.xStaircase(trial+1) = UD_up.xStaircase(trial);
    end    
end    

if strncmpi(UD_up.stopCriterion,'reversals',4) && sum(UD_up.reversal~=0) == UD_up.stopRule
    UD_up.stop = 1;
end
if strncmpi(UD_up.stopCriterion,'trials',4) && trial == UD_up.stopRule
    UD_up.stop = 1;
end
if ~UD_up.stop
    UD_up.x(trial+1) = UD_up.xStaircase(trial+1);
    if UD_up.x(trial+1) > UD_up.xMax
        UD_up.x(trial+1) = UD_up.xMax;
    elseif UD_up.x(trial+1) < UD_up.xMin
        UD_up.x(trial+1) = UD_up.xMin;
    end
    UD_up.xCurrent = UD_up.x(trial+1);
end