
# UPI_Transactions_2024_Analysis

This project analyzes a dataset of **2.5 lakh (250,000) UPI transactions** from **2024** to uncover patterns in **customer behavior**, **banking activity**, **fraud risk**, and **regional trends** across India. Using **SQL** for data querying and **Power BI** for visualization, the analysis covers **transaction volume and value**, **success/failure rates**, **peak usage hours**, **state-wise spending patterns**, **device and network trends**, and a dedicated **fraud & risk analysis**.


## Source of the Data
Downloaded from **Kaggle.**
<img width="1911" height="1072" alt="image" src="https://github.com/user-attachments/assets/a947a45e-09ae-40a6-9b6f-8eeec87ed928" />

## Tools Used
**SQL** (data querying & analysis), **Power BI** (dashboarding & visualization)
## Top Insights from SQL Queries

- **Young adults drive the platform:** The **26–35 age group** leads in both **transaction count (87K+)** and **total spend (₹11.6 crore+)**. **Shopping** is the top spending category for every age group under 46, while users aged **46+** spend more on **Utilities**.

- **Regional leaders:** **Maharashtra, Uttar Pradesh, and Karnataka** rank as the top three states by both **transaction volume** and **total transaction value**. Interestingly, **Rajasthan** and **Uttar Pradesh** record the **highest average transaction size**, despite not leading in overall transaction count.

- **P2P transfers need stronger fraud monitoring:** **Peer-to-peer (P2P) transfers** are both the **most frequently used** transaction type and the **most fraud-prone**, accounting for the highest number of **fraud-flagged transactions (206)**. This makes P2P the highest-priority area for fraud detection and prevention.

- **Android is the dominant platform:** Across every state, approximately **75% of users** transact via **Android**, around **20% use iOS**, and **web usage is negligible**. Product enhancements and testing should therefore prioritize the Android experience.

- **Consistent usage throughout the week:** UPI activity remains remarkably stable across the week, with **average daily transactions of ~35,733 on weekdays** and **~35,669 on weekends**, indicating that users rely on UPI consistently rather than primarily on weekends.
## Key Insights From Dashboards

- **Web users face the highest fraud risk:** Although **Web** accounts for only a **small fraction of total device usage**, it has the **highest fraud share (35.46%)**. **Android** follows with **33.34%**, while **iOS** has the **lowest fraud share (31.20%)** among the three platforms.

- **Fraud is slightly more common on weekends:** **51.48% of fraud cases** occur on **weekends**, compared to **48.52% on weekdays**. Since overall transaction volume is nearly identical (**50.89% weekdays vs. 49.11% weekends**), weekends appear to carry a **slightly higher fraud risk per transaction**.

- **Younger users are relatively more vulnerable:** While the **26–35 age group** generates the **highest transaction volume**, the **18–25 age group** has the **highest proportion of fraudulent transactions**, suggesting younger users may be more susceptible to fraud relative to their activity level.

- **Fraud peaks during evening hours:** The **6 PM–12 AM** time window records the **highest number of fraud-flagged transactions**, followed closely by **12 PM–6 PM**, while **12 AM–6 AM** has the fewest fraud cases. This indicates that fraud generally **tracks peak user activity** rather than occurring predominantly during overnight hours.
<img width="1658" height="962" alt="image" src="https://github.com/user-attachments/assets/3b7b8edb-92cc-4827-8d7e-a6d7adcdcd2b" />
<img width="1662" height="957" alt="image" src="https://github.com/user-attachments/assets/9e21e2d7-d694-4c41-bb22-7b2183f92e38" />

