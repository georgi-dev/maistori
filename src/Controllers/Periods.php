<?php
namespace Controllers;

trait Periods {
	static function getperiods($params) {
		global $container;
		//print_r($params);

		//die();
		//$where_array[] = "1:1";
		// if($params['filter'] !== ''){
			// $where_array[] = "periods.name LIKE \'%'.$params['filter'].'%\'";
		// }

		//print_r($where_array);
		$order_by = $params['filter'] != '' ? $params['filter'] : 'id';
		//die();
        $page = max(1, (int) $params["page"]);
		$limit = $container->get("settings")["db"]["page_size"];
		$offset = ($page - 1) * $limit;
		
		$periods = [];
		
		// if ($params) {
		// 	# code...
		// }
//WHERE periods.name LIKE \'%'.$params['filter'].'%\'
		$db = $container["db"];
		$periodsRows = $db->prepare('
			SELECT SQL_CALC_FOUND_ROWS
				periods.id AS id,
				periods.company AS company,
				periods.name AS name,
				periods.start AS start,
				periods.end AS end,
				periods.last_modified AS last_modified,
				companies.name AS company_name
				
			FROM
				periods
				LEFT JOIN companies ON periods.company = companies.id
			LIMIT
				' . $limit . '
			OFFSET
				' . $offset
			)->fetchAll();


		//return ["periods" => $periodsRows];


		//die();

		foreach($periodsRows as $row) {
			$periods[$row["id"]]["id"] = $row["id"];
			$periods[$row["id"]]["company"] = $row["company"];
			$periods[$row["id"]]["company_name"] = $row["company_name"];
			$periods[$row["id"]]["name"] = $row["name"];
			$periods[$row["id"]]["start"] = $row["start"];
			$periods[$row["id"]]["end"] = $row["end"];
			$periods[$row["id"]]["last_modified"] = $row["last_modified"];
			// if($row["period_id"] > 0) {
			// 	$periods[$row["id"]]["periods"][$row["period_id"]]["id"] = $row["period_id"];
			// 	$periods[$row["id"]]["periods"][$row["period_id"]]["name"] = $row["period_name"];
			// 	$periods[$row["id"]]["periods"][$row["period_id"]]["start"] = $row["period_start"];
			// 	$periods[$row["id"]]["periods"][$row["period_id"]]["end"] = $row["period_end"];
			// }
		}
		
		foreach($periods as $key => $company) {
			if(array_key_exists("periods", $periods[$key])) {
				$periods[$key]["periods"] = array_values($periods[$key]["periods"]);
			}
		}

		return [
			"periods" => array_values($periods),
			"pages" => ceil(count($periods) / $container->get("settings")["db"]["page_size"])
		];
	}
	
	// static function getcompany($params) {
	// 	global $container;
		
	// 	$company = ["periods" => []];
		
	// 	$db = $container["db"];
	// 	$companyRows = $db->prepare('
	// 		SELECT
	// 			companies.id AS id,
	// 			companies.name AS name,
	// 			companies.description AS description,
	// 			companies.last_modified AS last_modified,
	// 			periods.id AS period_id,
	// 			periods.name AS period_name,
	// 			periods.start AS period_start,
	// 			periods.end AS period_end,
	// 			periods.last_modified AS last_modified
	// 		FROM
	// 			companies
	// 			LEFT JOIN periods ON companies.id=periods.company
	// 		WHERE
	// 			companies.id=:company
	// 		')->fetchAll([
	// 			":company" => $params["id"]
	// 		]);
		
	// 	foreach($companyRows as $row) {
	// 		$company["id"] = $row["id"];
	// 		$company["name"] = $row["name"];
	// 		$company["description"] = $row["description"];
	// 		$company["last_modified"] = $row["last_modified"];
	// 		if($row["period_id"] > 0) {
	// 			$company["periods"][] = [
	// 				"id" => $row["period_id"],
	// 				"name" => $row["period_name"],
	// 				"start" => $row["period_start"],
	// 				"end" => $row["period_end"],
	// 				"last_modified" => $row["last_modified"]
	// 			];
	// 		}
	// 	}
		
	// 	return json_encode([
	// 		"company" => $company
	// 	]);
	// }
	
	// static function savecompany($params) {
	// 	global $container;
		
	// 	if((int) $params["id"] == 0) { // Insert new company
	// 		$companyId = $container["db"]->prepare('
	// 			INSERT INTO
	// 				companies
	// 			VALUES(
	// 				null,
	// 				:name,
	// 				:description,
	// 				NOW()
	// 			)
	// 		')->query([
	// 			":name" => $params["name"],
	// 			":description" => $params["description"]
	// 		]);
			
	// 		$newPeriods = json_decode($params["periods"], true);
	// 		foreach($newPeriods as $period) {
	// 			$container["db"]->prepare('
	// 				INSERT INTO
	// 					periods
	// 				VALUES(
	// 					null,
	// 					:company,
	// 					:name,
	// 					:start,
	// 					:end,
	// 					NOW()
	// 				)
	// 			')->query([
	// 				":name" => $period["name"],
	// 				":company" => $companyId,
	// 				":start" => $period["start"],
	// 				":end" => $period["end"]
	// 			]);
	// 		}
	// 	} else { // Update existing company
	// 		$container["db"]->prepare('
	// 			UPDATE
	// 				companies
	// 			SET
	// 				name=:name,
	// 				description=:description,
	// 				last_modified=NOW()
	// 			WHERE
	// 				id=:id
	// 		')->query([
	// 			":name" => $params["name"],
	// 			":description" => $params["description"],
	// 			":id" => $params["id"]
	// 		]);
			
	// 		// Fetch old periods
	// 		$oldPeriodsObj = $container["db"]->prepare('
	// 			SELECT
	// 				GROUP_CONCAT(id) AS ids
	// 			FROM
	// 				periods
	// 			WHERE
	// 				periods.company=:company
	// 			GROUP BY
	// 				periods.company
	// 		')->fetchOne([
	// 			":company" => $params["id"]
	// 		]);
			
	// 		foreach(explode(",", $oldPeriodsObj["ids"]) as $key => $item) {
	// 			$oldPeriods[$item] = true;
	// 		}
	
	// 		$newPeriods = json_decode($params["periods"], true);
	// 		foreach($newPeriods as $period) {
	// 			if($period["id"] == "") {
	// 				$container["db"]->prepare('
	// 					INSERT INTO
	// 						periods
	// 					VALUES(
	// 						null,
	// 						:company,
	// 						:name,
	// 						:start,
	// 						:end,
	// 						NOW()
	// 					)
	// 				')->query([
	// 					":name" => $period["name"],
	// 					":company" => $params["id"],
	// 					":start" => $period["start"],
	// 					":end" => $period["end"]
	// 				]);
	// 			} else {
	// 				$container["db"]->prepare('
	// 					UPDATE
	// 						periods
	// 					SET
	// 						name=:name,
	// 						start=:start,
	// 						end=:end,
	// 						last_modified=NOW()
	// 					WHERE
	// 						id=:id
	// 				')->query([
	// 					":name" => $period["name"],
	// 					":start" => $period["start"],
	// 					":end" => $period["end"],
	// 					":id" => $period["id"]
	// 				]);
					
	// 				unset($oldPeriods[$period["id"]]);
	// 			}
	// 		}
			
	// 		foreach($oldPeriods as $key => $item) {
	// 			$container["db"]->prepare('
	// 				DELETE FROM
	// 					periods
	// 				WHERE
	// 					id=:id
	// 			')->query([
	// 				":id" => $key
	// 			]);
	// 		}
	// 	}
		
	// 	return json_encode(true);
	// }
}