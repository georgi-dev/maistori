<?php
$app->get("/", function($request, $response) {
        include_once("../templates/home.php");
});

$app->get("/companies", function($request, $response) {
    include_once("../templates/companies.php");
    
    return $response;
});

$app->get("/company[/{id}]", function($request, $response, $args) {
    include_once("../templates/company.php");
    
    return $response;
});


$app->get("/periods", function($request, $response) {
    include_once("../templates/periods.php");
    
    return $response;
});

$app->get("/periods/{name}", function($request, $response) {
    include_once("../templates/periods.php");
    
    return $response;
});

// API calls
$app->get("/api/{method}[?{params}]", function($request, $response, $args) {
    parse_str($request->getUri()->getQuery(), $params);
    	//print_r($params);
    return $response->withJson(Controllers\Receiver::{$args["method"]}($params));    
});

$app->post("/api/{method}", function($request, $response, $args) {
    $params = $request->getParams();
    
    return $response->withJson(Controllers\Receiver::{$args["method"]}($params));    
});