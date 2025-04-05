SELECT
  `Dim_Incident___Index_Incident`.`incident` AS `Dim_Incident___Index_Incident__incident`,
  COUNT(*) AS `count`
FROM
  `vial_incidents.fact_table`
 
LEFT JOIN `vial_incidents.dim_incident` AS `Dim_Incident___Index_Incident` ON `vial_incidents.fact_table`.`index_incident` = `Dim_Incident___Index_Incident`.`index_incident`
WHERE
  `Dim_Incident___Index_Incident`.`incident` = {{mivariableincidente}}
GROUP BY
  `Dim_Incident___Index_Incident__incident`
ORDER BY
  `Dim_Incident___Index_Incident__incident` ASC