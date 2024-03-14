*Zehan Hu*

### Overall Grade: 151/180

### Quality of report: 7/10

-   Is the homework submitted (git tag time) before deadline? Take 10 pts off per day for late submission.  

-   Is the final report in a human readable format html? 

-   Is the report prepared as a dynamic document (Quarto) for better reproducibility?

-   Is the report clear (whole sentences, typos, grammar)? Do readers have a clear idea what's going on and how results are produced by just reading the report? Take some points off if the solutions are too succinct to grasp, or there are too many typos/grammar. 

  - Quality is poor (-3)

### Completeness, correctness and efficiency of solution: 114/130

- Q1 (17/20)

  - Q1.2 There are more than 5 columns. You didn't label all of them (-2)
  
  - Q1.2 Can make character variables factor variables to decrease runtime and memory (-1)

- Q2 (71/80)

    - Q2.1 (9/10) Explain why read_csv cannot ingest labevents.csv.gz
    
      - No explanation (-1)
    
    - Q2.2 (9/10) Explain why read_csv cannot ingest labevents.csv.gz
    
      - No explanation (-1)
    
    - Q2.3 (15/15) The Bash code should be able to generate a file `labevents_filtered.csv.gz` (127MB). Check the numbers of rows and columns are correct.
    
    - Q2.4 (13/15)
    
      - Did not report runtime or number of rows (-2)
    
    - Q2.5 (12/15)
    
      - Did not report runtime (-1)
      
      - Parquet file is 1.9 GB (-1)
      
      - Table does not match exactly the table in Q2.3 (-1)
    
    - Q2.6 (13/15)
    
      - Did not report number of rows (-1)
      
      - Table does not match exactly the table in Q2.3 (-1)

- Q3 (26/30) Steps should be documented and reproducible. Check final number of rows and columns.

  - Did not report number of rows. Did not filter columns (-4)
	    
### Usage of Git: 7/10

-   Are branches (`main` and `develop`) correctly set up? Is the hw submission put into the `main` branch?

  - No usage of develop (-1)

-   Are there enough commits (>=5) in develop branch? Are commit messages clear? The commits should span out not clustered the day before deadline. 

  - No commits (-2)
          
-   Is the hw2 submission tagged? 

-   Are the folders (`hw1`, `hw2`, ...) created correctly? 
  
-   Do not put a lot auxiliary files into version control. 

-   If those gz data files or `pg42671` are in Git, take 5 points off.

### Reproducibility: 5/10

-   Are the materials (files and instructions) submitted to the `main` branch sufficient for reproducing all the results? Just click the `Render` button will produce the final `html`? 

  - Error in line 70. Cannot reproduce because you did not give a file path. (-5)

-   If necessary, are there clear instructions, either in report or in a separate file, how to reproduce the results?

### R code style: 18/20

For bash commands, only enforce the 80-character rule. Take 2 pts off for each violation. 

-   [Rule 2.5](https://style.tidyverse.org/syntax.html#long-lines) The maximum line length is 80 characters. Long URLs and strings are exceptions.  

  - Some violations (-2)

-   [Rule 2.4.1](https://style.tidyverse.org/syntax.html#indenting) When indenting your code, use two spaces.  

-   [Rule 2.2.4](https://style.tidyverse.org/syntax.html#infix-operators) Place spaces around all infix operators (=, +, -, &lt;-, etc.).  

-   [Rule 2.2.1.](https://style.tidyverse.org/syntax.html#commas) Do not place a space before a comma, but always place one after a comma.  

-   [Rule 2.2.2](https://style.tidyverse.org/syntax.html#parentheses) Do not place spaces around code in parentheses or square brackets. Place a space before left parenthesis, except in a function call.
