% Objective
fun = @(x) 20 + x(1)^2 + x(2)^2 - 10*(cos(2*pi*x(1)) + cos(2*pi*x(2)))

% Bounds
lb = [5*pi;-20*pi];
ub = [20*pi;-4*pi];

% Integer Constraints
xtype = 'IC';

%Initial Guess
x0 = [16;0];   

% Options
opts = optiset('solver','nomad','display','iter')


% Create OPTI Object
Opt = opti('fun',fun,'bounds',lb,ub,'xtype',xtype,'options',opts)


% Solve the MINLP problem
[x,fval,exitflag,info] = solve(Opt,x0)   

function out = myfun(x)
out = 20 + x(1)^2 + x(2)^2 - 10*(cos(2*pi*x(1)) + cos(2*pi*x(2)));
end