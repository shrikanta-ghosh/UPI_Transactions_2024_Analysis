CREATE DATABASE UPI;
USE UPI;

SELECT * FROM data;

-- 1. Basic Business Insights

-- 1.1 Total number of transactions
SELECT COUNT("transaction_id") FROM data;
-- Ans: 2,50,000

-- 1.2 Total transaction value
SELECT SUM(amount)
FROM data;
-- Ans: 327,939,009

-- 1.3 Average transaction amount
SELECT AVG(amount) FROM data;
-- Ans: 1,311.7560

-- 1.4 Success rate
SELECT (SELECT COUNT(transaction_status) FROM data WHERE transaction_status = 'SUCCESS')/COUNT(transaction_id)*100 FROM data;
-- Ans: 95.0496%

-- 1.5 Failure rate
SELECT (SELECT COUNT(transaction_status) FROM data WHERE transaction_status = 'FAILED')/COUNT(transaction_id)*100 FROM data;
-- Ans: 4.9504%

-- 1.6 Share of fraud-flagged transactions
SELECT (SELECT COUNT(fraud_flag) FROM data WHERE fraud_flag = 1)/COUNT(transaction_id)*100 FROM data;
-- Ans: 0.192%

-- 1.7 P2P vs P2M vs Bill Payment vs Recharge
SELECT transaction_type, COUNT(transaction_id) FROM data
GROUP BY transaction_type;
-- Ans: P2P - 112445
    --  P2M - 87,660
    --  Bill payment - 37,368
    --  Recharge - 12,527

-- 1.8 Top categories by volume
SELECT merchant_category, COUNT(amount) FROM data
GROUP BY merchant_category
ORDER BY count(amount) DESC;
-- Ans: Grocery	        49966
    --  Food	        37464
    --  Shopping	    29872
    --  Fuel	        25063
    --  Other	        24828
    --  Utilities	    22338
    --  Transport	    20105
    --  Entertainment	20103
    --  Healthcare	    12663
    --  Education	    7598

-- 2. Time-based insights

-- 2.1 Which hours have maximum transaction count
SELECT hour_of_day, COUNT(transaction_id) FROM data
GROUP BY hour_of_day
ORDER BY count(transaction_id) DESC;
-- Ans:19	21232
    -- 18	20064
    -- 20	18506
    -- 17	18340
    -- 12	17516
    -- 11	16328
    -- 21	16253
    -- 13	15038
    -- 16	13992

-- 2.2 Highest transaction day of week
SELECT day_of_week, COUNT(transaction_id) FROM data
GROUP BY day_of_week
ORDER BY COUNT(transaction_id) DESC;

-- 2.3 Weekend vs weekday transaction behavior
SELECT COUNT(is_weekend)/5 FROM data
WHERE is_weekend = 0;
-- Ans: 35,732.6

SELECT COUNT(is_weekend)/2 FROM data
WHERE is_weekend = 1;
-- Ans: 35,668.5

-- 2.4 Whether weekends have much spending behavior
SELECT SUM(amount)/5 FROM data
WHERE is_weekend = 0;
-- Ans: 46,899,705.8000

-- 2.5 Which months had highest payment activity
SELECT month, SUM(amount) FROM data
GROUP BY month
ORDER BY SUM(amount) DESC;
-- Ans: July	28079905
    --  May	28024857
    --  October	27866829
    --  August	27845907
    --  March	27508202
    --  January	27456691
    --  December	27311087
    --  September	27105761
    --  June	27032118
    --  April	26988791
    --  November	26892531
    --  February	25826330

-- 3. Customer / demographic insights

-- 3.1 Which sender age group performs the most transactions
SELECT sender_age_group, COUNT(transaction_id) FROM data
GROUP BY sender_age_group;
-- Ans: 26-35	87432
   --   36-45	62873
   --   46-55	24841
   --   56+	    12509
   --   18-25	62345

-- 3.2 Which age group spends the highest amount
SELECT sender_age_group, SUM(amount) FROM data
GROUP BY sender_age_group;
-- Ans: 26-35	115959771
    --  36-45	89533745
    --  46-55	33116261
    --  56+	    14855296
    --  18-25	74473936

-- 3.3 Which age group has the highest average transaction size
SELECT sender_age_group, AVG(amount) FROM data
GROUP BY sender_age_group;

