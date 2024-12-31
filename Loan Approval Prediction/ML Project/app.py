import streamlit as st
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
import joblib
import matplotlib.pyplot as plt
import seaborn as sns

# Set page configuration
st.set_page_config(
    page_title="Loan Approval Prediction",
    page_icon="💰",
    layout="wide"
)

# Add custom CSS
st.markdown("""
    <style>
    .main {
        padding: 2rem;
    }
    .stButton>button {
        width: 100%;
        margin-top: 20px;
    }
    </style>
    """, unsafe_allow_html=True)

# Title and description
st.title("🏦 Loan Approval Prediction System")
st.markdown("""
This application uses machine learning to predict loan approval based on various factors.
Please fill in all the required information below to get a prediction.
""")

def load_data():
    try:
        # Load your data - replace with your actual data loading logic
        df = pd.read_csv("C:/Users/USER ACCOUNT/Downloads/Loan approval data set (ml).csv")
        return df
    except:
        st.error("Error: Unable to load the dataset. Please ensure the data file is in the correct location.")
        return None

def train_model(df):
    # Data preprocessing
    df = df.drop(["loan_id"], axis=1)
    le = LabelEncoder()
    df[" education"] = le.fit_transform(df[" education"])
    df[" self_employed"] = le.fit_transform(df[" self_employed"])
    df[" loan_status"] = le.fit_transform(df[" loan_status"])
    
    # Split features and target
    X = df.drop([" loan_status"], axis=1)
    y = df[" loan_status"]
    
    # Train model
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    rf_model = RandomForestClassifier(n_estimators=100, random_state=42)
    rf_model.fit(X_train, y_train)
    
    return rf_model, X.columns

def create_input_sections():
    st.subheader("📋 Personal Information")
    col1, col2 = st.columns(2)
    
    with col1:
        education = st.selectbox(
            "Education Level",
            ("Graduate", "Not Graduate"),
            help="Select your education level"
        )
        
        self_employed = st.selectbox(
            "Self Employed",
            ("No", "Yes"),
            help="Are you self-employed?"
        )
        
        no_of_dependents = st.number_input(
            "Number of Dependents",
            min_value=0,
            max_value=10,
            help="Number of people depending on the applicant"
        )
        
        income_annum = st.number_input(
            "Annual Income",
            min_value=0.0,
            help="Your annual income in currency",
            format="%f"
        )
        
    with col2:
        loan_amount = st.number_input(
            "Loan Amount",
            min_value=0.0,
            help="The loan amount you're requesting",
            format="%f"
        )
        
        loan_term = st.number_input(
            "Loan Term (in months)",
            min_value=0,
            max_value=360,
            help="Duration of the loan in months"
        )
        
        cibil_score = st.number_input(
            "CIBIL Score",
            min_value=300,
            max_value=900,
            value=300,
            help="Your credit score (300-900)"
        )

    st.subheader("💰 Asset Information")
    col3, col4 = st.columns(2)
    
    with col3:
        residential_assets_value = st.number_input(
            "Residential Assets Value",
            min_value=0.0,
            help="Total value of residential assets",
            format="%f"
        )
        
        commercial_assets_value = st.number_input(
            "Commercial Assets Value",
            min_value=0.0,
            help="Total value of commercial assets",
            format="%f"
        )
    
    with col4:
        luxury_assets_value = st.number_input(
            "Luxury Assets Value",
            min_value=0.0,
            help="Total value of luxury assets",
            format="%f"
        )
        
        bank_asset_value = st.number_input(
            "Bank Asset Value",
            min_value=0.0,
            help="Total value of bank assets",
            format="%f"
        )

    return {
        "education": 1 if education == "Graduate" else 0,
        "self_employed": 1 if self_employed == "Yes" else 0,
        "no_of_dependents": no_of_dependents,
        "income_annum": income_annum,
        "loan_amount": loan_amount,
        "loan_term": loan_term,
        "cibil_score": cibil_score,
        "residential_assets_value": residential_assets_value,
        "commercial_assets_value": commercial_assets_value,
        "luxury_assets_value": luxury_assets_value,
        "bank_asset_value": bank_asset_value
    }

def make_prediction(model, features, feature_names):
    # Convert features to DataFrame with correct column names
    df = pd.DataFrame([features], columns=feature_names)
    prediction = model.predict(df)
    probability = model.predict_proba(df)
    return prediction[0], probability[0]

def show_prediction(prediction, probability):
    if prediction == 1:
        st.success("🎉 Loan Approval Prediction: APPROVED")
        st.progress(probability[1])
        st.write(f"Confidence: {probability[1]*100:.2f}%")
    else:
        st.error("❌ Loan Approval Prediction: REJECTED")
        st.progress(probability[0])
        st.write(f"Confidence: {probability[0]*100:.2f}%")

def main():
    # Load data and train model
    df = load_data()
    if df is not None:
        model, feature_names = train_model(df)
        
        # Get user input
        user_inputs = create_input_sections()
        
        # Make prediction when user clicks the button
        if st.button("Predict Loan Approval"):
            with st.spinner("Processing..."):
                prediction, probability = make_prediction(model, user_inputs, feature_names)
                show_prediction(prediction, probability)
                
                # Show feature importance
                st.subheader("📊 Feature Importance")
                importances = model.feature_importances_
                feature_imp_df = pd.DataFrame({
                    'Feature': feature_names,
                    'Importance': importances
                }).sort_values('Importance', ascending=False)
                
                fig, ax = plt.subplots(figsize=(10, 6))
                sns.barplot(data=feature_imp_df, x='Importance', y='Feature')
                plt.title('Feature Importance in Loan Approval Decision')
                st.pyplot(fig)

if __name__ == "__main__":
    main()