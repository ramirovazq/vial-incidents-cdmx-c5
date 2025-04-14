SELECT
  `Dim_Incident___Index_Incident`.`incident` AS `Dim_Incident___Index_Incident__incident`,
  COUNT(*) AS `count`
FROM
  `vial_incidents_13042025.fact_table`
 
LEFT JOIN `vial_incidents_13042025.dim_incident` AS `Dim_Incident___Index_Incident` ON `vial_incidents_13042025.fact_table`.`index_incident` = `Dim_Incident___Index_Incident`.`index_incident`
WHERE
  `Dim_Incident___Index_Incident`.`incident` = {{mivariableincidente}}
GROUP BY
  `Dim_Incident___Index_Incident__incident`
ORDER BY
  `Dim_Incident___Index_Incident__incident` ASC