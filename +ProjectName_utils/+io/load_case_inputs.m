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
    digest = update_digest(digest, unicode2native(canonicalRecord, "UTF-8"));
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
    digest = update_digest(digest, fileBytes);
end
hashValue = finish_digest(digest);
end

function digest = create_sha256_digest()
if usejava("jvm")
    digest = javaMethod("getInstance", ...
        "java.security.MessageDigest", "SHA-256");
else
    digest = struct();
    digest.state = uint32([ ...
        hex2dec("6a09e667"), hex2dec("bb67ae85"), ...
        hex2dec("3c6ef372"), hex2dec("a54ff53a"), ...
        hex2dec("510e527f"), hex2dec("9b05688c"), ...
        hex2dec("1f83d9ab"), hex2dec("5be0cd19")]);
    digest.buffer = zeros(0, 1, "uint8");
    digest.byteCount = uint64(0);
end
end

function digest = update_digest(digest, bytes)
bytes = uint8(bytes(:));
if isempty(bytes)
    return
end
if isstruct(digest)
    digest.byteCount = digest.byteCount + uint64(numel(bytes));
    pending = [digest.buffer; bytes];
    completeLength = floor(numel(pending) / 64) * 64;
    for firstByte = 1:64:completeLength
        digest.state = sha256_compress( ...
            digest.state, pending(firstByte:firstByte + 63));
    end
    digest.buffer = pending(completeLength + 1:end);
else
    digest.update(typecast(bytes, "int8"));
end
end

function hashValue = finish_digest(digest)
if isstruct(digest)
    bitCount = digest.byteCount * uint64(8);
    zeroCount = mod(56 - mod(double(digest.byteCount) + 1, 64), 64);
    padding = [uint8(128); zeros(zeroCount, 1, "uint8"); ...
        uint64_to_big_endian_bytes(bitCount)];
    pending = [digest.buffer; padding];
    for firstByte = 1:64:numel(pending)
        digest.state = sha256_compress( ...
            digest.state, pending(firstByte:firstByte + 63));
    end
    hashValue = string(lower(reshape(dec2hex(digest.state, 8).', 1, [])));
else
    digestBytes = typecast(digest.digest(), "uint8");
    hashValue = string(lower(reshape(dec2hex(digestBytes, 2).', 1, [])));
end
end

function bytes = uint64_to_big_endian_bytes(value)
bytes = zeros(8, 1, "uint8");
for k = 1:8
    shift = 8 * (8 - k);
    bytes(k) = uint8(bitand(bitshift(value, -shift), uint64(255)));
end
end

function state = sha256_compress(state, block)
persistent roundConstants
if isempty(roundConstants)
    roundConstants = uint32([ ...
        hex2dec("428a2f98"), hex2dec("71374491"), hex2dec("b5c0fbcf"), hex2dec("e9b5dba5"), ...
        hex2dec("3956c25b"), hex2dec("59f111f1"), hex2dec("923f82a4"), hex2dec("ab1c5ed5"), ...
        hex2dec("d807aa98"), hex2dec("12835b01"), hex2dec("243185be"), hex2dec("550c7dc3"), ...
        hex2dec("72be5d74"), hex2dec("80deb1fe"), hex2dec("9bdc06a7"), hex2dec("c19bf174"), ...
        hex2dec("e49b69c1"), hex2dec("efbe4786"), hex2dec("0fc19dc6"), hex2dec("240ca1cc"), ...
        hex2dec("2de92c6f"), hex2dec("4a7484aa"), hex2dec("5cb0a9dc"), hex2dec("76f988da"), ...
        hex2dec("983e5152"), hex2dec("a831c66d"), hex2dec("b00327c8"), hex2dec("bf597fc7"), ...
        hex2dec("c6e00bf3"), hex2dec("d5a79147"), hex2dec("06ca6351"), hex2dec("14292967"), ...
        hex2dec("27b70a85"), hex2dec("2e1b2138"), hex2dec("4d2c6dfc"), hex2dec("53380d13"), ...
        hex2dec("650a7354"), hex2dec("766a0abb"), hex2dec("81c2c92e"), hex2dec("92722c85"), ...
        hex2dec("a2bfe8a1"), hex2dec("a81a664b"), hex2dec("c24b8b70"), hex2dec("c76c51a3"), ...
        hex2dec("d192e819"), hex2dec("d6990624"), hex2dec("f40e3585"), hex2dec("106aa070"), ...
        hex2dec("19a4c116"), hex2dec("1e376c08"), hex2dec("2748774c"), hex2dec("34b0bcb5"), ...
        hex2dec("391c0cb3"), hex2dec("4ed8aa4a"), hex2dec("5b9cca4f"), hex2dec("682e6ff3"), ...
        hex2dec("748f82ee"), hex2dec("78a5636f"), hex2dec("84c87814"), hex2dec("8cc70208"), ...
        hex2dec("90befffa"), hex2dec("a4506ceb"), hex2dec("bef9a3f7"), hex2dec("c67178f2")]);
end

schedule = zeros(1, 64, "uint32");
block = uint8(block(:));
for k = 1:16
    firstByte = 4 * (k - 1) + 1;
    schedule(k) = bitor( ...
        bitor(bitshift(uint32(block(firstByte)), 24), ...
        bitshift(uint32(block(firstByte + 1)), 16)), ...
        bitor(bitshift(uint32(block(firstByte + 2)), 8), ...
        uint32(block(firstByte + 3))));
end
for k = 17:64
    s0 = bitxor(bitxor(rotate_right(schedule(k - 15), 7), ...
        rotate_right(schedule(k - 15), 18)), bitshift(schedule(k - 15), -3));
    s1 = bitxor(bitxor(rotate_right(schedule(k - 2), 17), ...
        rotate_right(schedule(k - 2), 19)), bitshift(schedule(k - 2), -10));
    schedule(k) = add_uint32( ...
        schedule(k - 16), s0, schedule(k - 7), s1);
end

working = state;
for k = 1:64
    upperSigma1 = bitxor(bitxor(rotate_right(working(5), 6), ...
        rotate_right(working(5), 11)), rotate_right(working(5), 25));
    choose = bitxor(bitand(working(5), working(6)), ...
        bitand(bitcmp(working(5)), working(7)));
    temporary1 = add_uint32(working(8), upperSigma1, choose, ...
        roundConstants(k), schedule(k));
    upperSigma0 = bitxor(bitxor(rotate_right(working(1), 2), ...
        rotate_right(working(1), 13)), rotate_right(working(1), 22));
    majority = bitxor(bitxor(bitand(working(1), working(2)), ...
        bitand(working(1), working(3))), bitand(working(2), working(3)));
    temporary2 = add_uint32(upperSigma0, majority);
    working = [ ...
        add_uint32(temporary1, temporary2), working(1), working(2), working(3), ...
        add_uint32(working(4), temporary1), working(5), working(6), working(7)];
end
for k = 1:8
    state(k) = add_uint32(state(k), working(k));
end
end

function rotated = rotate_right(value, count)
rotated = bitor(bitshift(value, -count), bitshift(value, 32 - count));
end

function value = add_uint32(varargin)
sumValue = uint64(0);
for k = 1:nargin
    sumValue = sumValue + uint64(varargin{k});
end
value = uint32(bitand(sumValue, uint64(4294967295)));
end

function close_if_open(fid)
if ~isempty(fopen(fid))
    fclose(fid);
end
end
