*Zehan Hu*

### Overall Grade: 218/250

### Late penalty

- Is the homework submitted (git tag time) before deadline? Take 10 pts off per day for late submission.  

  - 7pm submission on the next day (-7)

### Quality of report: 9/10

-   Is the final report in a human readable format html? 

-   Is the report prepared as a dynamic document (Quarto) for better reproducibility?

-   Is the report clear (whole sentences, typos, grammar)? Do readers have a clear idea what's going on and how results are produced by just reading the report? Take some points off if the solutions are too succinct to grasp, or there are too many typos/grammar. 

  - Q1.8 output has lots of html writing (-1)

### Completeness, correctness and efficiency of solution: 183/200

- Q1 (88/100)

  - Incorrect grouping for some variables like admission_location (-2)
  
  - Included variables not of interest such as subject_id (-5)
  
  - Wanted median, IQR, and # of unknonwn values for labs and vitals (-5)

If `collect` before end of Q1.7, take 20 points off.

Cohort in Q1.7 should match that in HW3.

Q1.8 summaries should roughly match those given.
  
- Q2 (95/100)

  - No tabular summaries (-5)



### Usage of Git: 9/10

-   Are branches (`main` and `develop`) correctly set up? Is the hw submission put into the `main` branch?

-   Are there enough commits (>=5) in develop branch? Are commit messages clear? The commits should span out not clustered the day before deadline. 

  - Not enough commits
          
-   Is the hw submission tagged? 

-   Are the folders (`hw1`, `hw2`, ...) created correctly? 
  
-   Do not put a lot auxiliary files into version control. 

-   If those gz data files or `pg42671` are in Git, take 5 points off.

### Reproducibility: 10/10

-   Are the materials (files and instructions) submitted to the `main` branch sufficient for reproducing all the results? Just click the `Render` button will produce the final `html`? 

-   If necessary, are there clear instructions, either in report or in a separate file, how to reproduce the results?

### R code style: 14/20

For bash commands, only enforce the 80-character rule. Take 2 pts off for each violation. 

-   [Rule 2.5](https://style.tidyverse.org/syntax.html#long-lines) The maximum line length is 80 characters. Long URLs and strings are exceptions.  

  - Line 171 violation (-2)

-   [Rule 2.4.1](https://style.tidyverse.org/syntax.html#indenting) When indenting your code, use two spaces.  

  - Line 89 has an indent (-2)

-   [Rule 2.2.4](https://style.tidyverse.org/syntax.html#infix-operators) Place spaces around all infix operators (=, +, -, &lt;-, etc.).  

  - Line 171 violation (-2)

-   [Rule 2.2.1.](https://style.tidyverse.org/syntax.html#commas) Do not place a space before a comma, but always place one after a comma.  

-   [Rule 2.2.2](https://style.tidyverse.org/syntax.html#parentheses) Do not place spaces around code in parentheses or square brackets. Place a space before left parenthesis, except in a function call.
