import numpy as np
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

# Load the dataset
ngos_dataset = pd.read_csv('C:\\Users\\Acer\\Downloads\\NGO Federation of Nepal member organisations from Eastern Region (1).csv')

# Filter the dataset based on the desired district entered by the user
district = input("Enter the desired district: ")
filtered_ngos = ngos_dataset[ngos_dataset['District'] == district]

# Create a pivot table from the filtered dataset with 'NGO Name in English' as the index, and the other columns as the values
pt = filtered_ngos.pivot_table(index='NGO Name in English', values=['Zone', 'Geographical Region', 'Development Region', 'Acronym', 'Address'], aggfunc=lambda x: ' '.join(str(v) for v in x))

# Replace all non-numeric values with 0
pt = pt.apply(pd.to_numeric, errors='coerce').fillna(0)

# Compute the cosine similarity between the NGOs
similarity_scores = cosine_similarity(pt)

# Get the input NGO's zone
ngo_zone = input("Enter the zone of the NGO you want recommendations for: ")

# Get the indices of NGOs in the same district as the input NGO
indices = np.where(filtered_ngos['Zone'] == ngo_zone)[0]

# Get the top 5 recommended NGOs
ngos_similar = []
for index in indices:
    if len(pt.index) > 0:
        ngos_similar += sorted(list(enumerate(similarity_scores[index])),key=lambda x:x[1],reverse=True)[1:6]
ngos_similar = sorted(ngos_similar,key=lambda x:x[1],reverse=True)[:5]

if len(ngos_similar) > 0:
    print("Top 5 recommended NGOs:")
    for i in ngos_similar:
        print(pt.index[i[0]])
else:
    print("No similar NGOs found in the same zone")







