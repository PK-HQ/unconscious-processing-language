%
%PAL_AMUD_up_setupUD_up  Creates structure which contains settings for and 
%   results of up/down adaptive method.
%
%   syntax: UD_up = PAL_AMUD_up_setupUD_up({optional arguments})
%
%   UD_up = PAL_AMUD_up_setupUD_up creates and returns a structure containing
%   settings for the running fit adaptive method using default settings.
%
%   Default settings may be changed by providing pairwise arguments, where
%   the first entry of the pair is a string indicating the field to be
%   changed and the second entry provides the new value of the field.
%
%   Modifiable fields and settings (default values in curly brackets):
%   
%   'up'                  positive integer scalar {1}
%       Number of consecutive incorrect responses after which stimulus 
%       intensity should be increased.    
%
%   'down'                positive integer scalar {3}
%       Number of consecutive correct responses after which stimulus 
%       intensity should be decreased.
%
%   'stepSizeUp'          positive scalar {1}
%       Size of step up
%
%   'stepSizeDown'        positive scalar {1}
%       Size of step down
%
%   'stopCriterion'       {‘trials’} | ‘reversals’
%       When set to ‘trials’, staircase will terminate after the number of 
%       trials set in stopRule. When set to ‘reversals’, staircase will 
%       terminate after the number of reversals set in stopRule.
%
%   'stopRule'            positive integer scalar {50}
%       see 'stopCriterion'
%
%   'startValue'          scalar {0}
%       Stimulus intensity to be used on first trial.
%
%   'xMax'                scalar {[]}
%       Maximum stimulus intensity to be used in staircase. In case value 
%       is set to an empty array ([]) no maximum is applied.
%
%   'xMin'                scalar {[]}
%       Minimum stimulus intensity to be used in staircase. In case value 
%       is set to an empty array ([]) no minimum is applied.
%
%   'truncate'            {‘yes’} | ‘no’
%       When set to ‘yes’ up/down rule will be applied to stimulus 
%       intensities as limited by 'xMax' and 'xMin'. When set to ‘no’ 
%       up/down rule will be applied to stimulus intensities untruncated by 
%       'xMax' and 'xMin' (but stimulus intensities used in staircase 
%       ['UD_up.xCurrent'] will be truncated by 'xMax' and 'xMin'). See
%       Garcia-Perez, M.A. (1998). Vision Research, 38, 1861-1881.
%
%   Example: UD_up = PAL_AMUD_up_setupUD_up('stopCriterion','reversals', ...
%       'stopRule' ,12) creates a new structure using default settings for 
%       all fields except 'stopCriterion' and 'stopRule' ('UD_up.stop' will be 
%       set to 1 after 12 reversals).
%
%   In order to change settings in an existing structure, pass the existing
%   structure as the first argument. For example, given an existing
%   structure UD_up the call:
%       UD_up = PAL_AMUD_up_setupUD_up(UD_up, 'xMax',1.5)
%   changes field 'xMax' in the existing structure 'UD_up' to 1.5 without
%   affecting other settings in 'UD_up'.
%
%   UD_up's result storage fields:
%
%   'UD_up.xCurrent' contains stimulus magnitude to be used on current trial
%   'UD_up.x' stores stimulus intensities for all trials
%   'UD_up.response' stores responses for all trials
%   'UD_up.reversal' stores for each whether a reversal occurred. It contains 
%       a zero for trials on which no reversal occurred and the count of 
%       the reversal for trials on which a reversal did occur.
%   'UD_up.stop' is used as termination flag. While stop criterion has not 
%       been reached, 'UD_up.stop' will equal 0, when criterion is reached, 
%       'UD_up.stop' will be set to 1.
%
% Introduced: Palamedes version 1.0.0 (NP)
% Modified: Palamedes version 1.2.0, 1.4.5, 1.6.3 (see History.m)

function UD_up = PAL_AMUD_setupUD_up(varargin)

NumOpts = length(varargin);

if mod(NumOpts,2) == 0
    UD_up.up = 1;
    UD_up.down = 3;
    UD_up.stepSizeUp = .01;
    UD_up.stepSizeDown = .01;
    UD_up.stopCriterion = 'reversals';
    UD_up.stopRule = 32;
    UD_up.startValue = 0;
    UD_up.xMax = [Inf];
    UD_up.xMin = [-Inf];
    UD_up.truncate = 'yes';
    UD_up.response = [];
    UD_up.stop = 0;
    UD_up.u = 0;
    UD_up.d = 0;
    UD_up.direction = [];
    UD_up.reversal = 0;
    UD_up.xCurrent = UD_up.startValue;
    UD_up.x = UD_up.startValue;
    UD_up.xStaircase = [];
else
    UD_up = varargin{1};
end
    
if NumOpts > 1
    for n = 1:2:NumOpts-mod(NumOpts,2)
        n = n+mod(NumOpts,2);
        valid = 0;
        if strcmpi(varargin{n}, 'Up')
            UD_up.up = varargin{n+1};
            valid = 1;
        end
        if strcmpi(varargin{n}, 'Down')
            UD_up.down = varargin{n+1};
            valid = 1;
        end
        if strncmpi(varargin{n}, 'StepSizeUp',9)
            UD_up.stepSizeUp = varargin{n+1};
            valid = 1;
        end
        if strncmpi(varargin{n}, 'StepSizeDown',9)
            UD_up.stepSizeDown = varargin{n+1};
            valid = 1;
        end
        if strncmpi(varargin{n}, 'StopCriterion',5)
            UD_up.stopCriterion = varargin{n+1};
            valid = 1;
        end
        if strncmpi(varargin{n}, 'StopRule',5)
            UD_up.stopRule = varargin{n+1};
            valid = 1;
        end
        if strncmpi(varargin{n}, 'StartValue',6)
            UD_up.startValue = varargin{n+1};
            UD_up.x = UD_up.startValue;
            UD_up.xCurrent = UD_up.x;
            valid = 1;
        end
        if strcmpi(varargin{n}, 'xMax')
            UD_up.xMax = varargin{n+1};
            valid = 1;
        end
        if strcmpi(varargin{n}, 'xMin')
            UD_up.xMin = varargin{n+1};
            valid = 1;
        end
        if strncmpi(varargin{n}, 'Truncate',4)
            UD_up.truncate = varargin{n+1};
            valid = 1;
        end
        if valid == 0
            warning('PALAMEDES:invalidOption','%s is not a valid option. Ignored.',varargin{n})        
        end        
    end            
end