#####################################
# mod file Johan Cho 2023-11-05
#####################################
set CARS; #i
set FACTORIES; #j

# PARAMETERS
param selling_price {i in CARS, j in FACTORIES} >= 0;
param variable_cost {i in CARS, j in FACTORIES} >= 0;
param fixed_cost {i in CARS, j in FACTORIES} >= 0;
param price {i in CARS, j in FACTORIES} >= 0;
param quality {i in CARS, j in FACTORIES} >= 0;
param safety {i in CARS, j in FACTORIES} >= 0;
param luxury {i in CARS, j in FACTORIES} >= 0;
param assembly_time {i in CARS, j in FACTORIES} >= 0;
param raw_material {i in CARS, j in FACTORIES} >= 0;
param size_desc {i in CARS} symbolic;
param assembly_line_mapper {i in CARS, j in FACTORIES} symbolic;
# param assembly_line_mapper_reversed {i in CARS, j in FACTORIES} symbolic;

#CONSTRAINT PARAMETERS

param type_constr {j in FACTORIES} >= 0;
param assembly_constr {j in FACTORIES} >= 0;
param material_constr {j in FACTORIES} >= 0;
param car_min_constr {i in CARS, j in FACTORIES} >= 0;
param safety_total_min_constr {j in FACTORIES} >= 0;

param M{i in CARS, j in FACTORIES} := 
    min(
        assembly_constr[j] / assembly_time[i,j], 
        material_constr[j] / raw_material[i,j]
    );

#VARIABLES
var X {i in CARS, j in FACTORIES}  >= 0;
var Y {i in CARS, j in FACTORIES} binary >= 0;

#OBJECTIVE FUNCTION
maximize CPV: 
    sum {i in CARS, j in FACTORIES} (
        (selling_price[i,j] - variable_cost[i,j]) * X[i,j]  - (fixed_cost[i,j] * Y[i,j])
    ) * (price[i,j] * safety[i,j] + quality[i,j] * luxury[i,j]);


# raw material constraint
subject to raw_material_constraint {j in FACTORIES}:
    sum {i in CARS} raw_material[i,j] * X[i,j] <= material_constr[j];

#assembly time constraint
subject to assembly_time_constraint {j in FACTORIES}:
    sum {i in CARS} assembly_time[i,j] * X[i,j] <= assembly_constr[j];

# EQUALITY CONSTRAINTS: force binary variables to be the same, workaround for sharing assembly lines
subject to assembly_line_equality{i in CARS, j in FACTORIES: assembly_line_mapper[i,j] != ""}:
    Y[i,j] = Y[assembly_line_mapper[i,j], j];

# ASSEMBLY LINE CONSTRAINTS

# this is X <= M * Y
subject to assembly_lines_1{i in CARS, j in FACTORIES}:
    X[i,j] <= M[i,j] * Y[i,j];

# this is MIN - X <= M * (1 - Y)
subject to assembly_lines_2{i in CARS, j in FACTORIES}:
    car_min_constr[i,j] - X[i,j] <= M[i,j] * (1 - Y[i,j]);


# subject to test{i in CARS, j in FACTORIES}:
#     Y[i,j] <= X[i, j];

# # # this is X <= M * Y
# subject to test_con_1{i in CARS, j in FACTORIES: assembly_line_mapper[i,j] != ""}:
#     X[i,j] + X[assembly_line_mapper[i,j],j]  <= min(M[i,j], M[assembly_line_mapper[i,j],j]) * Y[i,j];

# # this is MIN - X <= M * (1 - Y)
# subject to test_con_2{i in CARS, j in FACTORIES: assembly_line_mapper[i,j] != ""}:
#     car_min_constr[i,j] + car_min_constr[assembly_line_mapper[i,j],j] - X[i,j] - X[assembly_line_mapper[i,j],j] <= min(M[i,j], M[assembly_line_mapper[i,j],j]) * (1 - Y[i,j]);

# subject to test_con_3{i in CARS, j in FACTORIES: assembly_line_mapper_reversed[i,j] != ""}:
#     car_min_constr[i,j] + car_min_constr[assembly_line_mapper_reversed[i,j],j] - X[i,j] - X[assembly_line_mapper_reversed[i,j],j] <= min(M[i,j], M[assembly_line_mapper_reversed[i,j],j]) * (1 - Y[i,j]);

# must produce at least x amount of cars for each factory
subject to type_constraint {j in FACTORIES}:
    sum {i in CARS} Y[i,j] >= type_constr[j];

# total safety ranking of cars produced must be at least x for each factory
subject to safety_constraint {j in FACTORIES}: 
    sum {i in CARS} safety[i,j] * Y[i,j] >= safety_total_min_constr[j];

# UNORISTAN: at least one car produced must be midsize
subject to uno_at_least_one_compact:
    sum {i in CARS: size_desc[i] in {"compact size/midsize", "compact size"}} 
        Y[i,"Unoristan"] >= 1;

# DOSOVO: at least one car produced must be midsize
subject to dos_at_least_one_midsize:
    sum {i in CARS: size_desc[i] in {"compact size/midsize", "midsize"}}
        Y[i,"Dosovo"] >= 1;

# UNORISTAN: if you produce a compact car, you must produce a midsize car
subject to uno_if_midsizefamily_then_midsize:
    sum {i in CARS: size_desc[i] == "midsize/family size" } Y[i,"Unoristan"] 
    <= sum {i in CARS: size_desc[i] == "midsize"} Y[i,"Unoristan"];

# DOSOVO: if you produce a midsize car, you must produce a compact car
subject to dos_if_midsize_then_compact:
    sum {i in CARS: size_desc[i] == "midsize" and assembly_line_mapper[i,"Dosovo"] == ""} Y[i,"Dosovo"] 
    <= sum {i in CARS: size_desc[i] in {"compact size/midsize", "compact size"} and assembly_line_mapper[i,"Dosovo"] == ""} Y[i,"Dosovo"];
