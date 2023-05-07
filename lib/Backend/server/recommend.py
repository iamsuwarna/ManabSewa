# import sys
# import numpy as np
# import pandas as pd
# from sklearn.metrics.pairwise import cosine_similarity
# import json

# # Load the dataset
# ngos_dataset = pd.read_csv('C:\\Users\\Acer\\Downloads\\NGO Federation of Nepal member organisations from Eastern Region (1).csv')

# # Get the desired district and zone from the command-line arguments
# district = sys.argv[1]
# zone = sys.argv[2]

# # Filter the dataset based on the desired district entered by the user
# filtered_ngos = ngos_dataset[ngos_dataset['District'] == district]

# # Create a pivot table from the filtered dataset with 'NGO Name in English' as the index, and the other columns as the values
# pt = filtered_ngos.pivot_table(index='NGO Name in English', values=['Zone', 'Geographical Region', 'Development Region', 'Acronym', 'Address'], aggfunc=lambda x: ' '.join(str(v) for v in x))

# # Replace all non-numeric values with 0
# pt = pt.apply(pd.to_numeric, errors='coerce').fillna(0)

# # Compute the cosine similarity between the NGOs
# similarity_scores = cosine_similarity(pt)

# # Get the indices of NGOs in the same district as the input NGO
# indices = np.where(filtered_ngos['Zone'] == zone)[0]

# # Get the top 5 recommended NGOs with their address and geographical region
# ngos_similar = []
# for index in indices:
#     if len(pt.index) > 0:
#         ngos_similar += sorted(list(enumerate(similarity_scores[index])), key=lambda x: x[1], reverse=True)[1:6]
# ngos_similar = sorted(ngos_similar, key=lambda x: x[1], reverse=True)[:5]

# if len(ngos_similar) > 0:
#     recommendations = []
#     for i in ngos_similar:
#         ngo_name = pt.index[i[0]]
#         ngo_address = filtered_ngos.loc[filtered_ngos['NGO Name in English'] == ngo_name, 'Address'].iloc[0]
#         ngo_geographical_region = filtered_ngos.loc[filtered_ngos['NGO Name in English'] == ngo_name, 'Geographical Region'].iloc[0]
#         recommendations.append({'name': ngo_name, 'address': ngo_address, 'geographical_region': ngo_geographical_region})
#     json.dump(recommendations, sys.stdout)
# else:
#     json.dump([], sys.stdout)




import sys
import numpy as np
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
import json

# Load the dataset
ngos_dataset = pd.read_csv('C:\\Users\\Acer\\Downloads\\NGO Federation of Nepal member organisations from Eastern Region (1).csv')

# Get the desired district and zone from the command-line arguments
district = sys.argv[1]
zone = sys.argv[2]

# Filter the dataset based on the desired district entered by the user
filtered_ngos = ngos_dataset[ngos_dataset['District'] == district]

# Create a pivot table from the filtered dataset with 'NGO Name in English' as the index, and the other columns as the values
pt = filtered_ngos.pivot_table(index='NGO Name in English', values=['Zone', 'Geographical Region', 'Development Region', 'Acronym', 'Address'], aggfunc=lambda x: ' '.join(str(v) for v in x))

# Replace all non-numeric values with 0
pt = pt.apply(pd.to_numeric, errors='coerce').fillna(0)

# Compute the cosine similarity between the NGOs
similarity_scores = cosine_similarity(pt)

# Get the indices of NGOs in the same district as the input NGO
indices = np.where(filtered_ngos['Zone'] == zone)[0]

# Get the top 5 recommended NGOs with their address and geographical region
ngos_similar = []
for index in indices:
    if len(pt.index) > 0:
        ngos_similar += sorted(list(enumerate(similarity_scores[index])), key=lambda x: x[1], reverse=True)[1:6]
ngos_similar = sorted(ngos_similar, key=lambda x: x[1], reverse=True)[:5]

if len(ngos_similar) > 0:
    recommendations = []
    for i in ngos_similar:
        ngo_name = pt.index[i[0]]
        ngo_address = filtered_ngos.loc[filtered_ngos['NGO Name in English'] == ngo_name, 'Address'].iloc[0]
        ngo_geographical_region = filtered_ngos.loc[filtered_ngos['NGO Name in English'] == ngo_name, 'Geographical Region'].iloc[0]
        if pd.notnull(ngo_address) and pd.notnull(ngo_geographical_region):
            recommendations.append({'name': ngo_name, 'address': ngo_address, 'geographical_region': ngo_geographical_region})
    json.dump(recommendations, sys.stdout)
else:
    json.dump([], sys.stdout)
