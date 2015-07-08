function submitString = getSubmitString(jobName, quotedLogFile, quotedCommand, additionalSubmitArgs)
%GETSUBMITSTRING Gets the correct sbatch command for a SLURM cluster

% Copyright 2010-2015 The MathWorks, Inc.

submitString = sprintf('sbatch --job-name=%s --output=%s %s %s', ...
    jobName, quotedLogFile, additionalSubmitArgs, quotedCommand);
