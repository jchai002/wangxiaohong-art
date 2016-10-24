<?php

/**
* General Configuration
*
* All of your system's general configuration settings go in here.
* You can see a list of the default settings in craft/app/etc/config/defaults/general.php
*/

return array(
  '*' => array(
    'environmentVariables' => array(
      'siteName' => 'Wang Xiao Hong',
      'siteUrl' => 'http://ec2-35-160-96-40.us-west-2.compute.amazonaws.com',
      'assetsBaseUrl' => 'http://ec2-35-160-96-40.us-west-2.compute.amazonaws.com/assets'
    ),
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
