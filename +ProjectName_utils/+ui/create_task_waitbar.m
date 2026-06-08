function progress = create_task_waitbar(taskName, totalUnits, options)
%CREATE_TASK_WAITBAR Track progress for a long-running local task.

arguments
    taskName (1,1) string
    totalUnits (1,1) double {mustBeInteger, mustBePositive}
    options.Enabled (1,1) logical = usejava("desktop")
end

enabled = options.Enabled && usejava("desktop");
waitbarHandle = [];
lastPrintedUnit = -1;
isClosed = false;

if enabled
    try
        waitbarHandle = waitbar(0, taskName, "Name", taskName);
    catch
        enabled = false;
    end
end

progress = struct();
progress.update = @update;
progress.close = @close_progress;
progress.enabled = enabled;
progress.totalUnits = totalUnits;
progress.taskName = taskName;

    function update(unitIndex, message)
        if nargin < 2
            message = "";
        end
        validateattributes(unitIndex, {'numeric'}, ...
            {'scalar', 'integer', 'nonnegative'}, mfilename, 'unitIndex');
        message = string(message);
        if ~isscalar(message)
            error("ProjectName_utils:ui:InvalidMessage", ...
                "message must be a scalar string.");
        end

        unitIndex = min(unitIndex, totalUnits);
        fraction = unitIndex / totalUnits;
        statusText = sprintf("%s %d/%d", taskName, unitIndex, totalUnits);
        if strlength(message) > 0
            statusText = sprintf("%s | %s", statusText, message);
        end

        if enabled && ~isempty(waitbarHandle) && ishandle(waitbarHandle)
            waitbar(fraction, waitbarHandle, statusText);
        elseif unitIndex ~= lastPrintedUnit
            fprintf("%s\n", statusText);
            lastPrintedUnit = unitIndex;
        end
    end

    function close_progress()
        if isClosed
            return
        end
        if enabled && ~isempty(waitbarHandle) && ishandle(waitbarHandle)
            close(waitbarHandle);
        end
        isClosed = true;
    end
end
