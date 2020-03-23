# -*- coding: utf-8 -*-
"""
Created on Wed Mar 11 10:54:13 2020

@author: lavanya.ilankuma
"""
import pandas as pd, numpy as np
import matplotlib.pyplot as plt
df = pd.read_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\imdb.csv",  escapechar='\\')
#df.loc[64]
df.shape
df.columns
df['len_of_movie'] = df.title.apply(lambda x : len(x))
#------------------1.Genere combinations for each type year on year-------------------------------------------------

df.nrOfGenre.value_counts()
def find_combo(df):
    subset = df[['tid','year','imdbRating','duration', 'Action', 'Adult', 'Adventure', 'Animation', 'Biography',
       'Comedy', 'Crime', 'Documentary', 'Drama', 'Family', 'Fantasy',
       'FilmNoir', 'GameShow', 'History', 'Horror', 'Music', 'Musical',
       'Mystery', 'News', 'RealityTV', 'Romance', 'SciFi', 'Short', 'Sport',
       'TalkShow', 'Thriller', 'War', 'Western']]
    subset['genre_combo'] = (subset==1).dot(subset.columns + ',').str.rstrip(', ')
    print(subset[['tid','year','genre_combo']])
    r=subset.groupby(['year','genre_combo'])["imdbRating"].agg({'avg_rating':np.average,
                    'min_rating':np.min,'max_rating':np.max
           })
    r['total_run_time_mins'] =subset.groupby(['year','genre_combo']).duration.sum()
    print(r)
find_combo(df)

##-------------2.trend of the number of letters in movies titles over years----------------------------------------------------------------------

def percentile(n):
    def percentile_(x):
        return np.percentile(x, n)
    percentile_.__name__ = 'percentile_%s' % n
    return percentile_

def genre_report(df):
    report = pd.DataFrame(df['year'],df['len_of_movie'])
    report = report.reset_index()
    print(report.head(5))
    plt.plot(report['year'],report['len_of_movie'])
    plt.show()
    report1 = df[df['type']=='video.movie']
    report1.shape
    score = pd.qcut(report1['len_of_movie'],4)
    print(score)
    d = pd.crosstab(index=score,columns=report1.year,
                    values = report1.len_of_movie,aggfunc='count', dropna=True).T
    print(d)
    r=report1.groupby(['year'])["len_of_movie"].agg({'min_length':np.min,'max_length':np.max,
                     'num_videos_less_than25Percentile':percentile(0),
                     'num_videos_25_50Percentile':percentile(25),
                     'num_videos_50_75Percentile':percentile(50),
                     '75': percentile(75),
                     '100': percentile(100)
           })
    return(d,r)
genre_report(df)



#--------------3.Represent the bins as a percentage of total-----------------------------------------------------------------------
df = pd.read_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\diamonds.csv")
df['z'] = df['z'].replace("None","")
df['z']=df['z'].convert_objects(convert_numeric=True)
df['carat']=df['carat'].convert_objects(convert_numeric=True)
df['z'].value_counts()
df.head(5)
df.shape
print(df.columns)
df.dtypes



def volume(df):
    df['volume'] = np.where(df['depth']>60, df.apply(lambda row: float(row.x) * float(row.y) * float(row.z), axis=1),8)
    df['bin'] = pd.qcut(df['volume'],5)
    df.bin.value_counts()
    bins = [-0.001,51.213,73.583,119.218,176.07,838.502]
    labels = [1,2,3,4,5]
    df['binned'] = pd.cut(df['volume'],bins=bins,labels=labels)
    df['binned'] = df['binned'].cat.add_categories(0)
    print(df[['binned','volume','bin']])
    #x = pd.crosstab(df.bin).apply(lambda r :r.count(),axis=1)
    x = pd.crosstab(df.binned,df.cut,normalize='index').round(4)*100
    return(x)
print(volume(df))

#---------------4.number of top performing movies under each genere-------------------------------------------------------------

df.dtypes

df = pd.read_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\movie_metadata.csv")
print(df.shape)
print(df.head(5))

def high_gross(df):
    movie = df.sort_values(["title_year","gross"],ascending = (False, False))
    movie = movie[["title_year","movie_title","gross","imdb_score"]]
    movie = df.fillna(0)
    df2=movie.groupby(['title_year'])["imdb_score"].agg({'avg':np.mean})
    print(df2)
    df1 = movie.groupby('title_year').apply(lambda x : x.nlargest(10,['gross']))
    print(df1)
    subset = pd.merge(df1,df2,left_index=True,right_index=True)
    print(subset.columns)
    report =subset.groupby(['genres']).apply(lambda x : x.nlargest(10,['gross']))
    report[["title_year","genres","gross"]].sort_values('gross',ascending=False)
    print(report.columns)
    print(report[["title_year","genres","gross"]])
    return(report)
    #top_rated = pd.crosstab(index=df.title_year,columns=df.movie_title,
       #             values = df.gross,aggfunc='size', dropna=True).T
    #print(top_rated)
