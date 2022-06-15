using JuMP, GLPK

# Preparing an optimization model
m = Model(GLPK.Optimizer)

# Declaring variables
@variable(m, 0<= x1 <=10)
@variable(m, x2 >=0)
@variable(m, x3 >=0)

# Setting the objective
@objective(m, Max, x1 + 2x2 + 5x3)

# Adding constraints
@constraint(m, constraint1, -x1 +  x2 + 3x3 <= -5)
@constraint(m, constraint2,  x1 + 3x2 - 7x3 <= 10)

# Printing the prepared optimization model
print(m)

# Solving the optimization problem
JuMP.optimize!(m)

# Printing the optimal solutions obtained
println("Optimal Solutions:")
println("x1 = ", JuMP.value(x1))
println("x2 = ", JuMP.value(x2))
println("x3 = ", JuMP.value(x3))

# Printing the optimal dual variables
println("Dual Variables:")
println("dual1 = ", JuMP.shadow_price(constraint1))
println("dual2 = ", JuMP.shadow_price(constraint2))


### Alternative way

m2 = Model(GLPK.Optimizer)

@variable(m2, x[1:3] >= 0)
c = [1; 2; 5]
@objective(m2, Max, sum( c[i]*x[i] for i in 1:3))

A = [-1  1  3;
      1  3 -7]
b = [-5; 10]

constraint = Dict()
#for j in 1:2
#  constraint[j] = @constraint(m2, sum(A[j,i]*x[i] for i in 1:3) <= b[j])
#end

@constraint(m2, constraint[j in 1:2], sum(A[j,i]*x[i] for i in 1:3) <= b[j])
@constraint(m2, bound, x[1] <= 10)