function matlab_example

%
% You will require both python and numpy to be installed to use this code.
% Place perc.py in the same directory as your MATLAB code.
%


% Tells MATLAB to search for python files in the current directory:
addpythonimport('');

% If you get an error message about 'py' or 'py.perc' being undefined, try uncommenting
% the following line of code. If MATLAB fails to load the 'perc.py' code, the following
% line of code will print an error message describing the problem. In particular, your
% problem might be that numpy is not being loaded properly.
%
% py.importlib.import_module('perc')


% If numpy is not loading, you may need to tell MATLAB which directory numpy is in.
% Try searching for a folder called "numpy" on your computer that contains files
% like "matlib.py" and "ctypeslib.py".
% Or, execute the following command on the command line to see what directory numpy
% is in:
%       python -c 'import numpy; print(numpy.__path__)'
% Once you have found a folder named "numpy", you should add a python import for
% the folder that contains the folder named "numpy".
% Some examples (the first is on a Linux machine, the second is on a Mac):
%
% addpythonimport('/usr/lib64/python3.5/site-packages/');
% addpythonimport('/System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python/');

% Your computer may have multiple versions of python installed. If you continue to
% have problems with numpy, it is possible that MATLAB is running a different version
% of python than the one that numpy is installed for. If so, use the following MATLAB
% command to tell you what version of python MATLAB is running:
%
% pyversion
%
% You can also use the 'pyversion' command to change which version of python that
% MATLAB is running. See https://www.mathworks.com/help/matlab/ref/pyversion.html
% for more information. In particular note that you must restart MATLAB before
% changing the python version, and that changes to version persist across future restarts.



% Okay, examples time!

% Example: biggest_clusters

[L p clustersizes] = biggest_clusters(2, 100, 0.5, 10);

disp('Biggest clusters example 1:');
disp(clustersizes);

[L p clustersizes] = biggest_clusters(2, [30 40 50 100], 0.5, 10);

disp('Biggest clusters example 2:');
disp(L);
disp(p);
disp(clustersizes);

[L p clustersizes] = biggest_clusters(2, 100, [0.3 0.4 0.5 0.6 0.7], 10);

disp('Biggest clusters example 3:');
disp(L);
disp(p);
disp(clustersizes);

% Example: percolation2d

grid = percolation2d('ones', 50, 0.5);

figure(1);
clf;
imagesc(grid);

end

% See documentation in perc.py for more details.

% d: dimension (integer)
% Ls: grid size(s) (integer or list of integers)
% ps: probability(s) (float or list of floats)
% numclusters: how many answers to give (integer, use 10 if you don't care)
%
% you can't give more than one value of L *and* more than one value of p
% in a single call
function [L p clustersizes] = biggest_clusters(d, Ls, ps, numclusters)
    py_result = py.perc.biggest_clusters(int32(d), int32(Ls), ps, int32(numclusters));

    n = py.len(py_result);

    L = zeros(1,n);
    p = zeros(1,n);
    clustersizes = zeros(n,numclusters);

    for i = 1:n
        row = py_result{i};
        L(1, i) = int32(row{1});
        p(1, i) = double(row{2});
        x = double(py.array.array('d', py.numpy.nditer(py.numpy.array(row{3}), pyargs('order', 'F'))));
        clustersizes(i, :) = x(:);
    end
end

% keyword: one of "ones", "masses", "biggest", or "whichcluster"
% L: grid size (integer)
% p: probability (float)
function [result] = percolation2d(keyword, L, p)
    py_result = py.perc.percolation2d(keyword, int32(L), p);
    flat_result = double(py.array.array('d', py.numpy.nditer(py_result, pyargs('order', 'F'))));
    result_shape = cell2mat(cell(py_result.shape));
    result = reshape(flat_result, result_shape);
end

function [] = addpythonimport(mypath)
    if count(py.sys.path, mypath) == 0
        insert(py.sys.path, int32(0), mypath);
    end
end