print(high_gross(df))


#----------------5.Top 3 geners of deciles using the duration---------------------------------------------------------

df = pd.read_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\imdb.csv",  escapechar='\\')
#df.loc[64]
df.shape
df.columns
def decile_movie(df):
    df_movies = df[df['type']=='video.movie']
    df_movies.shape
    #print(df_movies)
    df_movies = df_movies[['tid','duration','Action', 'Adult', 'Adventure', 'Animation', 'Biography',
       'Comedy', 'Crime', 'Documentary', 'Drama', 'Family', 'Fantasy',
       'FilmNoir', 'GameShow', 'History', 'Horror', 'Music', 'Musical',
       'Mystery', 'News', 'RealityTV', 'Romance', 'SciFi', 'Short', 'Sport',
       'TalkShow', 'Thriller', 'War', 'Western']]
    df_movies['duration'] = df_movies['duration'].fillna(0)
    df_movies['genre_combo'] = (df_movies==1).dot(df_movies.columns + ',').str.rstrip(', ')
    df_movies['decile'] = pd.qcut(df_movies['duration'], 10, labels=False)
    df_movies['nrOfNominations']= df['nrOfNominations']
    df_movies['nrOfWins']= df['nrOfWins']
    #df_movies.to_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\decile.csv")
    i=df_movies.groupby(['decile','genre_combo'])['nrOfNominations'].apply(lambda x: x.sum())
    j=df_movies.groupby(['decile','genre_combo'])['nrOfWins'].apply(lambda x: x.sum())
    subset1 = pd.merge(i,j,left_index=True,right_index=True).reset_index()
    subset2=df_movies.groupby(['decile','genre_combo']).size().reset_index(name='count')
    final = pd.merge(subset1,subset2,left_on=['decile','genre_combo'],right_on=['decile','genre_combo'])
    df_report= final.groupby('decile').apply(lambda x : x.nlargest(3,['count']))
    print(df_report)
decile_movie(df)


#------------------6.Insights from movie metadata set and the imdb data set-------------------------------------------------------------
imdb = pd.read_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\imdb.csv",  escapechar='\\')
movie = pd.read_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\movie_metadata.csv")

movie['movie_imdb_link'] = [x.strip().replace('?ref_=fn_tt_tt_1', '') for x in movie['movie_imdb_link']]

df = pd.merge(imdb,movie, left_on='url',right_on='movie_imdb_link')
print(df.shape)
print(df.head(5))

#"wordsInTitle","movie_title",
#df.to_csv("D:\\Udemy_Learn\\Takeaway Assignment - R _ Python\\combined_df.csv")
df.isnull().sum()

genres_value = df['genres'].value_counts()
print(genres_value[:10])

genres_value[:10].plot(kind = 'bar', figsize=(10,5) )
df[-30:].plot(x='genres', y='imdbRating', figsize=(10,5), grid=True , color ='g')
df[-20:].plot(x='year', y='imdbRating', figsize=(10,5), grid=True , color = 'r')


top_10 = df[['movie_title', 'imdbRating', 'title_year', 'gross', 'genres']].sort_values('gross', ascending=False)[:10]
top_10


profit = (df['gross']-df['budget'])
df.insert(len(df.columns),'profit',profit)
def plot_vs_year(df, y="gross"):
    df_t = df.pivot_table(index="title_year", values=y, aggfunc=np.mean)
    plt.plot(df_t.index, df_t.values, "-bo")
    plt.ylabel(y)
    plt.xlabel("Year")
plot_vs_year(df, "profit")

movies_year = df.groupby(['title_year'])['movie_title'].count()
movies_year.head()
movies_year.plot('line')

revenue = (df.groupby(['title_year'])['gross'].sum(),0.5)
print(revenue)


df['total_revenue'] = df['gross'].astype(str).astype('float64') 
df_Revenue = df.groupby(['director_name']).mean()
df_Revenue =df_Revenue.drop(df_Revenue.columns.difference(['director_name','total_revenue']), 1)
df_Revenue = df_Revenue.sort_values(by='total_revenue', ascending=1)[:10]
df_Revenue.plot(kind='barh', figsize=(10, 10),
            sort_columns='True', title='Top 10 Average Revenue of Movies per directors' );


df = df[["genres","imdbRating","year"]]
max_genres = df['genres'].str.contains('Drama')
df[max_genres].head(10).plot(kind = 'bar' , figsize = (10,5) )


