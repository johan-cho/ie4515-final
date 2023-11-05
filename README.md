# IE4515 Operations Research Final Project

Our final project in this class tasked us to solve a mixed integer optimization problem. I thought it was gonna be a creative project where I go out and create my own problem to solve, but this was a bit of a curveball.

I chose AMPL, and wrote it largely by myself. Interestingly, my professor didn't know how to program, at all, so I was a little bit in the dark with this kind of stuff; it was a lot of self-learning. I used the [AMPL VS Code](https://marketplace.visualstudio.com/items?itemName=michael-sundvick.ampl) extension so I didn't have to use the AMPL IDE.

Currently, my solution is `CPV = 680711.5`.

You could view the problem statement [here](https://drive.google.com/file/d/1CnO5QGbpaexRrt9mTwnDpIXqMVac_0eY/view?usp=sharing_), or read below.

## FINAL PROJECT

Clonation Motors manufactures 6 different types of cars (classified according to their size) in two different manufacturing sites: Unoristan and Dosovo.

Clonation motors has the following operative conditions (see Table 1 below):

- selling price and variable costs are in USD.
- cars are manufactured on different assembly lines, which are leased to a provider in the USA (the monthly lease is in USD).
- assembly time is in hours and the raw material is in steel tons.
- each type of cars has been classified into four criteria - price, quality, safety, luxury – and the evaluation scale used is 1, 2, or 3 (where 1 means "total poorness", and 3 means "total excellence").

On the other hand, Clonation Motors faces the following technical challenges. For the case of Unoristan:

- Midsize/family size and family size cars share the same assembly line.All of the rest car sizes are manufactured on their own assembly line.
- Produce at least three different types of cars.
- At least one car type produced at must be considered compact size or compact size/mid size.
- If a midsize/family size car is produced, then a mid size car must be produced.
- The total ranking of the different types of cars to be produced, regarding safety, must be at least 9.
- Produce at least 300 (or none at all) Boraxes.
- Produce at least 1000 (or none at all) Ferbys.
- Produce at least 900 (or none at all) Pupos.
- Produce at least 750 (or none at all) Molos.

Whereas for Dosovo:

- Tointers and Ferbys share the same assembly line, Pupos and Molos share the same assembly line. All of the rest car types are manufactured on their own assembly line.
- Produce at least four different types of cars.
- At least one car type produced at must be considered compact size/midsize or midsize.
- If a midsize car is produced a, then a compact size/mid size or compact size must be produced.
- The total ranking of the different types of cars to be produced, regarding safety, must be at least 10.
- Produce at least 900 (or none at all) Gettas.
- Produce at least 600 (or none at all) Tointers.
- Produce at least 300 (or none at all) Ferbys.
- Produce at least 750 (or none at all) Molos.

If the upper management of Clonation Motors calculates the `CPV` index (customer perceived value) of a produced car, as follows:

`CPV = total_profit * [(price_rank * safety_rank) + (quality_rank * luxury_rank)]`

Find the production mix, by formulating (and solving) a mixed-integer programing model, that allows Clonation Motors to maximize the `CPV` index.

### Table 1: Unoristan

| **Car type**  | **Size**   | **Selling price** | **Variable cost** | **Fixed cost** | **Price** | **Quality** | **Safety** | **Luxury** | **Assembly time (max 8000 hr)** | **Raw material (max 10000 tons)** |
|---------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|
| Getta         | midsize/ family size | 20k | 7k | 3k | 3 | 3 | 1 | 3 | 4 | 5 |
| Borax         | family size | 27k | 9k | 4k | 2 | 1 | 3 | 2 | 5 | 5 |
| Tointer       | compact size/mid size | 15k | 6k | 1k | 2 | 3 | 2 | 2 | 2 | 2 |
| Ferby         | compact size | 15k | 9k | 2k | 1 | 3 | 3 | 1 | 2 | 1 |
| Pupo          | compact size/mid size | 10k | 6k | 1.5k | 3 | 3 | 3 | 3 | 1 | 2 |
| Molo          | midsize | 18k | 11k | 1k | 3 | 1 | 2 | 3 | 3 | 3 |

### Table 2: Dosovo

| **Car type**  | **Size**   | **Selling price** | **Variable cost** | **Fixed cost** | **Price** | **Quality** | **Safety** | **Luxury** | **Assembly time (max 7000 hr)** | **Raw material (max 12000)** |
|---------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|
| Getta         | midsize/ family size | 27 | 6 | 3 | 3 | 1 | 3 | 3 | 5 | 2 |
| Borax         | family size | 18 | 9 | 1 | 1 | 3 | 2 | 2 | 2 | 3 |
| Tointer       | compact size/mid size | 12 | 11 | 4 | 3 | 2 | 2 | 2 | 1 | 5 |
| Ferby         | compact size | 20 | 6 | 2 | 3 | 3 | 1 | 1 | 5 | 2 |
| Pupo          | compact size/mid size | 15 | 9 | 1 | 3 | 3 | 3 | 3 | 3 | 1 |
| Molo          | midsize | 15 | 7 | 1.5 | 1 | 2 | 3 | 3 | 2 | 4 |
