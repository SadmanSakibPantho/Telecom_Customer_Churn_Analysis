# Telecom_Customer_Churn_Analysis
This analysis was conducted as a part of the Maven Analytics Monthly challenge for July, 2022. The objective was to submit a one-page report identifying High Value customers for a telecom company and to figure out what are the customer churn risks. You can discover entries and discussions about the challenge on LinkedIn using #mavenchurnchallenge.  And the dataset can be downloaded from: https://maven-datasets.s3.amazonaws.com/Telecom+Customer+Churn/Telecom+Customer+Churn.zip

I used SQL's common table expression (CTE) function to find running total values and identify the High Value customers, whom I've considered to fall in the intersection of top customers who are contributing to 75% of monthly recurring revenue, and top customers who are contributing to 75% of total revenue for the company.

I also discovered polychoric and tetrachoric correlations during this challenge while trying to find the correlation between the company's services and whether a customer using those services would churn or not. In this case, I used tetrachoric correlation since the variables I was trying to correlate were all dichotomous (i.e. varibales that can take only one of two possible values).

I used Tableau to make the graphs and compiled the entire report using PowerPoint. To find the retained customers at risk of churn, I filtered them by those using fibre optic internet, not using premium tech support, not using online security and being unmarried.

The entry was selected as one of the top 10 finalists for the challenge among a pool of 320+ participants from around the world.