-- Ans: 26-35	1326.2852
    --  36-45	1424.0412
    --  46-55	1333.1291
    --  56+	    1187.5686
    --  18-25	1194.5454

-- 3.4 Age group by merchant category
WITH HighestSpending AS (
    SELECT 
        sender_age_group, 
        merchant_category, 
        SUM(amount) AS total_amount_spent,
        ROW_NUMBER() OVER (PARTITION BY sender_age_group ORDER BY SUM(amount) DESC) AS ranking
    FROM data
    GROUP BY sender_age_group, merchant_category
)
SELECT 
    sender_age_group, 
    merchant_category, 
    total_amount_spent
FROM HighestSpending
WHERE ranking = 1;
-- Ans: 18-25	Shopping	22877040
    --  26-35	Shopping	28310939
    --  36-45	Shopping	17217294
    --  46-55	Utilities	6758368
    --  56+	Utilities	3826408

-- 4. Geographic insights

-- 4.1 Top states by transaction count
SELECT sender_state, COUNT(transaction_id) FROM data
GROUP BY sender_state
ORDER BY COUNT(transaction_id) DESC;
-- Ans: Maharashtra	    37427
   --   Uttar Pradesh	30125
   --   Karnataka	    29756
   --   Tamil Nadu	    25367
   --   Delhi	        24870
   --   Telangana	    22435
   --   Gujarat	        20061
   --   Andhra Pradesh	20006
   --   Rajasthan	    19981
   --   West Bengal	    19972

-- 4.2 Top states by transaction value
SELECT sender_state, SUM(amount) FROM data
GROUP BY SENDER_STATE
ORDER BY SUM(amount) DESC;
-- Ans: Maharashtra	    49043948
    --  Uttar Pradesh	40035717
    --  Karnataka	    38451158
    --  Tamil Nadu	    33343518
    --  Delhi	        32689865
    --  Telangana	    29750930
    --  Rajasthan	    26730470
    --  Gujarat	        25988190
    --  Andhra Pradesh	25952619
    --  West Bengal	    25952594

-- 4.3 Average transaction amount by state
SELECT sender_state, AVG(amount) FROM data
GROUP BY SENDER_STATE
ORDER BY AVG(amount) DESC;
-- Ans: Rajasthan	1337.7944
    --  Uttar Pradesh	1328.9865
    --  Telangana	1326.0945
    --  Tamil Nadu	1314.4447
    --  Delhi	1314.4296
    --  Maharashtra	1310.3895
    --  West Bengal	1299.4489
    --  Andhra Pradesh	1297.2418
    --  Gujarat	1295.4584
    --  Karnataka	1292.2153

-- 4.4 Grocery-heavy states
SELECT sender_state, COUNT(transaction_id) FROM data
WHERE merchant_category = 'grocery'
GROUP BY sender_state
ORDER BY COUNT(transaction_id) DESC;
-- Ans: Maharashtra	    7444
    --  Karnataka	    5962
    --  Uttar Pradesh	5926
    --  Tamil Nadu	    5056
    --  Delhi	        4841
    --  Telangana	    4519
    --  Gujarat	        4183
    --  West Bengal	    4083
    --  Andhra Pradesh	4014
    --  Rajasthan	    3938

-- 4.5 Fuel-heavy states
SELECT sender_state, COUNT(transaction_id) FROM data
WHERE merchant_category = 'fuel'
GROUP BY sender_state
ORDER BY COUNT(transaction_id) DESC;
-- Ans: Maharashtra	    3854
    --  Uttar Pradesh	3032
    --  Karnataka	    2951
    --  Delhi	        2525
    --  Tamil Nadu	    2521
    --  Telangana	    2208
    --  West Bengal	    2026
    --  Rajasthan	    2004
    --  Gujarat	        2002
    --  Andhra Pradesh	1940

-- 4.6 Healthcare-heavy states
SELECT sender_state, COUNT(transaction_id) FROM data
WHERE merchant_category = 'healthcare'
GROUP BY sender_state
ORDER BY COUNT(transaction_id) DESC;
-- Ans: Maharashtra	    1831
    --  Uttar Pradesh	1519
    --  Karnataka	    1488
    --  Tamil Nadu	    1325
    --  Delhi	        1275
    --  Telangana	    1169
    --  Andhra Pradesh	1079
    --  Rajasthan	    1037
    --  Gujarat	        975
    --  West Bengal	    965

