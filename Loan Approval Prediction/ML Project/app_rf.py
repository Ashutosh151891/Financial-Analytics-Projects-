import streamlit as st
import joblib
import numpy as np

# Load the saved Random Forest model
rf_model = joblib.load("random_forest_model.pkl")

# Define the app title
st.title("Loan Approval Prediction App (Random Forest)")

# User input for features
def get_user_input():
    no_of_dependents = st.number_input("Number of Dependents", min_value=0, max_value=10, step=1)
    education = st.selectbox("Education", ("Graduate", "Not Graduate"))
    self_employed = st.selectbox("Self Employed", ("Yes", "No"))
    income_annum = st.number_input("Annual Income (in currency)")
    loan_amount = st.number_input("Loan Amount")
    loan_term = st.number_input("Loan Term")
    cibil_score = st.number_input("CIBIL Score", min_value=300, max_value=900)
    residential_assets_value = st.number_input("Residential Assets Value")
    commercial_assets_value = st.number_input("Commercial Assets Value")
    luxury_assets_value = st.number_input("Luxury Assets Value")
    bank_asset_value = st.number_input("Bank Asset Value")

    # Encoding categorical variables
    education = 1 if education == "Graduate" else 0
    self_employed = 1 if self_employed == "Yes" else 0

    # Feature array
    features = np.array([[no_of_dependents, education, self_employed, income_annum, loan_amount,
                          loan_term, cibil_score, residential_assets_value, commercial_assets_value,
                          luxury_assets_value, bank_asset_value]])
    return features

# Predict function
def predict(features):
    prediction = rf_model.predict(features)
    return "Approved" if prediction[0] == 1 else "Rejected"

# Main section for user input and prediction
st.header("Enter Loan Details:")
user_input = get_user_input()

# Predict button
if st.button("Predict Loan Status"):
    result = predict(user_input)
    st.subheader(f"Loan Status: {result}")
