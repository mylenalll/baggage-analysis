# Baggage analysis project

The purpose of this project is to demonstrate the ability to distinguish significant predictors in data and predict the value of the categorical variable. 

## The data

I have several data sets of the following structure. 

| is_prohibited | weight | length | width | type     |
|---------------|--------|--------|-------|----------|
| No            | 69     | 53     | 17    | Suitcase |
| No            | 79     | 52     | 21    | Bag      |
| Yes           | 84     | 54     | 20    | Suitcase |

**test_data1** and **test_data2** are being used to test the **get_features** function, which returns a list of significant predictors in the data. Turned out, there aren't any in **test_data1**, but there are some in **test_data2**. 