-- 4.7 Which states show relatively higher fraud flags
SELECT sender_state, COUNT(transaction_id) FROM data
WHERE fraud_flag = 1
GROUP BY sender_state
ORDER BY COUNT(transaction_id) DESC;
-- Ans: Maharashtra	    71
    --  Karnataka	    69
    --  Uttar Pradesh	52
    --  Delhi	        50
    --  Rajasthan	    46
    --  Gujarat	        43
    --  Tamil Nadu	    40
    --  Telangana	    39
    --  Andhra Pradesh	35
    --  West Bengal	    35

-- 4.8 Which states show lower success rates
SELECT main.sender_state, 
      (SELECT COUNT(sub.transaction_id) 
        FROM data sub 
        WHERE sub.transaction_status = 'SUCCESS' 
        AND sub.sender_state = main.sender_state
    )/ COUNT(main.transaction_id)*100 AS Success_Rate
FROM data main       
GROUP BY main.sender_state
ORDER BY Success_Rate ASC;
-- Ans: Uttar Pradesh	94.7817
    --  Tamil Nadu	94.8831
    --  West Bengal	94.9579
    --  Andhra Pradesh	95.0015
    --  Delhi	95.0261
    --  Maharashtra	95.0784
    --  Karnataka	95.1371
    --  Rajasthan	95.2054
    --  Gujarat	95.2196
    --  Telangana	95.2931

-- 4.9 Android vs iOS share by state
SELECT sender_state, 
      (SELECT COUNT(sub.transaction_id) FROM data sub
       WHERE device_type = 'ios'
       AND sub.sender_state = main.sender_state)/
COUNT(main.transaction_id)*100 AS iOS_user, 
      (SELECT COUNT(sub.transaction_id) FROM data sub
       WHERE device_type = 'android'
       AND sub.sender_state = main.sender_state)/
COUNT(main.transaction_id)*100 AS Android_user
FROM data main
GROUP BY sender_state;
-- Ans: Delhi	        19.5979	75.4684
    --  Uttar Pradesh	19.8905	75.1170
    --  Karnataka	    20.0968	74.8252
    --  Telangana	    20.0936	74.8340
    --  Maharashtra	    19.8066	74.9646
    --  Gujarat	        19.8544	75.0361
    --  Rajasthan	    20.1241	74.7610
    --  Tamil Nadu	    19.7974	75.1606
    --  West Bengal	    19.6775	75.6559
    --  Andhra Pradesh	19.4442	75.4824

-- 4.10 4G vs 5G vs WiFi patterns by state
SELECT sender_state, 
      (SELECT COUNT(sub.transaction_id) FROM data sub
       WHERE network_type = '4G'
       AND sub.sender_state = main.sender_state)/
COUNT(main.transaction_id)*100 AS 4G_user, 
      (SELECT COUNT(sub.transaction_id) FROM data sub
       WHERE network_type = '5G'
       AND sub.sender_state = main.sender_state)/
COUNT(main.transaction_id)*100 AS 5G_user,
(SELECT COUNT(sub.transaction_id) FROM data sub
       WHERE network_type = 'WiFi'
       AND sub.sender_state = main.sender_state)/
COUNT(main.transaction_id)*100 AS WiFi_user
FROM data main
GROUP BY sender_state;
-- Ans: Delhi	        60.0161	25.1709	10.0523
    --  Uttar Pradesh	60.1660	24.7436	10.1444
    --  Karnataka	    59.8871	25.1983	9.9140
    --  Telangana	    59.8440	25.3934	10.0022
    --  Maharashtra	    59.7109	25.0648	10.1237
    --  Gujarat	        59.9920	24.8243	10.2438
    --  Rajasthan	    59.6617	25.0738	10.0696
    --  Tamil Nadu	    59.7114	25.2493	9.9539
    --  West Bengal	    60.2944	24.7847	9.8788
    --  Andhra Pradesh	60.0970	24.7276	10.1470

-- 5. Banking ecosystem insights

-- 5.1 Which banks initiate the most transactions
SELECT sender_bank, COUNT(transaction_id) FROM data
GROUP BY sender_bank
ORDER BY COUNT(transaction_id) DESC;
-- Ans: SBI	        62693
     -- HDFC	    37485
     -- ICICI	    29769
     -- IndusInd	25173
     -- Axis	    25042
     -- PNB	        24946
     -- Yes Bank	24860
     -- Kotak	    20032

