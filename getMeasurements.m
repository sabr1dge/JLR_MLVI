function D = getMeasurements(filename)

%% Assign a file identifier to the file.

fileID = fopen(filename, 'r');

%% Define the target line and read lines sequentially from 
% the data file until the target line is found.

target = '          C O M P L E X    E I G E N V A L U E    O U T P U T';
targetLength = length(target);

current_line = fgetl(fileID);

while ~strncmp(target, current_line, targetLength) && ~feof(fileID)
    
    current_line = fgetl(fileID);
    
    if strncmp(target, current_line, targetLength)
        break % Stop when the target line is found.
    end
    
end

%% Next, read in two columns of data from this section, 
% ignoring the first three columns.

line_format = '%*u8 %*f %*f %f %f';
data = textscan(fileID, line_format, 'Headerlines', 5);


%% Close the file.

fclose(fileID);

%% Process the data and extract the information of interest:
% in this case, we only need the negative damping ratios and
% the corresponding frequencies.

frequency = data{1};
dampingRatio = data{2};

tf = dampingRatio < -5*eps;

frequency = frequency(tf);
dampingRatio = abs(dampingRatio(tf));

%% The pressure and friction measurements are stored as part of the filename,
% so these need to be extracted using string manipulation techniques.

% Retrieve the filename as a string.
[~, name] = fileparts(filename);

% Extract the pressure value (this appears between the capital "F" and the
% string "bar" in the filename).
I1 = regexp(name, 'F');
I2 = regexp(name, 'bar');
pressure = str2double(name((I1+1:I2-1)));

% Extract the friction value (this appears between the last instance of
% capital "M" and the last instance of "_" in the filename).
J1 = regexp(name, 'M');
J1 = J1(end);
J2 = regexp(name, '_');
J2 = J2(end);
friction = str2double(['0.', name((J1+1:J2-1))]);

%% Assemble the output matrix.

n = length(frequency);
D = [frequency, repmat([pressure friction], n, 1), dampingRatio];


end





