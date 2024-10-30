# Coffee Market Analysis

## Objective
The goal of this project is to analyze the sales data of **Coffee Haven** and recommend the top three major cities in India for opening new coffee shop locations based on consumer demand and sales performance.

## Key Questions
The analysis focuses on the following key questions:

1. **Coffee Consumers Count**
   - How many people in each city are estimated to consume coffee, given that 25% of the population does?

2. **Total Revenue from Coffee Sales**
   - What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

3. **Sales Count for Each Product**
   - How many units of each coffee product have been sold?

4. **Average Sales Amount per City**
   - What is the average sales amount per customer in each city?

5. **City Population and Coffee Consumers**
   - Provide a list of cities along with their populations and estimated coffee consumers.

6. **Top Selling Products by City**
   - What are the top 3 selling products in each city based on sales volume?

7. **Customer Segmentation by City**
   - How many unique customers are there in each city who have purchased coffee products?

8. **Average Sale vs Rent**
   - Find each city and their average sale per customer and average rent per customer.

9. **Monthly Sales Growth**
   - Calculate the percentage growth (or decline) in sales over different time periods (monthly).

10. **Market Potential Analysis**
    - Identify the top 3 cities based on highest sales, returning city name, total sales, total rent, total customers, and estimated coffee consumers.

## SQL Queries
All SQL queries used for the analysis are located in the `sql/queries` directory. Each query is named based on the specific analysis it performs.

## Recommendations
After analyzing the data, the recommended top three cities for new store openings are:
### City 1: Pune
- High Revenue: Pune has the highest total revenue (1,258,290), indicating a strong market with high sales.
- Affordable Average Rent per Customer: With an average rent of 294.23, Pune has one of the lowest rent costs per customer, maximizing profitability.
- High Average Sales per Customer (24,197.88): This is a significant indicator of customer spending power.
- Verdict: Pune ranks at the top due to its revenue generation and affordability, making it ideal for sustained profitability.
### City 2: Delhi
- Large Market Potential: Delhi has 7.75 million estimated coffee consumers, the largest among all cities, suggesting a vast untapped customer base.
- Highest Customer Count (68): More customers mean broader reach and stability.
- Moderate Rent per Customer (330.88): This cost is manageable, balancing expansion potential with affordability.
- Verdict: Delhi offers a high potential for both immediate sales and future growth, with a large market and strong customer base.
### City 3: Bangalore
- Substantial Revenue (860,110): Bangalore’s revenue is close to other top cities, making it competitive.
- Moderate Customer Count (39) but Highest Rent per Customer (761.54): The higher rent per customer could indicate more affluent customers, with the potential for premium services.
- Average Sales per Customer (22,054.10): Customers in Bangalore also show strong spending, making the city lucrative.
- Verdict: While rent is high, Bangalore’s sales potential and affluent customer base make it a strong contender for a higher-end market.

Pune and Delhi remain excellent choices due to revenue, affordability, and market size. However, I would also consider Bangalore for its spending potential and affluent market, which could yield high returns even with higher operational costs.
Jaipur could be a viable fourth option if the goal is to focus on affordability and customer count, especially in markets with lower operating budgets.
