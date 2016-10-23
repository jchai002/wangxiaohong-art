<?php

/**
* General Configuration
*
* All of your system's general configuration settings go in here.
* You can see a list of the default settings in craft/app/etc/config/defaults/general.php
*/

return array(
  '*' => array(
    'generateTransformsBeforePageLoad' => true,
    'defaultSearchTermOptions' => array(
      'subLeft' => true,
      'subRight' => true,
    )
  ),
  'localhost' => array(
    'devMode' => true,
    'environmentVariables' => array(
      'siteName' => 'Hong Dev',
      'siteUrl' => 'http://localhost:8887/hong/public',
      'assetsBaseUrl' => 'http://localhost:8887/hong/public/assets'
    ),
  )
);
