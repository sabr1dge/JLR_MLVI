%% analysisScript

%% load data
load JLR

%% Identify NaNs
% For tables need to use ismissing function
missingIdx = ismissing(T);
% If T was numeric, then the function used is ...
% isnan
% How to convert a table to a numeric array and vice-versa
TT = table2array(T);
TTT = array2table(TT);

%% Counting missing values
% How would you calculate total number of missing values?
howMany = nnz(missingIdx);
disp('Number of missing values:')
disp(howMany)

%% How many bad columns are there?
badCols = any(missingIdx);
% Are they all bad???
checkBadCol = all(badCols);
disp('Are they all bad ...')
if checkBadCol
    disp('Yes')
else
    disp('no')
end

%% How many bad rows are there?
badRows = any(missingIdx,2);
% Are they all bad???
checkBadRow = all(badRows);
disp('Are they all bad ...')
if checkBadRow
    disp('Yes')
else
    disp('no')
end

%% Which row numbers are bad???
badRowIdx = find(badRows);
disp('Row locations ...')
disp(badRowIdx)

%% Determine that these missing values are in a block at the end of the file
howManyBadRows = nnz(badRows);
lowerT = T{badRowIdx, :}; % All the rows containing at least one missing value.
% Check
checkStatus = all(isnan(lowerT(:)))
checkStatus2 = isequaln(lowerT, NaN(size(lowerT)))

%% Remove the missing data
Tclean = T;
Tclean(badRowIdx,:) = [];

%% Working with Tclean
% For each mode, calculate the average and standard deviation of all the
% Tailpipe variables

% How would you approach such a task?

% Step 1: Identify all the tailpipe variables.
vars = Tclean.Properties.VariableNames;
target = 'Tailpipe';
nChars = numel(target);
chosenVarIdx = strncmp(vars, target, nChars);
tailpipeData = Tclean{:,chosenVarIdx};

% Step 2: Use a for-loop to go through each mode and compute the stats.
uniqueModes = unique(Tclean.Mode);
meanVals = zeros(length(uniqueModes), size(tailpipeData,2));
stdVals = meanVals;
for n = 1:length(uniqueModes)
    ObsIdx = Tclean.Mode==uniqueModes(n);
    meanVals(n,:) = mean(tailpipeData(ObsIdx,:));
    stdVals(n,:) = std(tailpipeData(ObsIdx,:));
end

% Step 3: Tidy up the results.
rowNames = cellstr([repmat('Mode ', length(uniqueModes), 1), num2str(uniqueModes)]);
meanValsT = array2table(meanVals, 'VariableNames', vars(chosenVarIdx), ...
    'RowNames', rowNames);
stdValsT = array2table(stdVals, 'VariableNames', vars(chosenVarIdx), ...
    'RowNames', rowNames);

%% Alternative approach using GRPSTATS - only available without conversion to a dataset in MATLAB R2014a.
TcleanDataset = table2dataset(Tclean);
requiredStats = grpstats(TcleanDataset, 'Mode', {@mean, @std, @(V) nnz(V > 0)}, 'DataVars', vars(chosenVarIdx));












