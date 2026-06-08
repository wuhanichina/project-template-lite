function outputFiles = write_case_outputs(caseConfig, caseData, proposedResults, baselineResults, metrics)
%WRITE_CASE_OUTPUTS Write scaffold case summary and run manifest.

summaryFile = fullfile(caseConfig.resultDir, "summary.txt");
manifestFile = fullfile(caseConfig.resultDir, "run_manifest.json");

summary = struct();
summary.case = string(caseConfig.name);
summary.network = string(caseConfig.network);
summary.description = string(caseConfig.description);
summary.claim = string(caseConfig.claim);
summary.evidenceId = string(caseConfig.evidenceId);
summary.status = "scaffold";
summary.dataStatus = string(caseData.status);
summary.proposedStatus = string(proposedResults.status);
summary.baselineStatus = string(baselineResults.status);
summary.metricsStatus = string(metrics.status);
summary.figureDir = string(caseConfig.figureDir);
summary.message = "Package skeleton ran. Fill package functions with real computation before using this case as paper evidence.";

ProjectName_utils.io.write_summary(summaryFile, summary);

manifest = struct();
manifest.case = summary.case;
manifest.network = summary.network;
manifest.status = summary.status;
manifest.claim = summary.claim;
manifest.evidenceId = summary.evidenceId;
manifest.generatedAt = string(datetime("now", "Format", "yyyy-MM-dd HH:mm:ss"));
manifest.dataDir = string(caseConfig.dataDir);
manifest.inputFiles = caseData.inputFiles;
manifest.resultDir = string(caseConfig.resultDir);
manifest.figureDir = string(caseConfig.figureDir);
manifest.proposedStatus = string(proposedResults.status);
manifest.baselineStatus = string(baselineResults.status);
manifest.metricsStatus = string(metrics.status);
manifest.note = summary.message;

write_json(manifestFile, manifest);

outputFiles = struct();
outputFiles.summaryFile = string(summaryFile);
outputFiles.manifestFile = string(manifestFile);
outputFiles.status = "scaffold";
outputFiles.files = [string(summaryFile); string(manifestFile)];
outputFiles.warnings = strings(0, 1);
end

function write_json(filePath, value)
[parentDir, ~, ~] = fileparts(filePath);
ProjectName_utils.io.ensure_dir(parentDir);

fid = fopen(filePath, "w");
if fid < 0
    error("ProjectName_utils:io:OpenFailed", "Could not open JSON file: %s", filePath);
end

cleanupObj = onCleanup(@() fclose(fid));
fprintf(fid, "%s\n", jsonencode(value));
end
