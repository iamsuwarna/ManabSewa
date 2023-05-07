from flask import Flask, request
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    return "<h1>Welcome to NGO Recommendation System</h1><p>Please enter the desired district and zone for NGO recommendations.</p>"

@app.route('/recommend', methods=['POST'])
def recommend():
    # Load the dataset
    ngos_dataset = pd.read_csv('C:\\Users\\Acer\\Downloads\\NGO Federation of Nepal member organisations from Eastern Region (1).csv')

    # Filter the dataset based on the desired district entered by the user
    district = request.form.get('district')
    filtered_ngos = ngos_dataset[ngos_dataset['District'] == district]

    # Create a pivot table from the filtered dataset with 'NGO Name in English' as the index, and the other columns as the values
    pt = filtered_ngos.pivot_table(index='NGO Name in English', values=['Zone', 'Geographical Region', 'Development Region', 'Acronym', 'Address'], aggfunc=lambda x: ' '.join(str(v) for v in x))

    # Replace all non-numeric values with 0
    pt = pt.apply(pd.to_numeric, errors='coerce').fillna(0)

    # Compute the cosine similarity between the NGOs
    similarity_scores = cosine_similarity(pt)

    # Get the input NGO's zone
    ngo_zone = request.form.get('zone')

    # Get the indices of NGOs in the same district as the input NGO
    indices = np.where(filtered_ngos['Zone'] == ngo_zone)[0]

    # Get the top 5 recommended NGOs
    ngos_similar = []
    for index in indices:
        if len(pt.index) > 0:
            ngos_similar += sorted(list(enumerate(similarity_scores[index])),key=lambda x:x[1],reverse=True)[1:6]
    ngos_similar = sorted(ngos_similar,key=lambda x:x[1],reverse=True)[:5]

    if len(ngos_similar) > 0:
        result = "<h3>Top 5 recommended NGOs:</h3><ul>"
        for i in ngos_similar:
            result += "<li>" + pt.index[i[0]] + "</li>"
        result += "</ul>"
    else:
        result = "<p>No similar NGOs found in the same zone</p>"

    return result

if __name__ == '__main__':
    app.run(debug=True)
