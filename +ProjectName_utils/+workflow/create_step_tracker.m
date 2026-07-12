function tracker = create_step_tracker(totalSteps, caseName, options)
%CREATE_STEP_TRACKER Track a case workflow in the MATLAB terminal.

arguments
    totalSteps (1,1) double {mustBeInteger, mustBePositive}
    caseName (1,1) string
    options.UseInline (1,1) logical = usejava("desktop")
end

startTime = tic;
stepStartTime = tic;
currentStep = 0;
currentStepName = "";
lastLineLength = 0;
isClosed = false;
useInline = options.UseInline && usejava("desktop");
refreshTimer = [];

tracker = struct();
tracker.update = @update;
tracker.close = @close_tracker;
tracker.complete = @complete_tracker;
tracker.fail = @fail_tracker;
tracker.caseName = caseName;
tracker.totalSteps = totalSteps;
tracker.useInline = useInline;

if useInline
    try
        refreshTimer = timer( ...
            "ExecutionMode", "fixedSpacing", ...
            "Period", 1, ...
            "TimerFcn", @(~, ~) refresh_current_step());
        start(refreshTimer);
    catch
        useInline = false;
        refreshTimer = [];
    end
end

    function update(stepIndex, stepName)
        validateattributes(stepIndex, {'numeric'}, ...
            {'scalar', 'integer', 'positive'}, mfilename, 'stepIndex');
        stepName = string(stepName);
        if ~isscalar(stepName)
            error("ProjectName_utils:workflow:InvalidStepName", ...
                "stepName must be a scalar string.");
        end

        if stepIndex > totalSteps
            error("ProjectName_utils:workflow:StepOutOfRange", ...
                "Step index %d exceeds total step count %d.", stepIndex, totalSteps);
        end

        if currentStep > 0
            print_line(sprintf("Finished step %02d/%02d in %s", ...
                currentStep, totalSteps, format_elapsed(toc(stepStartTime))), true);
        end

        currentStep = stepIndex;
        currentStepName = stepName;
        stepStartTime = tic;
        refresh_current_step();
    end

    function complete_tracker()
        close_tracker("completed", "");
    end

    function fail_tracker(errorValue)
        if isa(errorValue, "MException")
            errorText = string(errorValue.identifier) + ": " + string(errorValue.message);
        else
            errorText = string(errorValue);
        end
        close_tracker("failed", errorText);
    end

    function close_tracker(outcome, detail)
        if isClosed
            return
        end

        if nargin < 1 || strlength(string(outcome)) == 0
            outcome = "closed";
        end
        if nargin < 2
            detail = "";
        end
        outcome = lower(string(outcome));
        detail = string(detail);

        stop_refresh_timer();
        elapsedText = format_elapsed(toc(startTime));
        if outcome == "completed" || outcome == "succeeded"
            lineText = sprintf("[%s] Workflow finished in %s", caseName, elapsedText);
        elseif outcome == "failed"
            lineText = sprintf("[%s] Workflow failed at step %02d/%02d (%s) after %s", ...
                caseName, currentStep, totalSteps, currentStepName, elapsedText);
        else
            lineText = sprintf("[%s] Workflow closed with outcome '%s' at step %02d/%02d after %s", ...
                caseName, outcome, currentStep, totalSteps, elapsedText);
        end
        if strlength(detail) > 0
            lineText = sprintf("%s | %s", lineText, detail);
        end
        print_line(lineText, true);
        isClosed = true;
    end

    function refresh_current_step()
        if isClosed || currentStep == 0
            return
        end

        lineText = sprintf("[%s] Step %02d/%02d: %s | elapsed %s | step %s", ...
            caseName, currentStep, totalSteps, currentStepName, ...
            format_elapsed(toc(startTime)), format_elapsed(toc(stepStartTime)));
        print_line(lineText, false);
    end

    function stop_refresh_timer()
        if isempty(refreshTimer) || ~isvalid(refreshTimer)
            return
        end

        stop(refreshTimer);
        delete(refreshTimer);
        refreshTimer = [];
    end

    function print_line(lineText, finishLine)
        lineText = char(lineText);
        if useInline
            if lastLineLength > 0
                fprintf("%s", repmat('\b', 1, lastLineLength));
            end
            paddedText = lineText;
            if numel(paddedText) < lastLineLength
                paddedText = [paddedText blanks(lastLineLength - numel(paddedText))];
            end
            fprintf("%s", paddedText);
            lastLineLength = numel(paddedText);
            if finishLine
                fprintf("\n");
                lastLineLength = 0;
            end
        else
            fprintf("%s\n", lineText);
        end
    end
end

function text = format_elapsed(secondsValue)
secondsValue = max(0, secondsValue);
hoursValue = floor(secondsValue / 3600);
minutesValue = floor(mod(secondsValue, 3600) / 60);
secondsOnly = floor(mod(secondsValue, 60));
text = sprintf("%02d:%02d:%02d", hoursValue, minutesValue, secondsOnly);
end
