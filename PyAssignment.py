import pandas as pd, numpy as np
import os
import datetime
# Create the required data frames by reading in the files
os.getcwd()
df = pd.read_excel("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\SaleData.xlsx")
df['year'] = pd.DatetimeIndex(df['OrderDate']).year
df["Total_Sales"] = df["Units"] * df["Unit_price"]
df['current_date'] =np.datetime64(datetime.datetime.now())
print(df.head(5))
#print(df.dtypes)
print(df.columns)

# Q1 Find least sales amount for each item
# has been solved as an example
def least_sales(df):
    ls = df.groupby(["Item"])["Sale_amt"].min().reset_index()
    return ls
print(least_sales(df))

# Q2 compute total sales at each year X region
def sales_year_region(df):
    syr = df.groupby(["year","Region","Item"])["Total_Sales"].sum().reset_index()
    return syr
print(sales_year_region(df))

# Q3 append column with no of days difference from present date to each order date
def days_diff(df):
    df['diff'] = df['current_date'] - df['OrderDate']
    df['diff_days']=df['diff']/np.timedelta64(1,'D') 
    return df['diff_days']
print(days_diff(df))

# Q4 get dataframe with manager as first column and  salesman under them as lists in rows in second column.
def mgr_slsmn(df):
    df1 = pd.DataFrame(df.groupby(['Manager'])['SalesMan'].unique())
    return df1.rename(columns={'SalesMan': 'list_of_salesmen'})
print(mgr_slsmn(df))

# Q5 For all regions find number of salesman and number of units
def slsmn_units(df):
    df1=pd.DataFrame(df.groupby(['Region'])['SalesMan'].nunique())
    df1['total_units']=df.groupby(['Region'])['Units'].sum()
    return df1.rename(columns={'SalesMan': 'salesmen_count'})
print(slsmn_units(df))

# Q6 Find total sales as percentage for each manager
def sales_pct(df):
    df1=pd.DataFrame(df.groupby(['Manager'])['Total_Sales'].sum())
    df1 =df1.reset_index()
    df1['percent_sales']=df1['Total_Sales'].transform(lambda x:100 * x/x.sum())
    df1= df1[['Manager','percent_sales']]
    return df1
print(sales_pct(df))

df = pd.read_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\imdb.csv",  escapechar='\\')
#df.loc[64]
df.columns
#df.to_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\imdb_new.csv")

df.duration.value_counts()
# Q7 get imdb rating for fifth movie of dataframe
def fifth_movie(df):
     df1 = df[df['type']=='video.movie']
     df1 = df1.loc[[4],['imdbRating']]
     return df1
print(fifth_movie(df))

# Q8 return titles of movies with shortest and longest run time
def movies(df):
    df1 = df[df['type']=='video.movie']
    df2 = df1[df1['duration'] == df1['duration'].min()] 
    df3 = df1[df1['duration'] == df1['duration'].max()]
    return df2['title'],df3['title']
print(movies(df))

# Q9 sort by two columns - release_date (earliest) and Imdb rating(highest to lowest)
def sort_df(df):
    df = df.sort_values(["year", "imdbRating"], ascending = (True, False))
    return df
print(sort_df(df))


df = pd.read_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\movie_metadata.csv")
print(df.shape)
print(df.head(5))
# Q10 subset revenue more than 2 million and spent less than 1 million & duration between 30 mintues to 180 minutes
def subset_df(df):
    df = df[(df['duration'] >= 30) & (df['duration'] <= 180) & (df['gross'] > 20000000) & (df['budget'] < 10000000)]
    return df
print(subset_df(df))

df = pd.read_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\diamonds.csv")
df['z'] = df['z'].replace("None","")
df['z']=df['z'].convert_objects(convert_numeric=True)
df['carat']=df['carat'].convert_objects(convert_numeric=True)
df['z'].value_counts()
df.head(5)
df.shape
df.columns
df.dtypes
# Q11 count the duplicate rows of diamonds DataFrame.
def dupl_rows(df):
    df = df.duplicated(df.columns)
    return df.sum()
print(dupl_rows(df))

# Q12 droping those rows where any value in a row is missing in carat and cut columns
def drop_row(df):
    df = df.dropna(how='any', subset=['carat', 'cut'])
    return df
print(drop_row(df))

# Q13 subset only numeric columns
def sub_numeric(df):
    df = df.select_dtypes(include=np.number)
    return df
print(sub_numeric(df))

# Q14 compute volume as (x*y*z) when depth > 60 else 8
def volume(df):
    df['volume'] = np.where(df['depth']>60, df.apply(lambda row: float(row.x) * float(row.y) * float(row.z), axis=1),8)
    return df[['depth','volume']]
print(volume(df))

# Q15 impute missing price values with mean
def impute(df):
    df['price'] = df['price'].fillna(df['price'].mean())
    return df['price']
print(impute(df))
