%
%PAL_AMUD_down_updateUD_down  Updates structure which contains settings for and 
%   results of up/down adaptive method.
%
%   syntax: UD_down = PAL_AMUD_down_updateUD_down(UD_down, response)
%
%   After having created a structure 'UD_down' using PAL_AMUD_down_setupUD_down, use 
%   something akin to the following loop to control stimulus intensity
%   during experimental run:
%
%   while ~UD_down.stop
%       
%       %Present trial here at stimulus magnitude in 'UD_down.xCurrent'
%       %and collect response (1: correct/greater than, 0: incorrect/
%       %smaller than)
%
%       UD_down = PAL_AMUD_down_updateUD_down(UD_down, response); %update UD_down structure based 
%                                             %on response                                    
%    
%   end
%
% Introduced: Palamedes version 1.0.0 (NP)
% Modified: Palamedes version 1.4.0, 1.4.5 (see History.m)

function UD_down = PAL_AMUD_updateUD_down(UD_down, response)

trial = length(UD_down.x);
UD_down.response(trial) = response;

if trial == 1
    UD_down.xStaircase(trial) = UD_down.x(trial);
    if response == 1
        UD_down.direction = -1;        
    else
        UD_down.direction = 1;
    end
end
    
if response == 1
    UD_down.d = UD_down.d + 1;
    if UD_down.d == UD_down.down || max(UD_down.reversal) < 1
        UD_down.xStaircase(trial+1) = UD_down.xStaircase(trial)-(-log10((UD_down.stepSizeDown*trial)+(0.5)));
        if UD_down.xStaircase(trial+1) < UD_down.xMin && strcmp(UD_down.truncate,'yes')
            UD_down.xStaircase(trial+1) = UD_down.xMin;
        end
        UD_down.u = 0;
        UD_down.d = 0;
        UD_down.reversal(trial) = 0;
        if UD_down.direction == 1
            UD_down.reversal(trial) = sum(UD_down.reversal~=0) + 1;
        else
            UD_down.reversal(trial) = 0;
        end
        UD_down.direction = -1;
    else
        UD_down.xStaircase(trial+1) = UD_down.xStaircase(trial);
    end    
else
    UD_down.u = UD_down.u + 1;
    if UD_down.u == UD_down.up || max(UD_down.reversal) < 1
        UD_down.xStaircase(trial+1) = UD_down.xStaircase(trial)+(-log10((UD_down.stepSizeDown*trial)+(0.5)));
        if UD_down.xStaircase(trial+1) > UD_down.xMax && strcmp(UD_down.truncate,'yes')
            UD_down.xStaircase(trial+1) = UD_down.xMax;
        end
        UD_down.u = 0;
        UD_down.d = 0;
        UD_down.reversal(trial) = 0;
        if UD_down.direction == -1
            UD_down.reversal(trial) = sum(UD_down.reversal~=0) + 1;
        else
            UD_down.reversal(trial) = 0;
        end
        UD_down.direction = 1;
    else
        UD_down.xStaircase(trial+1) = UD_down.xStaircase(trial);
    end    
end    

if strncmpi(UD_down.stopCriterion,'reversals',4) && sum(UD_down.reversal~=0) == UD_down.stopRule
    UD_down.stop = 1;
end
if strncmpi(UD_down.stopCriterion,'trials',4) && trial == UD_down.stopRule
    UD_down.stop = 1;
end
if ~UD_down.stop
    UD_down.x(trial+1) = UD_down.xStaircase(trial+1);
    if UD_down.x(trial+1) > UD_down.xMax
        UD_down.x(trial+1) = UD_down.xMax;
    elseif UD_down.x(trial+1) < UD_down.xMin
        UD_down.x(trial+1) = UD_down.xMin;
    end
    UD_down.xCurrent = UD_down.x(trial+1);
end