-- 5.2 Which banks receive the most transactions
SELECT receiver_bank, COUNT(transaction_id) FROM data
GROUP BY receiver_bank
ORDER BY COUNT(transaction_id) DESC;
-- Ans: SBI	        62378
    --  HDFC	    37651
    --  ICICI	    29944
    --  IndusInd	25086
    --  Yes Bank	25009
    --  Axis	    24992
    --  PNB	        24802
    --  Kotak	    20138

-- 5.3 Which sender banks have higher/lower success rates
SELECT sender_bank, COUNT(transaction_id) FROM data
WHERE transaction_status = 'SUCCESS'
GROUP BY sender_bank
ORDER BY COUNT(transaction_id) DESC;
-- Ans: SBI	59598
    --  HDFC	35677
    --  ICICI	28270
    --  IndusInd	23926
    --  Axis	23803
    --  PNB	23725
    --  Yes Bank	23591
    --  Kotak	19034

-- 5.4 Which banks see higher-value UPI transactions
SELECT sender_bank, SUM(amount) FROM data
GROUP BY sender_bank
ORDER BY SUM(amount) DESC;
-- Ans: SBI	        82816520
     -- HDFC	    49791194
     -- ICICI	    38731193
     -- IndusInd	32842711
     -- Yes Bank	32492477
     -- PNB	        32476972
     -- Axis	    32472530
     -- Kotak	    26315412

-- 6. Device and network behavior

-- 6.1 Success rate across 3G / 4G / 5G / WiFi
SELECT main.network_type,
      (SELECT COUNT(sub.transaction_id) FROM data sub
       WHERE transaction_status = 'SUCCESS'
       AND main.network_type = sub.network_type)/
COUNT(main.transaction_id)*100 AS Success_Rate FROM data main
GROUP BY network_type
ORDER BY Success_Rate DESC;

-- 6.2 Device x network combination: Which combinations have higher success rate
SELECT CONCAT(device_type,'+',network_type) AS Combo, 
      (SELECT COUNT(sub.transaction_id) FROM data sub
       WHERE transaction_status = 'SUCCESS'
       AND sub.device_type = main.device_type
       AND sub.network_type = main.network_type)/
COUNT(main.transaction_id)*100 AS Success_Rate FROM data main
GROUP BY device_type, network_type
ORDER BY Success_Rate DESC;
-- Ans: iOS+WiFi	    95.2802
     -- iOS+3G	        95.1963
     -- Android+5G	    95.1677
     -- Android+WiFi	95.1126
     -- iOS+5G	        95.0967
     -- Android+4G	    95.0290
     -- iOS+4G	        95.0069
     -- Web+5G	        94.9763
     -- Web+WiFi	    94.9612
     -- Web+4G	        94.8929
     -- Android+3G	    94.7675
     -- Web+3G	        93.3962

-- 7. Fraud and risk insights

-- 7.1 Fraud transactions as % of total count
SELECT (SELECT COUNT(transaction_id) FROM data
        WHERE fraud_flag = 1)/
        COUNT(transaction_id)*100 AS Fraud_Perecentage FROM data;
-- Ans: 0.1920%
      
-- 7.2 Fraud amount as % of total amount
SELECT (SELECT SUM(amount) FROM data
        WHERE fraud_flag = 1)/
        SUM(amount)*100 AS Fraud_Perecentage FROM data;
-- Ans: 0.2194%

-- 7.3 Which transaction type is riskier
SELECT transaction_type, COUNT(transaction_id) FROM data
WHERE fraud_flag = 1
GROUP BY transaction_type
ORDER BY COUNT(transaction_id) DESC;
-- Ans: P2P	206
    --  P2M	167
    --  Bill Payment	77
    --  Recharge	30

-- 7.4 Fraud Rate By Bank
SELECT 
    sender_bank,(SUM(fraud_flag) * 1.0) / COUNT(transaction_id) AS fraud_rate 
FROM data
GROUP BY sender_bank
ORDER BY fraud_rate DESC;

-- 7.4 Fraud Rate By State
SELECT 
    sender_state,(SUM(fraud_flag) * 1.0) / COUNT(transaction_id) AS fraud_rate 
FROM data
GROUP BY sender_state
ORDER BY fraud_rate DESC;

