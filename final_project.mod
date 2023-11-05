#mod file Johan Cho 2023-10-25
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

#CONSTRAINT PARAMETERS

param type_constr {j in FACTORIES} >= 0;
param assembly_constr {j in FACTORIES} >= 0;
param material_constr {j in FACTORIES} >= 0;
param car_min_constr {i in CARS, j in FACTORIES} >= 0;
param safety_total_min_constr {j in FACTORIES} >= 0;

#VARIABLES
var X {i in CARS, j in FACTORIES} integer >= 0;
var Y {i in CARS, j in FACTORIES} binary;

#OBJECTIVE FUNCTION
maximize CPV: 
    sum {i in CARS, j in FACTORIES} (
            (selling_price[i,j] - variable_cost[i,j]) * X[i,j]  - (fixed_cost[i,j] * Y[i,j])
        ) * (price[i,j] * safety[i,j] + quality[i,j] * luxury[i,j]);

#BINARY CONSTRAINTS
# this is the same as saying that if X[i,j] is 0, then Y[i,j] must be 0
subject to binary_constraint_first {i in CARS, j in FACTORIES}:
    Y[i, j] <= X[i, j];

# this makes it so that if the number of cars is less than the minimum, then the number of cars and Y[i,j] must be 0
subject to binary_constraint_second {i in CARS, j in FACTORIES}:
    X[i, j] >= car_min_constr[i, j] * Y[i, j];


#CONSTRAINTS

# raw material constraint
subject to raw_material_constraint {j in FACTORIES}:
    sum {i in CARS} raw_material[i,j] * X[i,j] <= material_constr[j];

#assembly time constraint
subject to assembly_time_constraint {j in FACTORIES}:
    sum {i in CARS} assembly_time[i,j] * X[i,j] <= assembly_constr[j];


# UNORISTAN: Midsize/family size and family size cars share the same assembly line. 
subject to uno_assembly_line_1:
    sum {i in CARS: size_desc[i] in {"midsize/family size", "midsize"}} X[i,"Unoristan"] 
    <= sum {i in CARS: size_desc[i] in {"midsize/family size", "midsize"}} min(
        assembly_constr["Unoristan"] / assembly_time[i,"Unoristan"], 
        material_constr["Unoristan"] / raw_material[i,"Unoristan"]
    ) * Y[i, "Unoristan"];

# UNORISTAN: All of the rest car sizes are manufactured on their own assembly line.
subject to uno_assembly_line_2 :
    sum {i in CARS: size_desc[i] not in {"midsize/family size", "midsize"}} X[i,"Unoristan"] 
    <= sum {i in CARS: size_desc[i] not in {"midsize/family size", "midsize"}} 
        min(
            assembly_constr["Unoristan"] / assembly_time[i,"Unoristan"], 
            material_constr["Unoristan"] / raw_material[i,"Unoristan"]
        ) * Y[i, "Unoristan"];

# DOSOVO: Tointers and Ferbys share the same assembly line
subject to dos_assembly_line_1:
    sum {i in CARS: i in {"Tointer", "Ferby"}} X[i,"Dosovo"] 
    <= sum {i in CARS: i in {"Tointer", "Ferby"}} 
        min(
            assembly_constr["Dosovo"] / assembly_time[i,"Dosovo"], 
            material_constr["Dosovo"] / raw_material[i,"Dosovo"]
        ) * Y[i, "Dosovo"];

# DOSOVO: Pupos and Molos the same assembly line
subject to dos_assembly_line_2:
    sum {i in CARS: i in {"Pupo", "Molo"}} X[i,"Dosovo"]
    <= sum {i in CARS: i in {"Pupo", "Molo"}} 
        min(
            assembly_constr["Dosovo"] / assembly_time[i,"Dosovo"], 
            material_constr["Dosovo"] / raw_material[i,"Dosovo"]
        ) * Y[i, "Dosovo"];

# DOSOVO: All of the rest car types are manufactured on their own assembly line.
subject to dos_assembly_line_3:
    sum {i in CARS: i not in {"Tointer", "Ferby", "Pupo", "Molo"}} X[i,"Dosovo"] 
    <= sum {i in CARS: i not in {"Tointer", "Ferby", "Pupo", "Molo"}} 
        min(
            assembly_constr["Dosovo"] / assembly_time[i, "Dosovo"], 
            material_constr["Dosovo"] / raw_material[i, "Dosovo"]
        ) * Y[i, "Dosovo"];

# must produce at least x amount of cars for each factory
subject to type_constraint {j in FACTORIES}:
    sum {i in CARS} Y[i,j] >= type_constr[j];

# total safety ranking of cars produced must be at least x for each factory
subject to safety_constraint {j in FACTORIES}: 
    sum {i in CARS} (safety[i,j] * Y[i,j]) >= safety_total_min_constr[j];

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
    sum {i in CARS: size_desc[i] == "midsize/family size"} Y[i,"Unoristan"] 
    <= sum {i in CARS: size_desc[i] == "midsize"} Y[i,"Unoristan"];

# DOSOVO: if you produce a midsize car, you must produce a compact car
subject to dos_if_midsize_then_compact:
    sum {i in CARS: size_desc[i] == "midsize"} Y[i,"Dosovo"] 
    <= sum {i in CARS: size_desc[i] in {"compact size/midsize", "compact size"}} Y[i,"Dosovo"];

