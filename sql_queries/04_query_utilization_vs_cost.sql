-- Analysis 3: Utilization vs Cost Analysis

-- Business Question: Are high OOP costs driven by high 
-- utilization or high cost per claim?


SELECT
    chronic_condition,
    member_count as total_members,
    med_oop_member as median_oop_cost,
    med_claim_ct as median_claims,
    med_oop_member / NULLIF(med_claim_ct, 0) as oop_cost_per_claim,
    -- Utilization Categorization
    CASE
        WHEN med_claim_ct > 20 THEN 'High Utilization'
        WHEN med_claim_ct > 10 THEN 'Medium Utilization'
        ELSE 'Low Utilization'
    END as utilization_category,
    -- Total annual OOP burden categorization
    CASE
        WHEN med_oop_member > 500 THEN 'High Total OOP'
        WHEN med_oop_member > 200 THEN 'Medium Total OOP '
        ELSE 'Low Total OOP'
    END as total_oop_category,
    -- Cost per claim categorization
    CASE
        WHEN (med_oop_member / NULLIF(med_claim_ct, 0)) > 10 THEN 'High Cost Per Claim'
        WHEN (med_oop_member / NULLIF(med_claim_ct, 0)) > 5 THEN 'Medium Cost Per Claim'
        ELSE 'Low Cost Per Claim'
    END as cost_per_claim_category
FROM
    CA_HEALTH.PUBLIC.HPD_OOP_CHRONIC
WHERE
    county = 'All'
    AND product = 'All'
    AND chronic_condition IS NOT NULL
    AND chronic_number_v2 = 'All'
    AND member_count > 0
ORDER BY
    median_oop_cost DESC;
