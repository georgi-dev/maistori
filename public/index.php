<?php
// error_reporting(E_ERROR);
require __DIR__ . '/../vendor/autoload.php';

session_start();

// Instantiate the app
$settings = require __DIR__ . '/../src/settings.php';
$app = new \Slim\App($settings);

spl_autoload_register(function($classname) {
    require(__DIR__ . "/../src/" . str_replace("\\", "/", $classname) . ".php");
});

// Set up dependencies
require __DIR__ . '/../src/dependencies.php';

// Register routes
require __DIR__ . '/../src/routes.php';

// Run app
$app->run();
