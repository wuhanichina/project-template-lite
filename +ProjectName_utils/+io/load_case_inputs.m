function caseData = load_case_inputs(caseConfig)
%LOAD_CASE_INPUTS Load and validate case input data from data/.

dataDir = string(caseConfig.dataDir);
if ~isfolder(dataDir)
    error("ProjectName_utils:io:MissingDataDir", "Data directory was not found: %s", dataDir);
end

inputFileRecords = list_data_files(dataDir);
if isempty(inputFileRecords)
    dataFiles = strings(0, 1);
else
    dataFiles = reshape([inputFileRecords.absolutePath], [], 1);
end
dataVersion = build_data_version(inputFileRecords);

caseData = struct();
caseData.caseName = string(caseConfig.name);
caseData.status = "scaffold";
caseData.dataDir = dataDir;
caseData.inputFiles = dataFiles;
caseData.inputFileRecords = inputFileRecords;
caseData.dataVersionFingerprint = dataVersion.fingerprint;
caseData.dataVersion = dataVersion;
caseData.files = struct("dataDir", dataDir);
caseData.warnings = strings(0, 1);

if isempty(dataFiles)
    caseData.warnings(end + 1, 1) = "No case-specific input files found beyond placeholders.";
end
end

function records = list_data_files(dataDir)
records = collect_data_files(dataDir, "");
if isempty(records)
    return
end

[~, order] = sort([records.relativePath]);
records = records(order);
records = records(:);
end

function records = collect_data_files(currentDir, relativeDir)
records = empty_file_records();
entries = dir(currentDir);
for k = 1:numel(entries)
    entry = entries(k);
    if strcmp(entry.name, ".") || strcmp(entry.name, "..")
        continue
    end

    if strlength(relativeDir) == 0
        relativePath = string(entry.name);
    else
        relativePath = relativeDir + "/" + string(entry.name);
    end

    fullPath = string(fullfile(entry.folder, entry.name));
    if entry.isdir
        childRecords = collect_data_files(fullPath, relativePath);
        records = [records; childRecords]; %#ok<AGROW>
        continue
    end

    if strcmpi(entry.name, "README.md")
        continue
    end

    modifiedAt = datetime(entry.datenum, ...
        "ConvertFrom", "datenum", ...
        "Format", "yyyy-MM-dd'T'HH:mm:ss.SSS");
    record = struct();
    record.relativePath = relativePath;
    record.absolutePath = fullPath;
    record.bytes = entry.bytes;
    record.mtime = string(modifiedAt);
    record.mtimeDatenum = entry.datenum;
    record.sha256 = sha256_file(fullPath);
    records(end + 1, 1) = record; %#ok<AGROW>
end
end

function records = empty_file_records()
records = repmat(struct( ...
    "relativePath", "", ...
    "absolutePath", "", ...
    "bytes", 0, ...
    "mtime", "", ...
    "mtimeDatenum", 0, ...
    "sha256", ""), 0, 1);
end

function dataVersion = build_data_version(records)
digest = create_sha256_digest();
byteCount = 0;
for k = 1:numel(records)
    record = records(k);
    byteCount = byteCount + record.bytes;
    canonicalRecord = sprintf("%s%c%.0f%c%s%c", ...
        char(record.relativePath), 0, record.bytes, 0, char(record.sha256), 10);
    update_digest(digest, unicode2native(canonicalRecord, "UTF-8"));
end

dataVersion = struct();
dataVersion.algorithm = "SHA-256";
dataVersion.fingerprint = finish_digest(digest);
dataVersion.fileCount = numel(records);
dataVersion.byteCount = byteCount;
dataVersion.basis = "Sorted relativePath, byte count, and per-file SHA-256; mtime is recorded but does not change the content fingerprint.";
end

function hashValue = sha256_file(filePath)
fid = fopen(filePath, "rb");
if fid < 0
    error("ProjectName_utils:io:InputOpenFailed", ...
        "Could not open input file for SHA-256 hashing: %s", filePath);
end
cleanupObj = onCleanup(@() close_if_open(fid));

digest = create_sha256_digest();
while true
    fileBytes = fread(fid, 1024 * 1024, "*uint8");
    if isempty(fileBytes)
        break
    end
    update_digest(digest, fileBytes);
end
hashValue = finish_digest(digest);
end

function digest = create_sha256_digest()
if ~usejava("jvm")
    error("ProjectName_utils:io:Sha256Unavailable", ...
        "SHA-256 input fingerprinting requires the MATLAB JVM in standard Windows or macOS sessions.");
end
digest = javaMethod("getInstance", "java.security.MessageDigest", "SHA-256");
end

function update_digest(digest, bytes)
bytes = uint8(bytes(:));
if isempty(bytes)
    return
end
digest.update(typecast(bytes, "int8"));
end

function hashValue = finish_digest(digest)
digestBytes = typecast(digest.digest(), "uint8");
hashValue = string(lower(reshape(dec2hex(digestBytes, 2).', 1, [])));
end

function close_if_open(fid)
if ~isempty(fopen(fid))
    fclose(fid);
end
end
