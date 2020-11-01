import pandas as pd

#data is a dataframe
data = pd.read_csv('userReviews.csv', sep=';')

print(data.head())
print(data[:3])
print(data.movieName.iloc[1])

column_names = ['movieName', 'Metascore_w', 'Author','AuthorHref', 'Date', 'Summary'
      ,'InteractionsYesCount','InteractionsTotalCount','InteractionsThumbUp'
      ,'InteractionsThumpDown']
#This helps creating a empty dataframe with the same column as data
subset = pd.DataFrame(columns = column_names)

#This code replaces the slow looping with a faster filter method
for movie in range(100):
  if data.movieName.iloc[movie] == 'the-wolf-of-wall-street':
    row=data[movie:movie + 1]
    print(row)
    subset.append(row)

#This code creates a subset of reviews on your favourite movie
subset = data[data.movieName == 'the-wolf-of-wall-street']

#This code creates a final dataframe for recommendations
recommendations = pd.DataFrame(columns=data.columns.tolist()+['rel_inc','abs_inc'])

#This code loops over all the users that watched the same movie
for idx, Author in subset.iterrows():
    print(Author)
    #save each author and the ranking he gave
    author = Author[['Author']].iloc[0]
    ranking = Author[['Metascore_w']].iloc[0]
    #filteroptions
    filter1 = (data.Author==author)
    filter2 = (data.Metascore_w>ranking)
    #calculating relative and absolute score
    possible_recommendations = data[filter1 & filter2]
    print(possible_recommendations.head())
    
    possible_recommendations.loc[:,'rel_inc'] = possible_recommendations.Metascore_w/ranking
    possible_recommendations.loc[:,'abs_inc'] = possible_recommendations.Metascore_w - ranking
    
    #append this to the recommendations df
    recommendations = recommendations.append(possible_recommendations)
    
#sorting the recommendations in a descending order
recommendations = recommendations.sort_values(['rel_inc','abs_inc'], ascending=False)
#dropping duplicates to decrease df size
recommendations = recommendations.drop_duplicates(subset='movieName', keep="first")
    
#command to printing recommendations
recommendations.head(50).to_csv("recommendationsBasedOnMetascore.csv", sep=";", index=False)
print(recommendations.head(50))
print(recommendations.shape)