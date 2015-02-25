function [] = ivisDemo008_playingVideos()
% ivisDemo008_playingVideos. Displaying a video file on a PTB screen.
%
%   How to use IvVideo to play, pause and close videos. Note that we have
%   now shifted to using function, because otherwise matlab throws errors
%   with regards to calls to singleton getInstance() constructors. If you
%   are running a 64-bit version of matlab don't forget that you will need
%   to install GStreamer (and probably some additional packages)
%
%   If you are having problems then Psychtoolbox's MovieDemo.m might be a
%   good place to start
%
%   Note that it is vital that the broadcaster package is imported
%   (ivis.broadcaster.*), as this contains a wrapper for PTB's
%   Screen('Flip') which ensures that screen update events are broadcasted
%   throughout ivis.
%
% Requires:         ivis toolbox v1.3
%
% Matlab:           v2012 onwards
%
% See also:         ivisDemo007_classifyingFixations.m
%                   ivisDemo009_streamingWebcams.m
%
% Author(s):    	Pete R Jones <petejonze@gmail.com>
% 
% Version History:  1.0.0	PJ  22/06/2013    Initial build.
%                   1.1.0	PJ  18/10/2013    General tidy up (ivis 1.4).
%
%
% Copyright 2014 : P R Jones
% *********************************************************************
% 
    % clear memory and set workspace
    clearAbsAll();
    import ivis.main.* ivis.control.* ivis.video.*  ivis.broadcaster.*;

    % verify, initialise, and launch the ivis toolbox
    IvMain.assertVersion(1.4);
    IvMain.initialise(IvParams.getDefaultConfig('GUI.useGUI',false));
    [eyetracker, ~, InH, winhandle] = IvMain.launch();

    try % wrap in try..catch to ensure a graceful exit

        % Open video
        %IvVideo.getInstance().open(IvVideo.getInstance().defaultVidFns{2});
        fn = fullfile(ivisdir(),'ivisDemos','demoResources','composite.avi');
        IvVideo.getInstance().open(fn);
        
        % Start playing video
        IvVideo.getInstance().play(true);  % true for fullscreen

        % Keep looping until user exits
        fprintf('Space to pause.  Enter to end\n');
        while 1
            switch first(InH.getInput())
                case InH.INPT_SPACE.code
                    IvVideo.getInstance().togglePause(true); % CHANGE TO false TO STOP SHOWING VIDEO WHEN PAUSED
                case InH.INPT_RETURN.code
                    break % break the while loop
            end
            eyetracker.refresh(false); % false to supress logging

            Screen('Flip', winhandle); % n.b., requires that ivis.broadcaster.* has been imported
            WaitSecs(.01);
        end
        
        % not strictly necessary, but good practice to close the video
        % (otherwise ought to happen anyway during IvMain.finishUp)
        IvVideo.getInstance().close();
        
    catch ME
        IvMain.finishUp();
        rethrow(ME);
    end

    % that's it! close open windows and release memory
    IvMain.finishUp();

end