SELECT
  `vial_incidents.dim_incident`.`index_incident` AS `index_incident`,
  `vial_incidents.dim_incident`.`incident` AS `incident`
FROM
  `vial_incidents.dim_incident`
ORDER BY
  `vial_incidents.dim_incident`.`incident` ASC
LIMIT
  1048575